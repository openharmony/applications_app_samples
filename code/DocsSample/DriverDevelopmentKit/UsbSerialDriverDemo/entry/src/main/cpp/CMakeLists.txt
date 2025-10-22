# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(usbserial_demo1)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_STANDARD 17)
set(LIB_DIR ${NATIVERENDER_ROOT_PATH}/../../../libs/)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${LIB_DIR}/include)

#add_library(libparse_point SHARED parse_point_info.cpp)
#add_library(libparse_point SHARED IMPORTED)
#set_target_properties(libparse_point PROPERTIES IMPORTED_LOCATION ${LIB_DIR}/${OHOS_ARCH}/libparse_point.so)

add_library(entry SHARED hello.cpp data_parser.cpp)
target_link_libraries(entry PUBLIC libace_napi.z.so libusb_serial_ndk.z.so libhilog_ndk.z.so -lpthread)