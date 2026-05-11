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
// [Start animatedDecoding_import]
#include <string>
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_source_native.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include "napi/native_api.h"
#include <imageKits.h>
// [End animatedDecoding_import]

// [Start animatedDecoding_logInfo]
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "IMAGE_SAMPLE"
// [End animatedDecoding_logInfo]

// [Start create_animatedSourceClass]
static ImageAnimatedNative *g_thisAnimated = new ImageAnimatedNative();
// [End create_animatedSourceClass]

// [Start animatedDecoding_maxStringLength]
const int ANIMATED_MAX_STRING_LENGTH = 1024;
// [End animatedDecoding_maxStringLength]

static napi_value ReturnAnimatedErrorCode(napi_env env, Image_ErrorCode errCode, const std::string &funcName)
{
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "%{public}s failed, errCode: %{public}d.", funcName.c_str(), errCode);
    }
    return GetJsResult(env, errCode);
}

// [Start animatedDecoding_releasePixelmapList]
static void ReleaseAnimatedPixelmapList()
{
    if (g_thisAnimated->pixelMapList == nullptr) {
        return;
    }
    for (size_t index = 0; index < g_thisAnimated->pixelMapListSize; index++) {
        if (g_thisAnimated->pixelMapList[index] != nullptr) {
            OH_PixelmapNative_Release(g_thisAnimated->pixelMapList[index]);
            g_thisAnimated->pixelMapList[index] = nullptr;
        }
    }
    delete[] g_thisAnimated->pixelMapList;
    g_thisAnimated->pixelMapList = nullptr;
    g_thisAnimated->pixelMapListSize = 0;
}
// [End animatedDecoding_releasePixelmapList]

// [Start animatedDecoding_createImageSource]
// 创建ImageSource实例。
napi_value CreateAnimatedImageSource(napi_env env, napi_callback_info info)
{
    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok ||
        argCount < 1 || argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateAnimatedImageSource napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    char filePath[ANIMATED_MAX_STRING_LENGTH];
    size_t pathSize = ANIMATED_MAX_STRING_LENGTH;
    napi_get_value_string_utf8(env, argValue[0], filePath, ANIMATED_MAX_STRING_LENGTH, &pathSize);

    if (g_thisAnimated->source != nullptr) {
        ReleaseAnimatedImageSource(env, info);
    }

    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(filePath, pathSize, &g_thisAnimated->source);
    return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_CreateFromUri");
}
// [End animatedDecoding_createImageSource]

