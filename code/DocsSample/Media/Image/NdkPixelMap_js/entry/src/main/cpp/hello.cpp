/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi/native_api.h"

// 引入图片框架、raw文件、raw文件管理和日志打印头文件
#include <cstdlib>
#include <cstring>
#include <multimedia/image_framework/image_pixel_map_napi.h>
#include <multimedia/image_framework/image_source_mdk.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <rawfile/raw_file.h>
#include <rawfile/raw_file_manager.h>
#include <hilog/log.h>
#include <multimedia/image_framework/image_mdk_common.h>
#include <cstdlib>
#include <fcntl.h>
#include <unistd.h>

// 引入编码器image_packer_mdk.h头文件。
#include "multimedia/image_framework/image_packer_mdk.h"

const uint32_t BUFFER_MAX = 1024 * 1024;
const uint16_t BUFFER_SIZE = 2048;
const uint16_t OPTS_QUALITY = 100;
const uint16_t RESPONSE_SIZE = 100;
const uint16_t OPS_WIDTH = 500;
const uint16_t OPS_HEIGHT = 500;
const uint16_t OPS_PIXEL_FORMAT = 4;
const uint16_t OPS_ALPHA_TYPE = 0;


static napi_value getSyncPixelMap(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype srcType;
    napi_typeof(env, args[0], &srcType);

    // 入参args[0]是资源管理器，用来初始化native层的资源管理器
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, args[0]);

    size_t strSize;
    char srcBuf[BUFFER_SIZE];
    // 入参args[1]是文件名称
    napi_get_value_string_utf8(env, args[1], srcBuf, sizeof(srcBuf), &strSize);

    // 用资源管理器打开Raw文件
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, srcBuf);
    if (rawFile != NULL) {
        // 获取文件大小，并读取数据
        long len = OH_ResourceManager_GetRawFileSize(rawFile);
        uint8_t *data = nullptr;
        if (len > 0 && len <= BUFFER_MAX) {
            data = static_cast<uint8_t *>(malloc(len));
        }
        int res = OH_ResourceManager_ReadRawFile(rawFile, data, len);

        OhosImageSource imageSource_c;
        imageSource_c.buffer = data;
        imageSource_c.bufferSize = len;

        OhosImageSourceOps ops{};
        napi_value imageSource;
        napi_value pixelMap;

        // 用读取到的Raw数据创建ImageSource
        int32_t ret = OH_ImageSource_Create(env, &imageSource_c, &ops, &imageSource);

        // 初始化native层的ImageSource
        ImageSourceNative *imageSourceNative_c = OH_ImageSource_InitNative(env, imageSource);
        OhosImageDecodingOps decodingOps{};
        // 创建pixelMap
        OH_ImageSource_CreatePixelMap(imageSourceNative_c, &decodingOps, &pixelMap);

        OhosImageSourceInfo info{};
        // 读取图片宽高
        OH_ImageSource_GetImageInfo(imageSourceNative_c, 0, &info);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "[decode]", "imageInfo width:%{public}d , height:%{public}d",
                     info.size.width, info.size.height);

        // 读取图片源的ImageWidth配置参数并打印日志
        OhosImageSourceProperty target;
        const char* exifKeyC = "ImageWidth";
        target.size = strlen(exifKeyC);
        target.value = const_cast<char*>(exifKeyC);

        OhosImageSourceProperty response{};
        response.size = RESPONSE_SIZE;
        response.value = static_cast<char *>(malloc(RESPONSE_SIZE));
        OH_ImageSource_GetImageProperty(imageSourceNative_c, &target, &response);
        OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "[decode]", "ImageProperty width after modify:%{public}s",
                     response.value);

        // 处理完毕，释放native层资源
        OH_ImageSource_Release(imageSourceNative_c);
        OH_ResourceManager_CloseRawFile(rawFile);
        return pixelMap;
    }
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return nullptr;
}

