cmake_minimum_required(VERSION 3.13)
project(sample)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

include_directories(..)
include_directories(../../)

link_directories(/usr/lib)
link_libraries(-lz -lcrypto)

add_executable(ChatTokenBuilder2Sample.exe ChatTokenBuilder2Sample.cpp)
add_executable(FpaTokenBuilderSample.exe FpaTokenBuilderSample.cpp)
add_executable(RtcTokenBuilder2Sample.exe RtcTokenBuilder2Sample.cpp)
add_executable(RtcTokenBuilderSample.exe RtcTokenBuilderSample.cpp)
add_executable(RtmTokenBuilderSample.exe RtmTokenBuilderSample.cpp)
add_executable(RtmTokenBuilder2Sample.exe RtmTokenBuilder2Sample.cpp)
