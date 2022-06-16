import { CompletionTree } from "./completion";

export let bpfCompletionTree: CompletionTree = {
    type: 'root',
    children: [
        {
            type: 'keyword',
            name: 'dst',
            description: 'matching packet\'s destination.',
            children: [
                {
                    type: 'value',
                    name: '<host>',
                    description: 'matching packet\'s destination IP address.'
                },
                {
                    type: 'keyword',
                    name: 'host',
                    description: 'matching packet\'s destination IP address.',
                    children: [
                        {
                            type: 'value',
                            name: '<host>',
                            description: 'matching packet\'s destination IP address.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'net',
                    description: 'matching packet\'s destination network.',
                    children: [
                        {
                            type: 'value',
                            name: '<net>',
                            description: 'matching packet\'s destination network.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'port',
                    description: 'matching packet\'s destination port.',
                    children: [
                        {
                            type: 'value',
                            name: '<port>',
                            description: 'matching packet\'s destination port.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'portrange',
                    description: 'matching packet\'s destination port rage.',
                    children: [
                        {
                            type: 'value',
                            name: '<port1-port2>',
                            description: 'matching packet\'s destination port rage.'
                        }
                    ]
                }
            ]
        },
        {
            type: 'keyword',
            name: 'src',
            description: 'matching packet\'s source.',
            children: [
                {
                    type: 'value',
                    name: '<host>',
                    description: 'matching packet\'s source IP address.'
                },
                {
                    type: 'keyword',
                    name: 'host',
                    description: 'matching packet\'s source IP address.',
                    children: [
                        {
                            type: 'value',
                            name: '<host>',
                            description: 'matching packet\'s source IP address.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'net',
                    description: 'matching packet\'s source network.',
                    children: [
                        {
                            type: 'value',
                            name: '<net>',
                            description: 'matching packet\'s source network.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'port',
                    description: 'matching packet\'s source port.',
                    children: [
                        {
                            type: 'value',
                            name: '<port>',
                            description: 'matching packet\'s source port.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'portrange',
                    description: 'matching packet\'s source port range.',
                    children: [
                        {
                            type: 'value',
                            name: '<port1-port2>',
                            description: 'matching packet\'s source rage.'
                        }
                    ]
                }
            ]
        },
        {
            type: 'keyword',
            name: 'host',
            description: 'matching packets from or to the given IP address.',
            children: [
                {
                    type: 'value',
                    name: '<host>',
                    description: 'matching packets from or to the given IP address.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'net',
            description: 'matching packets from or to the given network.',
            children: [
                {
                    type: 'value',
                    name: '<net>',
                    description: 'matching packets from or to the given network.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'port',
            description: 'matching packets from or to the given port.',
            children: [
                {
                    type: 'value',
                    name: '<port>',
                    description: 'matching packets from or to the given port.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'portrange',
            description: 'matching packets from or to the given port range.',
            children: [
                {
                    type: 'value',
                    name: '<port1-port2>',
                    description: 'matching packets from or to the given port range.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'ether',
            description: 'matching packets with mac address.',
            children: [
                {
                    type: 'keyword',
                    name: 'dst',
                    description: 'matching packets to the given mac address.',
                    children: [
                        {
                            type: 'value',
                            name: '<mac address>',
                            description: 'matching packets to the given mac address.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'src',
                    description: 'matching packets from the given mac address.',
                    children: [
                        {
                            type: 'value',
                            name: '<mac address>',
                            description: 'matching packets from the given mac address.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'host',
                    description: 'matching packets from or to the given mac address.',
                    children: [
                        {
                            type: 'value',
                            name: '<mac address>',
                            description: 'matching packets from or to the given mac address.'
                        }
                    ]
                },
                {
                    type: 'keyword',
                    name: 'broadcast',
                    description: 'matching layer two broadcast packets.'
                },
                {
                    type: 'keyword',
                    name: 'multicast',
                    description: 'matching layer two multicast packets.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'ip',
            description: 'matching IP packets.',
            children: [
                {
                    type: 'keyword',
                    name: 'broadcast',
                    description: 'matching broadcast IP packets.'
                },
                {
                    type: 'keyword',
                    name: 'multicast',
                    description: 'matching multicast IP packets.'
                }
            ]
        },
        {
            type: 'keyword',
            name: 'arp',
            description: 'matching ARP packets.'
        },
        {
            type: 'keyword',
            name: 'tcp',
            description: 'matching TCP packets.'
        },
        {
            type: 'keyword',
            name: 'udp',
            description: 'matching UDP packets.'
        },
        {
            type: 'keyword',
            name: 'icmp',
            description: 'matching ICMP packets.'
        }
    ]
};