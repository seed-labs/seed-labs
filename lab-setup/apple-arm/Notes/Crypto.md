# Crypto Labs

## Secret-Key Encryption Lab

The openssl library is compiled successfully. 
Remember to run `openssl.sh` when building the VM.


## Padding Oracle Attack Lab

The docker image has not been built yet. See the instructions 
in `seed-labs/category-crypto/Crypto_Padding_Oracle/Container_Building`
regarding how to create the container. 


## MD5 Collision Attack

We need to rebuild the `md5collgen` program from the source. 
The one included in the `Labsetup.zip` file is the AMD version. 
Using the shell script `md5_firsttime.sh` in 
`seed-labs/lab-setup/ubuntu20.04-vm/src-vm`, we can successfully
build the `md5collgen` program. 

We also need to modify the instructor manuals for this 
lab: the arm binary and amd binary are different, so the offsets
of the array in the binary are also different. The offsets
are used in the solution script.


## Hash Length Extension

The Flask version has an issue. We can add the following line
to the `Dockerfile` to fix the issue (similar to the DNS rebinding 
lab). 

```
RUN pip3 install flask --upgrade
```

In the Flask docker image, we installed an old version using the 
following. We may need to update this, but we need to make sure 
it does not break other labs. 

```
pip3 install flask==1.1.1
```

## Random Number

The way how `/dev/random` works on Apple silicon machines is quite different.
I believe that most of the tasks can be made to work, but we need to modify the 
lab description. 
