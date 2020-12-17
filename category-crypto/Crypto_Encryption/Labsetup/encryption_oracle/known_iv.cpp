#include <array>
#include <iostream>

#include <openssl/rand.h>

#include "evp-encrypt.hpp"
#include "utils.hpp"

using namespace std;

int main(int argc, char const *argv[])
{
    // key, iv1, iv2
    array<Byte, KEY_SIZE> key;
    array<Byte, BLOCK_SIZE> iv1, iv2;

    RAND_bytes(&key[0], KEY_SIZE);
    RAND_bytes(&iv1[0], BLOCK_SIZE);
    RAND_bytes(&iv2[0], BLOCK_SIZE);

    // encrypt plaintext1 with iv1
    Bytes ptext1 = {'Y', 'e', 's'};
    Bytes ctext1 = aes_encrypt(key.data(), iv1.data(), ptext1);

    // print essential information
    cout << "ciphertext 1: " << hexlify(ctext1) << endl;
    cout << "iv 1        : " << hexlify(iv1) << endl;
    cout << "iv 2        : " << hexlify(iv2) << endl;

    string buf;
    while (true)
    {
        cout << endl
             << "plaintext 2 : ";
        cin >> buf;

        Bytes ptext2 = unhexlify(buf);
        Bytes ctext2 = aes_encrypt(key.data(), iv2.data(), ptext2);

        cout << "ciphertext 2: " << hexlify(ctext2) << endl;
    }

    return 0;
}
