# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(EncryptionDecryptionGuidanceSm2)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp types/project/sm2/CreateASN1Ciphertext.cpp types/project/sm2/ObtainCiphertext.cpp types/project/sm2/SM2EncryptionDecryption.cpp types/project/rsa/PKCS1_RSA.cpp types/project/rsa/RSAEncryptDecrypt.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libohcrypto.so)