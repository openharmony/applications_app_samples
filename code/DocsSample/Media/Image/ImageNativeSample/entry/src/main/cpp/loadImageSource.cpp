/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
// [Start packSource_import]
// [Start decodingPixel_import]
// [Start editExif_operations_import]
#include <string>
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include "napi/native_api.h"
// [End editExif_operations_import]
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
// [End decodingPixel_import]
#include <set>
#include <multimedia/image_framework/image/image_packer_native.h>
// [End packSource_import]
#include <imageKits.h>

// [Start define_logInfo]
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "IMAGE_SAMPLE"
// [End define_logInfo]

// [Start packSource_supportedFormats]
static std::set<std::string> g_encodeSupportedFormats;
// [End packSource_supportedFormats]
// [Start create_sourceClass]
static ImageSourceNative *g_thisImageSource = new ImageSourceNative();
// [End create_sourceClass]

// [Start define_maxStringLength]
const int MAX_STRING_LENGTH = 1024;
// [End define_maxStringLength]

// [Start decodingPixel_operations]
// 返回ErrorCode。
napi_value ReturnErrorCode(napi_env env, Image_ErrorCode errCode, std::string funcName)
{
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "%{public}s failed, errCode: %{public}d.", funcName.c_str(), errCode);
        return GetJsResult(env, errCode);
    }
    return GetJsResult(env, errCode);
}

// 获取解码能力范围。
napi_value GetSupportedFormats(napi_env env, napi_callback_info info)
{
    Image_MimeType* mimeType = nullptr;
    size_t length = 10;
    Image_ErrorCode errCode = OH_ImageSourceNative_GetSupportedFormats(&mimeType, &length);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceNative_GetSupportedFormats failed, "
                     "errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    }
    for (size_t count = 0; count < length; count++) {
        OH_LOG_INFO(LOG_APP, "Decode supportedFormats: %{public}s", mimeType[count].data);
    }
    return GetJsResult(env, errCode);
}

// 创建ImageSource实例。
napi_value CreateImageSource(napi_env env, napi_callback_info info)
{
    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateImageSource napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    char name[MAX_STRING_LENGTH];
    size_t nameSize = MAX_STRING_LENGTH;
    napi_get_value_string_utf8(env, argValue[0], name, MAX_STRING_LENGTH, &nameSize);

    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(name, nameSize, &g_thisImageSource->source);
    return ReturnErrorCode(env, errCode, "OH_ImageSourceNative_CreateFromUri");
}
// [End decodingPixel_operations]

// [Start get_imageInfo]
// 创建定义图片信息的结构体对象，并获取图片信息。
napi_value GetImageInfo(napi_env env, napi_callback_info info)
{
    OH_ImageSourceInfo_Create(&g_thisImageSource->imageInfo);
    Image_ErrorCode errCode = OH_ImageSourceNative_GetImageInfo(g_thisImageSource->source,
                                                                0, g_thisImageSource->imageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceInfo_Create failed, errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    }
    
    uint32_t width;
    uint32_t height;
    OH_ImageSourceInfo_GetWidth(g_thisImageSource->imageInfo, &width);
    OH_ImageSourceInfo_GetHeight(g_thisImageSource->imageInfo, &height);
    OH_LOG_INFO(LOG_APP, "OH_ImageSourceNative_GetImageInfo success,"
               "width: %{public}d, height: %{public}d.", width, height);
    OH_ImageSourceInfo_Release(g_thisImageSource->imageInfo);
    g_thisImageSource->imageInfo = nullptr;
    return GetJsResult(env, width); // 返回获取到info信息的width。
}
// [End get_imageInfo]

// [Start editExif_operations]
// 获取指定property的value值。
napi_value GetImageProperty(napi_env env, napi_callback_info info)
{
    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "GetImageProperty napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }
    // 修改指定属性键的值。
    char key[MAX_STRING_LENGTH];
    size_t keySize = MAX_STRING_LENGTH;
    napi_get_value_string_utf8(env, argValue[0], (char *)key, sizeof(key), &keySize);
    Image_String getKey;
    getKey.data = key;
    getKey.size = keySize;
    Image_String getValue;
    OH_LOG_INFO(LOG_APP, "OH_ImageSourceNative_GetImageProperty key: %{public}s.", getKey.data);
    Image_ErrorCode errCode = OH_ImageSourceNative_GetImagePropertyWithNull(g_thisImageSource->source,
                                                                            &getKey, &getValue);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceNative_GetImageProperty failed, errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    }
    napi_value resultNapi = nullptr;
    napi_create_string_utf8(env, getValue.data, getValue.size, &resultNapi);
    free(getValue.data);
    getValue.data = nullptr;
    return resultNapi;
}

