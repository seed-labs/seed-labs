# Firewall Exploration Lab


## Update on 1/15/2021

This lab is redesigned. 


## For Ubuntu 20.04 VM

- In the netfilter code, we need to make the following change.  This is caused by the changes in the kernel.
   ```
   Change 
           nf_register_hook(&telnetFilterHook)
   to
           nf_register_net_hook(&init_net, &telnetFilterHook)
   ```

- Due to the use of container, we are able to design more interesting tasks for
this lab. We decide to move the firewall evasion tasks out of this lab, 
into the Firewall Evasion lab, so we can focus on using and implementing 
firewalls in this lab. Therefore, this lab is sgifnicantly revised. 


- Docker will add firewall rules to the `nat` table, 
so we can no longer use ```iptables -F``` to clean the firewall rules in that table. 
For other tables, it is fine. We need to be careful.
