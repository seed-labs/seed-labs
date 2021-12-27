import dockerode from 'dockerode';
import { LogProducer } from '../interfaces/log-producer';
import { Logger } from 'tslog';
import { SessionManager, Session } from './session-manager';

export class Sniffer implements LogProducer {
    private _logger: Logger;
    private _listener: (nodeId: string, stdout: any) => void;
    private _sessionManager: SessionManager;

    constructor(docker: dockerode) {
        this._logger = new Logger({ name: 'Sniffer' });
        this._sessionManager = new SessionManager(docker, 'Sniffer');
        this._sessionManager.on('new_session', this._listenTo.bind(this));
    }

    private _listenTo(nodeId: string, session: Session) {
        this._logger.debug(`got new session for noed ${nodeId}; attaching listener...`);

        session.stream.addListener('data', data => {
            if (this._listener) {
                this._listener(nodeId, data);
            }
        });
    }

    async sniff(nodes: string[], expr: string) {
        this._logger.debug(`sniffing on ${nodes} with expr ${expr}...`);

        var sessions = await Promise.all(nodes.map(node => this._sessionManager.getSession(node, ['/seedemu_sniffer'])));

        sessions.forEach(session => {
            try {
                session.stream.write(`${expr}\r`);
            } catch (e) {
                this._logger.error("error communicating with node.");
            }
        });
    }

    setListener(listener: (nodeId: string, stdout: any) => void) {
        this._listener = listener;
    }

    clearListener() {
        this._listener = undefined;
    }

    getLoggers(): Logger[] {
        return [this._logger, this._sessionManager.getLoggers()[0]];
    }
}