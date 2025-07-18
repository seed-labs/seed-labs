#!/bin/env python3

from web3 import Web3
from web3.middleware import ExtraDataToPOAMiddleware
import os, sys

def getFileContent(file_name):
    file = open(file_name, "r")
    data = file.read()
    file.close()
    return data.replace("\n","")

# Connect to a geth node
def connect_to_geth_poa(url):
   web3 = Web3(Web3.HTTPProvider(url))
   if not web3.is_connected():
      sys.exit("Connection failed!") 
   web3.middleware_onion.inject(ExtraDataToPOAMiddleware, layer=0)
   return web3

# Connect to a geth node
def connect_to_geth_pow(url):
   web3 = Web3(Web3.HTTPProvider(url))
   if not web3.is_connected():
      sys.exit("Connection failed!")
   return web3

def connect_to_geth_pos(url):
    web3 = Web3(Web3.HTTPProvider(url))
    if not web3.is_connected():
        sys.exit("Connection failed!")
    return web3


# Print balance
def print_balance(web3, account):
    print("{}: {}".format(account, web3.eth.get_balance(account)))

# Deploy contract (high-level)
def deploy_contract(_web3, private_key, abi_file, bin_file, arg1):
    print("---------Deploying Contract ----------------")

    abi = getFileContent(abi_file)
    bytecode = getFileContent(bin_file)

    account = _web3.eth.account.from_key(private_key)
    sender_address = account.address

    contract = _web3.eth.contract(abi=abi, bytecode=bytecode)

    if arg1 is not None:
        constructor = contract.constructor(arg1)
    else:
        constructor = contract.constructor()

    nonce = _web3.eth.get_transaction_count(sender_address)
    gas_price = _web3.to_wei('10', 'gwei')

    tx = constructor.build_transaction({
        'from': sender_address,
        'nonce': nonce,
        'gas': 500000,
        'gasPrice': gas_price,
        'chainId': 1337  # local testnet chain ID
    })

    signed_tx = _web3.eth.account.sign_transaction(tx, private_key)
    tx_hash = _web3.eth.send_raw_transaction(signed_tx.raw_transaction)

    print("... Waiting for block")
    tx_receipt = _web3.eth.wait_for_transaction_receipt(tx_hash)

    contract_address = tx_receipt.contractAddress
    print("Transaction Hash: {}".format(tx_receipt.transactionHash.hex()))
    print("Transaction Receipt: {}".format(tx_receipt))
    return contract_address


