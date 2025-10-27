# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(vulkanSample)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
add_definitions(-DOHOS_PLATFORM)

ADD_DEFINITIONS(-DVK_USE_PLATFORM_OHOS=1)
ADD_DEFINITIONS(-DVK_NO_PROTOTYPES=1)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/player/include
                    ${NATIVERENDER_ROOT_PATH}/capbilities/include
                    ${NATIVERENDER_ROOT_PATH}/render/include
                    ${NATIVERENDER_ROOT_PATH}/utils/include
)

set(BASE_LIBRARY
    libace_napi.z.so libEGL.so libGLESv3.so libGLESv2.so libace_ndk.z.so libuv.so libhilog_ndk.z.so
    libnative_media_codecbase.so libnative_media_core.so libnative_media_vdec.so libnative_window.so
    libnative_media_venc.so libnative_media_acodec.so libnative_media_avdemuxer.so libnative_media_avsource.so
    libnative_media_avmuxer.so libohaudio.so libnative_vsync.so  libnative_image.so libnative_buffer.so
)

add_library(player SHARED
    main.cpp
    player/src/Player.cpp
    capbilities/src/Demuxer.cpp
    capbilities/src/VideoDecoder.cpp
    capbilities/src/SampleCallback.cpp
    render/src/PluginManager.cpp
    render/src/PluginRender.cpp
    render/src/VulkanRenderThread.cpp
    render/src/VulkanRender.cpp
    utils/src/VulkanUtils.cpp
)

target_link_libraries(player PUBLIC ${BASE_LIBRARY})