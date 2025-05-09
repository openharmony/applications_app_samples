# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)

project(decodeheifimage)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

# TODO：知识点：定义一个变量 BUILD_FLAG_SO
# TODO：知识点：BUILD_FLAG_SO为0时生成封装基于libcurl的HEIF图片网络请求库libnativedownloadheif.so，将生成好的so文件放入根目录的libs目录下，供native接口调用。
# TODO：知识点：BUILD_FLAG_SO为1时生成封装基于libheif的HEIF图片软解码库libnativedecodeheif.so，将生成好的so文件放入根目录的libs目录下，供native接口调用。
# TODO：知识点：BUILD_FLAG_SO为2时，生成一个包含native侧的HEIF图片软解码接口decodeHeifImageFromInternet(该接口调用libnativedownloadheif.so和libnativedecodeheif.so导出的网络请求和软解码接口进行HEIF图片软解码)的库，接口decodeHeifImageFromInternet供ArkTS侧调用。
set(BUILD_FLAG_SO 2)

if(BUILD_FLAG_SO EQUAL 0)
    # 生成封装libcurl库的libnativedownloadheif.so
    add_library(nativedownloadheif SHARED download_heif_image.cpp)

    # 配置动态链接，将libcurl.so加入工程中
    target_link_libraries(nativedownloadheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../libs/${OHOS_ARCH}/libcurl.so)
    # 将libcurl的头文件加入工程中
    target_include_directories(nativedownloadheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/curl/${OHOS_ARCH}/include)
    target_include_directories(nativedownloadheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
    # 导入napi、ndk相关库
    target_link_libraries(nativedownloadheif PUBLIC libace_napi.z.so libhilog_ndk.z.so)
elseif(BUILD_FLAG_SO EQUAL 1)
    # 生成封装libheif库的libnativedecodeheif.so
    add_library(nativedecodeheif SHARED decode_heif_image.cpp)
    # 配置动态链接，将libheif.so加入工程中
    target_link_libraries(nativedecodeheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/libheif/${OHOS_ARCH}/lib/libheif.so)
    # 将libheif的头文件加入工程中
    target_include_directories(nativedecodeheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/libheif/${OHOS_ARCH}/include)
    target_include_directories(nativedecodeheif PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
    # 导入napi、ndk相关库
    target_link_libraries(nativedecodeheif PUBLIC libace_napi.z.so libhilog_ndk.z.so)
else()
    # 生成native侧库,供ArkTS侧调用
    add_library(decodeheifimage SHARED  napi_init.cpp)
    # 导入引用的库路径
    target_link_directories(decodeheifimage PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../../libs/${OHOS_ARCH}/)
    target_include_directories(decodeheifimage PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
    # 导入napi、ndk相关库及libnativedownloadheif.so和libnativedecodeheif解码库
    target_link_libraries(decodeheifimage PUBLIC libace_napi.z.so  libhilog_ndk.z.so libpixelmap_ndk.z.so libnativedownloadheif.so  libnativedecodeheif.so)
endif()