// [Start animatedDecoding_getFrameCount]
// 获取图像帧数。帧数大于1时，可按动图处理。
napi_value GetAnimatedFrameCount(napi_env env, napi_callback_info info)
{
    if (g_thisAnimated->source == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageSource is nullptr.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    Image_ErrorCode errCode = OH_ImageSourceNative_GetFrameCount(g_thisAnimated->source, &g_thisAnimated->frameCnt);
    if (errCode != IMAGE_SUCCESS) {
        return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_GetFrameCount");
    }

    OH_LOG_INFO(LOG_APP, "Frame count: %{public}u.", g_thisAnimated->frameCnt);
    return GetJsResult(env, g_thisAnimated->frameCnt);
}
// [End animatedDecoding_getFrameCount]

// [Start animatedDecoding_getDelayTimeList]
// 获取图像延迟时间列表。
napi_value GetAnimatedDelayTimeList(napi_env env, napi_callback_info info)
{
    if (g_thisAnimated->source == nullptr || g_thisAnimated->frameCnt == 0) {
        OH_LOG_ERROR(LOG_APP, "Invalid ImageSource or frame count.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    int32_t *delayTimeList = new int32_t[g_thisAnimated->frameCnt];
    size_t size = g_thisAnimated->frameCnt;
    Image_ErrorCode errCode = OH_ImageSourceNative_GetDelayTimeList(g_thisAnimated->source, delayTimeList, size);
    if (errCode == IMAGE_SUCCESS) {
        for (size_t index = 0; index < size; index++) {
            OH_LOG_INFO(LOG_APP, "Frame %{public}zu delay time: %{public}d ms.", index, delayTimeList[index]);
        }
    }
    delete[] delayTimeList;
    delayTimeList = nullptr;
    return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_GetDelayTimeList");
}
// [End animatedDecoding_getDelayTimeList]

// [Start animatedDecoding_createPixelmapList]
// 通过图片解码参数创建PixelMap列表。
napi_value CreateAnimatedPixelmapList(napi_env env, napi_callback_info info)
{
    if (g_thisAnimated->source == nullptr || g_thisAnimated->frameCnt == 0) {
        OH_LOG_ERROR(LOG_APP, "Invalid ImageSource or frame count.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    ReleaseAnimatedPixelmapList();

    OH_DecodingOptions *opts = nullptr;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS || opts == nullptr) {
        return ReturnAnimatedErrorCode(env, errCode, "OH_DecodingOptions_Create");
    }

    g_thisAnimated->pixelMapList = new OH_PixelmapNative *[g_thisAnimated->frameCnt]();
    g_thisAnimated->pixelMapListSize = g_thisAnimated->frameCnt;
    errCode = OH_ImageSourceNative_CreatePixelmapList(g_thisAnimated->source, opts,
        g_thisAnimated->pixelMapList, g_thisAnimated->pixelMapListSize);

    OH_DecodingOptions_Release(opts);
    opts = nullptr;

    if (errCode != IMAGE_SUCCESS) {
        ReleaseAnimatedPixelmapList();
        return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_CreatePixelmapList");
    }

    OH_LOG_INFO(LOG_APP, "Create %{public}zu pixelmaps.", g_thisAnimated->pixelMapListSize);
    return GetJsResult(env, errCode);
}
// [End animatedDecoding_createPixelmapList]

// [Start animatedDecoding_createPixelmapByIndex]
// 通过帧索引创建指定帧PixelMap。
napi_value CreateAnimatedPixelmapByIndex(napi_env env, napi_callback_info info)
{
    if (g_thisAnimated->source == nullptr || g_thisAnimated->frameCnt == 0) {
        OH_LOG_ERROR(LOG_APP, "Invalid ImageSource or frame count.");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok ||
        argCount < 1 || argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateAnimatedPixelmapByIndex napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    uint32_t index = 0;
    napi_get_value_uint32(env, argValue[0], &index);
    if (index >= g_thisAnimated->frameCnt) {
        OH_LOG_ERROR(LOG_APP, "Invalid frame index: %{public}u.", index);
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }

    OH_DecodingOptions *opts = nullptr;
    Image_ErrorCode errCode = OH_DecodingOptions_Create(&opts);
    if (errCode != IMAGE_SUCCESS || opts == nullptr) {
        return ReturnAnimatedErrorCode(env, errCode, "OH_DecodingOptions_Create");
    }
    OH_DecodingOptions_SetIndex(opts, index);

    if (g_thisAnimated->pixelMap != nullptr) {
        OH_PixelmapNative_Release(g_thisAnimated->pixelMap);
        g_thisAnimated->pixelMap = nullptr;
    }

    errCode = OH_ImageSourceNative_CreatePixelmap(g_thisAnimated->source, opts, &g_thisAnimated->pixelMap);
    OH_DecodingOptions_Release(opts);
    opts = nullptr;

    return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_CreatePixelmap");
}
// [End animatedDecoding_createPixelmapByIndex]

// [Start animatedDecoding_release]
// 释放动图解码相关资源。
napi_value ReleaseAnimatedImageSource(napi_env env, napi_callback_info info)
{
    ReleaseAnimatedPixelmapList();

    if (g_thisAnimated->pixelMap != nullptr) {
        OH_PixelmapNative_Release(g_thisAnimated->pixelMap);
        g_thisAnimated->pixelMap = nullptr;
    }

    Image_ErrorCode errCode = IMAGE_SUCCESS;
    if (g_thisAnimated->source != nullptr) {
        errCode = OH_ImageSourceNative_Release(g_thisAnimated->source);
        g_thisAnimated->source = nullptr;
    }

    g_thisAnimated->frameCnt = 0;
    return ReturnAnimatedErrorCode(env, errCode, "OH_ImageSourceNative_Release");
}
// [End animatedDecoding_release]