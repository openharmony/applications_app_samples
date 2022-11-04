# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(XComponent)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
add_definitions(-DOHOS_PLATFORM)
include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/common
                    ${NATIVERENDER_ROOT_PATH}/napi
                    ${NATIVERENDER_ROOT_PATH}/render
                    )

add_library(nativerender SHARED
            render/egl_core.cpp
            render/plugin_render.cpp
            plugin_manager.cpp
            napi/napi_init.cpp
            )

target_link_libraries(nativerender PUBLIC -lEGL -lGLESv3 -lhilog_ndk.z -lace_ndk.z -lace_napi.z -luv libc++.a)