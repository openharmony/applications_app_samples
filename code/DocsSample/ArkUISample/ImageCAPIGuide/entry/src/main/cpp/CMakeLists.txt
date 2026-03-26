cmake_minimum_required(VERSION 3.5.0)
project(ImageExample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

# 【关键修复】指定头文件目录
include_directories(${NATIVERENDER_ROOT_PATH}/include)

# 编译源文件
add_library(entry SHARED
    napi_init.cpp
    NativeEntry.cpp
    ImageExample.cpp
)

# 链接API 20 系统库
target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libace_ndk.z.so
    libhilog_ndk.z.so
)