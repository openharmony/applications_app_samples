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

#include <multimedia/image_framework/image/pixelmap_native.h>
#include <native_drawing/drawing_image.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_region.h>
#include <native_drawing/drawing_round_rect.h>
#include <native_drawing/drawing_sampling_options.h>
#include <native_drawing/drawing_pixel_map.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_shader_effect.h>
#include <native_drawing/drawing_gpu_context.h>
#include <native_drawing/drawing_surface.h>
#include <native_drawing/drawing_path_effect.h>
#include <native_drawing/drawing_color_filter.h>
#include <native_drawing/drawing_filter.h>
#include <native_drawing/drawing_image_filter.h>
#include <native_drawing/drawing_mask_filter.h>
#include <native_drawing/drawing_matrix.h>
#include "sample_graphics.h"
#include "common/log_common.h"

void SampleGraphics::DrawCustomPixelMap(OH_Drawing_Canvas *canvas)
{
    uint32_t width = 600;
    uint32_t height = 400;
    // 字节长度，RGBA_8888每个像素占4字节
    size_t bufferSize = width * height * 4;
    uint8_t *pixels = new uint8_t[bufferSize];
    for (uint32_t i = 0; i < width * height; ++i) {
        // 遍历并编辑每个像素，从而形成红绿蓝相间的条纹，间隔20
        uint32_t n = i / 20 % 3;
        pixels[i * rgbaSize_] = rgbaMin_;
        pixels[i * rgbaSize_ + indexOne_] = rgbaMin_;
        pixels[i * rgbaSize_ + indexTwo_] = rgbaMin_;
        pixels[i * rgbaSize_ + indexThree_] = rgbaMax_;
        if (n == 0) {
            pixels[i * rgbaSize_] = rgbaMax_;
        } else if (n == 1) {
            pixels[i * rgbaSize_ + indexOne_] = rgbaMax_;
        } else {
            pixels[i * rgbaSize_ + indexTwo_] = rgbaMax_;
        }
    }
    // 设置位图格式（长、宽、颜色类型、透明度类型）
    OH_Pixelmap_InitializationOptions *createOps = nullptr;
    OH_PixelmapInitializationOptions_Create(&createOps);
    OH_PixelmapInitializationOptions_SetWidth(createOps, width);
    OH_PixelmapInitializationOptions_SetHeight(createOps, height);
    OH_PixelmapInitializationOptions_SetPixelFormat(createOps, PIXEL_FORMAT_RGBA_8888);
    OH_PixelmapInitializationOptions_SetAlphaType(createOps, PIXELMAP_ALPHA_TYPE_UNKNOWN);
    // 创建OH_PixelmapNative对象
    OH_PixelmapNative *pixelMapNative = nullptr;
    OH_PixelmapNative_CreatePixelmap(pixels, bufferSize, createOps, &pixelMapNative);
    // 利用OH_PixelmapNative对象创建PixelMap对象
    OH_Drawing_PixelMap *pixelMap = OH_Drawing_PixelMapGetFromOhPixelMapNative(pixelMapNative);
    OH_Drawing_Rect *src = OH_Drawing_RectCreate(0, 0, width, height);
    OH_Drawing_Rect *dst = OH_Drawing_RectCreate(value200_, value200_, value800_, value600_);
    OH_Drawing_SamplingOptions* samplingOptions = OH_Drawing_SamplingOptionsCreate(
        OH_Drawing_FilterMode::FILTER_MODE_LINEAR, OH_Drawing_MipmapMode::MIPMAP_MODE_LINEAR);
    // 绘制PixelMap
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, src, dst, samplingOptions);
    OH_PixelmapNative_Release(pixelMapNative);
    OH_Drawing_PixelMapDissolve(pixelMap);
    OH_Drawing_RectDestroy(src);
    OH_Drawing_RectDestroy(dst);
    OH_Drawing_SamplingOptionsDestroy(samplingOptions);
    delete[] pixels;
}

