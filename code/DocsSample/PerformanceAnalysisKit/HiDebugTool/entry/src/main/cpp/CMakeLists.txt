# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(CPP2)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# 新增动态库依赖libohhidebug.so和libhilog_ndk.z.so（日志输出）
add_library(entry SHARED napi_init.cpp test_backtrace.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libhilog_ndk.z.so libohhidebug.so)