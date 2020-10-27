# Container Files


Each SEED lab will have a folder called ```Labsetup```, which contains
all the container files needed by that lab. Since many SEED labs 
share a similar setup, to avoid duplication, we create this folder 
to store the standard container files. 
Here are the general guidelines how this folder should be 
used by each SEED lab.


- Image file (standard): we put several standard container image files
in this folder. If a SEED lab needs to use one of these standard images without
making any change, use a symbolic link to link to the corresponding image 
inside this folder. 

- If a SEED lab needs to make some changes to a standard SEED container image,
it can copy the image file from this folder. 

- For the Compose file, if a SEED lab only needs to use a standard one, 
it should use symbolic links. If it needs a customized one, it can
create its own. Here are some of main reasons for customization:
  - Give each container a more meaningful name related to the lab
  - Increase/Decrease the number of containers 

- ```Cheatsheet.txt``` file: this file provides a quick reference to some of 
the commonly used commands related to Docker and Compose. It
is not meant to replace the detailed manual that can be downloaded from 
the website.

## For Website

We will zip all the files together into ```Labsetup.zip```, and link it 
to the lab's web page. The ```zip``` program will automatically replace 
all the symbolic links with the actual files/folders. 
