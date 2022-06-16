import { Logger } from 'tslog';
import dockerode from 'dockerode';
import { SessionManager } from './session-manager';
import WebSocket from 'ws';
import { LogProducer } from '../interfaces/log-producer';

export class SocketHandler implements LogProducer {
    private _logger: Logger;
    private _sessionManager: SessionManager;

    constructor(docker: dockerode) {
        this._sessionManager = new SessionManager(docker);
        this._logger = new Logger({ name: 'SocketHandler' });
    }

    async handleSession(ws: WebSocket, id: string) {
        ws.send(`\x1b[0;30mConnecting to ${id}...\x1b[0m\r\n`);

        try {
            var session = await this._sessionManager.getSession(id);

            var dataHandler = (data: any) => {
                ws.send(data);
            };

            var closeHandler = () => {
                ws.close();
            };
    
            ws.send(`\x1b[0;30mConnected to ${id}.\x1b[0m\r\n`);
    
            ws.on('close', () => {
                session.stream.removeListener('data', dataHandler);
                session.stream.removeListener('close', closeHandler);
            });
    
            ws.on('message', async (data: string) => {
                if (typeof data === 'string' && data.length > 4 && data.substr(0, 4) == '\t\r\n\t') { // "control messages"
                    let msg = data.substr(4);
                    let [type, payload] = msg.split(';');
                    if (type == 'termsz') {
                        let [rows, cols] = payload.split(',');
                        let _rows: number = Number.parseInt(rows);
                        let _cols: number = Number.parseInt(cols);
    
                        await session.exec.resize({
                            h: _rows,
                            w: _cols
                        });
                    };
                    return;
                }
                session.stream.write(data);
            });

            session.stream.addListener('data', dataHandler);
            session.stream.addListener('close', closeHandler);   
        } catch (e) {
            this._logger.error(e);
            throw e;
        }
    }

    getSessionManager(): SessionManager {
        return this._sessionManager;
    }

    getLoggers(): Logger[] {
        return [this._logger, this._sessionManager.getLoggers()[0]];
    }
};
