import $ from 'jquery';
import { EmulatorNetwork, EmulatorNode } from '../common/types';
import { WindowManager } from '../common/window-manager';

export class IndexUi {
    private _containerTable: DataTables.Api;
    private _networkTable: DataTables.Api;
    private _wm: WindowManager;
    private _containerToolbar: HTMLDivElement;
    private _networkToolbar: HTMLDivElement;
    private _containerUrl: string;
    private _networkUrl: string;

    constructor(config: {
        containerListElementId: string,
        networkListElementId: string,
        desktopElementId: string,
        taskbarElementId: string
    }) {
        this._containerTable = $(`#${config.containerListElementId}`).DataTable({
            columnDefs: [
                {
                    targets: [4, 5],
                    orderable: false
                },
                {
                    targets: 0,
                    className: 'select-checkbox',
                    orderable: false
                }
            ],
            select: {
                selector: 'td:first-child',
                style: 'multi'
            },
            order: [[ 1, 'asc' ]],
            dom:
                "<'row'<'col-9 toolbar container-toolbar'><'col-3'f>>" + 
                "<'row'<'col-12'tr>>" +
                "<'row'<'col-12'i>>" +
                "<'row'<'col-12'p>>"

        });

        this._networkTable = $(`#${config.networkListElementId}`).DataTable({
            columnDefs: [
                {
                    targets: [5],
                    orderable: false
                },
                {
                    targets: 0,
                    className: 'select-checkbox',
                    orderable: false
                }
            ],
            select: {
                selector: 'td:first-child',
                style: 'multi'
            },
            order: [[ 1, 'asc' ]],
            dom:
                "<'row'<'col-9 toolbar network-toolbar'><'col-3'f>>" + 
                "<'row'<'col-12'tr>>" +
                "<'row'<'col-12'i>>" +
                "<'row'<'col-12'p>>"
        });

        this._containerToolbar = document.querySelector('.container-toolbar');
        this._networkToolbar = document.querySelector('.network-toolbar');
        this._wm = new WindowManager(config.desktopElementId, config.taskbarElementId);

        this._configureToolbar(this._containerTable, this._containerToolbar);
        this._configureToolbar(this._networkTable, this._networkToolbar);

        this._initContainerToolbar();
        this._initNetworkToolbar();
    }

    private _reloadContainers() {
        if (!this._containerUrl) return;

        this.loadContainers(this._containerUrl);
    }

    private _createBtn(text: string, className: string, cb: any, iconClassName?: string): HTMLButtonElement {
        var btn = document.createElement('button');
        var btnIcon = document.createElement('i');
        var btnText = document.createElement('span');

        btnText.innerText = text;

        btn.className = className;
        if (iconClassName) {
            btnIcon.className = iconClassName;
            btn.appendChild(btnIcon);
        }
        btn.appendChild(btnText);
        btn.onclick = cb;

        return btn;
    }

    private _configureToolbar(table: DataTables.Api, toolbar: HTMLDivElement) {
        var btnGroupSelects = document.createElement('div');
        btnGroupSelects.className = 'btn-group mr-1 mb-1';

        btnGroupSelects.appendChild(this._createBtn(
            'Select All',
            'btn btn-sm btn-secondary',
            () => table.rows({ search: 'applied' }).select()
        ));

        btnGroupSelects.appendChild(this._createBtn(
            'Invert Selections',
            'btn btn-sm btn-info',
            () => {
                var selected = table.rows({ selected: true, search: 'applied' });
                var rest = table.rows({ selected: false, search: 'applied' });

                rest.select();
                selected.deselect();
            }
        ));

        btnGroupSelects.appendChild(this._createBtn(
            'Deselect All',
            'btn btn-sm btn-light',
            () => table.rows({ search: 'applied' }).deselect()
        ));

        toolbar.appendChild(btnGroupSelects);
    }

    private _initContainerToolbar() {
        var btnGroupSelectedOptions = document.createElement('div');
        btnGroupSelectedOptions.className = 'btn-group mr-1 mb-1';

        btnGroupSelectedOptions.appendChild(this._createBtn(
            'Attach selected',
            'btn btn-sm btn-primary',
            () => {
                var console = this._wm.createWindow.bind(this._wm);
                this._containerTable.rows({ selected: true, search: 'applied' }).nodes().each((row: HTMLTableRowElement) => {
                    console(row.id, row.title);
                });
            }
        ));

        btnGroupSelectedOptions.appendChild(this._createBtn(
            'Run on selected…',
            'btn btn-sm btn-info',
            () => alert('Not implemented')
        ));

        btnGroupSelectedOptions.appendChild(this._createBtn(
            'Kill selected…',
            'btn btn-sm btn-danger',
            () => alert('Not implemented')
        ));

        this._containerToolbar.appendChild(btnGroupSelectedOptions);

        this._containerToolbar.appendChild(this._createBtn(
            'Add Node…',
            'btn btn-sm btn-success mr-1 mb-1',
            () => alert('Not implemented'),
            'bi bi-plus mr-1'
        ));

        this._containerToolbar.appendChild(this._createBtn(
            'Reload',
            'btn btn-sm btn-light mr-1 mb-1',
            this._reloadContainers.bind(this),
            'bi bi-arrow-clockwise'
        ));
    }

