# Docker Hub Issues

Many labs need to pull images from the docker hub.
If for some reasons, downloading docker images
from the official docker registry is slow in 
your country or region, you may need to
find a registry mirror. 
Given the popularity of Docker, it will be 
very likely that some registry mirrors
already exist in your region. You should find 
them, and add them to `/etc/docker/daemon.json`,
telling docker to use these registry mirrors, instead of 
using the official registry. If this file 
does not exist, create one. We give an example
in the following: 

```
{
  "registry-mirrors": [
    "https://<my-docker-mirror-1>",
    "https://<my-docker-mirror-2>",
  ]
}
```

After modifying the file, run the following command for the change
to take effect. The third command lets you see the register
mirror that you are using.

```
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
$ sudo docker info
```
