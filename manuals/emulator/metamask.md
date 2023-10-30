
# Connect MetaMask to SEED Emulator

In several of our blockchain labs, we use MetaMask as our wallet. 
In this manual, we show how to connect MetaMask to the SEED emulator.


## Step 1: Install the MetaMask Extension

We show how to conduct this step for Firefox. 
Other browsers have similar steps. 
Go to Firefox's menu, click the `"Add-ons and themes"`
item. Search for `metamask`, and you will find
an extension developed by `danfinlay`.
Follow the instruction to install it. 


## Step 2: Connect to the Blockchain

We need to connect the MetaMask wallet to the SEED blockchain.
This is done via connecting MetaMask to one of the
nodes on the blockchain. We can find the IP addresses of all
the Ethereum nodes using the docker command. We have
appended the IP address to the container name (the actual IP
address you get from your emulator may be different from
those listed in the following).

```
$ dockps | grep Eth
e372096bb926  as150h-Ethereum-POA-00-Signer-BootNode-10.150.0.71
f0ef91ef9e22  as150h-Ethereum-POA-01-10.150.0.72
3b8c1d191058  as151h-Ethereum-POA-02-Signer-10.151.0.71
...
aea1106d932d  as164h-Ethereum-POA-18-Signer-BootNode-10.164.0.71
7cd6fa6888b2  as164h-Ethereum-POA-19-10.164.0.72
```

Pick one of the nodes, and then configure MetaMask to connect to
this node. Go to the `Settings` menu inside MetaMask
and follow the instructions below. Replace
the `<IP Address>` with the actual IP address of the
node that you have selected. 

```
Settings > Networks > Add a network > Add a network manually

Network name:    pick any name (e.g., SEED emulator)
New RPC URL:     http://<IP Address>:8545
Chain ID:        1337
Currency symbol: ETH
```


## Step 3: Add Accounts

We can ask MetaMask to create new accounts for us or import existing our
accounts. For most of the labs, we have already created several 
accounts when creating the emulator, and these accounts already have funds in them.
These accounts are generated from a mnemonic phrase.
Unless otherwise specified by the lab description, the 
default mnemonic phrase used by the SEED emulator is the following:

```
gentle always fun glass foster produce north tail security list example gain
```

To add these existing accounts to our MetaMask wallet, 
we need to log out from our MetaMask account (or lock our
account). That will lead us to the login window. We will pretend
that we forgot the password, so we will click the
`"Forgot password"` link.
For MetaMask, if you forget the password to your wallet account,
unless you have already stored your keys somewhere, 
the only way to get your account
keys back is through a secret recovery phrase.
By typing the above recovery phrase, we can ask MetaMask to recover
our keys. MetaMask will generate all the existing accounts that have a non-zero
balance on the blockchain. 


## Common Problems 


- Problem: Sometimes, the transactions that we send through MetaMask 
are not added to the blockchain.
There are many reasons for that. One of the reasons is the nonce cached by MetaMask is out 
of the sync with the blockchain. We can clear MetaMask's cache.

  ```
  Settings > Advanced > Clear activity and nonce data

  This resets the account's nonce and erases data
  from the activity tab in your wallet. Only the current account and network will
  be affected. Your balances and incoming transactions won't change.
  ```

- Problem: MetaMask does not convert my ether balance to real money. By default,
MetaMask does not do that for the test networks, because the money on the test 
networks are worthless. To enable that, turn on the following switch.

  ```
  Settings > Advanced > Show conversion on test networks

  Select this to show fiat conversion on test networks
  ```
