# CTF - Format String

---

## For the Instructor(s)

### SEED Labs

This CTF is based on the [Format-String Vulnerability Lab](https://seedsecuritylabs.org/Labs_20.04/Software/Format_String/).

### Easy and Hard Challenges

The Docker Image used for this challenge is running [xinetd](https://en.wikipedia.org/wiki/Xinetd), which will listen for incoming connection requests from students and issue a response based on the students input.
The Docker Image contains the flag.
On the Docker Image there is the binary executable of program that is vulnerable to a buffer overflow attack, and the program has the set-uid bit enabled.

This CTF has been broken into two nearly identical versions, with one being denoted as the easy version, and the other denoted as the hard version.
The difference between the easy and hard version of the challenge is in the vulnerable program running on the Docker app.
In the easy version of the challenge, the vulnerable program prints out helpful information regarding the address of the buffer that is vulnerable to a buffer overflow, and in the hard version of the challenge this information is not printed for the student.

Both the easy and hard versions of the challenge can be deployed simultaneously from the same host machine and they should not interfere with each other.

#### Configuring the Docker Image

##### Replicas

The Docker Image for both the easy and hard versions are to be replicated instances, meaning that multiple instances of the Docker Image will be started when the Docker app is run.
The replication of this image is so that each student will be interacting with their own copy of the Docker image, with the hopes that if one student solves the CTF on their instance of the image, no information will be revealed to other students interacting with their own instance of the image.
To configure the number of instances to create (presumably one per each student):
1. Open `Return_to_Libc/easy_ret-to-libc/docker-compose.yml` or `Return_to_Libc/hard_ret-to-libc/docker-compose.yml` in a text editor.
2. Find the `replicas` tag, nested under `services > ubuntu > deploy > replicas`
3. Modify the value associated with the `replicas` tag, e.g. `replicas: 25`

##### Modifying the Flag

Both the easy and hard versions of the challenge contain a `flag.txt` file that will be copied in plaintext into the Docker Image. Simply modify the contents of `Return_to_Libc/easy_ret-to-libc/image_ubuntu/flag.txt` or `Return_to_Libc/hard_ret-to-libc/image_ubuntu/flag.txt` to update the flag.

#### Building the Docker Image

There is a build script supplied for both the easy and hard versions of the challenge:
* `Return_to_Libc/easy_ret-to-libc/build.sh`
* `Return_to_Libc/hard_ret-to-libc/build.sh`

You should build the Docker image before running for the first time, or after you make any changes to the Docker source image files.
To build:
1. `$ cd Return_to_Libc/easy_ret-to-libc` or `$ cd Return_to_Libc/hard_ret-to-libc`
2. `$ ./build.sh`

#### Starting the Docker App

There is a start script supplied for both the easy and hard versions of the challenge:
* `Return_to_Libc/easy_ret-to-libc/start.sh`
* `Return_to_Libc/hard_ret-to-libc/start.sh`

**WARNING:** In order to run this CTF, Address Space Layout Randomization ([ASLR](https://en.wikipedia.org/wiki/Address_space_layout_randomization)) will be disabled on the host machine that's hosting the challenge.
ASLR must be disabled on the host so that it'll be disabled in the Docker app.
Disabling ASLR makes it much more likely that this CTF can be solved, since ASLR is a countermeasure that is quite effective at mitigating buffer overflow attacks.
The `start.sh` script will disable ASLR on the host machine, and will print a large and obvious warning message about this.

You should build the Docker image before running the start script.
To start the Docker app:
1. `$ cd Return_to_Libc/easy_ret-to-libc` or `$ cd Return_to_Libc/hard_ret-to-libc`
2. `$ ./start.sh`

#### Stopping the Docker App

There is a stop script supplied for both the easy and hard versions of the challenge:
* `Return_to_Libc/easy_ret-to-libc/stop.sh`
* `Return_to_Libc/hard_ret-to-libc/stop.sh`

To execute the stop script:
1. `$ cd Return_to_Libc/easy_ret-to-libc` or `$ cd Return_to_Libc/hard_ret-to-libc`
2. `$ ./stop.sh`

If the `easy_ret-to-libc/stop.sh` script is run it will stop the Docker application for the easy version of the challenge, and if the `hard_ret-to-libc/stop.sh` script is run it will stop the Docker application for the hard version of the challenge.

**WARNING:** Both versions of the stop script will check to see if the other version of the challenge is still running, and if it is still running, it will **NOT** enable ASLR on the host machine.
If the other version of the challenge is not running when stop script is run then it **WILL** enable ASLR again on the host machine.

#### Deploying the Challenge

Once the Docker app is started, multiple instances of the same Docker Image will be started.
Each instance of the Docker Image will map to a different port on host machine.
The instructor should tell which instance of the image they want each student to connect to by telling them which port number on the host machine they will establish an SSH connection through.
The `start.sh` scripts will dump a summary of the running instances, including the assigned ports on the host machine.
If you need to retrieve this information again, you can run `$ sudo docker ps` to get a summary of the currently running Docker applications.

The instructor should also relay to the students that they will use a set of default credentials when they first connect via SSH to their instance of the Docker image.
Those default credentials are:
* User: `seed`
* Pass: `dees`

The first time the student connects to their instance they will be prompted to change the password, and after successfully changing the password the SSH connection will be broken.
The student can then connect via SSH using their newly changed password going forward.

---

## For the Student(s)

You instructor will provide you with a port number to use when establishing an SSH connection to the machine hosting the CTF.

1. `$ ssh <server-ip> -p <port-num> -l seed`
2. Use the password `dees` to authenticate.
3. You will be prompted to change the default password, follow the prompts to change it.
4. Once the password is changed, the SSH connection will be broken.
5. Establish an ssh connection again as in step 1, and use the newly changed password going forward.
