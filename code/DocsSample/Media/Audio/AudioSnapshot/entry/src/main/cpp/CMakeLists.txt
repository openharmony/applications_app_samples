cmake_minimum_required(VERSION 3.5.1)
project(AudioSnapshot)

set(NATIVEAUDIO_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVEAUDIO_ROOT_PATH})

add_library(entry SHARED audio.cpp NapiUtils.h NapiUtils.cpp)
if (CMAKE_CXX_COMPILER_ID MATCHES "[Cc]lang")
    target_compile_options(entry PRIVATE -Wno-unused-command-line-argument)
endif()
target_link_libraries(entry PUBLIC libace_napi.z.so libohaudio.so libhilog_ndk.z.so)
