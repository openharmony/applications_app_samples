# [Start cmake_start]
# CMakeLists.txt
# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(ndk_build_on_multi_thread)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED napi_init.cpp NativeEntry.cpp NativeModule.h ArkUIBaseNode.h ArkUINode.h ArkUIListNode.h ArkUIListItemNode.h ArkUITextNode.h NormalTextListExample.h CreateNode.h CreateNode.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libace_ndk.z.so libhilog_ndk.z.so)
# [End cmake_start]


# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(myapp)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(entry SHARED
    napi_init.cpp
    node/NodeCreator.cpp
    card/CardCreator.cpp
    )
target_link_libraries(entry PUBLIC libace_napi.z.so ace_ndk.z.so hilog_ndk.z.so)
