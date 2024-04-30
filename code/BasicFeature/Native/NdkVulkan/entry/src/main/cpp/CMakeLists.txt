# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(VulkanDemo)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

ADD_DEFINITIONS(-DVK_USE_PLATFORM_OHOS=1)
ADD_DEFINITIONS(-DVK_NO_PROTOTYPES=1)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/common
                    ${NATIVERENDER_ROOT_PATH}/render
                    ${NATIVERENDER_ROOT_PATH}/render/vulkan
                    ${NATIVERENDER_ROOT_PATH}/render/vulkan/shader
                    ${NATIVERENDER_ROOT_PATH}/include)

find_library( # Sets the name of the path variable.
              hilog-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              hilog_ndk.z )

find_library( # Sets the name of the path variable.
              libuv-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              uv )

find_library( # Sets the name of the path variable.
            libnapi-lib
            # Specifies the name of the NDK library that
            # you want CMake to locate.
            ace_napi.z )

find_library( # Sets the name of the path variable.
              libace-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              ace_ndk.z )

find_library(
             libnative_window-lib
             native_window )

add_library(nativerender SHARED
            render/plugin_manager.cpp
            render/plugin_render.cpp
            render/vulkan/vulkan_example.cpp
            render/vulkan/vulkan_utils.cpp
            plugin.cpp)

target_link_libraries(nativerender PUBLIC ${hilog-lib}  ${libuv-lib} ${libnapi-lib} ${libace-lib} librawfile.z.so)