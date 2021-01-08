/**
 * Modified From
 * https://wiki.openssl.org/index.php/EVP_Symmetric_Encryption_and_Decryption
 * g++ -Wall -std=c++11 evp-encrypt.cxx -o evp-encrypt.exe -lcrypto
*/

#include <array>
#include <iomanip>
#include <iostream>

#include <openssl/rand.h>

#include "evp-encrypt.hpp"
#include "utils.hpp"

//#include "secret.hpp"

using namespace std;

static std::array<unsigned char, 16> SECRET_KEY = {
    0xaa, 0xbb, 0xcc, 0xdd, 0xaa, 0xbb, 0xcc, 0xdd,
    0xaa, 0xbb, 0xcc, 0xdd, 0xaa, 0xbb, 0xcc, 0xdd
};


static std::array<unsigned char, 16> SECRET_IV = {
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
};

static std::array<unsigned char, 29> PLAIN_TEXT = {
    0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88,
    0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88,
    0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88,
    0xaa, 0xbb, 0xcc, 0xdd, 0xee
};


int main(int argc, char *argv[])
{
  Bytes ctext = aes_encrypt(SECRET_KEY.data(), SECRET_IV.data(), PLAIN_TEXT);
  cout << hexlify(SECRET_IV)  << hexlify(ctext) << endl;

  string buf;
  while (true)
  {
    cin >> buf;

    try
    {
      Bytes input = unhexlify(buf);

      // Get the ciphertext (the first BLOCK_SIZE bytes of the input are IV)
      Bytes ctext2(input.begin() + BLOCK_SIZE, input.end());

      //aes_decrypt(SECRET_KEY.data(), SECRET_IV.data(), ctext2);
      aes_decrypt(SECRET_KEY.data(), input.data(), ctext2);
      cout << "Valid" << endl;
    }
    catch (const std::bad_alloc &err)
    {
      cout << "Invalid hex string" << endl;
    }
    catch (const std::runtime_error &err)
    {
      cout << "Invalid" << endl;
    }
  }

  return 0;
}
