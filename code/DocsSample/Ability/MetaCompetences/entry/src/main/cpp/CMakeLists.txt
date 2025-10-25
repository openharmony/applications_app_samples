# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(MetaCompetences)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry_001 SHARED napi_init1.cpp)
add_library(entry_002 SHARED napi_init2.cpp)
add_library(entry_003 SHARED napi_init3.cpp)
add_library(entry_004 SHARED napi_init4.cpp)
add_library(entry_005 SHARED napi_init5.cpp)
add_library(entry_006 SHARED napi_init6.cpp)


target_link_libraries(entry_001 PUBLIC libace_napi.z.so entry_002 entry_003)

target_link_libraries(entry_002 PUBLIC libace_napi.z.so entry_003 entry_004)

target_link_libraries(entry_003 PUBLIC libace_napi.z.so entry_004)

target_link_libraries(entry_004 PUBLIC libace_napi.z.so)

target_link_libraries(entry_005 PUBLIC libace_napi.z.so entry_006)

target_link_libraries(entry_006 PUBLIC libace_napi.z.so)