    private _initNetworkToolbar() {
        this._networkToolbar.appendChild(this._createBtn(
            'Delete selected…',
            'btn btn-sm btn-danger mr-1 mb-1',
            () => alert('Not implemented')
        ));

        this._networkToolbar.appendChild(this._createBtn(
            'New network…',
            'btn btn-sm btn-success mr-1 mb-1',
            () => alert('Not implemented'),
            'bi bi-plus mr-1'
        ));

        this._networkToolbar.appendChild(this._createBtn(
            'Reload',
            'btn btn-sm btn-light mr-1 mb-1',
            () => alert('Not implemented'),
            'bi bi-arrow-clockwise'
        ));
    }

    private _createNodeRow(container: EmulatorNode) {
        var node = container.meta.emulatorInfo;

        var tr = document.createElement('tr');

        var tds = document.createElement('td');
        var td0 = document.createElement('td');
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var td3 = document.createElement('td');
        var td4 = document.createElement('td');

        td0.className = 'text-monospace';
        td1.className = 'text-monospace';
        td2.className = 'text-monospace';

        td0.innerText = node.asn != 0 ? `AS${node.asn}` : 'N/A';
        td1.innerText = node.name;
        td2.innerText = node.role;

        node.nets.forEach(a => {
            var div = document.createElement('div');

            div.className = 'network';

            var name = document.createElement('span');
            var address = document.createElement('span');

            name.className = 'name';
            address.className = 'address text-monospace';

            name.innerText = a.name;
            address.innerText = a.address;

            div.appendChild(name);
            div.appendChild(address);

            td3.appendChild(div);
        });

        var console = this._wm.createWindow.bind(this._wm);
        var id = container.Id.substr(0, 12);
        var title = `${node.role}: AS${node.asn}/${node.name}`;

        td4.appendChild(this._createBtn(
            'Attach',
            'btn btn-sm btn-primary mr-1 mb-1',
            () => console(id, title)
        ));

        td4.appendChild(this._createBtn(
            'Kill…',
            'btn btn-sm btn-danger mr-1 mb-1',
            () => alert('Not implemented')
        ));
        
        [tds, td0, td1, td2, td3, td4].forEach(td => tr.appendChild(td));

        tr.id = id;
        tr.title = title;

        return tr;
    }

    private _createNetworkRow(network: EmulatorNetwork) {
        var net = network.meta.emulatorInfo;

        var tr = document.createElement('tr');

        var tds = document.createElement('td');
        var td0 = document.createElement('td');
        var td1 = document.createElement('td');
        var td2 = document.createElement('td');
        var td3 = document.createElement('td');
        var td4 = document.createElement('td');

        td0.className = 'text-monospace';
        td1.className = 'text-monospace';
        td2.className = 'text-monospace';
        td3.className = 'text-monospace';

        td0.innerText = net.scope;
        td1.innerText = net.name;
        td2.innerText = net.type;
        td3.innerText = net.prefix;
        
        [tds, td0, td1, td2, td3, td4].forEach(td => tr.appendChild(td));

        tr.id = net.name;
        tr.title = net.name;

        return tr;
    }

    private _load(url: string, table: DataTables.Api, handler: (data: any) => HTMLTableRowElement) {
        var xhr = new XMLHttpRequest();
        var createRow = handler.bind(this);

        table.clear();

        xhr.open('GET', url);
        xhr.onload = function() {
            if (xhr.status == 200) {
                var res = JSON.parse(xhr.responseText);
                if (!res.ok) return;

                res.result.forEach((c) => {
                    table.row.add(createRow(c));
                });
            }
            table.draw();
        };

        xhr.send();
    }

    loadContainers(url: string) {
        this._containerUrl = url;
        this._load(url, this._containerTable, this._createNodeRow);
    }

    loadNetworks(url: string) {
        this._networkUrl = url;
        this._load(url, this._networkTable, this._createNetworkRow);
    }

};