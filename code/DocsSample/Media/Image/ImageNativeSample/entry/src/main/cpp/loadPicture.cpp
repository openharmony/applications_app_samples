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
// [Start decodingPicture_import]
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_native.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/picture_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
// [End decodingPicture_import]
// [Start define_const]
#define AUTO 0
#define SDR 1
const int MAX_SIZE = 1024;
const int MAX_FORMAT_LENGTH = 20;
// [End define_const]
#include <imageKits.h>
// [Start create_pictureClass]
static ImagePictureNative *g_thisPicture = new ImagePictureNative();
// [End create_pictureClass]
// [Start create_auxPictureClass]
static ImageAuxiliaryPictureNative *g_thisAuxiliaryPicture  = new ImageAuxiliaryPictureNative();
// [End create_auxPictureClass]

// [Start picture_operations]
// 释放ImageSource。
napi_value ReleasePictureSource(napi_env env, napi_callback_info info)
{
    if (g_thisPicture->source != nullptr) {
        g_thisPicture->errorCode = OH_ImageSourceNative_Release(g_thisPicture->source);
        g_thisPicture->source = nullptr;
        return GetJsResult(env, g_thisPicture->errorCode);
    }
    
    if (g_thisPicture->picture != nullptr) {
        g_thisPicture->errorCode = OH_PictureNative_Release(g_thisPicture->picture);
        g_thisPicture->picture = nullptr;
        return GetJsResult(env, g_thisPicture->errorCode);
    }
    
    OH_LOG_DEBUG(LOG_APP, "ReleasePictureSource source is null !");
    return GetJsResult(env, g_thisPicture->errorCode);
}

// 创造解码参数。
napi_value CreateDecodingOptions(napi_env env, napi_callback_info info)
{
    g_thisPicture->errorCode = OH_DecodingOptionsForPicture_Create(&g_thisPicture->options);

    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_DecodingOptionsForPicture_Create failed, errCode: %{public}d.",
                     g_thisPicture->errorCode);
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "OH_DecodingOptionsForPicture_Create success !");
    }

    return GetJsResult(env, g_thisPicture->errorCode);
}

// 配置解码参数 从应用层传入。
napi_value SetDesiredAuxiliaryPictures(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok || argc < 1 || args[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "napi_get_cb_info failed !");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    uint32_t length = 0;
    napi_get_array_length(env, args[0], &length);
    if (length <= 0) {
        OH_LOG_ERROR(LOG_APP, "napi_get_array_length failed !");
        return GetJsResult(env, IMAGE_UNKNOWN_ERROR);
    }
    Image_AuxiliaryPictureType typeList[length];
    for (int index = 0; index < length; index++) {
        napi_value element;
        uint32_t ulType = 0;
        napi_get_element(env, args[0], index, &element);
        napi_get_value_uint32(env, element, &ulType);
        typeList[index] = static_cast<Image_AuxiliaryPictureType>(ulType);
        OH_LOG_DEBUG(LOG_APP, "ulType is :%{public}d", ulType);
    }
    
    // 调用OH_DecodingOptionsForPicture_Create接口创建DecodingOptions。
    CreateDecodingOptions(env, info);
    g_thisPicture->errorCode =
        OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures(g_thisPicture->options, typeList, length);
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures failed,errCode: %{public}d.",
                     g_thisPicture->errorCode);
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "OH_DecodingOptionsForPicture_SetDesiredAuxiliaryPictures success !");
    }

    return GetJsResult(env, g_thisPicture->errorCode);
}

// 解码。
napi_value CreatePictureByImageSource(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok || argc < 1 || args[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreatePicture_ napi_get_cb_info failed !");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }
    
    char filePath[MAX_SIZE];
    size_t pathSize;
    napi_get_value_string_utf8(env, args[0], filePath, MAX_SIZE, &pathSize);

    g_thisPicture->errorCode = OH_ImageSourceNative_CreateFromUri(filePath, pathSize, &g_thisPicture->source);
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImageSourceNative_CreateFromUri failed, errCode: %{public}d.",
                     g_thisPicture->errorCode);
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "OH_ImageSourceNative_CreateFromUri success !");
    }
    
    // 先创建解码参数，再进行解码，此处创建解码参数的接口在SetDesiredAuxiliaryPictures实现。
    g_thisPicture->errorCode =
        OH_ImageSourceNative_CreatePicture(g_thisPicture->source, g_thisPicture->options, &g_thisPicture->picture);
    
    // 释放options。
    OH_DecodingOptionsForPicture_Release(g_thisPicture->options);
    g_thisPicture->options = nullptr;
    
    g_thisAuxiliaryPicture ->errorCode = OH_PictureNative_GetAuxiliaryPicture(g_thisPicture->picture,
        g_thisAuxiliaryPicture ->type, &g_thisAuxiliaryPicture ->auxiliaryPicture);
    if (g_thisAuxiliaryPicture ->errorCode == IMAGE_SUCCESS) {
        uint8_t* buff = new uint8_t[g_thisAuxiliaryPicture ->buffSize];
        OH_AuxiliaryPictureNative_ReadPixels(g_thisAuxiliaryPicture ->auxiliaryPicture, buff,
            &g_thisAuxiliaryPicture ->buffSize);
        OH_AuxiliaryPictureNative_Release(g_thisAuxiliaryPicture ->auxiliaryPicture);
        g_thisAuxiliaryPicture ->auxiliaryPicture = nullptr;
        delete []buff;
    }
    
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ImageSourceNative_CreatePicture failed, errCode: %{public}d.",
                     g_thisPicture->errorCode);
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "ImageSourceNative_CreatePicture success !");
    }
    
    return GetJsResult(env, g_thisPicture->errorCode);
}
// [End picture_operations]

