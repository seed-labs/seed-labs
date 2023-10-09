# For Network Security Labs


## TCP Lab

To compile the `synflood.c` program, we need to use the static 
binding (`gcc -static`), or we will see an issue caused by missing libraries. 
This is a minor issue. 

## DNS Remote Attack

Tried the attack. The program works, but the attack is not successful.
Need to investigate further. 


## DNS Rebinding Attack

It seems that the we have trouble running the flask server due to the 
version. We need to upgrade the flask container by running the 
following command. The one used in the original `Dockerfile` is 
version `1.1.1`. Further testing is needed. 

```
pip3 install flask --upgrade
```

Newer version of Firefox enables DNS over HTTPS. Therefore, the DNS
resolution may not go through the local DNS server or the `/etc/hosts`
file. This will create issues for many SEED labs. We need to disable it.
Go to `Setting` -> `Privacy & Security`, and go to `DNS over HTTPS`, and select
`off`. 


