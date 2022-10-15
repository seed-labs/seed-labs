#!/usr/bin/env python3
# encoding: utf-8

from seedemu import *
import os, sys

def makeStubAs(emu: Emulator, base: Base, asn: int, exchange: int, hosts_total: int):
    # Create AS and internal network
    network = "net0"
    stub_as = base.createAutonomousSystem(asn)
    stub_as.createNetwork(network)

    # Create a BGP router
    # Attach the router to both the internal and external networks
    router = stub_as.createRouter('router0')
    router.joinNetwork(network)
    router.joinNetwork('ix{}'.format(exchange))

    for counter in range(hosts_total):
       name = 'host_{}'.format(counter)
       host = stub_as.createHost(name)
       host.joinNetwork(network)

hosts_total = 2  # Each AS has 3 hosts.

###############################################################################
emu     = Emulator()
base    = Base()
routing = Routing()
ebgp    = Ebgp()
ibgp    = Ibgp()
ospf    = Ospf()


###############################################################################

ix100 = base.createInternetExchange(100)
ix101 = base.createInternetExchange(101)
ix102 = base.createInternetExchange(102)
ix103 = base.createInternetExchange(103)
ix104 = base.createInternetExchange(104)

# Customize names (for visualization purpose)
ix100.getPeeringLan().setDisplayName('NYC-100')
ix101.getPeeringLan().setDisplayName('San Jose-101')
ix102.getPeeringLan().setDisplayName('Chicago-102')
ix103.getPeeringLan().setDisplayName('Miami-103')
ix104.getPeeringLan().setDisplayName('Boston-104')


###############################################################################
# Create Transit Autonomous Systems 

## Tier 1 ASes
Makers.makeTransitAs(base, 2, [100, 101, 102], 
       [(100, 101), (101, 102)] 
)

Makers.makeTransitAs(base, 3, [100, 103, 104], 
       [(100, 103), (103, 104)]
)

Makers.makeTransitAs(base, 4, [100, 102, 104], 
       [(100, 104), (102, 104)]
)

## Tier 2 ASes
Makers.makeTransitAs(base, 12, [101, 104], [(101, 104)])


###############################################################################
# Create single-homed stub ASes. "None" means create a host only 

makeStubAs(emu, base, 150, 100, hosts_total)
makeStubAs(emu, base, 151, 100, hosts_total)

makeStubAs(emu, base, 152, 101, hosts_total)
makeStubAs(emu, base, 153, 101, hosts_total)

makeStubAs(emu, base, 154, 102, hosts_total)

makeStubAs(emu, base, 160, 103, hosts_total)
makeStubAs(emu, base, 161, 103, hosts_total)
makeStubAs(emu, base, 162, 103, hosts_total)

makeStubAs(emu, base, 163, 104, hosts_total)
makeStubAs(emu, base, 164, 104, hosts_total)


###############################################################################
# Peering via RS (route server). The default peering mode for RS is PeerRelationship.Peer, 
# which means each AS will only export its customers and their own prefixes. 
# We will use this peering relationship to peer all the ASes in an IX.
# None of them will provide transit service for others. 

ebgp.addRsPeers(100, [2, 3, 4])
ebgp.addRsPeers(102, [2, 4])
ebgp.addRsPeers(104, [3, 4])

# To buy transit services from another autonomous system, 
# we will use private peering  

ebgp.addPrivatePeerings(100, [2],  [150, 151], PeerRelationship.Provider)
ebgp.addPrivatePeerings(100, [3],  [150], PeerRelationship.Provider)

ebgp.addPrivatePeerings(101, [2],  [12], PeerRelationship.Provider)
ebgp.addPrivatePeerings(101, [12], [152, 153], PeerRelationship.Provider)

ebgp.addPrivatePeerings(102, [2, 4],  [154], PeerRelationship.Provider)

ebgp.addPrivatePeerings(103, [3],  [160, 161, 162], PeerRelationship.Provider)

ebgp.addPrivatePeerings(104, [3, 4], [12], PeerRelationship.Provider)
ebgp.addPrivatePeerings(104, [4],  [163], PeerRelationship.Provider)
ebgp.addPrivatePeerings(104, [12], [164], PeerRelationship.Provider)



###############################################################################
# Create the Ethereum layer

eth = EthereumService()
asns = [150, 151, 152, 153, 154]
i = 0
for asn in asns:
    for id in range(hosts_total):
        e = eth.install("eth{}".format(i)).setConsensusMechanism(ConsensusMechanism.POA)
        vnode = 'eth{}'.format(i)
        displayName = 'Ethereum-POA-{}'
        e.enableGethHttp()  # Enable HTTP on all nodes
        if i%3 == 0:
            e.setBootNode(True)
            e.unlockAccounts()
            displayName = displayName + '-BootNode'
        if i%2  == 0:
            e.startMiner()
            e.unlockAccounts()
            displayName = displayName + '-Signer'

        emu.getVirtualNode(vnode).setDisplayName(displayName.format(i))
        emu.addBinding(Binding(vnode, filter=Filter(asn=asn, nodeName='host_{}'.format(id))))
        i = i+1

# Create/Import prefunded accounts
eth.install("eth0").createAccount(balance= 99 * pow(10,20), password="admin")
eth.install("eth0").createAccount(balance= 0, password="admin")

eth.install("eth1").createAccounts(balance = 55*pow(10,20), password="admin")
eth.install("eth2").createAccounts(balance = 55*pow(10,20), password="admin")
eth.install("eth3").createAccounts(balance = 55*pow(10,20), password="admin")


# Enable HTTP and add port forwarding
# The default port is 8545, we can change it to others using setGethHttpPort()
e0 = eth.install("eth0")
e1 = eth.install("eth1")
e2 = eth.install("eth2")
e3 = eth.install("eth3")
e0.enableGethHttp()
e1.enableGethHttp()
e2.enableGethHttp()
e3.enableGethHttp()
emu.getVirtualNode("eth0").addPortForwarding(8545, e0.getGethHttpPort())
emu.getVirtualNode("eth1").addPortForwarding(8546, e1.getGethHttpPort())
emu.getVirtualNode("eth2").addPortForwarding(8547, e2.getGethHttpPort())
emu.getVirtualNode("eth3").addPortForwarding(8548, e3.getGethHttpPort())

# Add layers to the emulator
emu.addLayer(base)
emu.addLayer(routing)
emu.addLayer(ebgp)
emu.addLayer(ibgp)
emu.addLayer(ospf)
emu.addLayer(eth)
emu.render()


docker = Docker()
emu.compile(docker, './output-small', override = True)
