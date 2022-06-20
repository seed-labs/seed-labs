import { EdgeOptions, NodeOptions } from 'vis-network';
import { BgpPeer, EmulatorNetwork, EmulatorNode } from '../common/types';

export type DataEvent = 'packet' | 'dead';

export interface Vertex extends NodeOptions {
    id: string;
    label: string;
    group?: string;
    shape?: string;
    type: 'node' | 'network';
    object: EmulatorNode | EmulatorNetwork;
}

export interface Edge extends EdgeOptions {
    id?: undefined;
    from: string;
    to: string;
    label?: string;
}

export interface ApiRespond<ResultType> {
    ok: boolean;
    result: ResultType;
}

export interface FilterRespond {
    currentFilter: string;
}

export class DataSource {
    private _apiBase: string;
    private _nodes: EmulatorNode[];
    private _nets: EmulatorNetwork[];

    private _wsProtocol: string;
    private _socket: WebSocket;

    private _connected: boolean;

    private _packetEventHandler: (nodeId: string) => void;
    private _errorHandler: (error: any) => void;

    /**
     * construct new data provider.
     * 
     * @param apiBase api base url.
     * @param wsProtocol websocket protocol (ws/wss), default to ws.
     */
    constructor(apiBase: string, wsProtocol: string = 'ws') {
        this._apiBase = apiBase;
        this._wsProtocol = wsProtocol;
        this._nodes = [];
        this._nets = [];
        this._connected = false;
    }

    /**
     * load data from api.
     * 
     * @param method http method.
     * @param url target url.
     * @param body (optional) request body.
     * @returns api respond object.
     */
    private async _load<ResultType>(method: string, url: string, body: string = undefined): Promise<ApiRespond<ResultType>> {
        let xhr = new XMLHttpRequest();

        xhr.open(method, url);

        if (method == 'POST') {
            xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
        }

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
                
                if (res.ok) {
                    resolve(res);
                } else {
                    reject(res);
                }
            };

            xhr.onerror = function () {
                reject({
                    ok: false,
                    result: 'xhr failed.'
                });
            }

            xhr.send(body);
        })
    }

    /**
     * connect to api: start listening sniffer socket, load nodes/nets list.
     * call again when connected to reload nodes/nets.
     */
    async connect() {
        this._nodes = (await this._load<EmulatorNode[]>('GET', `${this._apiBase}/container`)).result;
        this._nets = (await this._load<EmulatorNetwork[]>('GET', `${this._apiBase}/network`)).result;

        if (this._connected) {
            return;
        }

        this._socket = new WebSocket(`${this._wsProtocol}://${location.host}${this._apiBase}/sniff`);
        this._socket.addEventListener('message', (ev) => {
            let msg = ev.data.toString();

            let object = JSON.parse(msg);
            if (this._packetEventHandler) {
                this._packetEventHandler(object);
            }
        });

        this._socket.addEventListener('error', (ev) => {
            if (this._errorHandler) {
                this._errorHandler(ev);
            }
        });

        this._socket.addEventListener('close', (ev) => {
            if (this._errorHandler) {
                this._errorHandler(ev);
            }
        });

        this._connected = true;
    }

    /**
     * disconnect sniff socket.
     */
    disconnect() {
        this._connected = false;
        this._socket.close();
    }

    /**
     * get current sniff filter expression.
     * 
     * @returns filter expression.
     */
    async getSniffFilter(): Promise<string> {
        return (await this._load<FilterRespond>('GET', `${this._apiBase}/sniff`)).result.currentFilter;
    }

    /**
     * set sniff filter expression.
     * 
     * @param filter filter expression.
     * @returns updated filter expression.
     */
    async setSniffFilter(filter: string): Promise<string> {
        return (await this._load<FilterRespond>('POST', `${this._apiBase}/sniff`, JSON.stringify({ filter }))).result.currentFilter;
    }

    /**
     * get list of bgp peers of the given node.
     * 
     * @param node node id. must be node with router role.
     * @returns list of peers.
     */
    async getBgpPeers(node: string): Promise<BgpPeer[]> {
        return (await this._load<BgpPeer[]>('GET', `${this._apiBase}/container/${node}/bgp`)).result;
    }

    /**
     * set bgp peer state.
     * 
     * @param node node id. must be node with router role.
     * @param peer peer name.
     * @param up protocol state, true = up, false = down.
     */
    async setBgpPeers(node: string, peer: string, up: boolean) {
        await this._load('POST', `${this._apiBase}/container/${node}/bgp/${peer}`, JSON.stringify({ status: up }));
    }

    /**
     * get network state of the given node.
     * 
     * @param node node id.
     * @returns true if up, false if down.
     */
    async getNetworkStatus(node: string): Promise<boolean> {
        return (await this._load<boolean>('GET', `${this._apiBase}/container/${node}/net`)).result;
    }

    /**
     * set network state of the given node.
     * 
     * @param node node id.
     * @param up true if up, false if down.
     */
    async setNetworkStatus(node: string, up: boolean) {
        await this._load('POST', `${this._apiBase}/container/${node}/net`, JSON.stringify({ status: up }));
    }

    /**
     * event handler register.
     * 
     * @param eventName event to listen.
     * @param callback callback.
     */
    on(eventName: DataEvent, callback?: (data: any) => void) {
        switch(eventName) {
            case 'packet':
                this._packetEventHandler = callback;
                break;
            case 'dead':
                this._errorHandler = callback;
        }
    }

    get edges(): Edge[] {
        var edges: Edge[] = [];

        this._nodes.forEach(node => {
            let nets = node.NetworkSettings.Networks;
            Object.keys(nets).forEach(key => {
                let net = nets[key];
                var label = '';

                node.meta.emulatorInfo.nets.forEach(emunet => {
                    // fixme
                    if (key.includes(emunet.name)) {
                        label = emunet.address;
                    }
                });

                edges.push({
                    from: node.Id,
                    to: net.NetworkID,
                    label
                });
            })
        })

        return edges;
    }

    get vertices(): Vertex[] {
        var vertices: Vertex[] = [];

        this._nets.forEach(net => {
            var netInfo = net.meta.emulatorInfo;
            var vertex: Vertex = {
                id: net.Id,
                label: netInfo.displayname ?? `${netInfo.scope}/${netInfo.name}`,
                type: 'network',
                shape: netInfo.type == 'global' ? 'star' : 'diamond',
                object: net
            };

            if (netInfo.type == 'local') {
                vertex.group = netInfo.scope;
            }

            vertices.push(vertex);
        });

        this._nodes.forEach(node => {
            var nodeInfo = node.meta.emulatorInfo;
            var vertex: Vertex = {
                id: node.Id,
                label: nodeInfo.displayname ?? `${nodeInfo.asn}/${nodeInfo.name}`,
                type: 'node',
                shape: nodeInfo.role == 'Router' ? 'dot' : 'hexagon',
                object: node
            };

            if (nodeInfo.role != 'Route Server') {
                vertex.group = nodeInfo.asn.toString();
            }

            vertices.push(vertex);
        });

        return vertices;
    }

    get groups(): Set<string> {
        var groups = new Set<string>();

        this._nets.forEach(net => {
            groups.add(net.meta.emulatorInfo.scope);
        });

        this._nodes.forEach(node => {
            groups.add(node.meta.emulatorInfo.asn.toString());
        })

        return groups;
    }
}