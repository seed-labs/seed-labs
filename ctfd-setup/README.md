# CTF Platform

# Setup

1. On the Linux server that will host the CTFd platform (e.g. a SEED Labs machine image), download the CTFd repository from here: https://github.com/tghosth/CTFd-docker-deploy and follow the instructions in the readme, generating a certificate or making your own self-signed certificate using ssl and configuring DNS settings as needed (described in the above repository instructions).

2. Still following the README from the CTFd-docker-deploy repo linked above, launch the CTFd containers.

3. Change the default admin credentials to your desired credentials (see below for procedure).

4. Clone this repository on your Linux server, and download the .zip file(s) for the CTF module(s) you would like to use from the associated directories within each module (e.g. web, cryptography).

5. Visit the CTFd site you launched above; you should be logged in as an admin.

6. On the site, go to Config - backup -import and choose a .zip file you downloaded for a module whose challenges you would like to run.

7. Use the admin dashboard to modify or configure challenges as desired (e.g. making challenges visible or hidden). based on the unit (all challenges start invisible by default)

8. Set up server challenges from the server challenges folder if desired, Instructions for building each server challenge are in the READMEs for each challenge folder.

# Changing Admin Account Credentials

1. Register a new user with desired credentials.
2. Login with default admin credentials (obtained by contacting the project maintainers; see bottom of page).
3. Go to the admin panel, then go to "Users" tab.
4. Click on the new account.
5. Click on "edit account" . 
6. Change account type to admin.
7. Log out.
8. Log in using new account.
9. Go to "Users" tab in the admin panel and delete the old (default) admin account.

# Student instructions:

What is a CTF?

A CTF (Capture The Flag) is a kind of information security competition that can challenge contestants to solve a variety of challenges, ranging from a scavenger hunt on Wikipedia to basic programming exercises, to hacking your way into a server to steal data. In these challenges, the contestant is usually asked to find a specific piece of text that may be hidden on the server or behind a webpage. This goal is called the flag, hence the name! ( credit: https://dev.to/atan/what-is-ctf-and-how-to-get-started-3f04)

In the context of this class, these challenges are in CTF format, where each submission consists of a string of text. The challenges are designed to test your mastery of studio and class materials, as well as proficiency with the tools used in studio. 

How to participate:

Please navigate to the following link: \[your server DNS here\] . You may get a security notification that the site is not secure; if so, go to the "advanced" option continue anyway. If Chrome does not work as a browser, Firefox should.

Please register a new account using your school email address and a username. Make sure you also remember your password for future logins. Once you log in, you should see a page with challenges for you to complete. Use the prompts and files provided to find the flags!

# Management/Troubleshooting

Student passwords can be reset through the admin panel by clicking on the user in the "Users" tab.

If the server goes down, the containers for both CTFd and the docker challenges may need to be restarted. Use the same docker command from the CTFd setup instructions to launch CTFd, and use the "start containers" bash script in the server challenges folder to restart all challenge containers. It is possible you may need to forcibly shut down and remove old container versions if the server restarts.

Challenges can be enabled/disabled/modified on the fly using the admin panelof the platform online. 

Challenge solutions are available to instructors upon request (see bottom of page for contact info).

# Credits

* Some challenges are based on existing challenges from CTF sources PicoCTF, DEFCON Biohacking, and CSICTF.
* This platform was originally developed by Zack Kaplan (zack.kaplan@wustl.edu) as part of a Master's project at Washington University in St. Louis (WUSTL). The work is being continued by Dylan Simmons as part of a Master's project at WUSTL.

# Collaboration

We'd love to hear your feedback and work together on this project! 

Please feel free to clone this repo and generate pull requests, and to contact us directly to discuss the project and how you're using it / would like to use it in your class..

# Contact Info
Please contact Steve Cole (svcole@wustl.edu) with any:
* requests for admin credentials for the CTF challenges
* requests for CTF challenge solutions
* questions
* comments
* suggestions.
