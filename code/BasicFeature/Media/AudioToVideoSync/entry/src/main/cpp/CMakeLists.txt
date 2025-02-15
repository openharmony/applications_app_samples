# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(AudioToVideoSync)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/capbilities/include
                    ${NATIVERENDER_ROOT_PATH}/common
                    ${NATIVERENDER_ROOT_PATH}/common/dfx/err
                    ${NATIVERENDER_ROOT_PATH}/common/dfx/log
                    ${NATIVERENDER_ROOT_PATH}/render/include
                    ${NATIVERENDER_ROOT_PATH}/player
)

set(BASE_LIBRARY
    libace_napi.z.so libEGL.so libGLESv3.so libace_ndk.z.so libuv.so libhilog_ndk.z.so
    libnative_media_codecbase.so libnative_media_core.so libnative_media_vdec.so libnative_window.so
    libnative_media_acodec.so libnative_media_avdemuxer.so libnative_media_avsource.so libohaudio.so
)
add_library(player SHARED player/PlayerNative.cpp
                          player/Player.cpp
                          capbilities/Demuxer.cpp
                          capbilities/VideoDecoder.cpp
                          capbilities/AudioDecoder.cpp
                          render/EglCore.cpp
                          render/PluginRender.cpp
                          render/PluginManager.cpp
                          common/SampleCallback.cpp
)

target_link_libraries(player PUBLIC ${BASE_LIBRARY})