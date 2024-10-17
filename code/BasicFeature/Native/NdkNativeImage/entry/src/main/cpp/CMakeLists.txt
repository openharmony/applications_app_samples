# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NdkNativeImage)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp
    render/image_render.cpp
    render/native_render.cpp
    render/render_engine.cpp
)

find_library(
    # Sets the name of the path variable.
    native-drawing-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    native_drawing
)

find_library(
    # Sets the name of the path variable.
    native-window-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    native_window
)

find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)

find_library(
    # Sets the name of the path variable.
    libace-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    ace_ndk.z
)

find_library(
    # Sets the name of the path variable.
    libnapi-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    ace_napi.z
)

target_link_libraries(entry PUBLIC libohcamera.so libace_napi.z.so libnative_buffer.so libhilog_ndk.z.so librawfile.z.so libnative_vsync.so
${native-drawing-lib} ${native-window-lib} ${hilog-lib} ${libace-lib} ${libnapi-lib} libEGL.so
                                                                                     libGLESv3.so
                                                                                     libnative_image.so
                                                                                     libnative_window.so
                                                                                     libnative_buffer.so)