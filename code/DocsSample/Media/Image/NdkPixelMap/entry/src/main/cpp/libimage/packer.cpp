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

// [Start ndk_pixelmap_packer]
#include <linux/kd.h>
#include <string>

#include <hilog/log.h>
#include <multimedia/image_framework/image/image_packer_native.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <multimedia/image_framework/image/image_source_native.h>
#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_TAG"
#include <cstdlib>
#include <fcntl.h>

const uint8_t OPTIONS_WIDTH = 6;
const uint8_t OPTIONS_HEIGHT = 4;
const uint8_t OPTIONS_PIXELFORMAT = 3;
const uint8_t OPTIONS_ALPHATYPE = 0;

static Image_ErrorCode packToFileFromImageSourceTest(int fd)
{
    // 创建ImagePacker实例
    OH_ImagePackerNative *testPacker = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP,
                     "ImagePackerNativeCTest CreatePacker OH_ImagePackerNative_Create failed, errCode: %{public}d.",
                     errCode);
        return errCode;
    }

    // 创建ImageSource实例
    OH_ImageSourceNative *imageSource = nullptr;
    errCode = OH_ImageSourceNative_CreateFromFd(fd, &imageSource);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ImagePackerNativeCTest OH_ImageSourceNative_CreateFromFd  failed, errCode: %{public}d.",
                     errCode);
        return errCode;
    }

    // 指定打包参数，将ImageSource图片源编码后直接打包进文件
    OH_PackingOptions *option = nullptr;
    OH_PackingOptions_Create(&option);
    char type[] = "image/jpeg";
    Image_MimeType image_MimeType = {type, strlen(type)};
    OH_PackingOptions_SetMimeType(option, &image_MimeType);
    // 编码为hdr内容(需要资源本身为hdr，支持jpeg格式)
    OH_PackingOptions_SetDesiredDynamicRange(option, IMAGE_PACKER_DYNAMIC_RANGE_AUTO);
    OH_PackingOptions_SetNeedsPackProperties(option, true);
    errCode = OH_ImagePackerNative_PackToFileFromImageSource(testPacker, option, imageSource, fd);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(
            LOG_APP,
            "ImagePackerNativeCTest OH_ImagePackerNative_PackToFileFromImageSource failed, errCode: %{public}d.",
            errCode);
        return errCode;
    }

    // 释放ImagePacker实例
    errCode = OH_ImagePackerNative_Release(testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP,
                     "ImagePackerNativeCTest ReleasePacker OH_ImagePackerNative_Release failed, errCode: %{public}d.",
                     errCode);
        return errCode;
    }
    // 释放ImageSource实例
    errCode = OH_ImageSourceNative_Release(imageSource);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP,
                     "ImagePackerNativeCTest ReleasePacker OH_ImageSourceNative_Release failed, errCode: %{public}d.",
                     errCode);
        return errCode;
    }

    return IMAGE_SUCCESS;
}

static Image_ErrorCode packToFileFromPixelmapTest(uint8_t *buffer, size_t buffSize, int fd)
{
    // 创建ImagePacker实例
    OH_ImagePackerNative *testPacker = nullptr;
    Image_ErrorCode errCode = OH_ImagePackerNative_Create(&testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "CreatePacker OH_ImagePackerNative_Create failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 创建Pixelmap实例
    OH_Pixelmap_InitializationOptions *createOpts;
    OH_PixelmapInitializationOptions_Create(&createOpts);
    OH_PixelmapInitializationOptions_SetWidth(createOpts, OPTIONS_WIDTH);
    OH_PixelmapInitializationOptions_SetHeight(createOpts, OPTIONS_HEIGHT);
    OH_PixelmapInitializationOptions_SetPixelFormat(createOpts, OPTIONS_PIXELFORMAT);
    OH_PixelmapInitializationOptions_SetAlphaType(createOpts, OPTIONS_ALPHATYPE);
    OH_PixelmapNative *pixelmap = nullptr;
    errCode = OH_PixelmapNative_CreatePixelmap(buffer, buffSize, createOpts, &pixelmap);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_PixelmapNative_CreatePixelmap  failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 指定打包参数，将PixelMap图片源编码后直接打包进文件
    OH_PackingOptions *option = nullptr;
    OH_PackingOptions_Create(&option);
    char type[] = "image/jpeg";
    Image_MimeType image_MimeType = {type, strlen(type)};
    OH_PackingOptions_SetMimeType(option, &image_MimeType);
    OH_PackingOptions_SetNeedsPackProperties(option, true);
    errCode = OH_ImagePackerNative_PackToFileFromPixelmap(testPacker, option, pixelmap, fd);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "OH_ImagePackerNative_PackToFileFromPixelmap failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 释放ImagePacker实例
    errCode = OH_ImagePackerNative_Release(testPacker);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ReleasePacker OH_ImagePackerNative_Release failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 释放Pixelmap实例
    errCode = OH_PixelmapNative_Release(pixelmap);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ReleasePacker OH_PixelmapNative_Release failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    return IMAGE_SUCCESS;
}
// [End ndk_pixelmap_packer]