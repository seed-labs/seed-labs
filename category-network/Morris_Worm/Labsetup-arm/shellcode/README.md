# Note 

- `shellcode_arm.s`: write the shellcode, generate machine code.
  Use the following command to get the binary
  ```
  $ xxd -p -c 20 shellcode_arm.o
  ```
  
- `convert.py`:   convert the machine code to Python's byte array

- `generate_shellcode.py`: include the byte array in this code. Students can modify
            this file (i.e., the shellcode), and then generate the payload.  

- `call_shellcode.c`: test the generated shellcode

