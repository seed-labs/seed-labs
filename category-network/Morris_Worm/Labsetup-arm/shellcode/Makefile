
all:
	gcc -z execstack -o a.out call_shellcode.c
	as shellcode_arm.s -o shellcode_arm.o
	ld --omagic shellcode_arm.o -o shellcode_arm

clean:
	rm -f *.out *.o codefile_arm shellcode_arm

