# PKI Lab

## For Ubuntu 20.04

There is no difference between Ubuntu 16.04 and Ubuntu 20.04. 
We did significantly improved the commands. We also added instructions
to add alternative names to certificates. 

## For Containers

We now host the HTTPS web server on a container. The container
already comes with a complete setup for `www.bank32.com`, including
the `VirtualHost` file and needed certificates and keys. 

Because of the need to type password (Bank32's private key is protected 
by a password), we are not able to auto-start the Apache server inside the
container. We need to go to the container, start the server manually,
and type the password. If we use the `-nodes` option when generating the 
Certificate Signing Request, the private key will not be encrypted
using a password, and therefore we can now auto-start the Apache server. 
However, we choose not to do that, because it compromises the security
of the private key. 
