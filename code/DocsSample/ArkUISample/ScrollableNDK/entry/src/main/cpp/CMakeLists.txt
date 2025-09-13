# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ScrollableNDK)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED
    napi_init.cpp
    components/grid/examples/ScrollableGrid.cpp
    components/waterflow/examples/WaterFlowInfiniteScrollingEarly.cpp
)

find_library(
    # Sets the name of the path variable.
    libnapi-lib
    # Specifies the name of the NDK library that
    # you want CMake to locate.
    ace_napi.z
)
target_link_libraries(entry PUBLIC
    libace_ndk.z.so
    libace_napi.z.so
    libhilog_ndk.z.so
    libnative_drawing.so
)