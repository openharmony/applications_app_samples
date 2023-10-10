# 设置CMake的最低版本要求为3.4.1
cmake_minimum_required(VERSION 3.4.1)

# 设置项目名称为XComponent
project(XComponent)

# 定义变量NATIVERENDER_ROOT_PATH为当前源代码的根路径
set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# 添加头文件路径到项目中
include_directories(
    ${NATIVERENDER_ROOT_PATH}
    ${NATIVERENDER_ROOT_PATH}/include
)

# 构建共享库vpn_client并添加源代码文件vpn_client.cpp
add_library(vpn_client SHARED vpn_client.cpp)

# 链接两个库文件到vpn_client库中
target_link_libraries(vpn_client PUBLIC libace_napi.z.so libc++.a)
target_link_libraries(vpn_client PUBLIC libhilog_ndk.z.so)