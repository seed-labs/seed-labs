# TODO List

Right now this lab can only be conducted on our Ubuntu 12.04, because 
the versions of the OpenSSL in newer Ubuntu OSes have already
fixed the problem. I really want to port this lab to our newest VM,
Ubuntu 20.04. In theory this should be doable, because all we need to 
do is to install the older OpenSSL library, which 
is quite easy to do. However, we haven't got time to try this yet 
on Ubuntu 20.04. Help is needed. We will soon migrate all our 
labs to Ubuntu 20.04, so there is no need to do this for Ubuntu 16.04.

There are two different approaches that we can pursue:

- The current Heartbleed design uses ```Elgg```. If we want to
keep this, we may have to rebuild the Apache web server, so it
can use the older OpenSSL library. This could be quite difficult. 

- Another approach is, instead of using ```Elgg```, 
let's write our own TLS client and server programs, and use these
programs to demonstrate the Heartbleed attack. We can easily 
write our own programs and link them with the older version of the ```openssl``` 
library. This could be more promising. In the code, we can
put in data and logic that can help us demonstrate the Heartbleed
attack. 



