#!/usr/bin/env python3
# encoding: utf-8


import sys, os
from seedemu import *

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
       host.appendStartCommand('rm -f /root/.bashrc && cd /bof && ./server &')


#n = len(sys.argv)
#if n < 2:
#    print("Please provide the number of hosts per networks")
#    exit(0)
#hosts_total = int(sys.argv[1])

hosts_total = int(5)


###############################################################################
emu     = Emulator()
base    = Base()
routing = Routing()
ebgp    = Ebgp()


###############################################################################

ix100 = base.createInternetExchange(100)
ix100.getPeeringLan().setDisplayName('NYC-100')

###############################################################################
# Create single-homed stub ASes, and peer them with one another 

makeStubAs(emu, base, 151, 100, hosts_total)
makeStubAs(emu, base, 152, 100, hosts_total)
makeStubAs(emu, base, 153, 100, hosts_total)

ebgp.addRsPeers(100, [151, 152, 153])
###############################################################################

# Add layers to the emulator
emu.addLayer(base)
emu.addLayer(routing)
emu.addLayer(ebgp)

emu.render()

# Use the "morris-worm-base" custom base image
docker = Docker()
docker.addImage(DockerImage('morris-worm-base', []))
docker.forceImage('morris-worm-base')
emu.compile(docker, './output', override = True)

# Copy the base container image to the output folder
os.system('cp -r container_files/morris-worm-base ./output')
