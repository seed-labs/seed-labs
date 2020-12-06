# Building, Starting, Stopping Containers

## Building the Containers

We can use the following commands to build the containers first.
This command will build the containers specified in
the `docker-compose.yml` file.  To use a different configuration
file, use the `-f` option.


``` shell
$ docker-compose build
$ docker-compose -f anotherfile.yml build
```


## Start All the Containers

We can run Compose's `up` command to start
all the containers specified in the `docker-compose.yml` file.
Make sure to run this command in the same folder
as `docker-compose.yml`.

``` shell
$ docker-compose up
Creating network "net-10.9.0.0" with the default driver
Creating host-10.9.0.7 ... done
Creating host-10.9.0.6 ... done
Creating host-10.9.0.5 ... done
Attaching to host-10.9.0.6, host-10.9.0.7, host-10.9.0.5
... (blocked here) ...
```

## Stopping All the Containers

To stop all the containers, we can use use `Ctrl-C` to
stop the `"docker-compose up"` command,
that will stop all the containers, but without removing them.
If we want to removing them, we can run Compose's `down` command.

``` shell
Attaching to host-10.9.0.6, host-10.9.0.7, host-10.9.0.5
^CGracefully stopping... (press Ctrl+C again to force)
Stopping host-10.9.0.5 ...
Stopping host-10.9.0.7 ...
Stopping host-10.9.0.6 ...

$ docker-compose down
Removing host-10.9.0.5 ... done
Removing host-10.9.0.7 ... done
Removing host-10.9.0.6 ... done
Removing network net-10.9.0.0
```

Another way to do this is to go to a different terminal (but still in the
same folder as `docker-compose.yml`), and run Compose's `down`
command. That will stop and removing all the containers.

``` shell
$ docker-compose down
Stopping host-10.9.0.7 ... done
Stopping host-10.9.0.6 ... done
Stopping host-10.9.0.5 ... done
Removing host-10.9.0.7 ... done
Removing host-10.9.0.6 ... done
Removing host-10.9.0.5 ... done
Removing network net-10.9.0.0
```



