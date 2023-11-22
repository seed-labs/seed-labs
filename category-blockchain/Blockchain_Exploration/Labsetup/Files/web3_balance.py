#!/bin/env python3
from web3 import Web3

url  = 'http://10.150.0.71:8545'
web3 = Web3(Web3.HTTPProvider(url))  # Connect to a blockchain node

addr = Web3.toChecksumAddress('0xF5406927254d2dA7F7c28A61191e3Ff1f2400fe9')
balance = web3.eth.get_balance(addr) # Get the balance 
print(addr + ": " + str(Web3.fromWei(balance, 'ether')) + " ETH")
