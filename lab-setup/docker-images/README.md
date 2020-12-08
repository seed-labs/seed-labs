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


## Design Philosophy

These images are very important for the SEED labs. We will make improvement
to these images, but to avoid making mistakes, I would like to document 
the thinking process behind the design. Eventually, we will come up 
with some design guidelines.

- **Image size:** Trying to minimize the image size is important, but we often got
carried away by this. We should keep in mind that image size is not the only factor 
in the design. It is an important one, but it is one of the parameters 
in our optimization formula. 

- **Considering caching:** Building all our images on top of the same base (or 
at least on a small number of them) increases the chance for caching. 
Students usually do several SEED labs during a semester, so
once they download the base (ubuntu), the basis layer will be cached. Even though
a particular image we choose is larger than some alternatives, chances are that students
already have the base layer cached.

- **Consistency:** Students may need to run commands or do simple coding on the flask image for
  some tasks. I would like provide them with a similar environment. I have observed
  differences when I was using Debian-based images, compared to Ubuntu-based images, 
  and had to modify my code to make it work (didn't have an issue in the Ubuntu-based 
  image, because the code was tested in the Ubuntu-based VM). 

- **Minimizing dependency:** We should reduce the dependence on others. 
Using too many base images increase the dependency. This may cause issues in the long term.
Currently, all the images we build are based on `Ubuntu 20.04`.  


