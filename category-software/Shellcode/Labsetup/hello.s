global _start

section .text

_start:
  mov rdi, 1        ; the standard output
  mov rsi, msg      ; address of the message
  mov rdx, 14       ; length of the message
  mov rax, 1        ; the number of the write() system call
  syscall           ; invoke write(1, msg, 14)

  mov rdi, 0        ; 
  mov rax, 60       ; the number for the exit() system call
  syscall           ; invoke exit(0)

section .rodata
  msg: db "Hello, world!", 10
