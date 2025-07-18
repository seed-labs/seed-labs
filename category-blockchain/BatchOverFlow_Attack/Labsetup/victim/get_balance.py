from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Path to ABI file
abi_file    = "../contract/BatchOverFlow.abi"

# Address of the deployed vulnerable contract
victim_addr = 'put address here'

# Connect to geth node (PoA)
web3 = SEEDWeb3.connect_to_geth_poa('http://10.151.0.71:8545')

# Choose a sender account
account_0 = web3.eth.accounts[0]
account_1 = web3.eth.accounts[1]

# Load ABI and contract
contract_abi  = SEEDWeb3.getFileContent(abi_file)
contract = web3.eth.contract(address=victim_addr, abi=contract_abi)

# Call the getBalance view function
balance_0 = contract.functions.getBalance(account_0).call()
balance_1 = contract.functions.getBalance(account_1).call()

# Print the balance
print(f"Virtual Balance of {account_0} in contract : {balance_0} wei ({web3.from_wei(balance_0, 'ether')} ETH)")
print(f"Virtual Balance of {account_1} in contract : {balance_1} wei ({web3.from_wei(balance_1, 'ether')} ETH)")

