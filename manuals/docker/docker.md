# Brief Tutorial on Docker

## Writing the Dockerfile

Docker can build images automatically by reading the instructions from
a `Dockerfile`, which is a text file that contains all commands needed to
build a container image. We show an example of `Dockerfile` in the following.

``` dockerfile
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install software packages inside the container
RUN apt-get update  \
    && apt-get -y install  \
          iputils-ping \
          iproute2  \
          net-tools \
          dnsutils  \
          mtr-tiny  \
          nano      \
    && apt-get clean

# Put file inside the container
COPY file  /

# The command executed by the container after startup
CMD [ "/bin/bash"]
```

The above `Dockerfile` indicates that our container
is be built on top of the official Ubuntu 20.04 Docker image.
That is the purpose of the `FROM` command.
On top of this base image, we use the `RUN` command
to install a number of additional software packages, including
some network utilities and the `nano` editor.
The `"apt-get clean"` command at the end
clear the local repository of retrieved package files
that are left in `/var/cache`, so the final image size
can be reduced. More explanation can be found
in the comments.


## Building and starting the container

We will statically assign IP addresses to our container. To do that,
we need to attach our container to a network first. We can let docker
attach our container to the default network. If you ca take this option,
you can skip the following network-creation step.

In many situations, we would like to attach our containers to a custom network.
To achieve that, we need to first create a network using the following
docker command, which creates a network called `seednetwork`,
and its network prefix is `172.20.0.0/24`.
We can further use `"docker network"` command to manage
all the created networks (listing, deleting, etc.).

``` shell
$ docker network create --subnet=172.20.0.0/24 seednetwork
```

We are now ready to build and run our container. The first command
in the following builds a container called `seedhost` using
the `Dockerfile` in the current directory.
The second command starts the container.
The flags `-it` tell Docker we want an interactive session
with a tty attached. The `--rm` option will remove the container
when it stops. The `--ip` option specifies the static
IP address, and the `--net` option specifies
the network this container should be attached to.

``` shell
$ docker build -t seedhost .
$ docker run --net seednetwork --ip 172.20.0.5 --rm -it seedhost
```

**Some related commands.** Docker has many useful commands,
we refer students to online resources (there
are many) to learn those commands. In the following, we
summarize some of the commands commonly used in SEED labs.

- `docker ps`:  List all the running containers, including
         the ID for each container.  The container id is
         a unique alphanumeric number for each container, and it is needed
         in many commands.

- `docker ps -a`:
List all the containers, regardless of whether they are
running or not.

- `docker exec -it <container id> /bin/bash`:
Execute the `/bin/bash` command
in a running container. We will get a shell prompt.
You don't need to type the entire ID string; typing the first
few characters will be sufficient, as long as they are unique.

- `docker rm <container id>`: Remove a container.



