# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(schemehandler)


set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})


if(DEFINED PACKAGE_INFO_FILE)
    include(${PACKAGE_INFO_FILE})
endif()


include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)


add_library(entry SHARED rawfile_request.cpp hello.cpp)
target_link_libraries(entry PUBLIC librawfile.z.so libace_napi.z.so libohweb.so libhilog_ndk.z.so)