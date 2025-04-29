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
#include <native_drawing/drawing_bitmap.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_brush.h>
#include <native_drawing/drawing_path.h>
#include <cstdint>
#include <unordered_map>
#include <string>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include "napi/native_api.h"
#include <multimedia/image_framework/image_pixel_map_mdk.h>


class SampleGraphics {
public:
    SampleGraphics() = default;
    ~SampleGraphics();
    explicit SampleGraphics(std::string id) : id_(id)
    {
        InitializeEglContext();
    }
    static napi_value Draw(napi_env env, napi_callback_info info);
    static napi_value DrawImage(napi_env env, napi_callback_info info);
    static void Release(std::string &id);
    void SetWidth(uint64_t width);
    void SetHeight(uint64_t height);
    void SetNativeWindow(OHNativeWindow *nativeWindow);
    
    // brush
    void DrawBrushBasic(OH_Drawing_Canvas *canvas);
    void DrawMixedMode(OH_Drawing_Canvas *canvas);
    void DrawShaderEffect1Line(OH_Drawing_Canvas *canvas);
    void DrawShaderEffect2Line(OH_Drawing_Canvas *canvas);
    void DrawShaderEffect(OH_Drawing_Canvas *canvas);
    void DrawColorFilter(OH_Drawing_Canvas *canvas);
    void DrawMaskFilterBrush(OH_Drawing_Canvas *canvas);
    
    // pen
    void DrawPenBasic(OH_Drawing_Canvas *canvas);
    void DrawPenLinearGradient(OH_Drawing_Canvas *canvas);
    void DrawMiterLimit(OH_Drawing_Canvas *canvas);
    void DrawStroke(OH_Drawing_Canvas *canvas);
    void DrawPathEffect(OH_Drawing_Canvas *canvas);
    void DrawImageFilter(OH_Drawing_Canvas *canvas);
    void DrawMaskFilterPen(OH_Drawing_Canvas *canvas);
    
    // rect
    void DrawRectBasic(OH_Drawing_Canvas *canvas);
    void DrawRectIntersect(OH_Drawing_Canvas *canvas);
    void DrawRectJoin(OH_Drawing_Canvas *canvas);
    void DrawRoundRect(OH_Drawing_Canvas *canvas);
    
    // path
    OH_Drawing_Path* DrawPathBasicTriangle(float startX, float startY, int32_t w);
    void DrawPathBasic(OH_Drawing_Canvas *canvas);
    void DrawPathAdd(OH_Drawing_Canvas *canvas);
    void DrawPathAdd1Line(OH_Drawing_Canvas *canvas);
    void DrawPathAdd2Line(OH_Drawing_Canvas *canvas);
    void DrawPathAdd3Line(OH_Drawing_Canvas *canvas);
    void DrawPathAdd4Line(OH_Drawing_Canvas *canvas);
    void DrawPathTo(OH_Drawing_Canvas *canvas);
    void DrawPathTo1Line(OH_Drawing_Canvas *canvas);
    void DrawPathTo2Line(OH_Drawing_Canvas *canvas);
    void DrawStar(OH_Drawing_Canvas *canvas);
    void BuildFromSvgString(OH_Drawing_Canvas *canvas);
    
    // matrix
    void DrawMatrixBasic(OH_Drawing_Canvas *canvas);
    void DrawTranslationOperation(OH_Drawing_Canvas *canvas);
    void DrawPreTranslationOperation(OH_Drawing_Canvas *canvas);
    void DrawPostTranslationOperation(OH_Drawing_Canvas *canvas);
    void DrawRotationOperation(OH_Drawing_Canvas *canvas);
    void DrawPreRotationOperation(OH_Drawing_Canvas *canvas);
    void DrawPostRotationOperation(OH_Drawing_Canvas *canvas);
    void DrawScaleOperation(OH_Drawing_Canvas *canvas);
    void DrawPreScaleOperation(OH_Drawing_Canvas *canvas);
    void DrawPostScaleOperation(OH_Drawing_Canvas *canvas);
    void DrawConcatOperation(OH_Drawing_Canvas *canvas);
    
    // Canvas
    void DrawCreateCanvas(OH_Drawing_Canvas *canvas);
    void DrawClipOperation(OH_Drawing_Canvas *canvas);
    void CanvasSaveOperation(OH_Drawing_Canvas *canvas);
    void CanvasSaveLayerOperation(OH_Drawing_Canvas *canvas);
    void DrawCanvasConcatMatrix(OH_Drawing_Canvas *canvas);
    void DrawRegion(OH_Drawing_Canvas *canvas);
    
    void DrawCustomPixelMap(OH_Drawing_Canvas *canvas);
    void DrawPixelMapRect(OH_Drawing_Canvas *canvas);
    void DrawBitmap(OH_Drawing_Canvas *canvas);
    void DrawImage(OH_Drawing_Canvas *canvas);
    
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
    
    static float value10_;
    static float value15_;
    static float value20_;
    static float value30_;
    static float value45_;
    static float value50_;
    static float value70_;
    static float value90_;
    static float value100_;
    static float value120_;
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
    static float value1100_;
    static float value1200_;
    bool desc = false;

    EGLDisplay EGLDisplay_ = EGL_NO_DISPLAY;
    EGLConfig EGLConfig_ = nullptr;
    EGLContext EGLContext_ = EGL_NO_CONTEXT;
    EGLSurface EGLSurface_ = nullptr;
    
    OH_Drawing_Bitmap *cScreenBitmap_ = nullptr;
    OH_Drawing_Canvas *cScreenCanvas_ = nullptr;
    OH_Drawing_Bitmap *cOffScreenBitmap_ = nullptr;
    OH_Drawing_Canvas *cCPUCanvas_ = nullptr;
    OH_Drawing_Canvas *cGPUCanvas_ = nullptr;
    NativePixelMap *nativePixelMap_ = nullptr;
    
    OHNativeWindow *nativeWindow_ = nullptr;
    uint32_t *mappedAddr_ = nullptr;
    BufferHandle *bufferHandle_ = nullptr;
    struct NativeWindowBuffer *buffer_ = nullptr;
    int fenceFd_ = 0;
    
    const uint16_t rgbaMin_ = 0x00;
    const uint16_t rgbaMax_ = 0xFF;
    const uint16_t rgbaHalf_ = 0x80;
    const uint16_t rgbaSize_ = 4;
    const uint16_t indexOne_ = 1;
    const uint16_t indexTwo_ = 2;
    const uint16_t indexThree_ = 3;
    const uint16_t indexFour_ = 4;
    const uint16_t indexFive_ = 5;
    const uint16_t indexSix_ = 6;
    const uint16_t indexSeven_ = 7;
    const uint16_t indexEight_ = 8;
    const uint16_t indexNine_ = 9;
};

#endif // SAMPLE_GRAPHICS_H
