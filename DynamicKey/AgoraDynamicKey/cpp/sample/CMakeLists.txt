cmake_minimum_required(VERSION 3.13)
project(sample)

set(CMAKE_CXX_STANDARD 11)

include_directories(..)
include_directories(../../)
#include_directories(/usr/local/include)

#link_directories(/usr/lib)
#link_directories(/usr/local/lib)
#link_libraries(-lz -lcrypto)


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

add_executable(ChatTokenBuilder2Sample.exe
        ChatTokenBuilder2Sample.cpp
        )

# openssl
find_package(openssl)
if (OPENSSL_FOUND)
  include_directories(${OPENSSL_INCLUDE_DIR})
  target_link_libraries(RtcTokenBuilderSample.exe ${OPENSSL_LIBRARIES})
  target_link_libraries(RtcTokenBuilder2Sample.exe ${OPENSSL_LIBRARIES})
  target_link_libraries(RtmTokenBuilderSample.exe ${OPENSSL_LIBRARIES})
  target_link_libraries(RtmTokenBuilder2Sample.exe ${OPENSSL_LIBRARIES})
  target_link_libraries(ChatTokenBuilder2Sample.exe ${OPENSSL_LIBRARIES})
else (OPENSSL_FOUND)
  message(SEND_ERROR "Could not find dependency: openssl")
endif (OPENSSL_FOUND)

# zlib
find_package(zlib)

if (ZLIB_FOUND)
  include_directories(${ZLIB_INCLUDE_DIR})
  target_link_libraries(RtcTokenBuilderSample.exe ${ZLIB_LIBRARIES})
  target_link_libraries(RtcTokenBuilder2Sample.exe ${ZLIB_LIBRARIES})
  target_link_libraries(RtmTokenBuilderSample.exe ${ZLIB_LIBRARIES})
  target_link_libraries(RtmTokenBuilder2Sample.exe ${ZLIB_LIBRARIES})
  target_link_libraries(ChatTokenBuilder2Sample.exe ${ZLIB_LIBRARIES})
else (ZLIB_FOUND)
  message(SEND_ERROR "Could not find dependency: zlib")
endif (ZLIB_FOUND)
