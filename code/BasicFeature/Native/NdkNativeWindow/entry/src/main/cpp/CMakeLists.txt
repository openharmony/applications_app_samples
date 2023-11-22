# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(NdkNativeWindow)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)
find_library( # Sets the name of the path variable.
              hilog-lib
              # Specifies the name of the NDK library that
              # you want CMake to locate.
              hilog_ndk.z )
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
add_library(nativerender SHARED
            plugin.cpp
            NativeRender.cpp
            NativeImageAdaptor.cpp)

target_link_libraries(nativerender PUBLIC ${hilog-lib} ${libnapi-lib} ${libace-lib} libnative_buffer.so libnative_window.so libnative_image.so libEGL.so libGLESv3.so)