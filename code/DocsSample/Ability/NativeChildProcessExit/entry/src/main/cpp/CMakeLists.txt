# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NativeChildProcess)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                        ${NATIVERENDER_ROOT_PATH}/include)

add_library(mainprocesssample SHARED MainProcessFile.cpp)
target_link_libraries(mainprocesssample libipc_capi.so libchild_process.so libace_napi.z.so libhilog_ndk.z.so libhilog_ndk.z.so)