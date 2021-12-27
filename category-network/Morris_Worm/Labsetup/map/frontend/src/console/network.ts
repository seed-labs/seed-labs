import { Configuration } from "../common/configuration";

/**
 * console network manager.
 */
export class ConsoleNetwork {
    private _id: string;

    constructor(id: string) {
        this._id = id;
    }

    /**
     * get the container details
     * 
     * @returns container details.
     */
    async getContainer(): Promise<any> {
        var xhr = new XMLHttpRequest();

        xhr.open('GET', `${Configuration.ApiPath}/container/${this._id}`);

        return new Promise((resolve, reject) => {
            xhr.onload = function () {
                if (this.status != 200) {
                    reject({
                        ok: false,
                        result: 'non-200 response from API.'
                    });

                    return;
                }

                var res = JSON.parse(xhr.response);
                
                if (res.ok) resolve(res);
                else reject(res);
            };

            xhr.onerror = function () {
                reject({
                    ok: false,
                    result: 'xhr failed.'
                });
            }

            xhr.send();
        });
    }

    /**
     * get the websocket.
     * 
     * @param protocol (optional) websocket protocol (ws/wss), default to ws.
     * @returns websocket.
     */
    getSocket(protocol: string = 'ws'): WebSocket {
        return new WebSocket(`${protocol}://${location.host}${Configuration.ApiPath}/console/${this._id}`);
    }
};