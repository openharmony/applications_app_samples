/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef SAMPLE_BITMAP_H
#define SAMPLE_BITMAP_H
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arpa/nameser.h>
#include <bits/alltypes.h>
#include <native_window/external_window.h>
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_path.h>
#include <cstdint>
#include <map>
#include <sys/mman.h>
#include <string>
#include "napi/native_api.h"

#define DECLARE_NAPI_FUNC(nativeFunc)                                                                                  \
    static napi_value Napi##nativeFunc(napi_env env, napi_callback_info info);                                         \
    void nativeFunc()

class SampleBitMap {
public:
    SampleBitMap() = default;
    ~SampleBitMap();
    explicit SampleBitMap(std::string id) : id_(id) {}
    DECLARE_NAPI_FUNC(DrawMultilingualText);
    DECLARE_NAPI_FUNC(DrawBreakAllText);
    DECLARE_NAPI_FUNC(DrawBreakWordText);
    DECLARE_NAPI_FUNC(DrawBreakHyphenText);
    DECLARE_NAPI_FUNC(DrawBreakHyphenGBText);
    DECLARE_NAPI_FUNC(DrawBreakHyphenUSText);
    DECLARE_NAPI_FUNC(DrawDecorationText);
    DECLARE_NAPI_FUNC(DrawFontFeatureText);
    DECLARE_NAPI_FUNC(DrawFontVariationText);
    DECLARE_NAPI_FUNC(DrawShadowText);
    DECLARE_NAPI_FUNC(DrawPlaceholderText);
    DECLARE_NAPI_FUNC(DrawAutoSpaceText);
    DECLARE_NAPI_FUNC(DrawGradientText);
    DECLARE_NAPI_FUNC(DrawVerticalAlignmentText);
    DECLARE_NAPI_FUNC(DrawBadgeText);
    DECLARE_NAPI_FUNC(DrawHighContrastText);
    DECLARE_NAPI_FUNC(DrawLineHeightLimitOneText);
    DECLARE_NAPI_FUNC(DrawLineHeightLimitTwoText);
    DECLARE_NAPI_FUNC(DrawLineSpacingText);
    DECLARE_NAPI_FUNC(DrawStyleCopyText);
    DECLARE_NAPI_FUNC(DrawIndependentShapingText);

    static napi_value NapiBaseFunc(napi_env env, napi_callback_info info, std::function<void(SampleBitMap *)> func,
                                   const std::string &name);
    static void Release(std::string &id);
    void SetWidth(uint64_t width);
    void SetHeight(uint64_t height);
    void SetNativeWindow(OHNativeWindow *nativeWindow);
    void Prepare();
    void Create();
    void DisPlay();
    void Export(napi_env env, napi_value exports);
    void RegisterCallback(OH_NativeXComponent *nativeXComponent);
    void Destroy();
    static SampleBitMap *GetInstance(std::string &id);
    std::string id_;

private:
    OH_NativeXComponent_Callback renderCallback_;

    uint64_t width_ = 0;
    uint64_t height_ = 0;

    OH_Drawing_Bitmap *cBitmap_ = nullptr;
    OH_Drawing_Canvas *cCanvas_ = nullptr;

    OH_Drawing_Path *cPath_ = nullptr;
    OH_Drawing_Brush *cBrush_ = nullptr;
    OH_Drawing_Pen *cPen_ = nullptr;
    OHNativeWindow *nativeWindow_ = nullptr;
    uint32_t *mappedAddr_ = nullptr;
    BufferHandle *bufferHandle_ = nullptr;
    struct NativeWindowBuffer *buffer_ = nullptr;
    int fenceFd_ = 0;
};


#endif