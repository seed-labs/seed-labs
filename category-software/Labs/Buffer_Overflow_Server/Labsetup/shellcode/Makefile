
all: 
	gcc -m32 -z execstack -o a32.out call_shellcode.c
	gcc -z execstack -o a64.out call_shellcode.c

clean:
	rm -f a32.out a64.out codefile_32 codefile_64

