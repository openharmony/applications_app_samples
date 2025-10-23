# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(CPP)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# <Start c_make_lists_jsoncpp>
# 新增jsoncpp.cpp(解析订阅事件中的json字符串)源文件
add_library(entry SHARED napi_init.cpp jsoncpp.cpp)
# <End c_make_lists_jsoncpp>

# <Start c_make_lists_link_libraries>
# 新增动态库依赖libhiappevent_ndk.z.so和libhilog_ndk.z.so(日志输出)，libohhicollie.so（HiCollie对外检测接口）
target_link_libraries(entry PUBLIC libace_napi.z.so libhilog_ndk.z.so libhiappevent_ndk.z.so libohhicollie.so)
# <End c_make_lists_link_libraries>
