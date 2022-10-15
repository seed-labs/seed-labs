#!/bin/env python3
  
from web3 import Web3
import SEEDWeb3

abi_file = "../contract/ReentrancyVictim.abi"
bin_file = "../contract/ReentrancyVictim.bin" 

# Connect to a geth node
port = 8546   # Deploy the contract from a user node
web3 = SEEDWeb3.connect_to_geth_poa('http://127.0.0.1:{}'.format(port))

# We use web3.eth.accounts[1] as the sender because it has more Ethers
sender_account = web3.eth.accounts[1]
web3.geth.personal.unlockAccount(sender_account, "admin")
print("Sending tx ...")
addr = SEEDWeb3.deploy_contract(web3, sender_account,
                                abi_file, bin_file, None)
print("Victim contract: {}".format(addr))
with open("contract_address_victim.txt", "w") as fd:
    fd.write(addr)
