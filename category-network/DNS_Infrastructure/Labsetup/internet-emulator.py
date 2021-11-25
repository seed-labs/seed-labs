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

emu.addBinding(Binding('root-server-a',  filter=Filter(asn=150), action=Action.FIRST))
emu.addBinding(Binding('root-server-b',  filter=Filter(asn=160), action=Action.FIRST))
emu.addBinding(Binding('com-server-a',   filter=Filter(asn=151), action=Action.FIRST))
emu.addBinding(Binding('com-server-b',   filter=Filter(asn=161), action=Action.FIRST))
emu.addBinding(Binding('edu-server',     filter=Filter(asn=152), action=Action.FIRST))
emu.addBinding(Binding('ns-example-com', filter=Filter(asn=154), action=Action.FIRST))
emu.addBinding(Binding('ns-AAAAA',     filter=Filter(asn=162), action=Action.NEW))
emu.addBinding(Binding('ns-BBBBB',     filter=Filter(asn=162), action=Action.NEW))

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
as153 = base.getAutonomousSystem(153)
as153.createHost('local-dns-1').joinNetwork('net0', address = '10.153.0.53')

as163 = base.getAutonomousSystem(163)
as163.createHost('local-dns-2').joinNetwork('net0', address = '10.163.0.53')

# Bind the Local DNS virtual nodes to physical nodes
emu.addBinding(Binding('global-dns-1', filter = Filter(asn=153, nodeName="local-dns-1")))
emu.addBinding(Binding('global-dns-2', filter = Filter(asn=163, nodeName="local-dns-2")))

# Use the following to set the local DNS for all ASes
# base.setNameServers(['10.163.0.53'])  


# We choose to set the local DNS for individual nodes
# We skip 155, so students can work on that.
asnlist = [150, 151, 152, 153, 154, 156, 160, 161, 162, 163, 164, 170, 171, 190]
for asn in asnlist: 
    base.getAutonomousSystem(asn).setNameServers(['10.153.0.53'])

# Add the ldns layer
emu.addLayer(ldns)


###############################################
# Render the emulation and further customization
emu.render()

###############################################
# Render the emulation
# Since we use IP anycast, we will set the selfManagedNetwork to true
#emu.compile(Docker(selfManagedNetwork=True, clientEnabled = True), './output')
emu.compile(Docker(selfManagedNetwork=True), './output2')

