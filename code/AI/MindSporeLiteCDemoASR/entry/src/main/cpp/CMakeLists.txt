# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(test)
set(CMAKE_CXX_STANDARD 17) # AudioFile.h
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# libsamplerate
set(LIBSAMPLERATE_DIR ${NATIVERENDER_ROOT_PATH}/third_party/libsamplerate)
include_directories(${LIBSAMPLERATE_DIR}/include)
add_subdirectory(${LIBSAMPLERATE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}/third_party/opencc/include/opencc)
# src
aux_source_directory(src SRC_DIR)
include_directories(${NATIVERENDER_ROOT_PATH}/src)

include_directories(${CMAKE_SOURCE_DIR}/third_party)

file(GLOB SRC src/*.cc)


add_library(entry SHARED mslite_napi.cpp ${SRC})
target_link_libraries(entry PUBLIC samplerate)
target_link_libraries(entry PUBLIC mindspore_lite_ndk)
target_link_libraries(entry PUBLIC hilog_ndk.z)
target_link_libraries(entry PUBLIC rawfile.z)
target_link_libraries(entry PUBLIC ace_napi.z)