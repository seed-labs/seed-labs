#include <stdio.h>
#include <unistd.h>

/* Check an environment capability without invoking any vulnerable lab program. */
int main(void)
{
    printf("%ld %ld\n", (long)getuid(), (long)geteuid());
    return 0;
}
