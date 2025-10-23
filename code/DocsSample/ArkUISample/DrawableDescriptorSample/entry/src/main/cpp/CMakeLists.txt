# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(DrawableDescriptorSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

find_library(
    libace-lib
    ace_ndk.z
)

# 查找系统库
find_library(ace_ndk_lib ace_ndk.z.so image_lib image.z.so)

add_library(entry SHARED napi_init.cpp drawable_manager.cpp)
target_link_libraries(entry PUBLIC
    ${libace-lib}
    libace_napi.z.so
    libpixelmap_ndk.z.so
    libhilog_ndk.z.so
    libimage_source.so
    libpixelmap.so
    libohresmgr.so
    librawfile.z.so
)