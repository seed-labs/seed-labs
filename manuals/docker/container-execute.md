# Running commands on a running container

All the containers will run in the background. If we need
to run some commands in a container, we just need to first
find out this container's ID using the `docker ps`
command, and then use the `docker exec` command to
run a `bash` shell inside the container. If we use
the `-it` option, we will get the interactive
shell (a root shell). See the following.

``` shell
$ docker ps
CONTAINER ID        NAMES       ...
bcff498d0b1f     host-10.9.0.6  ...
1e122cd314c7     host-10.9.0.5  ...
31bd91496f62     host-10.9.0.7  ...

$ docker exec -it 1e /bin/bash
root@1e122cd314c7:/#
```

It should be noted that in the `docker exec` command,
we did not type the full container ID; we only type the
first two characters. As long a prefix is unique among
all the container IDs, we only need to type the prefix.


## Command Aliases

The printout of the `docker ps` command is quite long. Most
of the information in the printout is not very useful to us.
We can use the `--format` option to limit the fields
in the printout. That will make the command quite long. Since
we are going to use this command very frequently, we
create the following alias in the `.bashrc` file (in the
home directory). Moreover, we are also going to run
`docker exec` very frequently, so we also want to create an alias for
this command. Since it needs to take an argument, we
add a shell function definition in the `.bashrc` file.

``` bash
alias dockps='docker ps --format "{{.ID}}  {{.Names}}"'
docksh() { docker exec -it $1 /bin/bash; }
```

With the alias and the function, we can simply do the following

``` shell
$ dockps
bcff498d0b1f  host-10.9.0.6
1e122cd314c7  host-10.9.0.5
31bd91496f62  host-10.9.0.7

$ docksh 31
root@31bd91496f62:/#
```
