# Miscellaneous Problems

## Error: Cannot Create Container

```
ERROR: for HostA1  Cannot create container for service HostA1:
Conflict. The container name "/attacker-10.9.0.5" is already in use by container
"b24b675aa5a221c0aa493b0b5f003215552fd2b459a30cb08fd49c0c72fe2fcf".
You have to remove (or rename) that container to be able to reuse that name.
```

This is because the container with the same name (either from this lab
or from other SEED labs) are still running. Maybe we did not shutdown
the container properly. That prevents us
from creating the container.
We just need to use the following commands
to stop and remove the container using its ID.

``` shell
$ docker container stop b24b
$ docker container rm b24b
```
