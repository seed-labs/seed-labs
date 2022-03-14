Build the image:
```bash
docker build -t seed-labs .
```
Only needs to be done 1 time, then you use the image for other exercices

To run setup:
```bash
docker run --rm -it seed-labs
```

For sudo commands: `[sudo] password for seed:` is seed

---
Steps for this lab:

1. use the root Dockerfile to compile the files used by the server
- Comment the lines : `COPY /server-code /home/seed` and `COPY /attack-code /home/seed/`
- `docker run --rm -it -v $('pwd'):'/home/seed' seed-labs`: Inside the container run : `cd server-code/ && make && make install`
- `exit` in the container and uncomment the lines of the Dockerfile
- `docker-compose up`
- `docker exec -it seed-lab /bin/bash`