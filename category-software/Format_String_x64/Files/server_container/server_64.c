#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/ip.h>

#define PORT 9090

/* Changing this size will change the layout of the stack.
 * We have added 2 dummy arrays: in main() and myprintf().
 * Instructors can change this value each year, so students 
 * won't be able to use the solutions from the past.   
 * Suggested value: between 0 and 300  */
#ifndef DUMMY_SIZE
#define DUMMY_SIZE 100
#endif

char *secret = "A secret message\n";
unsigned long  target = 0x1122334455667788;

void myprintf(char *msg)
{
    unsigned long int *framep;

    // Copy the rbp value into framep, and print it out
    asm("movq %%rbp, %0" : "=r" (framep));
    printf("Frame Pointer (rbp) inside myprintf():      0x%.16lx\n", (unsigned long) framep);

    /* Change the size of the dummy array to randomize the parameters 
       for this lab. Need to use the array at least once */
    char dummy[DUMMY_SIZE];  memset(dummy, 0, DUMMY_SIZE); 

    // This line has a format-string vulnerability
    printf("The target variable (value, before printf): 0x%.16lx\n", target);
    printf(msg);
    printf("The target variable (value, after printf):  0x%.16lx\n", target);
}


void main()
{
    struct sockaddr_in server;
    struct sockaddr_in client;
    int clientLen;
    char buf[1500];

    /* Change the size of the dummy array to randomize the parameters 
       for this lab. Need to use the array at least once */
    char dummy[DUMMY_SIZE];  memset(dummy, 0, DUMMY_SIZE); 

    /* Print out some internal data to simplify lab tasks */
    printf("Input buffer (address):        0x%.16lx\n", (unsigned long) buf);
    printf("The secret variable (address): 0x%.16lx\n", (unsigned long) secret);
    printf("The target variable (address): 0x%.16lx\n", (unsigned long) &target);
    myprintf("");

    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    memset((char *) &server, 0, sizeof(server));
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    server.sin_port = htons(PORT);

    if (bind(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
        perror("ERROR on binding");

    while (1) {
        bzero(buf, 1500);
        recvfrom(sock, buf, 1500-1, 0,
                 (struct sockaddr *) &client, &clientLen);
        myprintf(buf);
    }
    close(sock);
}
