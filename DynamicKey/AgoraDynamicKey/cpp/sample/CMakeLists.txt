cmake_minimum_required(VERSION 3.13)
project(sample)

set(CMAKE_CXX_STANDARD 11)

include_directories(..)
include_directories(../../)
include_directories(/usr/local/include)

link_directories(/usr/lib)
link_directories(/usr/local/lib)

link_libraries(-lz -lcrypto)

add_executable(RtcTokenBuilderSample.exe
        RtcTokenBuilderSample.cpp
        )

add_executable(RtcTokenBuilder2Sample.exe
        RtcTokenBuilder2Sample.cpp
        )

add_executable(RtmTokenBuilderSample.exe
        RtmTokenBuilderSample.cpp
        )

add_executable(RtmTokenBuilder2Sample.exe
        RtmTokenBuilder2Sample.cpp
        )