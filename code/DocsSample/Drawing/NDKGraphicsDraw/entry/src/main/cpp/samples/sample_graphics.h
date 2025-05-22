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

#ifndef SAMPLE_GRAPHICS_H
#define SAMPLE_GRAPHICS_H
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <native_window/external_window.h>
// [Start ndk_graphics_draw_include_native_drawing_canvas_and_bitmap]
#include <native_drawing/drawing_bitmap.h>
// [StartExclude ndk_graphics_draw_include_native_drawing_canvas_and_bitmap]
#include <native_drawing/drawing_color.h>
// [EndExclude ndk_graphics_draw_include_native_drawing_canvas_and_bitmap]
#include <native_drawing/drawing_canvas.h>
// [End ndk_graphics_draw_include_native_drawing_canvas_and_bitmap]
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_path.h>
#include <cstdint>
#include <unordered_map>
#include <string>
// [Start ndk_graphics_draw_include_egl_module]
#include <EGL/egl.h>
#include <EGL/eglext.h>
// [End ndk_graphics_draw_include_egl_module]
#include <GLES3/gl3.h>
#include "napi/native_api.h"


class SampleGraphics {
public:
    SampleGraphics() = default;
    ~SampleGraphics();
    explicit SampleGraphics(std::string id) : id_(id)
    {
        InitializeEglContext();
    }
    static napi_value Draw(napi_env env, napi_callback_info info);
    static void Release(std::string &id);
    void SetWidth(uint64_t width);
    void SetHeight(uint64_t height);
    void SetNativeWindow(OHNativeWindow *nativeWindow);
    
    // 画布操作
    void DrawClipOperation(OH_Drawing_Canvas *canvas);
    void DrawTranslationOperation(OH_Drawing_Canvas *canvas);
    void DrawRotationOperation(OH_Drawing_Canvas *canvas);
    void DrawScaleOperation(OH_Drawing_Canvas *canvas);
    void DrawStateOperation(OH_Drawing_Canvas *canvas);
    // 绘制效果
    void DrawFilling(OH_Drawing_Canvas *canvas);
    void DrawStroke(OH_Drawing_Canvas *canvas);
    void DrawMixedMode(OH_Drawing_Canvas *canvas);
    void DrawPathEffect(OH_Drawing_Canvas *canvas);
    void DrawLinearGradient(OH_Drawing_Canvas *canvas);
    void DrawPathGradient(OH_Drawing_Canvas *canvas);
    void DrawSectorGradient(OH_Drawing_Canvas *canvas);
    void DrawColorFilter(OH_Drawing_Canvas *canvas);
    void DrawImageFilter(OH_Drawing_Canvas *canvas);
    void DrawMaskFilter(OH_Drawing_Canvas *canvas);
    // 图元绘制
    void DrawPoint(OH_Drawing_Canvas *canvas);
    void DrawArc(OH_Drawing_Canvas *canvas);
    void DrawCircle(OH_Drawing_Canvas *canvas);
    void DrawPath(OH_Drawing_Canvas *canvas);
    void DrawRegion(OH_Drawing_Canvas *canvas);
    void DrawRect(OH_Drawing_Canvas *canvas);
    void DrawRoundRect(OH_Drawing_Canvas *canvas);
    void DrawPixelMap(OH_Drawing_Canvas *canvas);
    void DrawBaseText(OH_Drawing_Canvas *canvas);
    void DrawStrokeText(OH_Drawing_Canvas *canvas);
    void DrawGradientText(OH_Drawing_Canvas *canvas);
    // 创建画布及绘图结果显示
    void Prepare();
    void Create();
    void CreateByCPU();
    void CreateByGPU();
    void DisPlay();
    void DisPlayCPU();
    void DisPlayGPU();
    
    void Export(napi_env env, napi_value exports);
    void RegisterCallback(OH_NativeXComponent *nativeXComponent);
    void Destroy();
    static SampleGraphics *GetInstance(std::string &id);
    std::string id_;
private:
    std::unordered_map<std::string,  void (SampleGraphics::*)(OH_Drawing_Canvas *)> drawFunctionMap_;
    void InitDrawFunction(std::string id);
    void DoRender(SampleGraphics *render, char* canvasType, char* shapeType);
    int32_t InitializeEglContext();
    void DeInitializeEglContext();
    OH_NativeXComponent_Callback renderCallback_;

    uint64_t width_ = 0;
    uint64_t height_ = 0;
    
    static float value100_;
    static float value150_;
    static float value200_;
    static float value300_;
    static float value400_;
    static float value500_;
    static float value551_;
    static float value600_;
    static float value630_;
    static float value700_;
    static float value800_;
    static float value900_;
    static float value1000_;
    static float value1200_;
    bool desc = false;

    // [Start ndk_graphics_draw_initialize_egl_context_parameter]
    EGLDisplay EGLDisplay_ = EGL_NO_DISPLAY;
    EGLConfig EGLConfig_ = nullptr;
    EGLContext EGLContext_ = EGL_NO_CONTEXT;
    EGLSurface EGLSurface_ = nullptr;
    // [End ndk_graphics_draw_initialize_egl_context_parameter]
    
    OH_Drawing_Bitmap *cScreenBitmap_ = nullptr;
    OH_Drawing_Canvas *cScreenCanvas_ = nullptr;
    OH_Drawing_Bitmap *cOffScreenBitmap_ = nullptr;
    OH_Drawing_Canvas *cCPUCanvas_ = nullptr;
    OH_Drawing_Canvas *cGPUCanvas_ = nullptr;
    
    OHNativeWindow *nativeWindow_ = nullptr;
    uint32_t *mappedAddr_ = nullptr;
    BufferHandle *bufferHandle_ = nullptr;
    struct NativeWindowBuffer *buffer_ = nullptr;
    int fenceFd_ = 0;
};

#endif // SAMPLE_GRAPHICS_H