static napi_value DecodeIncrementally(napi_env env, long len, RawFile *rawFile)
{
    uint8_t *data = nullptr;
    if (len > 0 && len <= BUFFER_MAX) {
        data = static_cast<uint8_t *>(malloc(len));
    }
    // 读取文件全部数据
    int res = OH_ResourceManager_ReadRawFile(rawFile, data, len);

    uint8_t *holderdata = static_cast<uint8_t *>(malloc(len));
    if (holderdata == nullptr) {
        return nullptr;
    }

    OhosImageSource imageSource_c;
    // imageSource_c的buffer分配了空间，但是数据是空的
    imageSource_c.buffer = holderdata;
    imageSource_c.bufferSize = len;
    OhosImageSourceOps ops{};
    napi_value imageSource;
    // 初始化增量ImageSource
    OH_ImageSource_CreateIncremental(env, &imageSource_c, &ops, &imageSource);

    // 初始化native层的ImageSource
    ImageSourceNative *imageSourceNative_c = OH_ImageSource_InitNative(env, imageSource);

    // 以下模拟分片加载场景，分两次加载分片。第一次加载2048字节，第二次加载剩余的数据。
    OhosImageSourceUpdateData firstData{};
    firstData.buffer = data;    // 图片数据
    firstData.bufferSize = len; // 图片数据总大小
    firstData.isCompleted = false;
    firstData.offset = 0;                 // 第一次重头开始加载
    firstData.updateLength = BUFFER_SIZE; // 第一次加载了2048字节
    OH_ImageSource_UpdateData(imageSourceNative_c, &firstData);

    OhosImageSourceUpdateData secondData{};
    secondData.buffer = data;
    secondData.bufferSize = len;
    secondData.isCompleted = true;   // 最后一次加载，要标记加载完成
    secondData.offset = BUFFER_SIZE; // 已经加载过2048字节了，第二次偏移已经加载的量
    secondData.updateLength = len - BUFFER_SIZE; // 第二次加载剩余的数据
    OH_ImageSource_UpdateData(imageSourceNative_c, &secondData);

    napi_value pixelMap;
    OhosImageDecodingOps decodingOps{};
    decodingOps.index = 0;
    // 创建pixelMap
    OH_ImageSource_CreatePixelMap(imageSourceNative_c, &decodingOps, &pixelMap);

    // 处理完毕，释放native层资源
    OH_ImageSource_Release(imageSourceNative_c);
    OH_ResourceManager_CloseRawFile(rawFile);
    return pixelMap;
}

static napi_value getSyncPixelMapIncremental(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype srcType;
    napi_typeof(env, args[0], &srcType);

    // 入参args[0]是资源管理器，用来初始化native层的资源管理器
    NativeResourceManager *mNativeResMgr = OH_ResourceManager_InitNativeResourceManager(env, args[0]);

    size_t strSize;
    char srcBuf[2048];
    // 入参args[1]是文件名称
    napi_get_value_string_utf8(env, args[1], srcBuf, sizeof(srcBuf), &strSize);

    // 用资源管理器打开Raw文件
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(mNativeResMgr, srcBuf);
    if (rawFile != NULL) {
        // 获取文件大小，若大于2048字节，则增量式解码，否则直接全部解码
        long len = OH_ResourceManager_GetRawFileSize(rawFile);
        if (len > BUFFER_SIZE) {
            return DecodeIncrementally(env, len, rawFile);
        }
        // 读取Raw文件全部数据
        uint8_t *data = static_cast<uint8_t *>(malloc(len));
        int res = OH_ResourceManager_ReadRawFile(rawFile, data, len);

        OhosImageSource imageSource_c;
        imageSource_c.buffer = data;
        imageSource_c.bufferSize = len;

        OhosImageSourceOps ops{};
        napi_value imageSource;
        napi_value pixelMap;

        // 用读取到的Raw数据创建ImageSource
        int32_t ret = OH_ImageSource_Create(env, &imageSource_c, &ops, &imageSource);

        // 初始化native层的ImageSource
        ImageSourceNative *imageSourceNative_c = OH_ImageSource_InitNative(env, imageSource);
        OhosImageDecodingOps decodingOps{};

        // 创建pixelMap
        OH_ImageSource_CreatePixelMap(imageSourceNative_c, &decodingOps, &pixelMap);

        // 处理完毕，释放native层资源
        OH_ImageSource_Release(imageSourceNative_c);
        OH_ResourceManager_CloseRawFile(rawFile);
        return pixelMap;
    }
    OH_ResourceManager_ReleaseNativeResourceManager(mNativeResMgr);
    return nullptr;
}

static napi_value TestGetImageInfo(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr);

    OHOS::Media::OhosPixelMapInfo pixelMapInfo;
    OHOS::Media::OH_GetImageInfo(env, argValue[0], &pixelMapInfo);
    return result;
}

static napi_value TestAccessPixels(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr);

    void *addrPtr = nullptr;
    OHOS::Media::OH_AccessPixels(env, argValue[0], &addrPtr);
    return result;
}

static napi_value TestUnAccessPixels(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr);

    OHOS::Media::OH_UnAccessPixels(env, argValue[0]);
    return result;
}

