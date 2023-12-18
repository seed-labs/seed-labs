TARGET = mysh mysh2 mysh_64
  
all: $(TARGET)

mysh: mysh.s
	nasm -f elf32 $@.s -o $@.o
	ld -m elf_i386 $@.o -o $@

mysh2: mysh2.s
	nasm -f elf32 $@.s -o $@.o
	ld --omagic -m elf_i386 $@.o -o $@

mysh_64: mysh_64.s
	nasm -f elf64 $@.s -o $@.o
	ld $@.o -o $@

clean:
	rm -f *.o *.out $(TARGET)

