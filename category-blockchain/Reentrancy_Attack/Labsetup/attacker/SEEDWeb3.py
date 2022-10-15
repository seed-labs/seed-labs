#!/bin/env python3

from web3 import Web3
from web3.middleware import geth_poa_middleware
import os, sys

def getFileContent(file_name):
    file = open(file_name, "r")
    data = file.read()
    file.close()
    return data.replace("\n","")

# Connect to a geth node
def connect_to_geth_poa(url):
   web3 = Web3(Web3.HTTPProvider(url))
   if not web3.isConnected():
      sys.exit("Connection failed!") 
   web3.middleware_onion.inject(geth_poa_middleware, layer=0)
   return web3

# Connect to a geth node
def connect_to_geth_pow(url):
   web3 = Web3(Web3.HTTPProvider(url))
   if not web3.isConnected():
      sys.exit("Connection failed!")
   return web3


# Print balance
def print_balance(web3, account):
    print("{}: {}".format(account, web3.eth.get_balance(account)))

# Deploy contract (high-level)
def deploy_contract(_web3, sender_account, abi_file, bin_file, arg1):
    print("---------Deploying Contract ----------------")
    abi      = getFileContent(abi_file)
    bytecode = getFileContent(bin_file)

    contract = _web3.eth.contract(abi=abi, bytecode=bytecode)
    tx_hash = contract.constructor(arg1).transact({ 'from': sender_account })
    print("... Waiting for block")
    tx_receipt = _web3.eth.wait_for_transaction_receipt(tx_hash)
    contract_address = tx_receipt.contractAddress
    print("Transaction Hash: {}".format(tx_receipt.transactionHash.hex()))
    print("Transaction Receipt: {}".format(tx_receipt))
    return contract_address

