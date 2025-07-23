#!/usr/bin/env python3

from web3 import Web3
import os
import sys

# Add the shared folder to sys.path
sys.path.append(os.path.abspath("../shared"))

import SEEDWeb3

# Path to ABI file
abi_file = "../contract/KingOfEther.abi"

# Address of the deployed victim contract
# victim_addr = "put address here"
victim_addr = "0x3C27A90E2C9d1f702c3BE2C412790bDCa93fC68E"

# Connect to Geth PoA node
web3 = SEEDWeb3.connect_to_geth_pos('http://10.151.0.71:8545')

# Attacker Contract Address
# attack_addr = "put address here"
attack_addr = "0x2c0fc781D143654032C172A5F71491C7cB083581"


# Load ABI and contract
contract_abi = SEEDWeb3.getFileContent(abi_file)
contract = web3.eth.contract(address=victim_addr, abi=contract_abi)

# Get current king and balance
current_king = contract.functions.king().call()
current_balance = contract.functions.balance().call()

# Check if accounts are the king
is_attacker_king = current_king.lower() == attack_addr.lower()

# Print status
print(f"Current King: {current_king}")
print(f"Current Throne Balance: {current_balance} wei ({web3.from_wei(current_balance, 'ether')} ETH)")
print(f"Is Attacker Contract : {attack_addr} the king? {'Yes' if is_attacker_king else 'No'}")