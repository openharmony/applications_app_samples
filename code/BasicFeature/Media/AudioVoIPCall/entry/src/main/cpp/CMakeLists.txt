cmake_minimum_required(VERSION 3.5.1)
project(AudioVoIPCall)

set(NATIVEAUDIO_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVEAUDIO_ROOT_PATH})

add_library(entry SHARED audio.cpp NapiUtils.h NapiUtils.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libohaudio.so libhilog_ndk.z.so)