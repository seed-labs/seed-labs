import dockerode from 'dockerode';
import { LogProducer } from '../interfaces/log-producer';
import { Logger } from 'tslog';
import { Session, SessionManager } from './session-manager';

interface ExecutionResult {
    id: number,
    return_value: number,
    output: string
}

/**
 * bgp peer.
 */
export interface BgpPeer {
    /** name of the protocol in bird of the peer. */
    name: string;

    /** state of the protocol itself (up/down/start, etc.) */
    protocolState: string;

    /** state of bgp (established/active/idle, etc.) */
    bgpState: string;
}

/**
 * controller class.
 * 
 * The controller class offers the ability to control a node with some common
 * operations. The operations are provided by the seedemu_worker script
 * installed to every node by the docker compiler. 
 */
export class Controller implements LogProducer {
    private _logger: Logger;
    private _sessionManager: SessionManager;

    /** current task id. */
    private _taskId: number;

    /**
     * Callbacks for tasks. The key is task id, and the value is the callback.
     * All tasks are async: the requests need to be written to the container's
     * worker session, and the container will later reply the execution result
     * bound by '_BEGIN_RESULT_' and '_END_RESULT_'. 
     */
    private _unresolvedPromises: { [id: number]: ((result: ExecutionResult) => void)};

    /**
     * message buffers. The key is container id, and the value is buffer.
     * Container's execution results are marked by '_BEGIN_RESULT_' and
     * '_END_RESULT_'. One must wait till '_END_RESULT_' before parsing the
     * execution result. The buffers store to result received so far.
     */
    private _messageBuffer: { [nodeId: string]: string };

    /**
     * Only one task is allowed at a time. If the last task has not returned,
     * all future tasks must wait. This list stores the callbacks to wake
     * waiting tasks handler.
     */
    private _pendingTasks: (() => void)[];

    /**
     * construct controller.
     * 
     * @param docker dockerode object. 
     */
    constructor(docker: dockerode) {
        this._logger = new Logger({ name: 'Controller' });
        this._sessionManager = new SessionManager(docker, 'Controller');
        this._sessionManager.on('new_session', this._listenTo.bind(this));

        this._taskId = 0;
        this._unresolvedPromises = {};
        this._messageBuffer = {};
        this._pendingTasks = [];
    }

    /**
     * attach a listener to a newly created session.
     * 
     * @param nodeId node id.
     * @param session session.
     */
    private _listenTo(nodeId: string, session: Session) {
        this._logger.debug(`got new session for node ${nodeId}; attaching listener...`);

        session.stream.addListener('data', data => {
            var message: string = data.toString('utf-8');
            this._logger.debug(`message chunk from ${nodeId}: ${message}`);

            if (message.includes('_BEGIN_RESULT_')) {
                if (nodeId in this._messageBuffer && this._messageBuffer[nodeId] != '') {
                    this._logger.error(`${nodeId} sents another _BEGIN_RESULT_ while the last message was not finished.`);
                }

                this._messageBuffer[nodeId] = '';
            }

            if (!(nodeId in this._messageBuffer)) {
                this._messageBuffer[nodeId] = message;
            } else {
                this._messageBuffer[nodeId] += message;
            }
            
            if (!this._messageBuffer[nodeId].includes('_END_RESULT_')) {
                this._logger.debug(`message from ${nodeId} is not complete; push to buffer and wait...`);
                return;
            }

            let json = this._messageBuffer[nodeId]?.split('_BEGIN_RESULT_')[1]?.split('_END_RESULT_')[0];

            if (!json) {
                this._logger.warn(`end-of-message seen, but messsage incomplete for node ${nodeId}?`);
                return;
            }

            this._logger.debug(`message from ${nodeId}: "${json}"`);

            // message should be completed by now. parse and resolve.

            try {
                let result = JSON.parse(json) as ExecutionResult;

                if (result.id in this._unresolvedPromises) {
                    this._unresolvedPromises[result.id](result);
                    delete this._unresolvedPromises[result.id];
                } else {
                    this._logger.warn(`unknow task id ${result.id} from node ${nodeId}: `, result);
                }
            } catch (e) {
                this._logger.warn(`error decoding message from ${nodeId}: `, e);
            }

            this._messageBuffer[nodeId] = '';
        });
    }

