# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(nativeDemo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/player
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED oh_audio_playing_ndk.cpp player/oh_audio_playing.cpp player/audio_buffer_queue.h player/audio_buffer_queue.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libhilog_ndk.z.so libohaudio.so libuv.so)