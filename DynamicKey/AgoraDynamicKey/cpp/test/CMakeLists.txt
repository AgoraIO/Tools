cmake_minimum_required(VERSION 3.13)
project(test)

set(CMAKE_CXX_STANDARD 11)

include_directories(..)
include_directories(../../)
include_directories(/usr/local/include)

link_directories(/usr/lib)
link_directories(/usr/local/lib)

link_libraries(-lgtest -lz -lcrypto)

add_executable(test.exe
        AccessToken2_test.cpp
        AccessToken_test.cpp
        DynamicKey2_test.cpp
        DynamicKey3_test.cpp
        DynamicKey4_test.cpp
        DynamicKey5_test.cpp
        DynamicKey_test.cpp
        RtmTokenBuilder_test.cpp
        RtmTokenBuilder2_test.cpp
        RtcTokenBuilder_test.cpp
        RtcTokenBuilder2_test.cpp
        main.cpp
        )
