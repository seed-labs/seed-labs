
all: mysh64 hello another_sh64


mysh64: mysh64.s
	as  -o $@.o $<
	ld --omagic -o $@ $@.o

hello: hello.s
	as  -o $@.o $<
	ld  -o $@ $@.o

another_sh64: another_sh64.s
	as  -o $@.o $<
	ld  -o $@ $@.o


clean:
	rm -f hello mysh64 another_sh64 *.o 

