# Common Problems

In this document, we record some of the common problems encountered. 

## Problem 1: Web security labs

**Problem Description:** In the web security labs, students failed to 
browse the web server created for the lab. For example, when
they visit the Elgg website, the browser says that "an exception
has encountered". Students were not able to see the Elgg website.

**Cause:** The students unzipped the `Labsetup.zip` file inside the 
shared folder. The permissions on the unzipped files are not 
the same as those on the original files if the files are created
inside the shared folder. That created a problem
for the MySQL database, so the database container did not 
work properly, and the required tables were never created. The
shared folder has created many problems like this in the past, so we need to
tell students to never work from inside the shared folder. They
should copy the zip file outside of the shared folder, 
and unzip it from there. That solves the problem. 

It is quite common for students to directly work from inside
the shared folder. That has created many issues. After spending hours
doing the debugging, it turned out that the problem was simply caused 
by the shared folder. 

To avoid wasting time on this kind of problem, we should ask students to stay
away from the shared folder. Many students download the lab files 
to their host machines, and then use the shared folder to get the 
files into the VM. We can do it without using the shared folder. 
For example, to download the `Labsetup.zip` file, we can either 
do it directly from the browser inside the VM,
or use one of the following commands from the command line:
```
$ curl -o Labsetup.zip  <url of the file> 
$ wget --no-check-certificate <url of the file>
```
