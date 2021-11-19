#!/usr/bin/env python3
# encoding: utf-8

from seedemu.core import Emulator
from seedemu.services import DomainNameService, DomainNameCachingService

emu = Emulator()

###########################################################
# Create a DNS layer
dns = DomainNameService(autoNameServer = False)

# Create two nameservers for the root zone
dns.install('root-server-a').addZone('.').setMaster()   # Master server
dns.install('root-server-b').addZone('.')               # Slave server

# Create nameservers for TLD and ccTLD zones
dns.install('com-server-a').addZone('com.').setMaster()  
dns.install('com-server-b').addZone('com.')  
dns.install('edu-server').addZone('edu.')

# Create nameservers for second-level zones
dns.install('ns-example-com').addZone('example.com.')

# Create two place holders
dns.install('ns-AAAAA').addZone('AAAAA.')
dns.install('ns-BBBBB').addZone('BBBBB.')


# Customize the display names (for visualization purpose)
emu.getVirtualNode('root-server-a').setDisplayName('DNS-Root-A')
emu.getVirtualNode('root-server-b').setDisplayName('DNS-Root-B')
emu.getVirtualNode('com-server-a').setDisplayName('DNS-COM-A')
emu.getVirtualNode('com-server-b').setDisplayName('DNS-COM-B')
emu.getVirtualNode('edu-server').setDisplayName('DNS-EDU')
emu.getVirtualNode('ns-example-com').setDisplayName('DNS-Example.com')
emu.getVirtualNode('ns-AAAAA').setDisplayName('DNS-AAAAA')
emu.getVirtualNode('ns-BBBBB').setDisplayName('DNS-BBBBB')


###########################################################
emu.addLayer(dns)
emu.dump('component-dns.bin')
