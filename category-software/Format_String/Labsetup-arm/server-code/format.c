#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/ip.h>

/* Changing this size will change the layout of the stack.
 * Instructors can change this value each year, so students
 * won't be able to use the solutions from the past.
 * Suggested value: between 10 and 400  */
#ifndef BUF_SIZE
#define BUF_SIZE 100
#endif


unsigned long target = 0x1122334455667788;

char *secret = "A secret message\n";

void dummy_function(char *str);

void myprintf(char *msg)
{
    unsigned long int *framep;
    // Copy the rbp value into framep, and print it out
    asm("mov %0, x29" : "=r" (framep) : : "x29");
    printf("Frame Pointer (inside myprintf):      0x%.16lx\n", (unsigned long) framep);
    printf("The target variable's value (before): 0x%.16lx\n", target);

    // This line has a format-string vulnerability
    printf(msg);

    printf("The target variable's value (after):  0x%.16lx\n", target);
}


int main(int argc, char **argv)
{
    char buf[1500];


    printf("The input buffer's address:    0x%.16lx\n", (unsigned long) buf);
    printf("The secret message's address:  0x%.16lx\n", (unsigned long) secret);
    printf("The target variable's address: 0x%.16lx\n", (unsigned long) &target);

    printf("Waiting for user input ......\n"); 
    int length = fread(buf, sizeof(char), 1500, stdin);
    printf("Received %d bytes.\n", length);

    dummy_function(buf);
    printf("(^_^)(^_^)  Returned properly (^_^)(^_^)\n");

    return 1;
}

// This function is used to insert a stack frame between main and myprintf.
// The size of the frame can be adjusted at the compilation time. 
// The function itself does not do anything.
void dummy_function(char *str)
{
    char dummy_buffer[BUF_SIZE];
    memset(dummy_buffer, 0, BUF_SIZE);

    myprintf(str);
}

