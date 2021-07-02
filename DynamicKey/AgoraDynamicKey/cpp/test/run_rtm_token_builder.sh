#!/bin/bash
rm TestRtmTokenBuilder.exe
g++ -ggdb  -std=c++0x -O0 -I../../ RtmTokenBuilder_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestRtmTokenBuilder.exe
./TestRtmTokenBuilder.exe
