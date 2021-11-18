#!/usr/bin/env python3
# encoding: utf-8

from seedemu.core import Emulator
from seedemu.services import DomainNameService, DomainNameCachingService

emu = Emulator()

###########################################################
# Create a DNS layer
dns = DomainNameService(autoNameServer = False)

# Create two nameservers for the root zone
dns.install('a-root-server').addZone('.').setMaster()   # Master server
dns.install('b-root-server').addZone('.')               # Slave server

# Create nameservers for TLD and ccTLD zones
dns.install('a-com-server').addZone('com.').setMaster()  
dns.install('b-com-server').addZone('com.')  
dns.install('net-server').addZone('net.')
dns.install('edu-server').addZone('edu.')
dns.install('edu-server').addZone('xyz.')

# Create nameservers for second-level zones
dns.install('ns-google-com').addZone('google.com.')
dns.install('ns-example-net').addZone('example.net.')
dns.install('ns-syr-edu').addZone('syr.edu.')

# Add records to zones 
dns.getZone('google.com.').addRecord('@ A 2.2.2.2') 
dns.getZone('example.net.').addRecord('@ A 3.3.3.3') 
dns.getZone('syr.edu.').addRecord('@ A 128.230.18.63') 

# Customize the display names (for visualization purpose)
emu.getVirtualNode('a-root-server').setDisplayName('Root-A')
emu.getVirtualNode('b-root-server').setDisplayName('Root-B')
emu.getVirtualNode('a-com-server').setDisplayName('COM-A')
emu.getVirtualNode('b-com-server').setDisplayName('COM-B')
emu.getVirtualNode('net-server').setDisplayName('NET')
emu.getVirtualNode('edu-server').setDisplayName('EDU')
emu.getVirtualNode('ns-google-com').setDisplayName('google.com')
emu.getVirtualNode('ns-example-net').setDisplayName('example.net')
emu.getVirtualNode('ns-syr-edu').setDisplayName('syr.edu')


###########################################################
emu.addLayer(dns)
emu.dump('component-dns.bin')
