
all: 
	gcc -m32 -z execstack -o a32.out call_shellcode.c
	nasm -f elf64 shellcode_32.s -o shellcode_32.o 
	ld --omagic shellcode_32.o -o shellcode_32.out
	#objdump -Mintel --disassemble $@.o

clean:
	rm -f *.out *.o codefile_32 

