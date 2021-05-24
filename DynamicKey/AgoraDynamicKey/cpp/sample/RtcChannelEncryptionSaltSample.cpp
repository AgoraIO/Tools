#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/rand.h>
#include "../src/utils.h"
#define GET_ARRAY_LEN(array,len) {len = (sizeof(array) / sizeof(array[0]));}

using namespace std;
int main(int argc, char* argv[])
{
    // generate 32 bytes randrom char
    unsigned char salt[32] = { 0 };
    int re = RAND_bytes(buf, sizeof(salt));
    /*
    unsigned char *p = buf;
    int len;
    GET_ARRAY_LEN(buf, len);
    for (int i = 0; i < len; i++)
    {
        cout << (int)*(buf + i) << " ";
    }
    cout << endl;
    */

    //encode with base64
    char* saltBase64 = agora::tools::base64_encode(buf, 32);
    std::cout << saltBase64 << std::endl;

    //decode with base64
    int length = 0;
    const unsigned char* d = agora::tools::base64_decode(r, strlen(r), &length);
    /*
    for (int i = 0; i < 32; i++)
    {
        cout << (int)*(d + i) << " ";
    }
    */
}