// 修改指定property的value值。
napi_value ModifyImageProperty(napi_env env, napi_callback_info info)
{
    napi_value argValue[2] = {nullptr};
    size_t argCount = 2;
    const size_t minCount = 2;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < minCount ||
        argValue[0] == nullptr || argValue[1] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ModifyImageProperty napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    // 获取要修改的key值。
    char key[MAX_STRING_LENGTH];
    size_t keySize = MAX_STRING_LENGTH;
    napi_get_value_string_utf8(env, argValue[0], (char *)key, sizeof(key), &keySize);
    Image_String setKey;
    setKey.data = key;
    setKey.size = keySize;
    OH_LOG_INFO(LOG_APP, "ModifyImageProperty key: %{public}s.", setKey.data);
    
    // 获取要修改的value值。
    char value[MAX_STRING_LENGTH];
    size_t valueSize;
    napi_get_value_string_utf8(env, argValue[1], (char *)value, MAX_STRING_LENGTH, &valueSize);
    Image_String setValue;
    setValue.data = value;
    setValue.size = valueSize;
    OH_LOG_INFO(LOG_APP, "ModifyImageProperty value: %{public}s.", setValue.data);

    Image_ErrorCode errCode = OH_ImageSourceNative_ModifyImageProperty(g_thisImageSource->source, &setKey, &setValue);
    return ReturnErrorCode(env, errCode, "OH_ImageSourceNative_ModifyImageProperty");
}
// [End editExif_operations]

// [Start create_pixelMap]
// 通过图片解码参数创建PixelMap对象。
napi_value CreatePixelMap(napi_env env, napi_callback_info info)
{
    // ops参数支持传入nullptr, 当不需要设置解码参数时，不用创建。
    OH_DecodingOptions *ops = nullptr;
    OH_DecodingOptions_Create(&ops);
    // 设置为AUTO会根据图片资源格式和设备支持情况进行解码，如果图片资源为HDR资源且设备支持HDR解码则会解码为HDR的pixelmap。
    OH_DecodingOptions_SetDesiredDynamicRange(ops, IMAGE_DYNAMIC_RANGE_AUTO);
    
    OH_PixelmapNative_Release(g_thisImageSource->resPixMap);
    g_thisImageSource->resPixMap = nullptr;
    
    Image_ErrorCode errCode = OH_ImageSourceNative_CreatePixelmap(g_thisImageSource->source,
                                                                  ops, &g_thisImageSource->resPixMap);
    OH_DecodingOptions_Release(ops);
    ops = nullptr;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceNative_CreatePixelmap failed, errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    }

    // 判断pixelmap是否为HDR内容。
    OH_PixelmapImageInfo_Create(&g_thisImageSource->pixelmapImageInfo);
    OH_PixelmapNative_GetImageInfo(g_thisImageSource->resPixMap, g_thisImageSource->pixelmapImageInfo);
    bool pixelmapIsHdr;
    OH_PixelmapImageInfo_GetDynamicRange(g_thisImageSource->pixelmapImageInfo, &pixelmapIsHdr);
    if (pixelmapIsHdr) {
        OH_LOG_INFO(LOG_APP, "The pixelMap's dynamicRange is HDR.");
    }
    OH_PixelmapImageInfo_Release(g_thisImageSource->pixelmapImageInfo);
    g_thisImageSource->pixelmapImageInfo = nullptr;
    return GetJsResult(env, errCode);
}
// [End create_pixelMap]

// [Start get_frameCount]
// 获取图像帧数。
napi_value GetFrameCount(napi_env env, napi_callback_info info)
{
    Image_ErrorCode errCode = OH_ImageSourceNative_GetFrameCount(g_thisImageSource->source,
                                                                 &g_thisImageSource->frameCnt);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceNative_GetFrameCount failed, errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    }
    return GetJsResult(env, g_thisImageSource->frameCnt); // 返回获取到的图像帧数。
}
// [End get_frameCount]

