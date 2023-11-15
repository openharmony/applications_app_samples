# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(AVCastDemo)

set(NATIVERENEDR_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directions(${NATIVERENEDR_ROOT_PATH}
                   ${NATIVERENEDR_ROOT_PATH}/include)

add_library(entry SHARDE hello.cpp Session.cpp CommonUtils.cpp)
target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libhilog_ndk.z.so
)