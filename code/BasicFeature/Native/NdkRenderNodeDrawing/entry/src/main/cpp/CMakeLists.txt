# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(drawing_test)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED
    native_bridge.cpp
)
find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)
target_link_libraries(entry PUBLIC ${hilog-lib})
target_link_libraries(entry PUBLIC libace_napi.z.so)
target_link_libraries(entry PUBLIC libnative_drawing.so)
target_link_libraries(entry PUBLIC libpixelmap_ndk.z.so libimage_source_ndk.z.so librawfile.z.so)