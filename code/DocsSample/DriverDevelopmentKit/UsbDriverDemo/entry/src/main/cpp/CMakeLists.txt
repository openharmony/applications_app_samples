# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(NativeUsbMouse)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_STANDARD 17)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)


#add_library(parse_point SHARED parse_point_info.cpp)
#add_library(libparse_point SHARED IMPORTED)
#set_target_properties(libparse_point PROPERTIES IMPORTED_LOCATION ${LIB_DIR}/arm64-v8a/libparse_point.so)

add_library(entry SHARED hello.cpp data_parser.cpp hid_simulator.cpp inject_thread.cpp parse_point_info.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libusb_ndk.z.so libhid.z.so libhilog_ndk.z.so -lpthread)