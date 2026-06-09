# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(AudioSuiteSample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED manual_rendering.cpp real_time_rendering.cpp audio_suite.cpp pcm_file_utils.cpp audio_format_converter.cpp space_render_rotation.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libohaudio.so libohaudiosuite.so libhilog_ndk.z.so)