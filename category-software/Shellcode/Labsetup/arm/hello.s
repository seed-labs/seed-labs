.section .text
.global _start

_start:
        mov    x0, 1
        adr    x1, msg
        mov    x2, 14
        mov    x8, 64   // system call write()
        svc    0

        mov    x8, 93
        svc    0        // system call exit()

.data
        msg: .ascii "Hello, World!\n"
