# Notes for Lab setup in Virginia Cyber Range

In August 2023, we worked the Virginia Cyber Range
to get our SEED labs running in this environment. 
We document the issues encountered and how we resolve
these issues. 


## Issue: Web Proxy

The Cyber Range puts a restriction on outgoing packets. We cannot 
directly communicate with the outside machine (e.g., pinging outside
machines will not work). The Web traffic will go through a 
proxy. 

In some labs, we host a web server using a container. We add the 
hostname-to-IP mapping to the `/etc/hosts` file. The web proxy 
will cause issues. For example, if our web server is `www.seed-server.com`,
when we visit this URL, the browser will contact the proxy first, but
the proxy runs on another computer, so it will not be able to use the 
mapping in our `/etc/hosts` file. 

- We can solve this problem by adding the following 
  entry `/etc/profile.d/proxy.sh` file. This will allow the browser to 
  not use the proxy for this particular domain. After making the changes,
  we need to log out and then log in again (or simply reboot the machine).

  ```
  export no_proxy='localhost,.seed-server.com,.bank32.com,...' 
  ```

- We will provide a list of the domains used in the SEED labs, and add them to the 
  `proxy.sh` file when we build the VM for the cyber range. Here is the list:
  ```
  seed-server.com
  attacker32.com
  bank32.com
  bank99.com
  seedlab-hashlen.com
  seedIoT32.com
  example32a.com
  example32b.com
  example32c.com
  example60.com
  example2022.com
  example70.com
  bank32A.com
  bank32B.com
  bank32W.com
  ```

## Misc. Issue

- Add the current folder "." to the `PATH` environment variable. Without it,
  some lab may have small issue. 

- The version of `docker-compose` is 2.18.1, while the version on the SEED VM
  is 1.27.4, which is much older. The new version of `docker-compose` 
  does not work well with the `docker-compose.yml` file. 

  - It seems that the problem is caused by the base. This is a problem with
    the emulator, not the range. We have already found a solution,
    and are working on fixing it on our side. 


- To run the emulator-based labs, the memory of the VM should be 8GB. 
  The current setup is 4GB, which is good for most SEED labs, except the 
  emulator-based labs. At this point, only a small number of labs
  use emulators. 


## Testing Results: Labs with some issues

The follow labs have some issues. We document how they are 
resolved or what needs to be done to resolve them. 

- BGP Lab  
  - The environment building has some issue, but this is the issue with the 
    emulator. We are fixing it. 
  - Fully tested after manually fixing the building issue; no other issues.

- Blockchain Lab: It has several issues: 
  - Need to install Web3 Python module using `pip3 install web3==5.31.1`.
    Please make sure to install an older version, as our code does not 
    work well with the new web3 version. 
  - Have not yet fully tested it. 

- Crypto: Secret Key Encryption Lab 
  - The `openssl` library was not installed. It affects Task 7. 
  - Use [this script](https://github.com/seed-labs/seed-labs/blob/master/lab-setup/ubuntu20.04-vm/src-vm/openssl.sh) to install the library. This will solve the problem. 

- Crypto: Hash Extension Attack Lab 
  - Require the `openssl` library. Same problem as the encryption lab. 
  - Installing the `openssl` library solved the problem. 
  - Need to add `seedlab-hashlen.com` to the no-proxy list. 
  - Didn't do the full testing 

- Crypto: RSA lab 
  - We need to run `openssl s_client -connect www.example.org:443 -showcerts` to 
    get the certificates from a server. This will not work, as `openssl s_client`
    command does not recognize proxy. 

  - We can solve this problem by adding the `-proxy` option to the command. 
    We will add this to the lab description. 
    ```
    openssl s_client -proxy proxy.cyberservices.internal:80 -connect www.example.org:443 -showcerts
    ```

- Crypto: TLS lab
  - This lab will not work, as it requires communicating with the outside HTTPS
    servers, using our own Python programs. Making these programs to use the 
    proxy involves a lot of work. This is not a very popular lab, so 
    it should not affect too many people. 

- Network - ICMP Lab
  - ICMP redirection doesn't affect the router cache, so it does not work.
  - Will figure out the reason later. 

- Network - Firewall Lab 
  - Due to the firewall set up in the Cyber Range, some of the tasks will not 
    work. For example, In task1b , `dig @8.8.8.8 www.example.com` will be 
    blocked by the Range's firewall even if our firewall is not set up correctly. 

  - This is not a major issue. 

- Network - Mitnick Attack Lab
  - The `dcup` command shows an error: service "extensions" has 
    neither an image nor a build context specified: invalid 
    compose project.
  - Solution: in new docker compose specification `x-` is the 
    prefix to declare a extension field. So in our case, 
    Compose interprets the `x-` as an extension field instead of 
    a service name. Changing `X-terminal` to `Xterminal` in 
    `docker-compose.yml` solves the problem. We will fix this 
    issue on our side. 
    Reference (https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields). 

## Testing Results: Labs without issues 

The following labs do not have issues in the Cyber Range.

- Software - SetUID Lab: fully tested; no issue.
- Software - Race Condition lab: fully tested; no issue.
- Software - Return-to-libc: fully tested; no issue.
- Software - Buffer-overflow (server version): fully tested; no issue. 

- Web - CSRF, XSS, and SQL Injection Labs: tested the lab setup environment. 
           After adding the hostname to the `no-proxy` list, the environment starts
	   without any problem. 

- Crypto - PKI Lab: tested the scripts, and there is no problem. 
           Didn't do the full testing.
- Crypto - MD5 collision lab: fully tested; no issue.
- Crypto - Random number lab: fully tested; no issue.  
- Crypto - Padding oracle lab: fully tested; no issue.

- Network - ARP Lab: fully tested; no issue.
- Network - TCP Lab: fully tested; no issue.
- Network - VPN Tunneling Lab: fully tested; no issue.

