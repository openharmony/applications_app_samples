# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(MindSporeLiteCDemo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED mslite_napi.cpp)
target_link_libraries(entry PUBLIC mindspore_lite_ndk)
target_link_libraries(entry PUBLIC hilog_ndk.z)
target_link_libraries(entry PUBLIC rawfile.z)
target_link_libraries(entry PUBLIC ace_napi.z)