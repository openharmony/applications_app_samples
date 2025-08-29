# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NativeNodeSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp manager.cpp)

#add_subdirectory(nativeNodeDemo1)

find_library(
    libace-lib
    ace_ndk.z
)

target_link_libraries(entry PUBLIC ${libace-lib} libace_napi.z.so libnative_drawing.so libhilog_ndk.z.so)