// [Start pack_picture]
// 设置编码参数。
void SetPackOptions(OH_PackingOptions *packerOptions,
                    Image_MimeType format,
                    uint32_t quality,
                    bool needsPackProperties,
                    int32_t desiredDynamicRange)
{
    OH_PackingOptions_SetMimeType(packerOptions, &format);
    OH_PackingOptions_SetQuality(packerOptions, quality);
    OH_PackingOptions_SetNeedsPackProperties(packerOptions, needsPackProperties);
    OH_PackingOptions_SetDesiredDynamicRange(packerOptions, desiredDynamicRange);
}

// PackToData。
napi_value PackToDataFromPicture(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_get_cb_info failed!");
        return GetJsResult(env, g_thisPicture->errorCode);
    }
    
    size_t outDataSize = 10000 * 10000;
    uint8_t *outData = new uint8_t[outDataSize];

    if (g_thisPicture->packerOptions == nullptr) {
        g_thisPicture->errorCode = OH_PackingOptions_Create(&g_thisPicture->packerOptions);
    }
    if (g_thisPicture->imagePacker == nullptr) {
        g_thisPicture->errorCode = OH_ImagePackerNative_Create(&g_thisPicture->imagePacker);
    }
    
    char strFormat[MAX_FORMAT_LENGTH];
    size_t strFormatSize;
    napi_get_value_string_utf8(env, args[0], strFormat, MAX_FORMAT_LENGTH, &strFormatSize);
    OH_LOG_DEBUG(LOG_APP, "PackToDataFromPicture format: %{public}s", strFormat);

    Image_MimeType format;
    format.size = strFormatSize;
    format.data = const_cast<char *>(strFormat);
    uint32_t quality = 95;
    bool needsPackProperties = true;
    int32_t desiredDynamicRange = AUTO;
    SetPackOptions(g_thisPicture->packerOptions, format, quality, needsPackProperties, desiredDynamicRange);
    // 确保picture对象已被创建。
    g_thisPicture->errorCode = OH_ImagePackerNative_PackToDataFromPicture(
        g_thisPicture->imagePacker, g_thisPicture->packerOptions, g_thisPicture->picture, outData, &outDataSize);
    
    // 释放imagePacker和packerOptions。
    OH_PackingOptions_Release(g_thisPicture->packerOptions);
    g_thisPicture->packerOptions = nullptr;
    OH_ImagePackerNative_Release(g_thisPicture->imagePacker);
    g_thisPicture->imagePacker = nullptr;
    
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImagePackerNative_PackToDataFromPicture failed, errCode: %{public}d.",
                     g_thisPicture->errorCode);
        delete[] outData;
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "OH_ImagePackerNative_PackToDataFromPicture success !");
    }
    delete[] outData;
    return GetJsResult(env, g_thisPicture->errorCode);
}

// PackToFile。
napi_value PackToFileFromPicture(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
    OH_LOG_ERROR(LOG_APP, "napi_get_cb_info failed!");
        return GetJsResult(env, g_thisPicture->errorCode);
    }
    uint32_t fd = 0;
    napi_get_value_uint32(env, args[0], &fd);

    if (g_thisPicture->packerOptions == nullptr) {
        g_thisPicture->errorCode = OH_PackingOptions_Create(&g_thisPicture->packerOptions);
    }
    if (g_thisPicture->imagePacker == nullptr) {
        g_thisPicture->errorCode = OH_ImagePackerNative_Create(&g_thisPicture->imagePacker);
    }
    
    char strFormat[MAX_FORMAT_LENGTH];
    size_t strFormatSize;
    napi_get_value_string_utf8(env, args[1], strFormat, MAX_FORMAT_LENGTH, &strFormatSize);
    OH_LOG_INFO(LOG_APP, "PackToFileFromPicture format: %{public}s", strFormat);

    Image_MimeType format;
    format.size = strFormatSize;
    format.data = const_cast<char *>(strFormat);
    uint32_t quality = 95;
    bool needsPackProperties = false;
    int32_t desiredDynamicRange = SDR;
    SetPackOptions(g_thisPicture->packerOptions, format, quality, needsPackProperties, desiredDynamicRange);
    // 确保picture对象已被创建。
    g_thisPicture->errorCode = OH_ImagePackerNative_PackToFileFromPicture(
        g_thisPicture->imagePacker, g_thisPicture->packerOptions, g_thisPicture->picture, fd);
    
    // 释放imagePacker和packerOptions。
    OH_PackingOptions_Release(g_thisPicture->packerOptions);
    g_thisPicture->packerOptions = nullptr;
    OH_ImagePackerNative_Release(g_thisPicture->imagePacker);
    g_thisPicture->imagePacker = nullptr;
    
    if (g_thisPicture->errorCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImagePackerNative_PackToFileFromPicture failed,"
                     "errCode: %{public}d.", g_thisPicture->errorCode);
        return GetJsResult(env, g_thisPicture->errorCode);
    } else {
        OH_LOG_DEBUG(LOG_APP, "OH_ImagePackerNative_PackToFileFromPicture success !");
    }

    return GetJsResult(env, g_thisPicture->errorCode);
}
// [End pack_picture]
