# Docker Images for SEED Labs


These are the common images used by SEED labs. For all the 
images listed here, other than the `seed-dns` images, we have already
pre-built the images, and pushed them to the Docker Hub, 
in the `handsonsecurity` namespace. 
Most labs build their containers using these pre-built images
as the bases. 

The `seed-dns` images are built upon the bases from our Docker Hub images.
Other than the bases, they only contain local files. Therefore, we decided
not to push them to the Docker Hub. Students will just build the images
when they set up the lab; it does not take much time. 

## Convention

Each image's name has the following format `handsonsecurity/image:tag`. We 
use tag for different variation of a image. For example,
we have `seed-server` image with many different tags, each representing
a different server image, such as `bind`, `apache`, `bgp`, etc.


## Lab Setup for Labs

Each SEED lab will have a folder called `Labsetup`, which contains
all the container files needed by that lab. Most of them 
use the base images from this folder.

When we publish each lab to the SEED website, we will zip all the lab setup 
files into `Labsetup.zip`, and link it to the lab's web page. 
The `zip` program will automatically
replace all the symbolic links with the actual files/folders.


