# Special Settings for Containers

In the `docker-compose.yml` file, we sometimes add special settings 
to a container. This manual explains the purpose of those special settings.

## Volumes

Sometimes, we would like to share files between the host VM
and a container. One use case is code editing. 
For most containers, to keep the image size small, 
we have only installed a very simple 
editor called `nano`, but the host VM has many powerful editors.
Therefore, it is better to edit the code on the host VM.

Since the code needs to run inside the container, we need to 
get the code into the container. The easiest way is to 
create a shared folder between the VM and container.
This is done through `volumes` in Docker. In
the Docker Compose file, we add the following entry to 
a container. 

```
volumes:
        - ./vmfolder:/containerfolder
```

The entry above mounts the `vmfolder` folder on the host VM
to the `/containerfolder` folder inside the container. Therefore,
whatever we put inside `vmfolder` from the host VM will show up
in the `/containerfolder` inside the container, and vice versa.


## Host Mode

In many SEED labs, the attacker container needs to be able to sniff packets,
but running sniffer programs inside a container has problems, because
a container is effectively attached to a virtual switch,
so it can only see its own traffic, and it is never going to see
the packets among other containers. To solve this problem,
we use the `host` mode for the attacker container. This
allows the attacker container to see all the traffics. The following
entry used on the attacker container:

```
network_mode: host
```

When a container is in the `host` mode,  it sees
all the host's network interfaces, and it even has the same
IP addresses as the host. Basically, it is put in the
same network namespace as the host VM. However, the container
is still a separate machine, because its other namespaces are
still different from the host.


## Privileged Mode and `sysctl`

To be able to modify kernel parameters at runtime (using `sysctl`),
such as enabling IP forwarding, a container needs to be privileged.
This is achieved by including the following entry
in the Docker Compose file for the container.

```
privileged: true
```

It should be noted that some kernel parameters are global and cannot be
modified by a container, even if it is in the privileged mode. For 
example, the address layout randomization parameter cannot be set 
by containers. You can set them in the VM, and the change will 
be visible in all containers. 


