# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NodeApiLoadModuleWithInfo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so)

add_library(entryone SHARED har_name.cpp)
target_link_libraries(entryone PUBLIC libace_napi.z.so)

add_library(entrytwo SHARED remote_har.cpp)
target_link_libraries(entrytwo PUBLIC libace_napi.z.so)

add_library(entrythree SHARED api.cpp)
target_link_libraries(entrythree PUBLIC libace_napi.z.so)

add_library(entryfour SHARED file.cpp)
target_link_libraries(entryfour PUBLIC libace_napi.z.so)