napi_value CreatePixelMapTest(napi_env env, napi_callback_info info)
{
    napi_value udfVar = nullptr;
    napi_value pixelMap = nullptr;

    struct OhosPixelMapCreateOps createOps;
    createOps.width = OPS_WIDTH; // 修改创建设置中的宽高为500,使图像易于展示
    createOps.height = OPS_HEIGHT;
    createOps.pixelFormat = OPS_PIXEL_FORMAT;
    createOps.alphaType = OPS_ALPHA_TYPE;
    size_t bufferSize = createOps.width * createOps.height * 4;
    void *buff = malloc(bufferSize);
    if (buff == nullptr) {
        return udfVar;
    }

    char *cc = (char *)buff;
    for (int i = 0; i < bufferSize; i++) { // 处理全部的像素点,使图像易于展示
        *(cc++) = static_cast<char>(i);
    }
    
    int32_t res = OH_PixelMap_CreatePixelMap(env, createOps, (uint8_t *)buff, bufferSize, &pixelMap);
    free(buff);
    if (res != IMAGE_RESULT_SUCCESS || pixelMap == nullptr) {
        return udfVar;
    }
    return pixelMap;
}

napi_value CreateAlphaPixelMap(napi_env env, napi_callback_info info)
{
    napi_value udfVar = nullptr;
    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    napi_value alphaPixelMap = nullptr;

    napi_get_undefined(env, &udfVar);

    if (napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        return udfVar;
    }
    int32_t res = OH_PixelMap_CreateAlphaPixelMap(env, argValue[0], &alphaPixelMap);
    if (res != IMAGE_RESULT_SUCCESS || alphaPixelMap == nullptr) {
        return udfVar;
    }
    return alphaPixelMap;
}

napi_value Transform(napi_env env, napi_callback_info info)
{
    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    if (napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        return nullptr;
    }
    napi_value result = nullptr;
    napi_get_undefined(env, &result);

    // 初始化NativePixelMap对象。
    NativePixelMap *native = OH_PixelMap_InitNativePixelMap(env, argValue[0]);

    // 获取图片信息。
    struct OhosPixelMapInfos pixelMapInfo;
    OH_PixelMap_GetImageInfo(native, &pixelMapInfo);

    // 获取PixelMap对象每行字节数。
    int32_t rowBytes;
    OH_PixelMap_GetBytesNumberPerRow(native, &rowBytes);

    // 获取PixelMap对象是否可编辑的状态。
    int32_t editable = 0;
    OH_PixelMap_GetIsEditable(native, &editable);

    // 获取PixelMap对象是否支持Alpha通道。
    int32_t supportAlpha = 0;
    OH_PixelMap_IsSupportAlpha(native, &supportAlpha);

    // 设置PixelMap对象的Alpha通道。
    int32_t alphaAble = 0;
    OH_PixelMap_SetAlphaAble(native, alphaAble);

    // 获取PixelMap对象像素密度。
    int32_t densityG;
    OH_PixelMap_GetDensity(native, &densityG);

    // 设置PixelMap对象像素密度。
    int32_t densityS = 100;
    OH_PixelMap_SetDensity(native, densityS);

    // 设置PixelMap对象的透明度。
    float opacity = 0.5;
    OH_PixelMap_SetOpacity(native, opacity);

    // 设置缩放比例。
    // scaleX: 宽为原来的0.5。
    // scaleY: 高为原来的0.5。
    float scaleX = 0.5;
    float scaleY = 0.5;
    OH_PixelMap_Scale(native, scaleX, scaleY);

    // 设置偏移。
    // translateX: 向下偏移50。
    // translateY: 向右偏移50。
    float translateX = 50;
    float translateY = 50;
    OH_PixelMap_Translate(native, translateX, translateY);

    // 设置顺时针旋转90度。
    float angle = 90;
    OH_PixelMap_Rotate(native, angle);

    // 设置翻转
    // flipX: 水平翻转，0为不翻转，1为翻转。
    // flipY: 垂直翻转，0为不翻转，1为翻转。
    int32_t flipX = 0;
    int32_t flipY = 1;
    OH_PixelMap_Flip(native, flipX, flipY);

    // 设置裁剪区域。
    // cropX: 裁剪起始点横坐标。
    // cropY: 裁剪起始点纵坐标。
    // cropH: 裁剪高度10，方向为从上往下（裁剪后的图片高度为10）。
    // cropW: 裁剪宽度10，方向为从左到右（裁剪后的图片宽度为10）。
    int32_t cropX = 1;
    int32_t cropY = 1;
    int32_t cropW = 100; // 裁剪后的宽高修改为100，使图像易于展示
    int32_t cropH = 100;
    OH_PixelMap_Crop(native, cropX, cropY, cropW, cropH);

    // 获取PixelMap对象数据的内存地址，并锁定该内存。
    void *pixelAddr = nullptr;
    OH_PixelMap_AccessPixels(native, &pixelAddr);

    // 释放PixelMap对象数据的内存锁。
    OH_PixelMap_UnAccessPixels(native);

    return result;
}

