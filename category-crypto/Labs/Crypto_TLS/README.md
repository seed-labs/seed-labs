# TLS Lab

## For Ubuntu 20.04

There is a small change we need to make in our Python code.
See the following:

```
# Client code 
context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT) # For Ubuntu 20.04 VM
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)    # For Ubuntu 16.04 VM

# Server code 
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER) # For Ubuntu 20.04 VM
context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)    # For Ubuntu 16.04 VM

```

## For Containers

We use three containers for this lab, client, server, and proxy. 
We mounted a folder to all these containers, so we can do the 
development inside the VM, and then run the code easily 
from inside the containers. 
