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

- BGP lab: works (the environment building has some issue, see issues above).

- Blockchain Lab: It has several issues: 
  - Need to install Web3 Python module using `pip3 install web3==5.31.1`.
    Please make sure to install an older version, as our code does not 
    work well with the new web3 version. 


## Testing Results: Labs without issues 

The following labs do not have any issue in the Cyber Range.

- Name ... 
