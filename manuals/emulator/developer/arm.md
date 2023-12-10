# Generate container images for Apple silicon machines

Container images for different platforms are different. Generating
the docker images is done in the `Docker` class. Using the 
`platform` argument, we can specify what platform we 
will generate the images for. Currently, two platforms
are supported.

- `Platform.ARM64`: for Apple silicon machines
- `Platform.AMD64`: for AMD64 machines. 

See the following example. 


```
emu.render()
docker = Docker(internetMapEnabled=True, etherViewEnabled=True, 
                platform=Platform.ARM64)
emu.compile(docker, './emulator', override = True)
```
