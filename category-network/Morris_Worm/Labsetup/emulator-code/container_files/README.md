# Note

## The base container 

Removed the zsh from the `Dockerfile`, as it causes the 
problem in the BOF attack (still haven't figured out why). 
Also change the `FROM` entry to use our customized Ubuntu image.


## Containers for nodes 

The files in the `base` folder will be used to replace the 
`dummies` folder. This is the base image for all the containers. 
The other container's `Dockerfile` has only the following content:

```
FROM cfee3a34e9c68ac1d16035a81a926786

CMD ["/start.sh"]
```

## The server folder

This folder contains the server code (source code). The binary
code is already copied to the `morris-worm-base` folder.
