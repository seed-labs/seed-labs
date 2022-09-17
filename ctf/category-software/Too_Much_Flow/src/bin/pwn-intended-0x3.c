#include <stdio.h>
#include <stdlib.h>

int main() {
    char teleport[30];

    setbuf(stdout, NULL);
    setbuf(stdin, NULL);
    setbuf(stderr, NULL);

    puts("Put your code in below. Have you tried checking StackOverflow?");
    gets(teleport);
}

int flag() {
    puts("Well, that was quick. Here's your flag:");
    system("cat flag.txt");
    exit(0);
}
