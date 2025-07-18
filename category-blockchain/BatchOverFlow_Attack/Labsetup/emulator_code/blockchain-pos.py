#!/usr/bin/env python3
# encoding: utf-8

from seedemu import *
import sys, os

###############################################################################
# Set the platform information
script_name = os.path.basename(__file__)

if len(sys.argv) == 1:
    platform = Platform.AMD64
elif len(sys.argv) == 2:
    if sys.argv[1].lower() == 'amd':
        platform = Platform.AMD64
    elif sys.argv[1].lower() == 'arm':
        platform = Platform.ARM64
    else:
        print(f"Usage:  {script_name} amd|arm")
        sys.exit(1)
else:
    print(f"Usage:  {script_name} amd|arm")
    sys.exit(1)

# Create Emulator Base with 10 Stub AS (150-154, 160-164) using Makers utility method.
# hosts_per_stub_as=3 : create 3 hosts per one stub AS.
# It will create hosts(physical node) named `host_{}`.format(counter), counter starts from 0. 
hosts_per_stub_as = 3
emu = Makers.makeEmulatorBaseWith10StubASAndHosts(hosts_per_stub_as = hosts_per_stub_as)

# Create the Ethereum layer
eth = EthereumService()

# Create the Blockchain layer which is a sub-layer of Ethereum layer.
# chainName="pos": set the blockchain name as "pos"
# consensus="ConsensusMechnaism.POS" : set the consensus of the blockchain as "ConsensusMechanism.POS".
# supported consensus option: ConsensusMechanism.POA, ConsensusMechanism.POW, ConsensusMechanism.POS
blockchain = eth.createBlockchain(chainName="pos", consensus=ConsensusMechanism.POS)


asns = [150, 151, 152, 153, 154, 160, 161, 162, 163, 164]

###################################################
# Ethereum Node

i = 1
for asn in asns:
    for id in range(hosts_per_stub_as):        
        # Create a blockchain virtual node named "eth{}".format(i)
        e:EthereumServer = blockchain.createNode("eth{}".format(i))   
        
        # Create Docker Container Label named 'Ethereum-POS-i'
        e.appendClassName('Ethereum-POS-{}'.format(i))

        # Enable Geth to communicate with geth node via http
        e.enableGethHttp()

        # Set host in asn 150 with id 0 (ip : 10.150.0.71) as BeaconSetupNode.
        if asn == 150 and id == 0:
                e.setBeaconSetupNode()

        # Set host in asn 150 with id 1 (ip : 10.150.0.72) as BootNode. 
        # This node will serve as a BootNode in both execution layer (geth) and consensus layer (lighthouse).
        if asn == 150 and id == 1:
                e.setBootNode(True)

        # Set hosts in asn 152 and 162 with id 0 and 1 as validator node. 
        # Validator is added by deposit 32 Ethereum and is activated in realtime after the Merge.
        # isManual=True : deposit 32 Ethereum by manual. 
        #                 Other than deposit part, create validator key and running a validator node is done by codes.  
        if asn in [151]:
            if id == 0:
                e.enablePOSValidatorAtRunning()
            if id == 1:
                e.enablePOSValidatorAtRunning(is_manual=True)
        
        # Set hosts in asn 152, 153, 154, and 160 as validator node.
        # These validators are activated by default from genesis status.
        # Before the Merge, when the consensus in this blockchain is still POA, 
        # these hosts will be the signer nodes.
        if asn in [152,153,154,160,161,162,163,164]:
            e.enablePOSValidatorAtGenesis()

        # Customizing the display names (for visualiztion purpose)
        if e.isBeaconSetupNode():
            emu.getVirtualNode('eth{}'.format(i)).setDisplayName('Ethereum-BeaconSetup')
        else:
            emu.getVirtualNode('eth{}'.format(i)).setDisplayName('Ethereum-POS-{}'.format(i))

        # Binding the virtual node to the physical node. 
        emu.addBinding(Binding('eth{}'.format(i), filter=Filter(asn=asn, nodeName='host_{}'.format(id))))

        i = i+1


# Add layer to the emulator
emu.addLayer(eth)

emu.render()

# Enable internetMap
# Enable etherView
docker = Docker(internetMapEnabled=True, etherViewEnabled=True, platform=platform)

emu.compile(docker, './output', override = True)
