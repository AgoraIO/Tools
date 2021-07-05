#!/bin/bash
g++ -ggdb  -std=c++0x -O0 -I../../ DynamicKey_test.cpp DynamicKey2_test.cpp DynamicKey3_test.cpp DynamicKey4_test.cpp DynamicKey5_test.cpp AccessToken_test.cpp  main.cpp -lz -lcrypto -std=c++0x -lgtest -lpthread -o TestDynamicKey.exe
