# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(EncryptionDecryption)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp types/projects/napi_aescbcpkcs7.cpp types/projects/napi_aesgcmnopadding.cpp
types/projects/napi_descbcnopadding.cpp types/projects/napi_rsaecboaepsha256.cpp
types/projects/napi_rsaecbpkcs1_v1_5.cpp
types/projects/napi_sm2.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libhuks_ndk.z.so libohcrypto.so libhilog_ndk.z.so)