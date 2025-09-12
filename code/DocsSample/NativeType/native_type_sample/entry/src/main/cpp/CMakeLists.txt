# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(native_type_sample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp manager.cpp baseUtils.cpp SwiperMaker.cpp)

find_library(hilog-lib hilog_ndk.z)

find_library(libace-lib ace_ndk.z)

find_library(libnapi-lib ace_napi.z)


target_link_libraries(entry PUBLIC ${hilog-lib} ${libace-lib} ${libnapi-lib})