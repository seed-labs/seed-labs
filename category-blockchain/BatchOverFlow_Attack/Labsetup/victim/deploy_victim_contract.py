#!/bin/env python3
  
from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

abi_file = "../contract/BatchOverFlow.abi"
bin_file = "../contract/BatchOverFlow.bin" 

# Connect to a geth node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# === Your private key and derived account ===
private_key = "6510652e04c9bcb471982164cf779fc0b624bb26bc3cfe5a8a54bddeba90d667"

print("Sending tx ...")
addr = SEEDWeb3.deploy_contract(web3, private_key,
                                abi_file, bin_file, 0)
print("Victim contract: {}".format(addr))
with open("contract_address_victim.txt", "w") as fd:
    fd.write(addr)
