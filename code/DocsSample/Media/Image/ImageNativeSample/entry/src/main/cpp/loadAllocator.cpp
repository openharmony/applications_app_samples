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
// [Start allocator_operations]
#include <cstring>
#include <hilog/log.h>
#include <multimedia/image_framework/image/image_common.h>
#include <multimedia/image_framework/image/pixelmap_native.h>
#include <multimedia/image_framework/image/image_source_native.h>
// [StartExclude allocator_operations]
#include <imageKits.h>
// [EndExclude allocator_operations]

// 根据像素格式返回每像素的字节数。
int32_t GetPixelFormatBytes(int32_t pixelFormat)
{
    switch (pixelFormat) {
        case PIXEL_FORMAT_RGB_565:
            return 2; // 每像素2字节。
        case PIXEL_FORMAT_RGBA_8888:
        case PIXEL_FORMAT_BGRA_8888:
            return 4; // 每像素4字节。
        case PIXEL_FORMAT_RGB_888:
            return 3; // 每像素3字节。
        case PIXEL_FORMAT_ALPHA_8:
            return 1; // 每像素1字节。
        case PIXEL_FORMAT_RGBA_F16:
            return 8; // 每通道16位浮点数，共4通道，合计8字节。
        case PIXEL_FORMAT_NV21:
        case PIXEL_FORMAT_NV12:
            // NV21和NV12格式是YUV 4:2:0半平面格式，返回2作为每像素字节。
            return 2; // 每像素2字节（简化处理）。
        case PIXEL_FORMAT_RGBA_1010102:
            return 4; // 每像素4字节。
        case PIXEL_FORMAT_YCBCR_P010:
        case PIXEL_FORMAT_YCRCB_P010:
            return 2; // 每像素2字节。
        default:
            return 0; // 如果像素格式未知，返回0。
    }
}

struct PixelmapInfo {
    uint32_t width = 0;
    uint32_t height = 0;
    uint32_t rowStride = 0;
    int32_t pixelFormat = 0;
    uint32_t byteCount = 0;
    uint32_t allocationByteCount = 0;
};

static void GetPixelmapInfo(OH_PixelmapNative *pixelmap, PixelmapInfo *info)
{
    OH_Pixelmap_ImageInfo *srcInfo = nullptr;
    OH_PixelmapImageInfo_Create(&srcInfo);
    OH_PixelmapNative_GetImageInfo(pixelmap, srcInfo);
    OH_PixelmapImageInfo_GetWidth(srcInfo, &info->width);
    OH_PixelmapImageInfo_GetHeight(srcInfo, &info->height);
    OH_PixelmapImageInfo_GetRowStride(srcInfo, &info->rowStride);
    OH_PixelmapImageInfo_GetPixelFormat(srcInfo, &info->pixelFormat);
    OH_PixelmapImageInfo_Release(srcInfo);
    srcInfo = nullptr;
    return;
}

static void GetPixelmapAddrInfo(OH_PixelmapNative *pixelmap, PixelmapInfo *info)
{
    OH_PixelmapNative_GetByteCount(pixelmap, &info->byteCount);
    OH_PixelmapNative_GetAllocationByteCount(pixelmap, &info->allocationByteCount);
    return;
}

void DataCopy(OH_PixelmapNative *pixelmap, OH_ImageSourceNative* imageSource, OH_DecodingOptions *options,
              IMAGE_ALLOCATOR_TYPE allocatorType)
{
    PixelmapInfo srcInfo;
    GetPixelmapInfo(pixelmap, &srcInfo);
    GetPixelmapAddrInfo(pixelmap, &srcInfo);

    void *pixels = nullptr;
    OH_PixelmapNative_AccessPixels(pixelmap, &pixels);
    OH_PixelmapNative *newPixelmap = nullptr;
    OH_ImageSourceNative_CreatePixelmap(imageSource, options, &newPixelmap);
    uint32_t dstRowStride = srcInfo.width * GetPixelFormatBytes(srcInfo.pixelFormat);
    void *newPixels = nullptr;
    OH_PixelmapNative_AccessPixels(newPixelmap, &newPixels);
    uint8_t *src = reinterpret_cast<uint8_t *>(pixels);
    uint8_t *dst = reinterpret_cast<uint8_t *>(newPixels);
    uint32_t dstSize = srcInfo.byteCount;
    uint32_t rowSize;
    if (allocatorType == IMAGE_ALLOCATOR_TYPE::IMAGE_ALLOCATOR_TYPE_DMA) {
        rowSize = srcInfo.rowStride;
    } else {
        rowSize = dstRowStride;
    }
    for (uint32_t i = 0; i < srcInfo.height; ++i) {
        if (dstSize >= dstRowStride) {
            std::copy(src, src + dstRowStride, dst);
        } else {
            break;
        }
        src += rowSize;
        dst += dstRowStride;
        dstSize -= dstRowStride;
    }
    OH_PixelmapNative_UnaccessPixels(newPixelmap);
    OH_PixelmapNative_UnaccessPixels(pixelmap);
    OH_DecodingOptions_Release(options);
    options = nullptr;
    OH_ImageSourceNative_Release(imageSource);
    imageSource = nullptr;
    OH_PixelmapNative_Release(pixelmap);
    pixelmap = nullptr;
    OH_PixelmapNative_Release(newPixelmap);
    newPixelmap = nullptr;
}

napi_value TestStrideWithAllocatorType(napi_env env, napi_callback_info info)
{
    napi_value argValue[1] = {nullptr};
    size_t argCount = 1;
    if (napi_get_cb_info(env, info, &argCount, argValue, nullptr, nullptr) != napi_ok || argCount < 1 ||
        argValue[0] == nullptr) {
        OH_LOG_ERROR(LOG_APP, "CreateImageSource napi_get_cb_info failed!");
        return GetJsResult(env, IMAGE_BAD_PARAMETER);
    }
    
    const size_t maxPathLength = 1024;
    char filePath[maxPathLength];
    size_t pathSize = maxPathLength;
    napi_get_value_string_utf8(env, argValue[0], filePath, maxPathLength, &pathSize);

    OH_ImageSourceNative* imageSource = nullptr;
    Image_ErrorCode image_ErrorCode = OH_ImageSourceNative_CreateFromUri(filePath, pathSize, &imageSource);
    OH_DecodingOptions *options = nullptr;
    OH_DecodingOptions_Create(&options);
    IMAGE_ALLOCATOR_TYPE allocatorType = IMAGE_ALLOCATOR_TYPE::IMAGE_ALLOCATOR_TYPE_DMA;  // 使用DMA创建pixelMap。
    OH_PixelmapNative *pixelmap = nullptr;
    image_ErrorCode = OH_ImageSourceNative_CreatePixelmapUsingAllocator(imageSource, options, allocatorType, &pixelmap);
    DataCopy(pixelmap, imageSource, options, allocatorType);
    return GetJsResult(env, image_ErrorCode);
}
// [End allocator_operations]
