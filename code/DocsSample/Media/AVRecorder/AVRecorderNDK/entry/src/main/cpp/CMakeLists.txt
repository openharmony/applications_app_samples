# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(AVRecorder)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED main.cpp camera_manager.cpp muxer.cpp video_encoder_sample.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libavrecorder.so libhilog_ndk.z.so libnative_window.so
                    libohcamera.so libnative_buffer.so libnative_media_avdemuxer.so libnative_media_avmuxer.so
                    libnative_buffer.so libnative_media_core.so libnative_media_adec.so libnative_media_avsource.so
                    libnative_media_codecbase.so libnative_media_venc.so libmedia_asset_manager.so)