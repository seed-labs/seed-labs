#!/bin/bash


# Install tools using apt
source base.sh        


# Specific Software
source wireshark.sh   
source dns.sh         
source mysql.sh       
source apache.sh      
source python.sh      
source php.sh         
source shellshock.sh  
source openssl.sh     
source crypto.sh      
source docker.sh

# Web Related 
source elgg.sh        
source xss.sh         
source csrf.sh        
source sql_injection.sh  



# Miscellaneous (gdb plugin, ...)
source misc.sh        

# Configuration 
source system.sh      

# Clean up
source cleanup.sh

# Post-Install Messages (what needs to be done)
source postinstall.sh
