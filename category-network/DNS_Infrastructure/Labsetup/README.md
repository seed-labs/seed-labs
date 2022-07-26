# Instructions

## Use Pre-built container files

We have already generated all the container files
for this lab.  Just go to the `output` folder, run 
`docker-compose build` and `docker-compose up` to build and 
start the containers.


## Generate the container files

If you want to generate the docker files yourself, you need to 
download the Internet emulator source code first. After setting
up the development environment, you can run the following 
commands to generate the docker files. 

- Run `component-base.py`
- Run `component-dns.py`
- Finally, run `internet-emulator.py`. This will create 
  a folder called `output`, and put all the created docker 
  files inside. If the `output` folder already exists, the 
  program will fail, so you need to delete the folder first. 

