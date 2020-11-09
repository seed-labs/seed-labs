# Web Security


## Summary of the Changes for Ubuntu 20.04

Detailed changes are described in the README file for each lab.
Here we only summarize how much change is made.
The Status column states whether the revision is finished or not.
The meaning of the Changes column can be found from
[this file](../common-files/category_of_revision.md).

| Lab Name | Changes | Status |  Notes |
| ---      | ---     | ---    |  ---   |
| XSS Attack    | Major | Done | [README](Web_XSS_Elgg/README.md)|
| CSRF Attack   |       |      | [README](Web_CSRF_Elgg/README.md)|
| SQL Injection |       |      | [README](Web_SQL_Injection/README.md)|
||||


## Network Topology and Docker Images Used

| Lab Name      | Topology | PHP | SQL |
| ---           | :---:    | :---: | :---:  | :---: |
| XSS Attack    | 1 LAN    | x | x |
| CSRF Attack   | 1 LAN    | x | x |
| SQL Injection | 1 LAN    | x | x |
|||||



## Wish List

I hope that we can develop more web security labs. Here is a list of 
the topics that we can pursue:

- Use a different web application for XSS and CSRF. Right now, these
two labs are based on the Elgg web application. Introducing more 
web applications give instructors more choices. With the container 
setup, adding another application to the lab will be very convenient. 


- A lab focusing on the ClickJacking attack.

- A lab focusing on the Browser Security. Browser has a lot of interesting
security mechanisms, such as same origin policy, sandbox, etc. It will be
great if we can design a lab based on these mechanisms. 

- OWASP publishes a list of common vulnerabilities in web applications.
We can develop labs based on some of them, if they are not already covered 
by other SEED labs.
