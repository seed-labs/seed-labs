#!/bin/env python3
  
from web3 import Web3
import SEEDWeb3
import os

abi_file    = "../contract/ReentrancyVictim.abi"
victim_addr = 'put the actual address here'

# Connect to our geth node
web3 = SEEDWeb3.connect_to_geth_poa('http://10.150.0.71:8545')

# We use web3.eth.accounts[1] as the sender because it has more Ethers
sender_account = web3.eth.accounts[1]
web3.geth.personal.unlockAccount(sender_account, "admin")

# Deposit Ethers to the victim contract
# The attacker will steal them in the attack later
contract_abi  = SEEDWeb3.getFileContent(abi_file)
amount = 10  # the unit is ether
contract = web3.eth.contract(address=victim_addr, abi=contract_abi)
tx_hash  = contract.functions.deposit().transact({ 
                    'from':  sender_account,
                    'value': Web3.toWei(amount, 'ether')
                })
print("Transaction sent, waiting for the block ...")
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
print("Transaction Receipt: {}".format(tx_receipt))

# print out the balance of my account and the entire contract
myBalance = contract.functions.getBalance(sender_account).call()
print("----------------------------------------------------------")
print("== My balance inside the contract:")
print("   {}: {}".format(sender_account, myBalance))
print("== Smart Contract total balance:")
print("   {}: {}".format(victim_addr, web3.eth.get_balance(victim_addr)))
print("----------------------------------------------------------")
