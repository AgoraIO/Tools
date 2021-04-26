#!/bin/bash

GTEST_CFLAGS=$(pkg-config --cflags gtest_main)
GTEST_LIBS=$(pkg-config --libs gtest_main)
OPENSSL_CFLAGS=$(pkg-config --cflags openssl)
OPENSSL_LIBS=$(pkg-config --libs openssl)
ZLIB_CFLAGS=$(pkg-config --cflags zlib)
ZLIB_LIBS=$(pkg-config --libs zlib)

g++ -ggdb -std=c++0x -O0 -I../../ \
    DynamicKey_test.cpp \
    DynamicKey2_test.cpp \
    DynamicKey3_test.cpp \
    DynamicKey4_test.cpp \
    DynamicKey5_test.cpp \
    AccessToken_test.cpp \
    AccessToken2_test.cpp \
    RtcTokenBuilder_test.cpp \
    RtcTokenBuilder2_test.cpp \
    RtmTokenBuilder_test.cpp \
    RtmTokenBuilder2_test.cpp \
    ChatTokenBuilder2_test.cpp \
    main.cpp \
    ${GTEST_CFLAGS} \
    ${GTEST_LIBS} \
    ${OPENSSL_CFLAGS} \
    ${OPENSSL_LIBS} \
    ${ZLIB_LIBS} \
    ${ZLIB_CFLAGS} \
    -o TestDynamicKey.exe