// [Start create_pixelmapList]
// 通过图片解码参数创建Pixelmap列表。
napi_value CreatePixelmapList(napi_env env, napi_callback_info info)
{
    OH_DecodingOptions *opts = nullptr;
    OH_DecodingOptions_Create(&opts);
    OH_PixelmapNative** resVecPixMap = new OH_PixelmapNative* [g_thisImageSource->frameCnt];
    size_t outSize = g_thisImageSource->frameCnt;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreatePixelmapList(g_thisImageSource->source,
                                                                      opts, resVecPixMap, outSize);
    OH_DecodingOptions_Release(opts);
    opts = nullptr;
    delete[] resVecPixMap;
    return ReturnErrorCode(env, errCode, "OH_ImageSourceNative_CreatePixelmapList");
}
// [End create_pixelmapList]

// [Start get_delayTimeList]
// 获取图像延迟时间列表。
napi_value GetDelayTimeList(napi_env env, napi_callback_info info)
{
    int32_t *delayTimeList = new int32_t[g_thisImageSource->frameCnt];
    size_t size = g_thisImageSource->frameCnt;
    OH_LOG_INFO(LOG_APP, "GetDelayTimeList size: %{public}zu.", size);
    Image_ErrorCode errCode = OH_ImageSourceNative_GetDelayTimeList(g_thisImageSource->source, delayTimeList, size);
    delete[] delayTimeList;
    return ReturnErrorCode(env, errCode, "OH_ImageSourceNative_GetDelayTimeList");
}
// [End get_delayTimeList]

// [Start release_imageSource]
// 释放资源。
napi_value ReleaseImageSource(napi_env env, napi_callback_info info)
{
    Image_ErrorCode errCode = OH_ImageSourceNative_Release(g_thisImageSource->source);
    g_thisImageSource->source = nullptr;
    OH_PixelmapNative_Release(g_thisImageSource->resPixMap);
    g_thisImageSource->resPixMap = nullptr;
    return ReturnErrorCode(env, errCode, "OH_ImageSourceNative_Release");
}
// [End release_imageSource]

// [Start pack_source]
// 获取编码能力范围。
Image_ErrorCode GetEncodeSupportedFormats()
{
    Image_MimeType* mimeType = nullptr;
    size_t length = 0;
    Image_ErrorCode errCode = OH_ImagePackerNative_GetSupportedFormats(&mimeType, &length);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImagePackerNative_GetSupportedFormats failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }
    for (size_t count = 0; count < length; count++) {
        if (mimeType[count].data != nullptr) {
            g_encodeSupportedFormats.insert(std::string(mimeType[count].data));
            OH_LOG_INFO(LOG_APP, "Encode supportedFormats: %{public}s", mimeType[count].data);
        }
    }
    return IMAGE_SUCCESS;
}

Image_MimeType GetMimeTypeIfEncodable(const char *format)
{
    auto it = g_encodeSupportedFormats.find(format);
    if (it == g_encodeSupportedFormats.end()) {
        return {const_cast<char *>(""), 0};
    }
    return {const_cast<char *>(format), strlen(format)};
}

