#include <stdio.h>
#include <unistd.h>

#ifndef BUF_SIZE
#define BUF_SIZE 1000
#endif

int main(int argc, char* argv[])
{
   char buf[BUF_SIZE];
   if (read(STDIN_FILENO, buf, BUF_SIZE) > 0)
   {
      printf(buf);
   }
   return 0;
}
