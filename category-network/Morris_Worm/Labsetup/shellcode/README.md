# Note 

- `shellcode_32.s`: write the shellcode, generate machine code.
  Use the following command to get the binary
  ```
  $ xxd -p -c 20 shellcode_32.o
  ```
  
- `convert.py`:   convert the machine code to Python's byte array

- `shellcode_32.py`: include the byte array in this code. Students can modify
            this file (i.e., the shellcode), and then generate the payload.  

- `call_shellcode.c`: test the generated shellcode

