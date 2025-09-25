# the minimum version of CMake.
cmake_minimum_required(VERSION 3.28.0)
project(native_type_sample)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

file(GLOB_RECURSE ENTRY_SOURCES CONFIGURE_DEPENDS
    "${NATIVERENDER_ROOT_PATH}/napi_init.cpp"
    "${NATIVERENDER_ROOT_PATH}/*.cpp"
    "${NATIVERENDER_ROOT_PATH}/common/*.cpp"
    "${NATIVERENDER_ROOT_PATH}/components/**/*.cpp"
)

add_library(entry SHARED ${ENTRY_SOURCES})

find_library(
    # Sets the name of the path variable.
    hilog-lib
    libace-lib
    libnapi-lib
    ace_napi.z
)
target_link_libraries(entry PUBLIC
    libace_ndk.z.so
    libace_napi.z.so
    libhilog_ndk.z.so
    libnative_drawing.so
    libability_base_want.so
)