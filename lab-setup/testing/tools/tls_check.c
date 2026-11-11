#include <openssl/ssl.h>
#include <stdio.h>

int main(void)
{
    SSL_CTX *context = SSL_CTX_new(TLS_method());
    if (!context) return 1;
    SSL_CTX_free(context);
    puts("TLS context available");
    return 0;
}