Image_ErrorCode packToFileFromImageSourceTest(int fd, OH_ImageSourceNative* imageSource)
{
    // 创建ImagePacker实例。
    OH_ImagePackerNative *testPacker = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromImageSourceTest OH_ImagePackerNative_Create failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }
    
    // 获取编码能力范围。
    errCode = GetEncodeSupportedFormats();
    if (errCode != IMAGE_SUCCESS) {
        OH_ImagePackerNative_Release(testPacker);
        return errCode;
    }
    
    // 指定编码参数，将ImageSource直接编码进文件。
    OH_PackingOptions *option = nullptr;
    OH_PackingOptions_Create(&option);
    Image_MimeType image_MimeType = GetMimeTypeIfEncodable(MIME_TYPE_JPEG);
    if (image_MimeType.data == nullptr || image_MimeType.size == 0) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromImageSourceTest GetMimeTypeIfEncodable failed,"
                     "format can't support encode.");
        return IMAGE_BAD_PARAMETER;
    }
    OH_PackingOptions_SetMimeType(option, &image_MimeType);
    // 当设备支持HDR编码，资源本身为HDR图且图片资源的格式为jpeg时，编码产物才能为HDR内容。
    OH_PackingOptions_SetDesiredDynamicRange(option, IMAGE_PACKER_DYNAMIC_RANGE_AUTO);
    // 设置编码质量，quality默认为0，建议quality的值不低于80
    uint32_t quality = 90;
    OH_PackingOptions_SetQuality(option, quality);
    errCode = OH_ImagePackerNative_PackToFileFromImageSource(testPacker, option, imageSource, fd);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromImageSourceTest OH_ImagePackerNative_PackToFileFromImageSource failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }

    // 释放ImagePacker实例。
    errCode = OH_ImagePackerNative_Release(testPacker);
    testPacker = nullptr;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromImageSourceTest OH_ImagePackerNative_Release failed,"
                     "errCode: %{public}d.", errCode);
        return errCode;
    }
    
    // 释放PackingOptions实例。
    errCode = OH_PackingOptions_Release(option);
    option = nullptr;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromImageSourceTest OH_PackingOptions_Release failed,"
                     "errCode: %{public}d.", errCode);
        return errCode;
    }
    return IMAGE_SUCCESS;
}

Image_ErrorCode packToFileFromPixelmapTest(int fd, OH_PixelmapNative *pixelmap)
{
    // 创建ImagePacker实例。
    OH_ImagePackerNative *testPacker = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromPixelmapTest CreatePacker OH_ImagePackerNative_Create failed,"
                     "errCode: %{public}d.", errCode);
        return errCode;
    }

    // 指定编码参数，将PixelMap直接编码进文件。
    OH_PackingOptions *option = nullptr;
    OH_PackingOptions_Create(&option);
    char type[] = "image/jpeg";
    Image_MimeType image_MimeType = {type, strlen(type)};
    OH_PackingOptions_SetMimeType(option, &image_MimeType);
    // 设置编码质量，quality默认为0，建议quality的值不低于80
    uint32_t quality = 90;
    OH_PackingOptions_SetQuality(option, quality);
    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(testPacker, option, pixelmap, fd);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromPixelmapTest OH_ImagePackerNative_PackToFileFromPixelmap failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }

    // 释放ImagePacker实例。
    errCode = OH_ImagePackerNative_Release(testPacker);
    testPacker = nullptr;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromPixelmapTest ReleasePacker OH_ImagePackerNative_Release failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }
    
    // 释放PackingOptions实例。
    errCode = OH_PackingOptions_Release(option);
    option = nullptr;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromPixelmapTest OH_PackingOptions_Release failed,"
                              "errCode: %{public}d.", errCode);
        return errCode;
    }
    
    return IMAGE_SUCCESS;
}

napi_value PackToFileFromImageSourceTestJs(napi_env env, napi_callback_info info)
{
    napi_value argv[1] = {0};
    size_t argc = 1;
    if (napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "PackToFileFromImageSourceTestJs napi_get_cb_info failed.");
        return nullptr;
    }
    
    int fd;
    napi_get_value_int32(env, argv[0], &fd);
    
    Image_ErrorCode errCode = packToFileFromImageSourceTest(fd, g_thisImageSource->source);
    if (errCode == IMAGE_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "ImagePackerNativeCTest PackToFileFromImageSourceTestJs successfully.");
    }
    return GetJsResult(env, errCode);
}

napi_value PackToFileFromPixelmapTestJs(napi_env env, napi_callback_info info)
{
    napi_value argv[1] = {0};
    size_t argc = 1;
    if (napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "PackToFileFromImageSourceTestJs napi_get_cb_info failed.");
        return nullptr;
    }
    
    int fd;
    napi_get_value_int32(env, argv[0], &fd);
    
    Image_ErrorCode errCode = packToFileFromPixelmapTest(fd, g_thisImageSource->resPixMap);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "packToFileFromPixelmapTest failed,"
                     "errCode: %{public}d.", errCode);
        return GetJsResult(env, errCode);
    } else {
        OH_LOG_INFO(LOG_APP, "PackToFileFromPixelmapTestJs successfully.");
    }
    return GetJsResult(env, errCode);
}
// [End pack_source]
