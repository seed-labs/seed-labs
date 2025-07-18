#!/usr/bin/env python3

from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Connect to the Geth PoA node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Path to ABI file
abi_file = "../contract/KingOfEther.abi"

# Address of the deployed victim contract
# victim_addr = "put address here"
victim_addr = "0x3C27A90E2C9d1f702c3BE2C412790bDCa93fC68E"

# Load ABI and contract
contract_abi = SEEDWeb3.getFileContent(abi_file)
contract = web3.eth.contract(address=victim_addr, abi=contract_abi)

# Choose a non-attacker account to attempt to claim the throne
challenger_account_private_key = "ec2c9e1284e00fed6361a4fd4953cca003b557830e6431b18205ee350c25fb37"
challenger_account = web3.eth.account.from_key(challenger_account_private_key).address

# Get current balance and king
current_balance = contract.functions.balance().call()
current_king = contract.functions.king().call()

# Attempt to claim the throne with more Ether than current balance
value_to_send = current_balance + web3.to_wei(1, 'ether')  # Send 1 ETH more than current balance
print(f"Attempting to claim throne with {web3.from_wei(value_to_send, 'ether')} ETH from {challenger_account}...")

try:
    nonce = web3.eth.get_transaction_count(challenger_account)
    transaction = contract.functions.claimThrone().build_transaction({
        'from': challenger_account,
        'value': value_to_send,
        'nonce': nonce,
        'gas': 500000,
        'gasPrice': web3.to_wei('10', 'gwei'),
        'chainId': 1337
    })

    signed_tx = web3.eth.account.sign_transaction(transaction, challenger_account_private_key)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.raw_transaction)
    tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)


    if tx_receipt['status'] == 1:
        print(f"Transaction successful! Hash: {tx_hash.hex()}")
        print("Unexpected: Transaction succeeded!")
    else:
        raise Exception(f"Transaction reverted! Hash: {tx_hash.hex()}")

except Exception as e:
    print(f"Failed to claim throne: {str(e)}")
    print("The DoS attack prevents others from becoming king.")

# Verify current king and balance
print("\n---------------------------------------------------------")
print("Verifying current king and balance after the attack...")
current_king = contract.functions.king().call()
current_balance = contract.functions.balance().call()

print(f"Current King: {current_king}")
print(f"Current Throne Balance: {current_balance} wei ({web3.from_wei(current_balance, 'ether')} ETH)")