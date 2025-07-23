#!/bin/env python3

from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Paths to ABI and bytecode files
abi_file = "../contract/KingOfEther.abi"
bin_file = "../contract/KingOfEther.bin"

# Connect to a geth node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Private key and derived account
private_key = "6510652e04c9bcb471982164cf779fc0b624bb26bc3cfe5a8a54bddeba90d667"

print("Deploying KingOfEther contract...")
addr = SEEDWeb3.deploy_contract(web3, private_key, abi_file, bin_file, None)
print(f"Victim contract deployed at: {addr}")
with open("contract_address_victim.txt", "w") as fd:
    fd.write(addr)