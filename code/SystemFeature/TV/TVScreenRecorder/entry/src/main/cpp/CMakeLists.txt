# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(applicationsscreen-recordertv)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp)
set(HILOG_LIBRARY_NAME libhilog_n)
string(APPEND HILOG_LIBRARY_NAME dk.z.so)

target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libnative_avscreen_capture.so
    ${HILOG_LIBRARY_NAME}
    libuv.so)
