cmake_minimum_required(VERSION 3.4.1)
project(UsageInstructionsFive)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
# 日志打印配置
add_definitions( "-DLOG_DOMAIN=0xd0d0" )
add_definitions( "-DLOG_TAG=\"testTag\"" )
include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# 添加名为entry的库
add_library(isarraybuffer SHARED hello.cpp)
# 构建此可执行文件需要链接的库
target_link_libraries(isarraybuffer PUBLIC libace_napi.z.so libjsvm.so libhilog_ndk.z.so)
