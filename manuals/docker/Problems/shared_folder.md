# Problems Caused by Shared Folder

Shared folders have caused many problems. 
Some students download the lab files to their host machines, 
and then use the shared folder to get the files into the VM. 
They then directly do their work inside the shared folder,
such as unzipping the `Labsetup.zip` file.
Doing so has caused many problems, because
the permissions on the unzipped files are not
the same as those on the original files, if the files
are unzipped inside the shared folder. Some labs
and container setup are sensitive to 
the file permissions. 

When a student reported a wired problem, the first 
thing we should check is whether the student
is doing work inside the shared folder. Moreover, 
we should try to avoid using the shared folder.
For example, to download the `Labsetup.zip` file, we can either
do it directly from the browser inside the VM,
or use one of the following commands from the command line:
```
$ curl -o Labsetup.zip  <url of the file>
$ wget --no-check-certificate <url of the file>
```


