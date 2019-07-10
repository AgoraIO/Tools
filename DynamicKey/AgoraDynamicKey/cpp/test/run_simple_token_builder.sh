#!/bin/bash
g++ -ggdb  -std=c++0x -O0 -I../../ SimpleTokenBuilder_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestSimpleTokenBuilder.exe
g++ -ggdb  -std=c++0x -O0 -I../../ SimpleTokenBuilder2_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestSimpleTokenBuilder2.exe
./TestSimpleTokenBuilder.exe
./TestSimpleTokenBuilder2.exe
