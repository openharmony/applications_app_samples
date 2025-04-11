# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NDKGraphicDraw)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    )

add_library(entry SHARED
    napi_init.cpp
    samples/sample_graphics.cpp
    plugin/plugin_manager.cpp
    utils/adaptation_util.cpp
    )
target_link_libraries(entry PUBLIC
                      EGL
                      GLESv3
                      libhilog_ndk.z.so
                      libace_napi.z.so
                      libnative_drawing.so
                      libnative_window.so
                      libace_ndk.z.so
                      libnative_display_soloist.so
                      libpixelmap.so
                      libnative_display_manager.so
                      )