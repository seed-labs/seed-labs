#!/usr/bin/env python3
# encoding: utf-8

from seedemu import *
import os, sys

if len(sys.argv) < 2:
    print ("Usage: blockchain-poa.py <option>")
    print ("       <option>: -s for small size, -l for large size") 
    exit()

if sys.argv[1]=='-s': 
   emulator_size = 10
else:
   emulator_size = 20


###############################################################################
emu = Emulator()

# Load the pre-built components and merge them
emu.load('./base-component.bin')


###############################################################################
# Create the Ethereum layer

eth = EthereumService()
blockchain = eth.createBlockchain(chainName="POA", consensus=ConsensusMechanism.POA)

# Change the default account balance to 1000
mnemonic, _, _= blockchain.getEmuAccountParameters()
blockchain.setEmuAccountParameters(mnemonic=mnemonic, balance=1000, total_per_node=2)

# Create 10 accounts, each with 100 Ethers. We will use these accounts to
# generate background traffic (sending random transactions from them).
words = "great amazing fun seed lab protect network system security prevent attack future"
blockchain.setLocalAccountParameters(mnemonic=words, total=10, balance=100) 

# These 3 accounts are generated from the following phrase:
# "gentle always fun glass foster produce north tail security list example gain"
# They are for users. We will use them in MetaMask, as well as in our sample code.  
blockchain.addLocalAccount(address='0xF5406927254d2dA7F7c28A61191e3Ff1f2400fe9',
                           balance=30)
blockchain.addLocalAccount(address='0x2e2e3a61daC1A2056d9304F79C168cD16aAa88e9', 
                           balance=9999999)
blockchain.addLocalAccount(address='0xCBF1e330F0abD5c1ac979CF2B2B874cfD4902E24', 
                           balance=10)


# Create the Ethereum servers. 
asns  = [150, 151, 152, 153, 154, 160, 161, 162, 163, 164]
if emulator_size == 10:
   hosts_total = 1    # The number of servers per AS
else:
   hosts_total = 2    # The number of servers per AS

signers  = []
i = 0
for asn in asns:
    for id in range(hosts_total):
        vnode = 'eth{}'.format(i)
        e = blockchain.createNode(vnode)

        displayName = 'Ethereum-POA-%.2d'
        e.enableGethHttp()  # Enable HTTP on all nodes
        e.unlockAccounts()
        if i%2  == 0:
            e.startMiner()
            signers.append(vnode)
            displayName = displayName + '-Signer'
            emu.getVirtualNode(vnode).appendClassName("Signer")
        if i%3 == 0:
            e.setBootNode(True)
            displayName = displayName + '-BootNode'
            emu.getVirtualNode(vnode).appendClassName("BootNode")

        emu.getVirtualNode(vnode).setDisplayName(displayName%(i))
        emu.addBinding(Binding(vnode, filter=Filter(asn=asn, nodeName='host_{}'.format(id))))
        i = i+1

# Add the Ethereum layer
emu.addLayer(eth)

# Rendering 
emu.render()

# Generate output folders for ARM and AMD
for platform in ('arm', 'amd'):
    if platform=='arm':
        OUTPUTDIR = '../emulator_arm_{}'.format(emulator_size)
        emulator_platform = Platform.ARM64
    else:
        OUTPUTDIR = '../emulator_{}'.format(emulator_size)
        emulator_platform = Platform.AMD64

    # Compiling 
    docker = Docker(internetMapEnabled=True, etherViewEnabled=True, 
                         platform=emulator_platform)
    emu.compile(docker, OUTPUTDIR, override = True)
