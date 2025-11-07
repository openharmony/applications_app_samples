# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(MetaCompetences)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(hsp1_01 SHARED napi_init1.cpp)
add_library(hsp1_02 SHARED napi_init2.cpp)

target_link_libraries(hsp1_01 PUBLIC libace_napi.z.so)
target_link_libraries(hsp1_02 PUBLIC libace_napi.z.so)
