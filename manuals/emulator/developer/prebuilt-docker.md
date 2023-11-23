# Add a pre-built docker image to the emulation

The base images used by the container in the SEED emulator 
are pulled from the Docker Hub, and they are fixed (which base image
is used is based on the type of a node). 
However, sometimes, we would like to use a different 
base image for some of the nodes in the emulator. This image
could be a different image from the Docker Hub, or 
it could be a local image. This can be done. 


Step 1: If we use a local image, we need to put the pre-built image in a directory, 
        say `my_image/`. 

Step 2: We create a `DockerImage` object from this pre-built docker image folder. 
We also need to add it to the `Docker` object. For the local image, we need to 
specify `True` for the `local` parameter. We also set the `software` parameter
with an empty list (this parameter will be used in the future revision). 

```
docker = Docker(internetMapEnabled=True)
image  = DockerImage(name='my_local_image', dirName='./my_image', 
                     local=True, software=[])
docker.addImage(image)
```


Step 3: We use `Docker`'s `setImageOverride()` method to override the
default image set for a node. In this example, we 
get an existing host (`host_2`) from the emulator, 
and set our pre-built image as its base image. 

```
myhost = base.getAutonomousSystem(150).getHost('host_2')
docker.setImageOverride(myhost, 'my_local_image')
```

Step 4: After generating all the docker images, we need to copy
our pre-built image to the output folder. In our future revision,
we will do the copy when generate the docker images. For now, 
this needs to be done manually. 

```
# Render and compile 
OUTPUT = './emulator'
emu.render()
emu.compile(docker, OUTPUT, override = True)

# Copy the pre-build image to the output folder 
os.system('cp -r my_image/ ' + OUTPUT)
```



## Note

If we just want to use a docker image from the Docker Hub, we can do the following
in Steps 2 and 3: 

```
imagename = 'handsonsecurity/seed-ubuntu:large'
docker = Docker(internetMapEnabled=True)
image  = DockerImage(name=imagename, software=[])
docker.addImage(image)

myhost = base.getAutonomousSystem(150).getHost('host_2')
docker.setImageOverride(myhost, imagename)
```