napi_value EncodeImagesToFile(napi_env env, napi_callback_info info)
{
    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    if (napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        return nullptr;
    }

    napi_value source = argValue[0];

    if (source == nullptr) {
        return nullptr;
    }

    // 使用napi_value 承接创建的编码器对象
    napi_value packer;
    // 通过 napi_env 创建编码器，返回result为 IMAGE_RESULT_SUCCESS则创建成功
    int32_t result = OH_ImagePacker_Create(env, &packer);

    // 通过 napi_env 及上述创建的编码器对象初始化原生实例对象
    ImagePacker_Native *nativePacker = OH_ImagePacker_InitNative(env, packer);

    // 编码参数
    struct ImagePacker_Opts_ opts;
    // 配置编码格式（必须）
    opts.format = "image/jpeg";
    // 配置编码质量（必须）
    opts.quality = OPTS_QUALITY;
    // 打开需要输出的文件（请确保应用有权限访问这个路径）
    // 修改路径为可访问的沙箱路径
    int fd = open("/data/storage/el2/base/haps/entry/cache/test.jpg", O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "[encode]", "EncodeImagesToFile fd:%{public}d", fd);
    if (fd >= 0) {
        // 开始对输入source进行编码过程，返回result为 IMAGE_RESULT_SUCCESS则编码成功
        int32_t res = OH_ImagePacker_PackToFile(nativePacker, source, &opts, fd);
        if (res != IMAGE_RESULT_SUCCESS) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "[encode]", "EncodeToFile failed, errCode: %{public}d", result);
        } else {
            OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "[encode]", "EncodeToFile success, result: %{public}d", result);
        }
        // 关闭输出文件
        close(fd);
    }

    // 调用OH_ImagePacker_Release, 销毁编码器
    int32_t ret = OH_ImagePacker_Release(nativePacker);
    if (ret != IMAGE_RESULT_SUCCESS) {
        // 异常处理
    } else {
        nativePacker = NULL; // 不可重复destroy
    }
    return nullptr;
}

napi_value EncodeImagesToBuffer(napi_env env, napi_callback_info info)
{
    napi_value thisVar = nullptr;
    napi_value argValue[1] = {0};
    size_t argCount = 1;

    if (napi_get_cb_info(env, info, &argCount, argValue, &thisVar, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        return nullptr;
    }

    napi_value source;
    napi_create_object(env, &source);
    if (source == nullptr) {
        return nullptr;
    }

    // 使用napi_value 承接创建的编码器对象
    napi_value packer;
    // 通过 napi_env 创建编码器，返回result为 IMAGE_RESULT_SUCCESS则创建成功
    int32_t resultCreate = OH_ImagePacker_Create(env, &packer);

    // 通过 napi_env 及上述创建的编码器对象初始化原生实例对象
    ImagePacker_Native *nativePacker = OH_ImagePacker_InitNative(env, packer);

    // 编码参数
    struct ImagePacker_Opts_ opts;
    // 配置编码格式（必须）
    opts.format = "image/jpeg";
    // 配置编码质量（必须）
    opts.quality = OPTS_QUALITY;
    // 配置输出的缓存区大小为4k（缓存区大小视应用场景定）
    size_t bufferSize = 4 * 1024;
    // 申请图片编码缓存区
    uint8_t *outData = (uint8_t *)(malloc(bufferSize));
    // 开始对输入source进行编码过程，返回result为
    // IMAGE_RESULT_SUCCESS则编码成功，同时bufferSize中包含编码实际使用缓存区大小
    int32_t result = OH_ImagePacker_PackToData(nativePacker, source, &opts, outData, &bufferSize);

    // 调用OH_ImagePacker_Release, 销毁编码器
    int32_t ret = OH_ImagePacker_Release(nativePacker);
    if (result != IMAGE_RESULT_SUCCESS) {
        // 异常处理
    } else {
        nativePacker = NULL; // 不可重复destroy
    }
    return nullptr;
}
