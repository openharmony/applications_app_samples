# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(ImageEffect)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${NATIVERENDER_ROOT_PATH}/backend
                    ${NATIVERENDER_ROOT_PATH}/utils
)

add_library(entry SHARED
    napi_init.cpp
    utils/common_utils.cpp
    utils/pixelmap_helper.cpp
    backend/image_edit.cpp
)
target_link_libraries(entry PUBLIC
     libace_napi.z.so
     libhilog_ndk.z.so
     libpixelmap.so
     libimage_effect.so
     libpixelmap_ndk.z.so
     libimage_packer.so
     libimage_source.so
)