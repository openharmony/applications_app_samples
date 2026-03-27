# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NativeTest)

set(CMAKE_OBJECT_PATH_MAX 4096)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp project/native_test.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libohcrypto.so libhilog_ndk.z.so)
