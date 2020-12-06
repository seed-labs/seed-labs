# Commands Commonly Used in SEED Labs

Detailed instructions on how to set up the lab environment
using Docker and Compose are included in the
[SEED Container manual](SEEDManual-Container.md).
Here we provide some quick guides:

## Build, Start, and Shutdown the Lab Environment

``` bash
docker-compose build
docker-compose up
docker-compose down
```

## Alias Included in the SEED VM

``` bash
dcbuild        # Alias for: docker-compose build
dcup           # Alias for: docker-compose up
dcdown         # Alias for: docker-compose down
dockps         # Alias for: docker ps --format "{{.ID}}  {{.Names}}"
docksh  <id>   # Alias for: docker exec -it <id> /bin/bash
```

## Useful Docker Commands

``` bash
docker network ls              # List all the networks
docker container restart <id>  # Restart a container
docker container stop    <id>  # Stop a container
docker container start   <id>  # Start a container
```
