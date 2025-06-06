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

target_link_libraries(entry PUBLIC
    libace_napi.z.so
    libace_ndk.z.so
    libnative_buffer.so
    libhilog_ndk.z.so
    librawfile.z.so
    libnative_vsync.so
    ${native-drawing-lib}
    ${native-window-lib}
    ${hilog-lib}
    ${libace-lib}
    ${libnapi-lib}
    libEGL.so
    libGLESv3.so
    libnative_image.so
    libnative_window.so
    libnative_buffer.so
)