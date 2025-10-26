# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ndk_scope_task)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp)

find_library(
    # Sets the name of the path variable.
    hilog-lib
    libace-lib
    libnapi-lib
    ace_napi.z
    EGL-lib
    EGL
    GLES-lib
    GLESv3
)

target_link_libraries(entry PUBLIC
    libace_ndk.z.so
    libace_napi.z.so
    libhilog_ndk.z.so
    libnative_drawing.so
    libability_base_want.so
)

target_link_libraries(entry PUBLIC libace_napi.z.so)