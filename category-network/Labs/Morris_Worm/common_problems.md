# Common Problems

- VM setup: give the VM 2 cores and 8 GB. Some students did not do this,
  and their VM either crashed or became very slow.

- Due to some problems, when we shut down the emulator,
  some container or networks are not removed. This will
  prevent us from starting the emulator.  We can run
  the following command to remove all the stopped containers
  and remove all the unused networks.

  ```
  docker container prune 
  docker network prune
  ```

- Sometimes, we failed to start the containers.
  One of the problem is the failure to remove
  a network because it has some active attachment. We can
  delete the attached container using the following command,
  and then delete the network 

  ```
  docker network disconnect --force network_name container_name
  docker network rm network_name

  ```

