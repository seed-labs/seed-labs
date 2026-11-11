#include <pcap/pcap.h>
#include <stdio.h>

int main(void)
{
    puts(pcap_lib_version());
    return 0;
}
