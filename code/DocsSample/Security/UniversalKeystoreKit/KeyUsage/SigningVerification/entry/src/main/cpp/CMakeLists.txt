# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(SigningVerification)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED
    napi_init.cpp
    ecc_sha256_sign_verify.cpp
    rsa_sha384_pss_sign_verify.cpp
    sm2_sm3_sign_verify.cpp
    sm2_nodigest_sign_verify.cpp
    rsa_sha256_pss_sign_verify.cpp
    rsa_sha256_pkcs1_v1_5_sign_verify.cpp
    sign_verify.h)

target_link_libraries(entry PUBLIC libace_napi.z.so libhuks_ndk.z.so)
