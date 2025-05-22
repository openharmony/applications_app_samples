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

// [Start ndk_pixelmap_source]
#include <linux/kd.h>
#include <string>

#include <hilog/log.h>
#include <multimedia/image_framework/image/image_source_native.h>
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_TAG"

#define NUM_0 0
#define NUM_1 1

const uint32_t MAX_FRAME_CNT = 1024;
const uint32_t NAME_SIZE = 1024;

static napi_value getJsResult(napi_env env, Image_ErrorCode errCode)
{
    napi_value result;
    napi_create_int32(env, errCode, &result);
    return result;
}

static Image_ErrorCode CreatePixelMap(OH_ImageSourceNative *source, OH_PixelmapNative *resPixMap)
{
    // 创建定义图片信息的结构体对象，并获取图片信息
    OH_ImageSource_Info *imageInfo;
    OH_ImageSourceInfo_Create(&imageInfo);
    Image_ErrorCode errCode = OH_ImageSourceNative_GetImageInfo(source, 0, imageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_GetImageInfo failed, errCode:%{public}d.",
            errCode);
        return errCode;
    }

    // 获取指定属性键的值
    uint32_t width, height;
    OH_ImageSourceInfo_GetWidth(imageInfo, &width);
    OH_ImageSourceInfo_GetHeight(imageInfo, &height);
    OH_ImageSourceInfo_Release(imageInfo);
    OH_LOG_INFO(LOG_APP,
                "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_GetImageInfo success, width: %{public}d, "
                "height: %{public}d.",
                width, height);

    // 通过图片解码参数创建PixelMap对象
    OH_DecodingOptions *ops = nullptr;
    OH_DecodingOptions_Create(&ops);
    // 设置为AUTO会根据图片资源格式解码，如果图片资源为HDR资源则会解码为HDR的pixelmap。
    OH_DecodingOptions_SetDesiredDynamicRange(ops, IMAGE_DYNAMIC_RANGE_AUTO);

    // ops参数支持传入nullptr, 当不需要设置解码参数时，不用创建
    errCode = OH_ImageSourceNative_CreatePixelmap(source, ops, &resPixMap);
    OH_DecodingOptions_Release(ops);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_CreatePixelmap failed, errCode: %{public}d.",
            errCode);
        return errCode;
    }
    return IMAGE_SUCCESS;
}

static Image_ErrorCode GetPixelMapInfo(OH_ImageSourceNative *source, OH_PixelmapNative *resPixMap)
{
    // 判断pixelmap是否为hdr内容
    OH_Pixelmap_ImageInfo *pixelmapImageInfo = nullptr;
    OH_PixelmapImageInfo_Create(&pixelmapImageInfo);
    OH_PixelmapNative_GetImageInfo(resPixMap, pixelmapImageInfo);
    bool pixelmapIsHdr;
    OH_PixelmapImageInfo_GetDynamicRange(pixelmapImageInfo, &pixelmapIsHdr);
    OH_PixelmapImageInfo_Release(pixelmapImageInfo);

    // 获取图像帧数
    uint32_t frameCnt = 0;
    Image_ErrorCode errCode = OH_ImageSourceNative_GetFrameCount(source, &frameCnt);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_GetFrameCount failed, errCode: %{public}d.",
            errCode);
        return errCode;
    }

    // 通过图片解码参数创建Pixelmap列表
    OH_DecodingOptions *opts = nullptr;
    OH_DecodingOptions_Create(&opts);
    OH_PixelmapNative **resVecPixMap = nullptr;
    if (frameCnt > 0 && frameCnt <= MAX_FRAME_CNT) {
        resVecPixMap = new OH_PixelmapNative *[frameCnt];
    }
    size_t outSize = frameCnt;
    errCode = OH_ImageSourceNative_CreatePixelmapList(source, opts, resVecPixMap, outSize);
    OH_DecodingOptions_Release(opts);
    delete[] resVecPixMap;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_CreatePixelmapList failed, errCode: %{public}d.",
            errCode);
        return errCode;
    }
    
    int32_t *delayTimeList = nullptr;
    if (frameCnt > 0 && frameCnt <= MAX_FRAME_CNT) {
        // 获取图像延迟时间列表
        delayTimeList = new int32_t[frameCnt];
    }

    size_t size = frameCnt;
    errCode = OH_ImageSourceNative_GetDelayTimeList(source, delayTimeList, size);
    delete[] delayTimeList;
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_GetDelayTimeList failed, errCode: %{public}d.",
            errCode);
        return errCode;
    }
    return IMAGE_SUCCESS;
}

static napi_value sourceTest(napi_env env, napi_callback_info info)
{
    napi_value argValue[NUM_1] = {0};
    size_t argCount = NUM_1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < NUM_1 ||
        argValue[NUM_0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ImageSourceNativeCTest sourceTest napi_get_cb_info failed, argCount: %{public}d.",
                     argCount);
        return getJsResult(env, IMAGE_BAD_PARAMETER);
    }
    char name[NAME_SIZE];
    size_t nameSize = NAME_SIZE;
    napi_get_value_string_utf8(env, argValue[NUM_0], name, NAME_SIZE, &nameSize);
    
    // 创建ImageSource实例
    OH_ImageSourceNative *source = nullptr;
    Image_ErrorCode errCode = OH_ImageSourceNative_CreateFromUri(name, nameSize, &source);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImageSourceNativeCTest sourceTest OH_ImageSourceNative_CreateFromUri failed, errCode: %{public}d.",
            errCode);
        return getJsResult(env, errCode);
    }
    
    OH_PixelmapNative *resPixMap = nullptr;
    errCode = CreatePixelMap(source, resPixMap);
    if (errCode != IMAGE_SUCCESS) {
        return getJsResult(env, errCode);
    }
    
    errCode = GetPixelMapInfo(source, resPixMap);
    if (errCode != IMAGE_SUCCESS) {
        return getJsResult(env, errCode);
    }
    
    // 释放ImageSource实例
    OH_ImageSourceNative_Release(source);
    OH_LOG_INFO(LOG_APP, "ImageSourceNativeCTest sourceTest success.");
    return getJsResult(env, IMAGE_SUCCESS);
}
// [End ndk_pixelmap_source]