    /**
     * run seedemu worker command on a node.
     * 
     * @param node id of node to run on.
     * @param command command.
     * @returns execution result.
     */
    private async _run(node: string, command: string): Promise<ExecutionResult> {
        // wait for all pending tasks to finish.
        await this._wait();

        let task = ++this._taskId;

        this._logger.debug(`[task ${task}] running "${command}" on ${node}...`);
        let session = await this._sessionManager.getSession(node, ['/seedemu_worker']);

        session.stream.write(`${task};${command}\r`);

        // create a promise, push the resolve callback to unresolved promises for current id.
        let promise = new Promise<ExecutionResult>((resolve, reject) => {
            this._unresolvedPromises[task] = (result: ExecutionResult) => {
                resolve(result);

                // one or more tasks is waiting for us to finish, let the first in queue know we are done. 
                if (this._pendingTasks.length > 0) {
                    this._pendingTasks.shift()();
                }
            };
        });

        // wait for the listener to invoke the resolve callback.
        let result = await promise;

        this._logger.debug(`[task ${task}] task end:`, result);

        return result;
    }

    /**
     * wait for other tasks, if exist, to finish. return immediately if no
     * other tasks are running.
     */
    private async _wait(): Promise<void> {
        if (Object.keys(this._unresolvedPromises).length == 0) {
            return;
        }

        let promise = new Promise<void>((resolve, reject) => {
            this._pendingTasks.push(resolve);
        });

        return await promise;
    }

    /**
     * change the network connection state of a node.
     * 
     * @param node node id
     * @param connected true to re-connect, false to disconnect.
     */
    async setNetworkConnected(node: string, connected: boolean) {
        this._logger.debug(`setting network to ${connected ? 'connected' : 'disconnected'} on ${node}`);
        await this._run(node, connected ? 'net_up' : 'net_down');
    }

    /**
     * get the network connection state of a node. 
     * 
     * @param node node id
     * @returns true if connected, false if not connected.
     */
    async isNetworkConnected(node: string): Promise<boolean> {
        this._logger.debug(`getting network status on ${node}`);

        let result = await this._run(node, 'net_status');

        return result.output.includes('up');
    }

    /**
     * list bgp peers.
     * 
     * @param node node id. this node must be a router node with bird running.
     * @returns list of bgp peers.
     */
    async listBgpPeers(node: string): Promise<BgpPeer[]> {
        // potential crash when running on non-router node?

        this._logger.debug(`getting bgp peers on ${node}...`);

        let result = await this._run(node, 'bird_list_peer');

        let lines = result.output.split('\n').map(s => s.split(/\s+/));

        var peers: BgpPeer[] = [];

        lines.forEach(line => {
            if (line.length < 6) {
                return;
            }
            peers.push({
                name: line[0],
                protocolState: line[3],
                bgpState: line[5]
            });
        });

        this._logger.debug(`parsed bird output: `, lines, peers);

        return peers;
    }

    /**
     * set bgp peer state.
     * 
     * @param node node id.  this node must be a router node with bird running.
     * @param peer peer protocol name.
     * @param state new state. true to enable, false to disable.
     */
    async setBgpPeerState(node: string, peer: string, state: boolean) {
        this._logger.debug(`setting peer session with ${peer} on ${node} to ${state ? 'enabled' : 'disabled'}...`);

        await this._run(node, `bird_peer_${state ? 'up' : 'down'} ${peer}`);
    }

    getLoggers(): Logger[] {
        return [this._logger, this._sessionManager.getLoggers()[0]];
    }
}