# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(TestQueryNative)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

file(GLOB_RECURSE ENTRY_SOURCES CONFIGURE_DEPENDS
      "${NATIVERENDER_ROOT_PATH}/*.cpp"
  )

 add_library(entry SHARED ${ENTRY_SOURCES})

find_library(hilog-lib hilog_ndk.z)

find_library(libace-lib ace_ndk.z)

find_library(libnapi-lib ace_napi.z)

target_link_libraries(entry PUBLIC ${hilog-lib} ${libace-lib} ${libnapi-lib} libability_base_want.so)