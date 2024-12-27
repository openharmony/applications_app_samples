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

#include <linux/kd.h>
#include <string>

#include <hilog/log.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "MY_TAG"

const uint8_t DATA_SIZE = 96;
const uint8_t OPTS_WIDTH = 6;
const uint8_t OPTS_HEIGHT = 4;
const float OPACITY_VALUE = 0.5;
const float SCALE_X = 2.0;
const float SCALE_Y = 1.0;
const float TRANSLATE_X = 50.0;
const float TRANSLATE_Y = 10.0;
const float ROTATE_ANGLE = 90.0;
const uint8_t REGION_X = 100;
const uint8_t REGION_Y = 100;
const uint8_t REGION_WIDTH = 6;
const uint8_t REGION_HEIGHT = 4;

static Image_ErrorCode CreatePixelMap(OH_PixelmapNative **pixelmap)
{
    uint8_t data[DATA_SIZE];
    for (int i = 0; i < DATA_SIZE; i++) {
        data[i] = i + 1;
    }
    
    // 创建参数结构体实例，并设置参数
    OH_Pixelmap_InitializationOptions *createOpts;
    OH_PixelmapInitializationOptions_Create(&createOpts);
    OH_PixelmapInitializationOptions_SetWidth(createOpts, OPTS_WIDTH);
    OH_PixelmapInitializationOptions_SetHeight(createOpts, OPTS_HEIGHT);
    OH_PixelmapInitializationOptions_SetPixelFormat(createOpts, PIXEL_FORMAT_RGBA_8888);
    OH_PixelmapInitializationOptions_SetAlphaType(createOpts, PIXELMAP_ALPHA_TYPE_UNKNOWN);
    
    Image_ErrorCode errCode = OH_PixelmapNative_CreatePixelmap(data, DATA_SIZE, createOpts, pixelmap);

    // 读取图像像素数据，结果写入数组里
    uint8_t destination[DATA_SIZE];
    size_t destinationSize = DATA_SIZE;
    errCode = OH_PixelmapNative_ReadPixels(*pixelmap, destination, &destinationSize);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_ReadPixels failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 读取缓冲区中的图片数据，结果写入Pixelmap中
    uint8_t source[DATA_SIZE];
    size_t sourceSize = DATA_SIZE;
    for (int i = 0; i < sourceSize; i++) {
        source[i] = i + 1;
    }
    errCode = OH_PixelmapNative_WritePixels(*pixelmap, source, sourceSize);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_WritePixels failed, errCode:%{public}d.", errCode);
        return errCode;
    }

    // 创建图片信息实例，并获取图像像素信息
    OH_Pixelmap_ImageInfo *imageInfo;
    OH_PixelmapImageInfo_Create(&imageInfo);
    errCode = OH_PixelmapNative_GetImageInfo(*pixelmap, imageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_GetImageInfo failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 获取图片的宽，高，pixel格式，透明度等信息
    uint32_t width, height, rowStride;
    int32_t pixelFormat, alphaType;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &height);
    OH_PixelmapImageInfo_GetRowStride(imageInfo, &rowStride);
    OH_PixelmapImageInfo_GetPixelFormat(imageInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetAlphaType(imageInfo, &alphaType);
    OH_PixelmapImageInfo_Release(imageInfo);
    OH_LOG_INFO(LOG_APP, "pixelmapTest GetImageInfo success, width:%{public}d, height:%{public}d, rowStride:"
        "%{public}d, pixelFormat:%{public}d, alphaType:%{public}d.", width, height, rowStride, pixelFormat, alphaType);
    
    OH_PixelmapInitializationOptions_Release(createOpts);
    return IMAGE_SUCCESS;
}

static Image_ErrorCode PixelmapTest()
{
    // 创建Pixelmap实例
    OH_PixelmapNative *pixelmap = nullptr;

    Image_ErrorCode errCode = CreatePixelMap(&pixelmap);
    if (errCode != IMAGE_SUCCESS) {
        return errCode;
    }

    // 设置透明比率来让Pixelap达到对应的透明效果
    errCode = OH_PixelmapNative_Opacity(pixelmap, OPACITY_VALUE);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Opacity failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 对图片进行缩放
    errCode = OH_PixelmapNative_Scale(pixelmap, SCALE_X, SCALE_Y);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Scale failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 对图片进行位置变换
    errCode = OH_PixelmapNative_Translate(pixelmap, TRANSLATE_X, TRANSLATE_Y);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Translate failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 对图片进行旋转
    errCode = OH_PixelmapNative_Rotate(pixelmap, ROTATE_ANGLE);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Rotate failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 对图片进行翻转
    errCode = OH_PixelmapNative_Flip(pixelmap, true, true);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Flip failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 对图片进行裁剪
    Image_Region region;
    region.x = REGION_X;
    region.y = REGION_Y;
    region.width = REGION_WIDTH;
    region.height = REGION_HEIGHT;
    errCode = OH_PixelmapNative_Crop(pixelmap, &region);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "pixelmapTest OH_PixelmapNative_Crop failed, errCode: %{public}d.", errCode);
        return errCode;
    }

    // 释放Pixelmap, InitializationOptions实例
    OH_PixelmapNative_Release(pixelmap);
    return IMAGE_SUCCESS;
}