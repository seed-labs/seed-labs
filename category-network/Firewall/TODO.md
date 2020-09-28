# TODO

## A New Firewall Lab Based on Containers

Our current firewall lab is quite simple, mostly because it is hard to set up a
complicated network environment using virtual machines. We are limited on the
number of VMs that can be used in the lab. With the container technology, this
limitation is lifted. We are also limited to the industry experience, so a
person who has real-world experience on firewalls can help us a lot.

I would like to design a new firewall lab (or a series of them) that has the
following features.

- A quite sophisticated network topology that emulates a setup for a small
  company. We will use docker container to set this up. In this setup, we will
  have hosts, routers, and firewalls, each running as a separate container. We
  may even provide multiple topologies for students.

- Design lab tasks for students to do the following (this is not a complete list, ):
   - Placing the firewall in the right places.
   - Setting up firewall rules (using ```iptables```) for various requirements.
     It will be great if these requirements emulate what is in the real world.
   - Intentional creating loopholes in some of the firewall configuration, so
     students' job is to evade the firewall using the loopholes.
   - Incorporating real-world problems into this lab.

