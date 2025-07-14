# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NodeApiLoadModule)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so)

add_library(entry1 SHARED etsDirFile.cpp)
target_link_libraries(entry1 PUBLIC libace_napi.z.so)

add_library(entry2 SHARED library.cpp)
target_link_libraries(entry2 PUBLIC libace_napi.z.so)

add_library(entry3 SHARED sharedlibrary.cpp)
target_link_libraries(entry3 PUBLIC libace_napi.z.so)

add_library(entry4 SHARED far_har.cpp)
target_link_libraries(entry4 PUBLIC libace_napi.z.so)

add_library(entry6 SHARED ohpm.cpp)
target_link_libraries(entry6 PUBLIC libace_napi.z.so)

add_library(entry7 SHARED native.cpp)
target_link_libraries(entry7 PUBLIC libace_napi.z.so)

add_library(entry8 SHARED moduleFile.cpp)
target_link_libraries(entry8 PUBLIC libace_napi.z.so)