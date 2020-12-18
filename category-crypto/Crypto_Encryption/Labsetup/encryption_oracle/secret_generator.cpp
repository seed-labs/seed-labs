#include <array>
#include <fstream>
#include <iostream>

#include <openssl/rand.h>

#include "evp-encrypt.hpp"
#include "utils.hpp"

using namespace std;

template <class Container>
void dump(ostream &os, const string &var_name, Container bytes)
{
    os << "static std::array<unsigned char, " << bytes.size() << "> " << var_name << " = {" << endl;
    for (auto b : bytes)
    {
        os << (unsigned)b << ",";
    }
    os << endl
       << "};" << endl;
}

int main(int argc, char const *argv[])
{
    string secret;
    if (argc < 2)
    {
        secret = "This is a top secret!";
    }
    else
    {
        secret = argv[1];
    }

    cout << "The secret is: " << secret << endl;

    // key, iv
    array<Byte, KEY_SIZE> key;
    array<Byte, BLOCK_SIZE> iv;

    RAND_bytes(&key[0], KEY_SIZE);
    RAND_bytes(&iv[0], BLOCK_SIZE);

    Bytes ctext = aes_encrypt(key.data(), iv.data(), secret);

    // write header file

    ofstream of("secret.hpp");

    of << "#pragma once" << endl
       << endl
       << "#include <array>"
       << endl;

    dump(of, "SECRET_KEY", key);
    dump(of, "SECRET_IV", iv);
    dump(of, "SECRET_CTEXT", ctext);

    of.close();

    return 0;
}