void SampleGraphics::DrawPixelMapRect(OH_Drawing_Canvas *canvas)
{
    // 从NativePixelMap中获取PixelMap对象
    OH_Drawing_PixelMap *pixelMap = OH_Drawing_PixelMapGetFromNativePixelMap(nativePixelMap_);
    OH_Drawing_SamplingOptions *sampling = OH_Drawing_SamplingOptionsCreate(FILTER_MODE_LINEAR, MIPMAP_MODE_NONE);
    float width = value400_;
    float height = value400_;
    OH_Drawing_Rect *src = OH_Drawing_RectCreate(0, 0, width, height);
    OH_Drawing_Rect *dst = OH_Drawing_RectCreate(value100_, value100_, value700_, value700_);
    // 绘制PixelMap
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, src, dst, sampling);
    // 解除NativePixelMap和PixelMap的关联
    OH_Drawing_PixelMapDissolve(pixelMap);
    OH_Drawing_SamplingOptionsDestroy(sampling);
    OH_Drawing_RectDestroy(src);
    OH_Drawing_RectDestroy(dst);
}

void SampleGraphics::DrawBitmap(OH_Drawing_Canvas *canvas)
{
    // 创建一个bitmap对象
    OH_Drawing_Bitmap* bitmap1 = OH_Drawing_BitmapCreate();
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    uint64_t width = width_ / 2;
    uint64_t height = height_ / 2;
    // 构建bitmap对象
    OH_Drawing_BitmapBuild(bitmap1, width, height, &cFormat);
    OH_Drawing_Canvas* newCanvas = OH_Drawing_CanvasCreate();
    OH_Drawing_CanvasBind(newCanvas, bitmap1);
    OH_Drawing_CanvasClear(newCanvas, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 获取位图宽高
    SAMPLE_LOGI("Bitmap-->width=%{public}d,height=%{public}d", OH_Drawing_BitmapGetWidth(bitmap1),
        OH_Drawing_BitmapGetHeight(bitmap1));
    // 获取像素
    void *pixels = OH_Drawing_BitmapGetPixels(bitmap1);
    OH_Drawing_Image_Info imageInfo;
    imageInfo.width = width;
    imageInfo.height = height;
    imageInfo.colorType = COLOR_FORMAT_RGBA_8888;
    imageInfo.alphaType = ALPHA_FORMAT_OPAQUE;
    // 通过像素创建一个bitmap对象
    OH_Drawing_Bitmap* bitmap2 = OH_Drawing_BitmapCreateFromPixels(&imageInfo, pixels, width * 4);
    OH_Drawing_CanvasDrawBitmap(canvas, bitmap1, 0, 0);
    OH_Drawing_CanvasDrawBitmap(canvas, bitmap2, width, height);
    OH_Drawing_CanvasDestroy(newCanvas);
    OH_Drawing_BitmapDestroy(bitmap1);
    OH_Drawing_BitmapDestroy(bitmap2);
}

void SampleGraphics::DrawImage(OH_Drawing_Canvas *canvas)
{
    // 创建一个bitmap对象
    OH_Drawing_Bitmap* bitmap = OH_Drawing_BitmapCreate();
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    uint64_t width = width_ / 2;
    uint64_t height = height_ / 2;
    OH_Drawing_BitmapBuild(bitmap, width, height, &cFormat);
    OH_Drawing_Canvas* newCanvas = OH_Drawing_CanvasCreate();
    OH_Drawing_CanvasBind(newCanvas, bitmap);
    OH_Drawing_CanvasClear(newCanvas, OH_Drawing_ColorSetArgb(rgbaMax_, rgbaMax_, rgbaMin_, rgbaMin_));
    // 创建image对象
    OH_Drawing_Image* image = OH_Drawing_ImageCreate();
    // 从bitmap构建image
    OH_Drawing_ImageBuildFromBitmap(image, bitmap);
    // 获取Image宽高
    SAMPLE_LOGI("Image-->width=%{public}d,height=%{public}d", OH_Drawing_ImageGetWidth(image),
        OH_Drawing_ImageGetHeight(image));
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(0, 0, width / 2, height / 2);
    OH_Drawing_SamplingOptions* options = OH_Drawing_SamplingOptionsCreate(
        OH_Drawing_FilterMode::FILTER_MODE_LINEAR, OH_Drawing_MipmapMode::MIPMAP_MODE_LINEAR);
    OH_Drawing_CanvasDrawImageRect(canvas, image, rect, options);
    // 销毁对象
    OH_Drawing_CanvasDestroy(newCanvas);
    OH_Drawing_BitmapDestroy(bitmap);
    OH_Drawing_ImageDestroy(image);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_SamplingOptionsDestroy(options);
}
