# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(456)

set(NATIVEFENCE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVEFENCE_ROOT_PATH}
                    ${NATIVEFENCE_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp)

find_library(
    # Sets the name of the path variable.
    hilog-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    hilog_ndk.z
)

target_link_libraries(entry PUBLIC libace_napi.z.so)
target_link_libraries(entry PUBLIC ${hilog-lib})
target_link_libraries(entry PUBLIC libnative_fence.so)