#!/usr/bin/env python3
# encoding: utf-8

from os.path import exists
from seedemu import *

emuA = Emulator()
emuB = Emulator()

# Load the pre-built components and merge them

baseComponent = './component-base.bin'
dnsComponent  = './component-dns.bin'

if exists(baseComponent) and exists(dnsComponent):
   emuA.load(baseComponent)
   emuB.load(dnsComponent)
   emu = emuA.merge(emuB, DEFAULT_MERGERS)
else:
   print("Please run 'component-base.py' and 'component-dns.py' first")
   quit()


#####################################################################################
# Bind the virtual nodes in the DNS infrastructure layer to physical nodes.
# Action.FIRST will look for the first acceptable node that satisfies the filter rule.
# There are several other filters types that are not shown in this example.

emu.addBinding(Binding('a-root-server',  filter=Filter(asn=171), action=Action.FIRST))
emu.addBinding(Binding('b-root-server',  filter=Filter(asn=150), action=Action.FIRST))
emu.addBinding(Binding('a-com-server',   filter=Filter(asn=151), action=Action.FIRST))
emu.addBinding(Binding('b-com-server',   filter=Filter(asn=152), action=Action.FIRST))
emu.addBinding(Binding('a-net-server',   filter=Filter(asn=152), action=Action.FIRST))
emu.addBinding(Binding('a-edu-server',   filter=Filter(asn=153), action=Action.FIRST))
emu.addBinding(Binding('ns-google-com',  filter=Filter(asn=162), action=Action.FIRST))
emu.addBinding(Binding('ns-example-net', filter=Filter(asn=163), action=Action.FIRST))
emu.addBinding(Binding('ns-syr-edu',     filter=Filter(asn=164), action=Action.FIRST))

#####################################################################################
# Create two local DNS servers (virtual nodes).
ldns = DomainNameCachingService()
ldns.install('global-dns-1')
ldns.install('global-dns-2')

# Customize the display name (for visualization purpose)
emu.getVirtualNode('global-dns-1').setDisplayName('Global DNS-1')
emu.getVirtualNode('global-dns-2').setDisplayName('Global DNS-2')

# Create two new host in AS-152 and AS-153, use them to host the local DNS server.
# We can also host it on an existing node.
base: Base = emu.getLayer('Base')
as152 = base.getAutonomousSystem(152)
as152.createHost('local-dns-1').joinNetwork('net0', address = '10.152.0.53')
as153 = base.getAutonomousSystem(153)
as153.createHost('local-dns-2').joinNetwork('net0', address = '10.153.0.53')

# Bind the Local DNS virtual nodes to physical nodes
emu.addBinding(Binding('global-dns-1', filter = Filter(asn=152, nodeName="local-dns-1")))
emu.addBinding(Binding('global-dns-2', filter = Filter(asn=153, nodeName="local-dns-2")))

# Add 10.152.0.53 as the local DNS server for AS-160 and AS-170
# Add 10.153.0.53 as the local DNS server for all the other nodes
# We can also set this for individual nodes
base.getAutonomousSystem(160).setNameServers(['10.152.0.53'])
base.getAutonomousSystem(170).setNameServers(['10.152.0.53'])
base.setNameServers(['10.153.0.53'])

# Add the ldns layer
emu.addLayer(ldns)


###############################################
# Render the emulation and further customization
emu.render()

###############################################
# Render the emulation
# Since we use IP anycast, we will set the selfManagedNetwork to true
emu.compile(Docker(selfManagedNetwork=True, clientEnabled = True), './output')

