# Instructors

## Building the Docker Container

If you have not build the Docker container before, or have made changes that warrant a rebuild, follow these steps:

1. cd into the `Too_Much_Flow` directory
2. Run the `build.sh` script

## Starting the Docker Container

Ensure that you have build the Docker container before running (see above instructions).

1. cd into `Too_Much_Flow` directory
2. Run the `start.sh` script

You can then verify that the container is running by executing `$ sudo docker ps` and seeing if the too-much-flow container is listed among the running containers.

## Stopping the Docker Container

1. cd into `Too_Much_Flow` directory
2. Run the `stop.sh` script

You can then verify that the container has stopped by executing `$ sudo docker ps` and seeing if the too-much-flow container is listed among the running containers.

## Modifying the Flag

To change the flag for future semesters follow these steps:

1. Modify `Too_Much_Flow/src/bin/flag.txt` to your desired flag.
2. Rebuild the container using the above instructions.

---

# Students

## Connecting to the Server

Students should use the netcat utility to connect to the server hosting the challenge.
To connect, simply execute `$ nc <server-ip> 3002` to establish a TCP connection to the server.
