# Instructors

## Building the Docker Container

If you have not build the Docker container before, or have made changes that warrant a rebuild, follow these steps:

1. cd into the `Wheres_WALD0` directory
2. Run the `build.sh` script

## Starting the Docker Container

Ensure that you have build the Docker container before running (see above instructions).

1. cd into `Wheres_WALD0` directory
2. Run the `start.sh` script

You can then verify that the container is running by executing `$ sudo docker ps` and seeing if the wald0 container is listed among the running containers.

## Stopping the Docker Container

1. cd into `Wheres_WALD0` directory
2. Run the `stop.sh` script

You can then verify that the container has stopped by executing `$ sudo docker ps` and seeing if the wald0 container is listed among the running containers.

---

# Students

## Connecting to the Server

Students should connect to the server hosting the challenge via SSH:
* Specify port `3001` when establishing an SSH connection.
* Use these credentials when connecting:
   * User: `user1`
   * Pass: `find32`
* `$ ssh <server-ip> -p 3001 -l user1`
