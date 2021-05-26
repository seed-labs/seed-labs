# Significant Changes Made in SEED Labs 2.0

To help instructors migrate to the SEED Labs 2.0,
we summarize the significant changes made in SEED Labs 2.0.

 - [Software Security](#software-security)
 - [Web Security](#web-security)
 - [Network Security](#network-security)
 - [Crypto](#crypto)
 - [Hardware Security](#hardware-security)
 - [Mobile Security](#mobile-security)

## Software Security 

 - **Buffer Overflow (Setuid):** This lab is significantly different from the one in SEED 1.0.
   In the old version, there is only one attack, in this version, there are four different 
   levels of attack. The Level-1 attack is the same as the attack task in 1.0, but all the
   other levels are new, including two levels that focus on 64-bit programs. 

 - **Buffer Overflow (Server):** This lab is the same as the Set-UID version, except that the
   vulnerable program is now a server program (as opposed to a Set-UID program). 
   The server program runs inside a container. Moreover,
   the shellcode for the server version is significantly different from the Set-UID version,
   and the reverse shell is introduced in this lab.

 - **Return-to-Libc Lab:** The lab was partitially re-designed. 
   In the new design, we use a different way to defeat the countermeasures in bash or 
   dash (Task 4). This method is much simpler than the ROP method. We also added an
   optional task (Task 5) to give students a taste of ROP (a special case of
   ROP). Generic ROP is quite complicated, and we plan to develop a separate
   lab on ROP in the future.


 - **Format String Attack Lab:** 
   The majority of the tasks are the same as those in SEED 1.0,
   and they target a 32-bit server program. 
   A new task on 64-bit programs is added. This task is significantly more difficult,
   so if instructors do not want to include this task, they can make it optional.


 - **Shellcode Lab:**  There is no significant change.

 - **Environment Variable and Set-UID Lab:** This is no significant change.

 - **Race Condition Lab:** There is no significant change.

 - **Shellshock Lab:** There is no significant change, except that the server 
   program is now running inside a container. 

 - **Dirty COW:** There is no change. This lab is still based on the Ubuntu 12.04 VM.


## Web Security 

In all the web security labs, the web servers are now hosted inside containers. 
Because of this, these labs do not depend on the SEED VM anymore, and they can 
be conducted on generic Ubuntu 20.04 OS.

 - **XSS Attack Lab:** There is no change in the attack tasks. 
   Significant changes were made to the CSP task (countermeasure).

 - **CSRF Attack Lab:** There is no change in the attack tasks. 
   For the countermeasure, we revised the secret token section, 
   because the Elgg program has changed. We also added a new countermeasure task 
   based on the samesite cookies.

 - **SQL Injection Attack Lab:**  There is no change in the attack tasks.
   We did revise Task 4 (prepared statement). Instead of asking students to modify 
   the actual web application, we create a simplified version, and ask students to 
   modify this version.


## Network Security 

The most significant change in the network security labs is the container. 
Most of the labs require several machines. In SEED 1.0, we have to use 2-3
VMs. In SEED 2.0, we will only use one VM; all the other 
machines will use containers. This significantly reduces the complexity
of the lab setup.

 - **Packet Sniffing/Spoofing Lab:** There is no significant change. 

 - **ARP Cache Poisoning Attack Lab:** There is no significant change. 

 - **ICMP Redirect Attack Lab:** This lab is redesigned. It now only focuses
   on the ICMP redirect attack. 

 - **TCP Attacks Lab:** For the SYN flooding attack, there is a significant
   difference between Ubuntu 20.04 and 16.04. The issue is described in the lab
   description. We completely removed the dependency on the netwox tool. For the RST and
   session hijacking attacks, students will write their own tools using Scapy.
   For SYN flooding attacks, a C program is provided.

 - **Mitnick Attack Lab:** There is no significant change. 

 - **Local DNS Attack Lab:** The environment setup is much simplified. The 
   lab tasks are still the same.

 - **Remote DNS Attack Lab:** The environment setup is much simplified. 
   The lab tasks are still the same.

 - **DNS Rebinding Attack Lab:** There is no significant change. 

 - **DNS-in-a-box Lab:** This is a new lab.

 - **Firewall Lab:** This lab is redesigned, so it is a new lab. 

 - **VPN Tunneling Lab:** There is no significant change, except Task 8, which is completely
   different.

 - **VPN Lab:** There is no change. 

 - **BGP Lab:** This is a new lab.

 - **Firewall Bypassing Lab:** This lab is currently being redesigned. 

 - **Heartbleed Attack:** There is no change. 


## Crypto

 - **Public-Key Infrastructure (PKI) Lab:**
   There is no significant change. We did significantly improve the commands. 
   We also added instructions to add alternative names to certificates.

 - **Transport Layer Security (TLS) Lab:** There is no significant change. 

 - **RSA Encryption and Signature Lab:** There is no significant change. 

 - **Secret-Key Encryption Lab:** Task 6 (common mistakes) is significantly revised. 

 - **Padding Oracle Attack Lab:** This is a new lab.

 - **MD5 Collision Attack Lab:** There is no significant change. 

 - **Hash Length Extension Attack Lab:**  There is no significant change.

 - **Pseudo Random Number Generation Lab:** There is no change. 


## Hardware Security 

 - **Spectre Attack Lab:** This lab is ported to Ubuntu 20.04. We made
   some change to the code. 

 - **Meltdown Attack Lab:** Due to the countermeasure implemented inside
   the Ubuntu 20.04 OS, the Meltdown attack no longer works, so this 
   lab stays with the Ubuntu 16.04 VM. 

## Mobile Security 

We didn't make any change to these labs. They are still based on the Ubuntu 16.04 VM.
