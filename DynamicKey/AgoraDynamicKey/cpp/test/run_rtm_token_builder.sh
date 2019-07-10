#!/bin/bash
g++ -ggdb  -std=c++0x -O0 -I../../ RtmTokenBuilder_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestRtmTokenBuilder.exe
g++ -ggdb  -std=c++0x -O0 -I../../ RtmTokenBuilder2_test.cpp  main.cpp -lcrypto -std=c++0x -lgtest -lpthread -lz -o TestRtmTokenBuilder2.exe
./TestRtmTokenBuilder.exe
./TestRtmTokenBuilder2.exe
