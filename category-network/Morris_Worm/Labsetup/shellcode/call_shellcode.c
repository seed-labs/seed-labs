#include <stdlib.h>
#include <stdio.h>

// Read the shellcode from a file, and then execute the code. 
int main(int argc, char **argv)
{
    char code[500];
    FILE *fd;
#if __x86_64__
    const char *filename = "codefile_64";
#else 
    const char *filename = "codefile_32";
#endif

    fd = fopen(filename, "r");
    if (!fd){
       perror(filename); exit(1);
    }
    fread(code, sizeof(char), 500, fd);

    int (*func)() = (int(*)())code;
    func();
    return 1;
}

