# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(nativeThreadsCallJS)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(
    ${NATIVERENDER_ROOT_PATH}
    ${NATIVERENDER_ROOT_PATH}/include
)

find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)

add_library(entry SHARED hello.cpp)
target_link_libraries(entry PUBLIC ${hilog-lib} libuv.so libace_napi.z.so libc++.a)