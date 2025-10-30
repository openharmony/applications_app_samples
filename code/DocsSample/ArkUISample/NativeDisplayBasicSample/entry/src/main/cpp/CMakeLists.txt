# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NativeDisplayBasicSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(nativedisplay SHARED napi_init.cpp)
target_link_libraries(nativedisplay PUBLIC libace_napi.z.so)
# [Start add_display_target_link]
target_link_libraries(nativedisplay PUBLIC libhilog_ndk.z.so)
target_link_libraries(nativedisplay PUBLIC libnative_display_manager.so )
# [End add_display_target_link]