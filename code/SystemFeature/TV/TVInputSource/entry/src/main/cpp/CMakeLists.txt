cmake_minimum_required(VERSION 3.4.1)
project(XComponent)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
add_definitions(-DOHOS_PLATFORM)

add_compile_options(-D_FORTIFY_SOURCE=2 -O2)
add_compile_options(-ftrapv)
add_compile_options(-s)

include_directories(
    ${NATIVERENDER_ROOT_PATH},
    ${NATIVERENDER_ROOT_PATH}/include
)

add_library(nativerender SHARED
    render/egl_core.cpp
    render/plugin_render.cpp
    manager/plugin_manager.cpp
    napi_init.cpp
)

find_library(
    EGL-lib
    EGL
)

find_library(
    GLES-lib
    GLESv3
)

find_library(
    hilog-lib
    hilog_ndk.z
)


find_library(
    libnapi-lib
    ace_napi.z
)

target_link_libraries(nativerender PUBLIC
    ${EGL-lib} ${GLES-lib} ${hilog-lib} ${libace-lib} libnative_window.so libace_napi.z.so)