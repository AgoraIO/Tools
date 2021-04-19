#!/bin/bash
rm TestRtcTokenBuilder.exe
g++ -ggdb  -std=c++0x -O0 -I../../ RtcTokenBuilder_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestRtcTokenBuilder.exe -m64
./TestRtcTokenBuilder.exe
