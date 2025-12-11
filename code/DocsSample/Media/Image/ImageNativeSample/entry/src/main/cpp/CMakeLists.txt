# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ImageNativeModuleSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)
add_library(entry SHARED
    napi_init.cpp
    loadPicture.cpp
    loadAllocator.cpp
    loadImageSource.cpp
    loadReceiver.cpp
    )
target_link_libraries(
    entry PUBLIC
    libace_napi.z.so
    libhilog_ndk.z.so
    libimage_source.so
    libpixelmap.so
    libimage_packer.so
    libohimage.so
    libpicture.so
    libimage_common.so
    libimage_receiver_ndk.z.so
    libimage_receiver.so
    libnative_buffer.so
    libohcamera.so
    libohfileuri.so)