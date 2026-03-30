# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(FFRTConcurrentQueue_Sample)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${MODULES_PATH}/@ppd/ffrt/include)

add_library(entry SHARED napi_init.cpp concurrent_queue.cpp concurrent_queue_cpp.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libhilog_ndk.z.so ffrt::ffrt_cpp libffrt.z.so)