import dockerode from 'dockerode';
import { Duplex } from 'stream';
import { Logger } from 'tslog';
import { LogProducer } from '../interfaces/log-producer';

export interface Session {
    stream: Duplex,
    exec: dockerode.Exec
};

export type SessionEvent = 'new_session';

/**
 * session manager class.
 * 
 * The session manager providers a way to open an interactive shell session
 * with the container. It keeps track of previously opened sessions and re-open
 * existing sessions if possible.
 */
export class SessionManager implements LogProducer {
    private _logger: Logger;

    private _sessions: {
        [id: string]: Session
    };

    private _docker: dockerode;

    private _newSessionCallback: (nodeId: string, session: Session) => void;

    /**
     * construct new session manager.
     * 
     * @param docker dockerode object.
     * @param namespace name prefix for log outputs. this is only used for
     * distinctions between multiple uses of the session manager.
     */
    constructor(docker: dockerode, namespace: String = '') {
        this._sessions = {};
        this._docker = docker;
        this._logger = new Logger({ name: `${namespace}SessionManager` });
    }

    /**
     * get the full length id of a container from a partial id.
     * 
     * @param id partial id
     * @returns full id
     */
    private async _getContainerRealId(id: string): Promise<string> {
        var containers = await this._docker.listContainers();
        var candidates = containers.filter(container => container.Id.startsWith(id));

        if (candidates.length != 1) {
            var err = `no match or multiple match for container ID ${id}`;
            this._logger.error(err);
            throw err;
        }

        return candidates[0].Id;
    }

    /**
     * test if a reuseable session exist for a container.
     * 
     * @param fullId full length id of the container
     * @returns true if exists, false otherwise.
     */
    hasSession(fullId: string): boolean {
        return this._sessions[fullId] && this._sessions[fullId].stream.writable;
    }

    /**
     * listen for events.
     * 
     * event: new_session: will be invoked when a new session is created for a
     * node. 
     * 
     * @param event event to listen
     * @param callback callback
     */
    on(event: SessionEvent, callback: (nodeId: string, session: Session) => void) {
        if (event == 'new_session') {
            this._newSessionCallback = callback;
        }
    }

    /**
     * get session for a container.
     * 
     * @param id container id. can be partial
     * @param command (optional) command to start session with. default to
     * ['bash']
     * @returns session
     */
    async getSession(id: string, command: string[] = ['bash']): Promise<Session> {
        this._logger.info(`getting container ${id}...`);

        var fullId = await this._getContainerRealId(id);
        this._logger.trace(`${id}'s full id: ${fullId}.`)

        var container = this._docker.getContainer(fullId);

        if (this._sessions[fullId]) {
            var session = this._sessions[fullId];
            this._logger.debug(`found existing session for ${id}, try re-attach...`);
            var stream = session.stream;
            if (stream.writable) {
                this._logger.info(`attached to existing session for ${id}.`);
                return session;
            }
            this._logger.info(`existing session for ${id} is invalid, creating new session.`);
        }

        this._logger.trace(`getting container ${id}...`);

        var execOpt = {
            AttachStdin: true,
            AttachStdout: true,
            AttachStderr: true,
            Tty: true,
            Cmd: command
        };
        this._logger.trace('spawning exec object with options:', execOpt);
        var exec = await container.exec(execOpt);
    
        var startOpt = {
            Tty: true,
            Detach: false,
            stdin: true,
            hijack: true
        };
        this._logger.trace('starting exec object with options:', startOpt);    
        var stream = await exec.start(startOpt);

        this._logger.info(`started session for container ${id}.`);

        this._sessions[fullId] = {
            stream, exec
        };

        if (this._newSessionCallback) {
            this._newSessionCallback(fullId, this._sessions[fullId]);
        }

        return this._sessions[fullId];
    }

    getLoggers(): Logger[] {
        return [this._logger];
    }
};