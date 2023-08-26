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
  example 
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

## Testing Results: Labs with some issues

The follow labs have some issues. We document how they are 
resolved or what needs to be done to resolve them. 

- name 
- name 


## Testing Results: Labs without issues 

The following labs do not have any issue in the Cyber Range.

- name 
- name 
