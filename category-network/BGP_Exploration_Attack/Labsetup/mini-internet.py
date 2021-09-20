#!/usr/bin/env python3
# encoding: utf-8

from seedemu.layers import Base, Routing, Ebgp, Ibgp, Ospf, PeerRelationship, Dnssec
from seedemu.services import WebService, DomainNameService, DomainNameCachingService
from seedemu.services import CymruIpOriginService, ReverseDomainNameService, BgpLookingGlassService
from seedemu.compiler import Docker, Graphviz
from seedemu.hooks import ResolvConfHook
from seedemu.core import Emulator, Service, Binding, Filter
from seedemu.layers import Router
from seedemu.raps import OpenVpnRemoteAccessProvider
from seedemu.utilities import Makers
from os import mkdir

from typing import List, Tuple, Dict


###############################################################################
emu     = Emulator()
base    = Base()
routing = Routing()
ebgp    = Ebgp()
ibgp    = Ibgp()
#ospf    = Ospf()
web     = WebService()
#ovpn    = OpenVpnRemoteAccessProvider()


###############################################################################

ix100 = base.createInternetExchange(100)
ix101 = base.createInternetExchange(101)
ix102 = base.createInternetExchange(102)
ix103 = base.createInternetExchange(103)
ix104 = base.createInternetExchange(104)
ix105 = base.createInternetExchange(105)

# Customize names (for visualization purpose)
ix100.getPeeringLan().setDisplayName('NYC-100')
ix101.getPeeringLan().setDisplayName('San Jose-101')
ix102.getPeeringLan().setDisplayName('Chicago-102')
ix103.getPeeringLan().setDisplayName('Miami-103')
ix104.getPeeringLan().setDisplayName('Boston-104')
ix105.getPeeringLan().setDisplayName('Huston-105')


###############################################################################
# Create Transit Autonomous Systems 

## Tier 1 ASes
Makers.makeTransitAs(base, 2, [100, 101, 102, 105], 
       [(100, 101), (101, 102), (100, 105)] 
)

Makers.makeTransitAs(base, 3, [100, 103, 104, 105], 
       [(100, 103), (100, 105), (103, 105), (103, 104)]
)

Makers.makeTransitAs(base, 4, [100, 102, 104], 
       [(100, 104), (102, 104)]
)

# This transit is for lab exercise. Its setup is incomplete
Makers.makeTransitAs(base, 5, [101, 103, 105], 
       [(101, 103), (103, 105)]
)

## Tier 2 ASes
Makers.makeTransitAs(base, 11, [102, 105], [(102, 105)])
Makers.makeTransitAs(base, 12, [101, 104], [(101, 104)])


###############################################################################
# Create single-homed stub ASes. "None" means create a host only 

Makers.makeStubAs(emu, base, 150, 100, [web, None])
# Add a shared folder to AS-150's BGP router (need it for the experiment)
as150 = base.getAutonomousSystem(150)
as150.getRouter('router0').addSharedFolder('/volumes', './volumes')


Makers.makeStubAs(emu, base, 151, 100, [web, None])

Makers.makeStubAs(emu, base, 152, 101, [None, None])
Makers.makeStubAs(emu, base, 153, 101, [web, None, None])

Makers.makeStubAs(emu, base, 154, 102, [None, web])
Makers.makeStubAs(emu, base, 155, 102, [None, web])
Makers.makeStubAs(emu, base, 156, 102, [None, web])

Makers.makeStubAs(emu, base, 160, 103, [web, None])
Makers.makeStubAs(emu, base, 161, 103, [web, None])
Makers.makeStubAs(emu, base, 162, 103, [web, None])

Makers.makeStubAs(emu, base, 163, 104, [web, None])
Makers.makeStubAs(emu, base, 164, 104, [None, None])

Makers.makeStubAs(emu, base, 170, 105, [web, None])
Makers.makeStubAs(emu, base, 171, 105, [None])

# This stub AS is for lab exercise. Its setup is incomplete
Makers.makeStubAs(emu, base, 180, 105, [web, None])


###############################################################################
# This stub AS is for IP anycast
# Create a new AS with two disjoint networks, but the
# IP prefix of these two networks are the same.
as190 = base.createAutonomousSystem(190)
as190.createNetwork('net0', '10.190.0.0/24')
as190.createNetwork('net1', '10.190.0.0/24')

# Create a host on each network, but assign them the same IP address
as190.createHost('host-0').joinNetwork('net0', address = '10.190.0.100')
as190.createHost('host-1').joinNetwork('net1', address = '10.190.0.100')

# Attach one network to IX-100 and the other to IX-105 (via BGP router)
as190.createRouter('router0').joinNetwork('net0').joinNetwork('ix100')
as190.createRouter('router1').joinNetwork('net1').joinNetwork('ix105')



###############################################################################
# Peering via RS (route server). The default peering mode for RS is PeerRelationship.Peer, 
# which means each AS will only export its customers and their own prefixes. 
# We will use this peering relationship to peer all the ASes in an IX.
# None of them will provide transit service for others. 

ebgp.addRsPeers(100, [2, 3, 4])
ebgp.addRsPeers(102, [2, 4])
ebgp.addRsPeers(104, [3, 4])
ebgp.addRsPeers(105, [2, 3])

# To buy transit services from another autonomous system, 
# we will use private peering  

ebgp.addPrivatePeerings(100, [2],  [150, 151], PeerRelationship.Provider)
ebgp.addPrivatePeerings(100, [3],  [150], PeerRelationship.Provider)
ebgp.addPrivatePeerings(100, [150], [151], PeerRelationship.Peer)

ebgp.addPrivatePeerings(101, [2],  [12], PeerRelationship.Provider)
ebgp.addPrivatePeerings(101, [12], [152, 153], PeerRelationship.Provider)

ebgp.addPrivatePeerings(102, [2, 4], [11, 154, 155], PeerRelationship.Provider)
ebgp.addPrivatePeerings(102, [11],   [154], PeerRelationship.Provider)
ebgp.addPrivatePeerings(102, [4],    [156], PeerRelationship.Provider)
ebgp.addPrivatePeerings(102, [155],  [156], PeerRelationship.Peer)

ebgp.addPrivatePeerings(103, [3],  [160, 161, 162], PeerRelationship.Provider)

ebgp.addPrivatePeerings(104, [3, 4], [12], PeerRelationship.Provider)
ebgp.addPrivatePeerings(104, [4],  [163], PeerRelationship.Provider)
ebgp.addPrivatePeerings(104, [12], [164], PeerRelationship.Provider)

ebgp.addPrivatePeerings(105, [3],  [11, 170], PeerRelationship.Provider)
ebgp.addPrivatePeerings(105, [11], [171], PeerRelationship.Provider)

# AS-190 is for the IP anycast task
ebgp.addPrivatePeerings(100, [4],  [190], PeerRelationship.Provider)
ebgp.addPrivatePeerings(105, [3],  [190], PeerRelationship.Provider)


###############################################################################

# Add layers to the emulator
emu.addLayer(base)
emu.addLayer(routing)
emu.addLayer(ebgp)
emu.addLayer(ibgp)
#emu.addLayer(ospf)
emu.addLayer(Ospf())
emu.addLayer(web)

# Save it to a component file, so it can be used by other emulators
#emu.dump('base-component.bin')

emu.render()
#emu.compile(Docker(clientEnabled = True), './output')

emu.compile(Docker(selfManagedNetwork=True, clientEnabled = True), './output')


# Create the shared folder
mkdir('./output/volumes')

