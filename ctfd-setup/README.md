# Open-Source CTF Platform

---

## For Administrators

### Repository Layout

The directory `ctfd-setup` located in this repo's root directory contains the source code needed to deploy CTFd.
[CTFd](https://ctfd.io/) is an open-source application for hosting [Capture The Flag (CTF) challenges](https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity).
The CTFd applcation is included in this repo as a [Git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
CTFd is included as a submodule to minimize the need to modify and subsequently maintain the CTFd source code.

### CTFd Deployment

After you clone this repo, you will need to initialize the CTFd submodule, and you can do so by running the `submoduleInit.sh` script.
The `submoduleInit.sh` script will initialize the local instance of the CTFd submodule and will fetch all of the data from the CTFd project.
Once the CTFd submodule has been initialized, the CTFd application should be ready to be run.
The `run.sh` script can be used to start the CTFd application (NOTE the `run.sh` script specifies a relative path so it should be run from within the `/ctfd-setup/` directory).
The CTFd application runs in Docker containers, and once started via the `run.sh` script you should be able to interact with CTFd.
From a web browser, navigate to [http://your-server-ip:80](http://your-server-ip:80) to view the CTFd landing page.

### Admin Account Setup

1. Visit the CTFd site you launched above.
2. Login with default admin credentials (obtained by contacting the project maintainers; see bottom of page).
3. Change the default admin credentials to your desired credentials (see below for procedure).

### Changing Admin Account Credentials

1. Register a new user with desired credentials.
2. Login with default admin credentials (obtained by contacting the project maintainers; see bottom of page).
3. Go to the admin panel, then go to "Users" tab.
4. Click on the new account.
5. Click on "edit account" .
6. Change account type to admin.
7. Log out.
8. Log in using new account.
9. Go to "Users" tab in the admin panel and delete the old (default) admin account.

### Importing challenges

There are two main ways to import CTF challenges into the CTFd application.
First, make sure the CTFd application is running, then login to the admin portal using admin credentials.
Next, navigate to `Admin Panel > Config > Backup`.
From here there are two options: importing a `.zip` or importing `.csv`.
There are a few differences between the two import options:

#### Importing challenges in `.zip` files

* **This will overwrite any existing configurations you have in place**, including user accounts, challenges, files, etc. This essentially imports a snapshot of the CTFd application at the time the `.zip` file was generated.
* Multiple challenges can be imported in a single `.zip` file.
* Files needed to complete the challenges will be included when imported.

#### Importing challenges in `.csv` files

* This will not overwrite any existing configurations you have in place.
* Multiple challenges can be imported in a single `.csv` file.
* Files needed to complete the challenge **will not** be included when imported.

### Management & Troubleshooting

Student passwords can be reset through the admin panel by clicking on the user in the "Users" tab.
If the server goes down, the containers for both CTFd and the docker challenges may need to be restarted. Use the same docker command from the CTFd setup instructions to launch CTFd, and use the "start containers" bash script in the server challenges folder to restart all challenge containers. It is possible you may need to forcibly shut down and remove old container versions if the server restarts.
Challenges can be enabled/disabled/modified on the fly using the admin panel of the platform online.
Challenge solutions are available to instructors upon request (see bottom of page for contact info).

---

## For Students

### What is a CTF?

A [CTF (Capture The Flag)](https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity) is a kind of information security competition that can challenge contestants to solve a variety of challenges, ranging from a scavenger hunt on Wikipedia to basic programming exercises, to hacking your way into a server to steal data.
In these challenges, the contestant is usually asked to find a specific piece of text that may be hidden on the server or behind a webpage.
This goal is called the flag, hence the name! ( credit: https://dev.to/atan/what-is-ctf-and-how-to-get-started-3f04)
In the context of this class, these challenges are in CTF format, where each submission consists of a string of text.
The challenges are designed to test your mastery of studio and class materials, as well as proficiency with the tools used in studio.

### How to participate

Please navigate to the following link: [your server DNS here].
You may get a security notification that the site is not secure; if so, go to the "advanced" option continue anyway.
If Chrome does not work as a browser, Firefox should.
Please register a new account using your school email address and a username.
Make sure you also remember your password for future logins.
Once you log in, you should see a page with challenges for you to complete.
Use the prompts and files provided to find the flags!

---

## Credits

* Some challenges are based on existing challenges from CTF sources [PicoCTF](https://www.picoctf.org/), [DEFCON Biohacking](https://www.defconbiohackingvillage.org/), and CSICTF.
* This platform was originally developed by [Zack Kaplan](mailto:zack.kaplan@wustl.edu) as part of a Master's project at [Washington University in St. Louis (WUSTL)](https://wustl.edu/).
* The work is being continued by [Dylan Simmons](mailto:dylan.simmons@wustl.edu) as part of a Master's project at WUSTL.
* The project development is being advised by [Steve Cole](mailto:svcole@wustl.edu).

## Collaboration

We'd love to hear your feedback and work together on this project!
Please feel free to clone this repo and generate pull requests, and to contact us directly to discuss the project and how you're using it / would like to use it in your class.

## Contact Info

Please contact [Dylan Simmons](mailto:dylan.simmons@wustl.edu) or [Steve Cole](mailto:svcole@wustl.edu) with any:
* Requests for admin credentials for the CTF challenges
* Requests for CTF challenge solutions
* Questions
* Comments
* Suggestions
