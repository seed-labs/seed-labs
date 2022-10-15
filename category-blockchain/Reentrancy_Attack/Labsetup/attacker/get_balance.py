#!/bin/env python3

from web3 import Web3
import SEEDWeb3

def print_balance(_web3, address):
    if address != None:
       caddr = Web3.toChecksumAddress(address)
       print("{}: {}".format(caddr, _web3.eth.get_balance(caddr)))
    else:
       print("Address is None!")

port = 8545  
web3 = SEEDWeb3.connect_to_geth_poa('http://127.0.0.1:{}'.format(port))

# Get the balance of the accounts on the geth node 
print("----------------------------------------------------------")
print("*** This client program connects to 127.0.0.1:{}".format(port))
print("*** The following are the accounts on this Ethereum node")
for acct in web3.eth.accounts:
    print_balance(web3, acct)
print("----------------------------------------------------------")


# Get the balances of the victim's and attacker's contract accounts.
# Please use their correct addresses.
try:
  victim_addr = 'put the real address here'
  print("  Victim: ", end='')
  print_balance(web3, victim_addr)

  attack_addr = 'put the real address here'
  print("Attacker: ", end='')
  print_balance(web3, attack_addr)
except:
  print()
  print("Exception captured: Please put the actual address in the code")
