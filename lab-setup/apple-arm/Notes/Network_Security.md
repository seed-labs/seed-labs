# For Network Security Labs

## ICMP Lab

The setup is fine, however, the behaviors of ICMP redirect
on Ubuntu 22.04 is slightly different from that on Ubuntu 20.04.
In both versions, the ICMP redirect packets must include
the original packet that triggers the redirect, and the sender
is supposed to verify that the included packet is the same
as the original one. However, how strictly the checking is
conducted is different for these two OS versions;
Ubuntu 22.04 seems to be more strict.
Therefore, on Ubuntu 20.04, we can just directly spoof an
ICMP redirect packet, but on Ubuntu 22.04, we need to
capture the original packet.
We can use sniff and spoof technique to do this:
we can monitor the LAN via packet sniffing. Whenever we see an
ICMP echo request, we spoof an ICMP redirect packet.

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
version `1.1.1`. We added the following command to the flask container.


```
pip3 install flask --upgrade
```

Newer version of Firefox enables DNS over HTTPS. Therefore, the DNS
resolution may not go through the local DNS server or the `/etc/hosts`
file. This will create issues for many SEED labs. We need to disable it.
Go to `Setting` -> `Privacy & Security`, and go to `DNS over HTTPS`, and select
`off`.


## Firewall Exploration Lab

For the kernel version above 6.5, 
we need to install gcc-12 to compile a loadable kernel module.
```
sudo apt install gcc-12
```

The `dmesg` command in Ubuntu 22.04 requires the root privilege. This is
different from Ubuntu 20.04.


## Morris Worm Lab

The Internet emulator works, but since the attack depends on the
buffer overflow attack, the shellcode in the solution needs to
change. We also made changes to the server program: 

- The original server program use `execle()` to invoke the `stack`
  program. On Apple VMs, the addresses of the buffer are different,
  this makes the attack a little bit more difficult (on AMD VMs, the
  addresses are always the same). After changing to `execl()`,
  the problem is fixed. 

- On Apple VM, we need to use `docker compose` instead of `docker-compose`.

- On Apple VM, building the images directly using `dcbuild`
  has a problem, but if we build 10 images at a time (like the command
  in `z_start.sh`, there is no problem. We wrote a script
  called `z_build.sh` for this purpose. 

- On Apple VM, we don't need the `z_start.sh` to start the containers.
  Simply running `dcup` should work.

- On AMD VM, it is opposite: `dcbuild` is fine, but we need to use
  `z_start.sh` to start the containers.

