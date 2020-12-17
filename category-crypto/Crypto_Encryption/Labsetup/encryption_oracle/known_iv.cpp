#include <array>
#include <cstdlib>
#include <iostream>

#include <openssl/rand.h>

#include "evp-encrypt.hpp"
#include "utils.hpp"

using namespace std;

int main(int argc, char const *argv[])
{
    // key, iv1, iv2
    array<Byte, KEY_SIZE> key;
    array<Byte, BLOCK_SIZE> iv;

    RAND_bytes(&key[0], KEY_SIZE);
    RAND_bytes(&iv[0], BLOCK_SIZE);

    // encrypt plaintext1 with iv1
    Bytes ptext1 = {'Y', 'e', 's'};
    Bytes ctext1 = aes_encrypt(key.data(), iv.data(), ptext1);

    // print essential information
    cout << "iv1   : " << hexlify(iv) << endl;
    cout << "ctext1: " << hexlify(ctext1) << endl;

    srand(*reinterpret_cast<unsigned *>(&iv[8]));
    string buf;
    while (true)
    {
        (*reinterpret_cast<uint64_t *>(&iv[0])) += rand();

        cout << endl
             << "iv    : " << hexlify(iv) << endl
             << "ptext : ";
        cin >> buf;

        try
        {
            Bytes ptext2 = unhexlify(buf);
            Bytes ctext2 = aes_encrypt(key.data(), iv.data(), ptext2);

            cout << "ctext : " << hexlify(ctext2) << endl;
        }
        catch (const std::bad_alloc &err)
        {
            cout << "Invalid hex string" << endl;
        }
    }

    return 0;
}
