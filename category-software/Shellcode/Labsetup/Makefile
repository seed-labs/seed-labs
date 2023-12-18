
all: hello mysh64 another_sh64 

hello: hello.s
	nasm -g -f elf64 -o $@.o $<
	ld -o $@  $@.o

mysh64: mysh64.s
	nasm -g -f elf64 -o $@.o $<
	ld --omagic -o $@  $@.o

another_sh64: another_sh64.s
	nasm -g -f elf64 -o $@.o $<
	ld --omagic -o $@  $@.o

clean:
	rm -rf *.o mysh64 another_sh64 hello

