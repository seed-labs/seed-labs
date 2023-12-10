# Connect Remix to SEED Emulator

Remix IDE (Integrated Development Environment) can be
used to write, compile, and debug the Solidity code.
It supports testing, debugging and deploying smart contracts.
In this manual, we show how to connect it to the SEED emulator. 


## Step 1: Open Remix IDE

We use Remix online IDE, so we do not need to install anything.
Simply go to [https://remix.ethereum.org/](https://remix.ethereum.org/), 
and you will get the Remix IDE. Remix provides excellent instructions on
[how to use the IDE](https://remix-ide.readthedocs.io/).


## Step 2: Set Up MetaMask

Remix can connect to blockchains via several mechanisms,
such as Remix VM, injected provider (MetaMask), and external HTTP
providers. The Remix VM is sandbox blockchain in the browser;
it is a blockchain simulator, not a real blockchain.
We will connect Remix to our SEED blockchain emulator, which
is a real blockchain. This can be done using an injected
provider (such as MetaMask) or an external HTTP provider.
We will use the MetaMask approach because we would like
to use MetaMask to manage our accounts. 
Please follow this instruction to 
[set up MetaMask and connect it to the SEED emulator](./metamask.md). 


## Step 3: Connect Remix to MetaMask

After setting up MetaMask, go to the Remix IDE,
in the `"Deploy & Run Transactions` menu,
set the `Environment` to `"Injected Provider - MetaMask"`.
If everything is set up correctly, in the `Account` drop-down menu,
you should be able to see the list of accounts from your 
MetaMask wallet. 

Whenever we need to send transactions to the SEED blockchain
from Remix, such as deploying a contract or invoking 
a contract function, Remix will communicate with 
MetaMask, which sends the transactions for us using 
the accounts (their private keys) in the wallet. 
When sending a transaction from Remix, MetaMask window will show 
up, asking for confirmation. 
