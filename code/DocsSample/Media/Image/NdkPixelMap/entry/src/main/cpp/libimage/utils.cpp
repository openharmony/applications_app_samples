/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start ndk_pixelmap_extract_average_color]
#include <cmath>
#include <hilog/log.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

// 颜色结构体。
struct AverageColor {
    uint8_t r;
    uint8_t g;
    uint8_t b;
};

// 提取图片平均颜色。
// 基本思路：
// 1. 将原始PixelMap缩放到较小尺寸（如32×32像素），减少像素数量以提高计算效率。
// 2. 读取缩放后的像素数据。
// 3. 遍历所有像素，累加R、G、B通道的值。
// 4. 计算各通道的平均值作为最终颜色。
static Image_ErrorCode ExtractAverageColor(OH_PixelmapNative* pixelmap, AverageColor& avgColor)
{
    if (pixelmap == nullptr) {
        OH_LOG_ERROR(LOG_APP, "ExtractAverageColor: pixelmap is nullptr");
        return IMAGE_BAD_PARAMETER;
    }

    // 获取原始图片信息，判断是否需要缩放。
    OH_Pixelmap_ImageInfo* imageInfo;
    OH_PixelmapImageInfo_Create(&imageInfo);
    Image_ErrorCode errCode = OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ExtractAverageColor: GetImageInfo failed, errCode: %{public}d", errCode);
        OH_PixelmapImageInfo_Release(imageInfo);
        return errCode;
    }

    uint32_t width, height;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &width);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &height);
    OH_PixelmapImageInfo_Release(imageInfo);

    // 定义缩小后的目标尺寸（32×32像素是经验值，平衡性能和准确度）。
    const uint32_t SAMPLE_SIZE = 32;

    // 如果图片较大，先进行缩放处理。
    if (width > SAMPLE_SIZE || height > SAMPLE_SIZE) {
        // 计算缩放比例。
        double scaleX = (double)SAMPLE_SIZE / width;
        double scaleY = (double)SAMPLE_SIZE / height;

        // 对图片进行缩放。
        errCode = OH_PixelmapNative_Scale(pixelmap, scaleX, scaleY);
        if (errCode != IMAGE_SUCCESS) {
            OH_LOG_ERROR(LOG_APP, "ExtractAverageColor: Scale failed, errCode: %{public}d", errCode);
            OH_PixelmapNative_Release(pixelmap);
            return errCode;
        }
    } else {
        // 图片较小，直接使用原图。
        pixelmap = pixelmap;
    }

    // 重新获取缩放后的图片信息。
    OH_PixelmapImageInfo_Create(&imageInfo);
    errCode = OH_PixelmapNative_GetImageInfo(pixelmap, imageInfo);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ExtractAverageColor: GetImageInfo after scale failed, errCode: %{public}d", errCode);
        OH_PixelmapImageInfo_Release(imageInfo);
        return errCode;
    }

    uint32_t scaledWidth, scaledHeight, rowStride;
    int32_t pixelFormat, alphaType;
    OH_PixelmapImageInfo_GetWidth(imageInfo, &scaledWidth);
    OH_PixelmapImageInfo_GetHeight(imageInfo, &scaledHeight);
    OH_PixelmapImageInfo_GetRowStride(imageInfo, &rowStride);
    OH_PixelmapImageInfo_GetPixelFormat(imageInfo, &pixelFormat);
    OH_PixelmapImageInfo_GetAlphaType(imageInfo, &alphaType);
    OH_PixelmapImageInfo_Release(imageInfo);
    if (pixelFormat != PIXEL_FORMAT_RGBA_8888) {
        // 此案例中只处理RGBA格式。
        return IMAGE_BAD_SOURCE;
    }

    // 读取像素数据。
    size_t bufferSize = rowStride * scaledHeight;
    uint8_t* pixelData = new uint8_t[bufferSize];
    errCode = OH_PixelmapNative_ReadPixels(pixelmap, pixelData, &bufferSize);
    if (errCode != IMAGE_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "ExtractAverageColor: ReadPixels failed, errCode: %{public}d", errCode);
        delete[] pixelData;
        return errCode;
    }

    // 根据像素格式确定每像素字节数。
    constexpr int bytesPerPixel = 4; // 默认RGBA_8888

    // 累加RGB值。
    uint64_t totalR = 0, totalG = 0, totalB = 0;
    uint32_t pixelCount = 0;

    for (uint32_t y = 0; y < scaledHeight; y++) {
        for (uint32_t x = 0; x < scaledWidth; x++) {
            size_t offset = y * rowStride + x * bytesPerPixel;
            // RGBA_8888格式：R-G-B-A
            totalR += pixelData[offset];
            totalG += pixelData[offset + 1];
            totalB += pixelData[offset + 2];
            pixelCount++;
        }
    }

    // 释放资源。
    delete[] pixelData;
    // 计算平均值。
    if (pixelCount > 0) {
        avgColor.r = (uint8_t)(totalR / pixelCount);
        avgColor.g = (uint8_t)(totalG / pixelCount);
        avgColor.b = (uint8_t)(totalB / pixelCount);
    } else {
        avgColor.r = 0;
        avgColor.g = 0;
        avgColor.b = 0;
    }

    OH_LOG_INFO(LOG_APP,
        "ExtractAverageColor success, avgColor: R=%{public}d, G=%{public}d, B=%{public}d, pixelCount=%{public}d",
        avgColor.r, avgColor.g, avgColor.b, pixelCount);

    return IMAGE_SUCCESS;
}
// [End ndk_pixelmap_extract_average_color]