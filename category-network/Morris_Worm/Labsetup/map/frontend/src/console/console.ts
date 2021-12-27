import { Terminal } from 'xterm';
import 'xterm/css/xterm.css';
import './css/console.css';
import { ConsoleUi } from './ui';
import { ConsoleNetwork } from './network';

const term = new Terminal({
    theme: {
        foreground: '#C5C8C6',
        background: '#1D1F21',
        cursor: '#C5C8C6',
        cursorAccent: '#C5C8C6',
        black: '#555555',
        red: '#CC6666',
        green: '#B5BD68',
        yellow: '#F0C674',
        blue: '#81A2BE',
        magenta: '#B294BB',
        cyan: '#8ABEB7',
        white: '#C5C8C6'
    }
});

term.open(document.getElementById('terminal'));

const id = window.location.hash.replace('#', '');

(async function () {
    const net = new ConsoleNetwork(id);

    try {
        var container = (await net.getContainer()).result;
    } catch (e) {
        term.write(`error: ${e.result}\r\n`);
        return;
    }

    var meta = container.meta;
    var node = meta.emulatorInfo;

    var info = [];

    info.push({
        label: 'ASN',
        text: node.asn
    });
    
    info.push({
        label: 'Name',
        text: node.name
    });

    info.push({
        label: 'Role',
        text: node.role
    });

    node.nets.forEach(net => {
        info.push({
            label: 'IP',
            text: `${net.name},${net.address}`
        });
    });

    document.title = `${node.role}: AS${node.asn}/${node.name}`;

    const ui = new ConsoleUi(id, term, `AS${node.asn}/${node.name}`, info);

    if (meta.hasSession) {
        ui.createNotification('Attaching to an existing session; if you don\'t see the shell prompt, try pressing the return key.');
    }

    var ws = net.getSocket();

    ui.attach(ws);
    ui.configureIpc();
})();