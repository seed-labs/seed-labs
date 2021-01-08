# Building Container Image

We will build a container image for this lab. 
The image is hosted on the DockerHub. There is
a secret key and message hidden in the image. 
Students' job is to find out the secret message
using the padding oracle attack.

Here is the command to build and push this image:
```
$ docker build -t handsonsecurity/seed-server:padding-oracle .
$ docker image push handsonsecurity/seed-server:padding-oracle
```

## Note

To build the container image, we need to place a secret 
message in `Makefile`. This secret will be used by
`secret_generator.cpp` to generate obfuscated secret,
which will then be load into the padding oracle.
The padding oracle will de-obfuscate the secret. 
The main purpose is to hide the secret in the binary.

We use a very simple way to do the obfuscation. We basically put 
an encryted version of the original message inside the 
padding oracle program. The key and IV are stored inside the 
program, so the oracle program can de-obfuscate the message 
by decrypting it. 

Although this protection is not strong, it is sufficient
for the purpose of this lab, because it will take more 
time to find the obfuscated secret from the binary 
code than doing the lab task, i.e. using the padding oracle 
attack to find the secret. Moreover, knowing the secret
message does not help the padding oracle attack at all.
Students won't get any credit if the do not use the 
the padding oracle attack to get the secret. 


After building this image, we have removed the secret. The 
one left in `Makefile` is not the same as the one used when we 
built the image. The secret is in the instructor manual (not 
in this open-source repo). 
