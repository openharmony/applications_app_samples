# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(NdkEmbedArktsComponents)

set(CMAKE_CXX_STANDARD 17)
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED NapiInit.cpp NativeEntry.cpp ArkUIMixedRefresh.cpp)
  find_library(
       # Sets the name of the path variable.
       hilog-lib
       # Specifies the name of the NDK library that
       # you want CMake to locate.
       hilog_ndk.z
   )

  find_library(
       # Sets the name of the path variable.
       libace-lib
       # Specifies the name of the NDK library that
       # you want CMake to locate.
       ace_ndk.z
   )

  find_library(
       # Sets the name of the path variable.
       libnapi-lib
       # Specifies the name of the NDK library that
       # you want CMake to locate.
       ace_napi.z
   )

   find_library(
        # Sets the name of the path variable.
        libuv-lib
        uv
    )

  target_link_libraries(entry PUBLIC
       ${hilog-lib} ${libace-lib} ${libnapi-lib} ${libuv-lib} )