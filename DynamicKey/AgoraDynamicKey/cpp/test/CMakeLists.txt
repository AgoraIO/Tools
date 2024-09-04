cmake_minimum_required(VERSION 3.13)
project(test)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

include_directories(..)
include_directories(../../)

link_directories(/usr/lib)
link_libraries(-lgtest -lz -lcrypto)

add_executable(test.exe
    AccessToken_test.cpp
    AccessToken2_test.cpp
    ApaasTokenBuilder_test.cpp
    ChatTokenBuilder2_test.cpp
    DynamicKey_test.cpp
    DynamicKey2_test.cpp
    DynamicKey3_test.cpp
    DynamicKey4_test.cpp
    DynamicKey5_test.cpp
    EducationTokenBuilder2_test.cpp
    RtcTokenBuilder_test.cpp
    RtcTokenBuilder2_test.cpp
    RtmTokenBuilder_test.cpp
    RtmTokenBuilder2_test.cpp
    ../src/md5/md5.cpp
    main.cpp
)

