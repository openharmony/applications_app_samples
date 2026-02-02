# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(CameraSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED main.cpp camera_manager.cpp)
target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libhilog_ndk.z.so
    libohcamera.so
    libimage_source.so
    libmedia_asset_manager.so
    libimage_packer.so
    librawfile.z.so
    libpixelmap.so
    libnative_buffer.so
    libnative_display_manager.so
)
