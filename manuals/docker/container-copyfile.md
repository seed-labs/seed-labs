# Copy files between container and host

Very often, we need to transfer files between a container
and the hosting machine. This can be easily done using the 
`docker cp` command. See the following example.

``` shell
$ docker ps
CONTAINER ID        NAMES       ...
bcff498d0b1f     host-10.9.0.6  ...
1e122cd314c7     host-10.9.0.5  ...
31bd91496f62     host-10.9.0.7  ...

// From host to container
$ docker cp  file.txt  bcff:/tmp/
$ docker cp  folder  bcff:/tmp

// From container to host 
$ docker cp  bcff:/tmp/file.txt .
$ docker cp  bcff:/tmp/folder  .
```
