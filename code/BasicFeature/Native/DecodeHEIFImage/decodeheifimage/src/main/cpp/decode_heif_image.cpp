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

#include "decode_heif_image.h"
#include <cstring>
#include <hilog/log.h>
#include "common.h"
#include <algorithm>

#include "libheif/heif.h"

DecodeHEIFImage::DecodeHEIFImage() {}  // 构造函数
DecodeHEIFImage::~DecodeHEIFImage() {} // 析构函数

// 定义颜色编码格式转换函数
void DecodeHEIFImage::swapRBChannels(uint8_t *pixels, int pixelCount)
{
    for (int i = 0; i < pixelCount; i++) {
        std::swap(pixels[i * 4], pixels[i * 4 + 2]); // 2,4
    }
}

// 上下文初始化
static heif_context* InitHeifContext(const MemoryStruct& chunk)
{
    heif_context* ctx = heif_context_alloc();
    if (!ctx) {
        OH_LOG_ERROR(LOG_APP, "heif_context_alloc failed");
        return nullptr;
    }

    heif_error err = heif_context_read_from_memory_without_copy(ctx, chunk.memory, chunk.size, nullptr);
    if (err.code != heif_error_Ok) {
        OH_LOG_ERROR(LOG_APP, "heif_context_read failed: %{public}s", err.message);
        heif_context_free(ctx);
        return nullptr;
    }
    return ctx;
}

// 获取主句柄
static heif_image_handle* GetPrimaryHandle(heif_context* ctx)
{
    heif_image_handle* handle = nullptr;
    heif_error err = heif_context_get_primary_image_handle(ctx, &handle);
    if (err.code != heif_error_Ok || !handle) {
        OH_LOG_ERROR(LOG_APP, "heif_context_get_primary failed: %{public}s", err.message);
        heif_context_free(ctx);
        return nullptr;
    }
    return handle;
}

// 解码图像数据
static heif_image* DecodeImageData(heif_image_handle* handle)
{
    heif_image* heif_img = nullptr;
    heif_error err = heif_decode_image(handle, &heif_img,
        heif_colorspace_RGB, heif_chroma_interleaved_RGBA, nullptr);
    if (err.code != heif_error_Ok || !heif_img) {
        OH_LOG_ERROR(LOG_APP, "heif_decode_image failed: %{public}s", err.message);
        heif_image_handle_release(handle);
        return nullptr;
    }
    return heif_img;
}

// 获取像素数据
static const uint8_t* GetPixelData(heif_image* heif_img, int& width, int& height, int& stride)
{
    width = heif_image_get_width(heif_img, heif_channel_interleaved);
    height = heif_image_get_height(heif_img, heif_channel_interleaved);
    stride = 0;

    const uint8_t* data = heif_image_get_plane_readonly(heif_img, heif_channel_interleaved, &stride);
    if (!data) {
        OH_LOG_ERROR(LOG_APP, "heif_image_get_plane failed");
        heif_image_release(heif_img);
        return nullptr;
    }
    return data;
}

static uint8_t* ProcessStrideAlignment(const uint8_t* srcData, int width, int height, int srcStride)
{
    const size_t bpp = 4; // 4
    const size_t dstStride = width * bpp;

    if (srcStride == dstStride) {
        return const_cast<uint8_t*>(srcData);
    }

    uint8_t* alignedData = new (std::nothrow) uint8_t[height * dstStride];
    if (!alignedData) {
        OH_LOG_ERROR(LOG_APP, "Memory allocation failed");
        return nullptr;
    }

    for (int row = 0; row < height; ++row) {
        std::copy(
            srcData + row * srcStride,          // 源起始地址（转换为迭代器）
            srcData + row * srcStride + dstStride, // 源结束地址（src起始地址 + 要复制的字节数）
            alignedData + row * dstStride);
    }

    return alignedData;
}

// 颜色格式转换
static void ConvertRGBAtoBGRA(uint8_t* data, size_t pixelCount)
{
    for (size_t i = 0; i < pixelCount * 4; i += 4) { //4
        std::swap(data[i], data[i + 2]);  // 2,Swap R and B channels
    }
}

// 解码主逻辑
DecodeResult* DecodeHEIFImage::decode_heif_image(MemoryStruct chunk)
{
    // 初始化上下文
    heif_context* ctx = InitHeifContext(chunk);
    if (!ctx) return nullptr;

    // 获取主句柄
    heif_image_handle* handle = GetPrimaryHandle(ctx);
    if (!handle) {
        heif_context_free(ctx);
        return nullptr;
    }

    // 解码图像
    heif_image* heif_img = DecodeImageData(handle);
    if (!heif_img) {
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return nullptr;
    }

    // 获取元数据
    int width = 0;
    int height = 0;
    int stride = 0;
    const uint8_t* src_data = GetPixelData(heif_img, width, height, stride);
    if (!src_data) {
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return nullptr;
    }

    // 处理字节对齐
    uint8_t* processed_data = ProcessStrideAlignment(src_data, width, height, stride);
    if (!processed_data) {
        heif_image_release(heif_img);
        heif_image_handle_release(handle);
        heif_context_free(ctx);
        return nullptr;
    }

    // 颜色转换
    ConvertRGBAtoBGRA(processed_data, width * height);

    // 资源释放, 此处不heif_image_release(heif_img); 由调用方delete processed_data数据时释放
    heif_image_handle_release(handle);
    heif_context_free(ctx);

    return new DecodeResult(processed_data, width * 4, width, height); // 4
}