/* Vunlerable program: stack.c */
/* You can get this program from the lab's website */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Changing this size will change the layout of the stack.
 * Instructors can change this value each year, so students
 * won't be able to use the solutions from the past.
 * Suggested value: between 100 and 400  */
#ifndef BUF_SIZE
#define BUF_SIZE 200
#endif

void printBuffer(char * buffer, int size);
void foo(char *str, int length);

int bof(char *str, int length)
{
    char buffer[BUF_SIZE];

#if __aarch64__
    unsigned long int *framep;
    // Copy the rbp value into framep, and print it out
    asm("mov %0, x29" : "=r" (framep) : : "x29");
#if SHOW_FP
    printf("Frame pointer (x29) inside bof():  0x%.16lx\n", (unsigned long)framep);
#endif
    printf("Buffer's address inside bof():     0x%.16lx\n", (unsigned long) &buffer);
#endif

    // The following statement has a buffer overflow problem 
#if STRCPY    
    strcpy(buffer, str);       
#else 
    memcpy(buffer, str, length);       
#endif

    return 1;
}

int main(int argc, char **argv)
{
    char str[517];

    int length = fread(str, sizeof(char), 517, stdin);
    printf("Input size: %d\n", length);
    foo(str, length);
    fprintf(stdout, "==== Returned Properly ====\n");
    return 1;
}

// This function is used to insert a stack frame of size 
// 1000 (approximately) between main's and bof's stack frames. 
// The function itself does not do anything. 
void foo(char *str, int length)
{
#if __aarch64__
    unsigned long int *framep;
    // Copy the x29 value into framep
    asm("mov %0, x29" : "=r" (framep) : : "x29");
#if SHOW_FP
    printf("Frame pointer (x29) inside foo():  0x%.16lx\n", (unsigned long)framep);
#endif
#endif

    char dummy_buffer[1000];
    memset(dummy_buffer, 0, 1000);
    bof(str, length);
}

void printBuffer(char * buffer, int size)
{
   int i;
   for  (i=0; i<size; i++){

     if (i % 20 == 0) printf("\n%.3d: ", i);
     printf("%.2x ", (unsigned char) buffer[i]);
   }
}
