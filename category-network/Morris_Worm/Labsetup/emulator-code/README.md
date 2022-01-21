# Generate the Container Files

Instructors who are interested in generating their customized
Internet emulator can use the Python program in this folder. 

Run the `internet-nano.py` or `internet-mini.py` to generate the container files.
Each program will create a folder called `output`, which stores
the container files for the emulation. 

After  generating the containers file, please manually added the following 
service entry to the `docker-compose.yml` file (add it to the first entry). 
Our Python code currently does not add this entry automatically (it 
will be in the future).

```
  morris-worm-base:
        build:
            context: ./morris-worm-base
        image: morris-worm-base
```
