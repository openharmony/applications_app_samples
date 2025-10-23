# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(NativeScsiPeripheral)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_STANDARD 17)
set(LIB_DIR ${NATIVERENDER_ROOT_PATH}/../../../libs/)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${LIB_DIR}/include)

add_library(entry SHARED hello.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libscsi.z.so libhilog_ndk.z.so -lpthread)