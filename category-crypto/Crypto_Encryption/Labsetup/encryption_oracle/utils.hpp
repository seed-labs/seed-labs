#pragma once

#include <iomanip>
#include <sstream>
#include <string>
#include <vector>

#include <openssl/crypto.h>

template <class T>
std::string hexlify(const T &buf)
{
    std::stringstream hexstr;
    hexstr << std::hex << std::setfill('0');

    for (auto b : buf)
    {
        hexstr << std::setw(2) << (unsigned)b;
    }

    return hexstr.str();
}

std::vector<unsigned char> unhexlify(const std::string &hexstr)
{
    long sz;
    unsigned char *buf_ptr = OPENSSL_hexstr2buf(hexstr.c_str(), &sz);

    std::vector<unsigned char> buf(buf_ptr, buf_ptr + sz);
    OPENSSL_free(buf_ptr);

    return buf;
}
