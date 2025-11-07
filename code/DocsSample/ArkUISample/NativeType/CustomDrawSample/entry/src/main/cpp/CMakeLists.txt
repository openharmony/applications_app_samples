# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(CustomDrawSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED NapiInit.cpp NativeEntry.cpp ArkUICustomContainerNode.h UITimer.h ArkUICustomNode.h)

# 添加以下查找库的指令
find_library(
    hilog-lib
    hilog_ndk.z
)
find_library(
    libuv-lib
    uv  # 或者 libuv.so，取决于你的NDK中libuv的命名
)
# 修改target_link_libraries，添加缺失的库
target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libace_ndk.z.so
    libnative_drawing.so
    ${hilog-lib}  # 提供OH_LOG_Print
    ${libuv-lib}  # 提供uv_run和uv_loop_delete
)