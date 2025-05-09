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
#include <native_drawing/drawing_text_typography.h>
#include <native_display_soloist/native_display_soloist.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_point.h>
#include <native_drawing/drawing_region.h>
#include <native_drawing/drawing_round_rect.h>
#include <native_drawing/drawing_sampling_options.h>
#include <native_drawing/drawing_pixel_map.h>
#include <native_drawing/drawing_text_blob.h>
#include <native_drawing/drawing_shader_effect.h>
// [Start ndk_graphics_draw_include_native_drawing_surface_and_gpu_context]
#include <native_drawing/drawing_gpu_context.h>
#include <native_drawing/drawing_surface.h>
// [End ndk_graphics_draw_include_native_drawing_surface_and_gpu_context]
#include <native_drawing/drawing_path_effect.h>
#include <native_drawing/drawing_color_filter.h>
#include <native_drawing/drawing_filter.h>
#include <native_drawing/drawing_image_filter.h>
#include <native_drawing/drawing_mask_filter.h>
#include <native_drawing/drawing_matrix.h>
#include <map>
#include <sys/mman.h>
#include "common/log_common.h"
#include "sample_graphics.h"
#include "utils/adaptation_util.h"

const uint16_t RGBA_MIN = 0x00;
const uint16_t RGBA_MAX = 0xFF;
const uint16_t RGBA_SIZE = 4;

static std::unordered_map<std::string, OH_DisplaySoloist *> g_displaySync;
// 多设备适配工具类,按设备宽度等比例缩放适配
AdaptationUtil* adaptationUtil = AdaptationUtil::GetInstance();
float SampleGraphics::value100_ = adaptationUtil->GetWidth(100.f);
float SampleGraphics::value150_ = adaptationUtil->GetWidth(150.f);
float SampleGraphics::value200_ = adaptationUtil->GetWidth(200.f);
float SampleGraphics::value300_ = adaptationUtil->GetWidth(300.f);
float SampleGraphics::value400_ = adaptationUtil->GetWidth(400.f);
float SampleGraphics::value500_ = adaptationUtil->GetWidth(500.f);
float SampleGraphics::value551_ = adaptationUtil->GetWidth(551.f);
float SampleGraphics::value600_ = adaptationUtil->GetWidth(600.f);
float SampleGraphics::value630_ = adaptationUtil->GetWidth(630.f);
float SampleGraphics::value700_ = adaptationUtil->GetWidth(700.f);
float SampleGraphics::value800_ = adaptationUtil->GetWidth(800.f);
float SampleGraphics::value900_ = adaptationUtil->GetWidth(900.f);
float SampleGraphics::value1000_ = adaptationUtil->GetWidth(1000.f);
float SampleGraphics::value1200_ = adaptationUtil->GetWidth(1200.f);

// [Start ndk_graphics_draw_initialize_egl_context]
EGLConfig getConfig(int version, EGLDisplay eglDisplay)
{
    int attribList[] = {EGL_SURFACE_TYPE,
                        EGL_WINDOW_BIT,
                        EGL_RED_SIZE,
                        8,
                        EGL_GREEN_SIZE,
                        8,
                        EGL_BLUE_SIZE,
                        8,
                        EGL_ALPHA_SIZE,
                        8,
                        EGL_RENDERABLE_TYPE,
                        EGL_OPENGL_ES2_BIT,
                        EGL_NONE};
    EGLConfig configs = NULL;
    int configsNum;

    if (!eglChooseConfig(eglDisplay, attribList, &configs, 1, &configsNum)) {
        SAMPLE_LOGE("eglChooseConfig ERROR");
        return NULL;
    }

    return configs;
}

int32_t SampleGraphics::InitializeEglContext()
{
    EGLDisplay_ = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (EGLDisplay_ == EGL_NO_DISPLAY) {
        SAMPLE_LOGE("unable to get EGL display.");
        return -1;
    }

    EGLint eglMajVers;
    EGLint eglMinVers;
    if (!eglInitialize(EGLDisplay_, &eglMajVers, &eglMinVers)) {
        EGLDisplay_ = EGL_NO_DISPLAY;
        SAMPLE_LOGE("unable to initialize display");
        return -1;
    }

    int version = 3;
    EGLConfig_ = getConfig(version, EGLDisplay_);
    if (EGLConfig_ == nullptr) {
        SAMPLE_LOGE("GLContextInit config ERROR");
        return -1;
    }

    /* Create EGLContext from */
    int attribList[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE}; // 2 size

    EGLContext_ = eglCreateContext(EGLDisplay_, EGLConfig_, EGL_NO_CONTEXT, attribList);

    EGLint attribs[] = {EGL_WIDTH, 1, EGL_HEIGHT, 1, EGL_NONE};
    EGLSurface_ = eglCreatePbufferSurface(EGLDisplay_, EGLConfig_, attribs);
    if (!eglMakeCurrent(EGLDisplay_, EGLSurface_, EGLSurface_, EGLContext_)) {
        SAMPLE_LOGE("eglMakeCurrent error = %{public}d", eglGetError());
        return -1;
    }

    SAMPLE_LOGE("Init success.");
    return 0;
}
// [End ndk_graphics_draw_initialize_egl_context]

// [Start ndk_graphics_draw_deinitialize_egl_context]
void SampleGraphics::DeInitializeEglContext()
{
    EGLBoolean ret = eglDestroySurface(EGLDisplay_, EGLSurface_);
    if (!ret) {
        SAMPLE_LOGE("eglDestroySurface failure.");
    }

    ret = eglDestroyContext(EGLDisplay_, EGLContext_);
    if (!ret) {
        SAMPLE_LOGE("eglDestroyContext failure.");
    }

    ret = eglTerminate(EGLDisplay_);
    if (!ret) {
        SAMPLE_LOGE("eglTerminate failure.");
    }

    EGLSurface_ = NULL;
    EGLContext_ = NULL;
    EGLDisplay_ = NULL;
}
// [End ndk_graphics_draw_deinitialize_egl_context]

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    SAMPLE_LOGI("OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        SAMPLE_LOGE("OnSurfaceCreatedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    auto render = SampleGraphics::GetInstance(id);
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    render->SetNativeWindow(nativeWindow);

    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    if ((xSize == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) && (render != nullptr)) {
        render->SetHeight(height);
        render->SetWidth(width);
        SAMPLE_LOGI("xComponent width = %{public}llu, height = %{public}llu", width, height);
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    SAMPLE_LOGI("OnSurfaceDestroyedCB");
    if ((component == nullptr) || (window == nullptr)) {
        SAMPLE_LOGE("OnSurfaceDestroyedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("OnSurfaceDestroyedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    SampleGraphics::Release(id);
}

static std::unordered_map<std::string, SampleGraphics *> g_instance;

void SampleGraphics::SetWidth(uint64_t width) { width_ = width; }

void SampleGraphics::SetHeight(uint64_t height) { height_ = height; }

void SampleGraphics::SetNativeWindow(OHNativeWindow *nativeWindow) { nativeWindow_ = nativeWindow; }

void SampleGraphics::Prepare()
{
    if (nativeWindow_ == nullptr) {
        SAMPLE_LOGE("nativeWindow_ is nullptr");
        return;
    }
    // 这里的nativeWindow是从上一步骤中的回调函数中获得的
    // [Start ndk_graphics_draw_get_buffer_handle]
    // 通过 OH_NativeWindow_NativeWindowRequestBuffer 获取 OHNativeWindowBuffer 实例
    int ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer_, &fenceFd_);
    SAMPLE_LOGI("request buffer ret = %{public}d", ret);
    // 通过 OH_NativeWindow_GetBufferHandleFromNative 获取 buffer 的 handle
    bufferHandle_ = OH_NativeWindow_GetBufferHandleFromNative(buffer_);
    // [End ndk_graphics_draw_get_buffer_handle]
    // [Start ndk_graphics_draw_get_mapped_addr]
    // 使用系统mmap接口拿到bufferHandle的内存虚拟地址
    mappedAddr_ = static_cast<uint32_t *>(
        mmap(bufferHandle_->virAddr, bufferHandle_->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle_->fd, 0));
    if (mappedAddr_ == MAP_FAILED) {
        SAMPLE_LOGE("mmap failed");
    }
    // [End ndk_graphics_draw_get_mapped_addr]
}

void SampleGraphics::Create()
{
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    // [Start ndk_graphics_draw_create_canvas]
    // 创建一个bitmap对象
    cScreenBitmap_ = OH_Drawing_BitmapCreate();
    // 定义bitmap的像素格式
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cScreenBitmap_, width, height_, &cFormat);

    // 创建一个canvas对象
    cScreenCanvas_ = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cScreenCanvas_, cScreenBitmap_);
    // [End ndk_graphics_draw_create_canvas]
    // 使用白色清除画布内容
    OH_Drawing_CanvasClear(cScreenCanvas_, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MAX, 0xFF));
}

void SampleGraphics::CreateByCPU()
{
    // [Start ndk_graphics_draw_create_canvas_by_cpu]
    // 创建一个离屏位图对象
    cOffScreenBitmap_ = OH_Drawing_BitmapCreate();
    // 设置位图属性
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_PREMUL};
    // 设置位图长宽（按需设置）
    uint32_t width = 800;
    uint32_t height = 800;
    // 初始化位图
    OH_Drawing_BitmapBuild(cOffScreenBitmap_, width, height, &cFormat);
    // 创建一个离屏Canvas对象
    cCPUCanvas_ = OH_Drawing_CanvasCreate();
    // 将离屏Canvas与离屏bitmap绑定，离屏Canvas绘制的内容会输出到绑定的离屏bitmap内存中
    OH_Drawing_CanvasBind(cCPUCanvas_, cOffScreenBitmap_);
    // [End ndk_graphics_draw_create_canvas_by_cpu]
    // [Start ndk_graphics_draw_clear_canvas_cpu]
    // 将背景设置为白色
    OH_Drawing_CanvasClear(cCPUCanvas_, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MAX, 0xFF));
    // [End ndk_graphics_draw_clear_canvas_cpu]
    
    // 创建一个bitmap对象
    cScreenBitmap_ = OH_Drawing_BitmapCreate();
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cScreenBitmap_, width_, height_, &cFormat);
    // 创建一个canvas对象
    cScreenCanvas_ = OH_Drawing_CanvasCreate();
    // 将Canvas与bitmap绑定，Canvas绘制的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cScreenCanvas_, cScreenBitmap_);
}

void SampleGraphics::CreateByGPU()
{
    // 创建一个bitmap对象
    cScreenBitmap_ = OH_Drawing_BitmapCreate();
    // 定义bitmap的像素格式
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cScreenBitmap_, width_, height_, &cFormat);
    // 创建一个canvas对象
    cScreenCanvas_ = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cScreenCanvas_, cScreenBitmap_);
    
    // [Start ndk_graphics_draw_create_canvas_by_gpu]
    // 设置宽高（按需设定）
    int32_t cWidth = 800;
    int32_t cHeight = 800;
    // 设置图像，包括宽度、高度、颜色格式和透明度格式
    OH_Drawing_Image_Info imageInfo = {cWidth, cHeight, COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_PREMUL};
    // GPU上下文的选项
    OH_Drawing_GpuContextOptions options{true};
    
    // 创建一个使用OpenGL（GL）作为其GPU后端的绘图上下文
    OH_Drawing_GpuContext *gpuContext = OH_Drawing_GpuContextCreateFromGL(options);
    // 创建surface对象
    OH_Drawing_Surface *surface = OH_Drawing_SurfaceCreateFromGpuContext(gpuContext, true, imageInfo);
    // 创建一个canvas对象
    cGPUCanvas_ = OH_Drawing_SurfaceGetCanvas(surface);
    // [End ndk_graphics_draw_create_canvas_by_gpu]
    // [Start ndk_graphics_draw_clear_canvas_gpu]
    // 将背景设置为白色
    OH_Drawing_CanvasClear(cGPUCanvas_, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MAX, 0xFF));
    // [End ndk_graphics_draw_clear_canvas_gpu]
}

void SampleGraphics::DisPlay()
{
    // 画完后获取像素地址，地址指向的内存包含画布画的像素数据
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cScreenBitmap_);
    uint32_t *value = static_cast<uint32_t *>(bitmapAddr);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr_); // 使用mmap获取到的地址来访问内存
    if (pixel == nullptr) {
        SAMPLE_LOGE("pixel is null");
        return;
    }
    if (value == nullptr) {
        SAMPLE_LOGE("value is null");
        return;
    }
    for (uint32_t x = 0; x < width_; x++) {
        for (uint32_t y = 0; y < height_; y++) {
            *pixel++ = *value++;
        }
    }
    // [Start ndk_graphics_draw_native_window_flush_buffer]
    // 设置刷新区域，如果Region中的Rect为nullptr,或者rectNumber为0，则认为OHNativeWindowBuffer全部有内容更改。
    Region region{nullptr, 0};
    // 通过OH_NativeWindow_NativeWindowFlushBuffer 提交给消费者使用，例如：显示在屏幕上。
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer_, fenceFd_, region);
    // [End ndk_graphics_draw_native_window_flush_buffer]
    // 内存使用完记得去掉内存映射
    int result = munmap(mappedAddr_, bufferHandle_->size);
    if (result == -1) {
        SAMPLE_LOGE("munmap failed!");
    }
}

void SampleGraphics::DisPlayCPU()
{
    // [Start ndk_graphics_draw_drawing_to_window_canvas_cpu]
    // 将离屏bitmap中的内容绘制到屏幕画布，实现上屏操作
    OH_Drawing_CanvasDrawBitmap(cScreenCanvas_, cOffScreenBitmap_, 0, 0);
    // [End ndk_graphics_draw_drawing_to_window_canvas_cpu]
    DisPlay();
}

void SampleGraphics::DisPlayGPU()
{
    // 设置宽高（按需设定）
    int32_t cWidth = 800;
    int32_t cHeight = 800;
    // 设置图像，包括宽度、高度、颜色格式和透明度格式
    OH_Drawing_Image_Info imageInfo = {cWidth, cHeight, COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_PREMUL};
    // [Start ndk_graphics_draw_drawing_to_window_canvas_gpu]
    void* dstPixels = malloc(cWidth * cHeight * RGBA_SIZE); // 4 for rgba
    OH_Drawing_CanvasReadPixels(cGPUCanvas_, &imageInfo, dstPixels, RGBA_SIZE * cWidth, 0, 0);
    OH_Drawing_Bitmap* cOffScreenBitmap_ = OH_Drawing_BitmapCreateFromPixels(&imageInfo, dstPixels,
        RGBA_SIZE * cWidth);
    OH_Drawing_CanvasDrawBitmap(cScreenCanvas_, cOffScreenBitmap_, 0, 0);
    // [End ndk_graphics_draw_drawing_to_window_canvas_gpu]
    DisPlay();
}

void SampleGraphics::DrawClipOperation(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_canvas_clip]
    // 创建画刷对象
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    // 设置画刷填充颜色为蓝色
    OH_Drawing_BrushSetColor(brush, 0xff0000ff);
    // 在画布中设置画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value400_, value400_, value1200_, value1200_);
    // 裁剪矩形区域
    OH_Drawing_CanvasClipRect(canvas, rect, OH_Drawing_CanvasClipOp::INTERSECT, true);
    OH_Drawing_Point *point = OH_Drawing_PointCreate(value600_, value600_);
    // 绘制圆形
    OH_Drawing_CanvasDrawCircle(canvas, point, value600_);
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁画刷对象并收回其占的内存
    OH_Drawing_BrushDestroy(brush);
    // [End ndk_graphics_draw_canvas_clip]
}

void SampleGraphics::DrawTranslationOperation(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_canvas_translation]
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置填充颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画布中的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建在水平和垂直方向分别平移300px的矩阵对象
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreateTranslation(value300_, value300_);
    // 对Canvas进行矩阵变换
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value200_, value300_, value700_, value600_);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    // [End ndk_graphics_draw_canvas_translation]
}

void SampleGraphics::DrawRotationOperation(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_canvas_rotation]
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置填充颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画布中的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建旋转的矩阵对象，三个参数分别是旋转角度和旋转中心坐标
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateRotation(45, value200_, value300_);
    // 对Canvas进行矩阵变换
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value200_, value300_, value700_, value600_);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_MatrixDestroy(matrix);
    // [End ndk_graphics_draw_canvas_rotation]
}

void SampleGraphics::DrawScaleOperation(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_canvas_scale]
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置填充颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画布中的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建缩放的矩阵对象，4个参数分别是旋转中心坐标和水平垂直方向的缩放因子
    OH_Drawing_Matrix* matrix = OH_Drawing_MatrixCreateScale(2, 2, value200_, value300_);
    // 对Canvas进行矩阵变换
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    // 绘制矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value200_, value300_, value700_, value600_);
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    OH_Drawing_RectDestroy(rect);
    // [End ndk_graphics_draw_canvas_scale]
}

void SampleGraphics::DrawStateOperation(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_canvas_state_operation]
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, 20);
    // 在画布中设置画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 保存当前画布状态，当前是不存在放大等操作的，这个原始状态会被保存下来
    OH_Drawing_CanvasSave(canvas);
    OH_Drawing_Matrix *matrix = OH_Drawing_MatrixCreateScale(2, 2, 2, 2);
    // 放大画布
    OH_Drawing_CanvasConcatMatrix(canvas, matrix);
    OH_Drawing_Point* point = OH_Drawing_PointCreate(value300_, value300_);
    // 绘制圆形，因为执行过放大操作，所以此时绘制的是大圆
    OH_Drawing_CanvasDrawCircle(canvas, point, value200_);
    // 恢复操作，将恢复到没有放大的原始状态
    OH_Drawing_CanvasRestore(canvas);
    // 绘制圆形，因为已经恢复没有放大的原始状态，所以此时绘制的小圆
    OH_Drawing_CanvasDrawCircle(canvas, point, value200_);
    // 去除画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁画笔对象并收回其占的内存
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PointDestroy(point);
    OH_Drawing_MatrixDestroy(matrix);
    // [End ndk_graphics_draw_canvas_state_operation]
}

void SampleGraphics::DrawFilling(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_create_brush]
    // 创建画刷
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // [End ndk_graphics_draw_create_brush]
    // [Start ndk_graphics_draw_brush_set_color]
    // 设置填充颜色为红色
    uint32_t color = 0xffff0000;
    OH_Drawing_BrushSetColor(brush, color);
    // [End ndk_graphics_draw_brush_set_color]
    // [Start ndk_graphics_draw_brush_set_antialias]
    // 开启抗锯齿效果
    OH_Drawing_BrushSetAntiAlias(brush, true);
    // [End ndk_graphics_draw_brush_set_antialias]
    // [Start ndk_graphics_draw_canvas_attach_brush]
    // 设置画布的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // [End ndk_graphics_draw_canvas_attach_brush]
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(0, 0, value800_, value800_);
    // 绘制椭圆
    OH_Drawing_CanvasDrawOval(canvas, rect);
    // [Start ndk_graphics_draw_canvas_detach_brush]
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // [End ndk_graphics_draw_canvas_detach_brush]
    // [Start ndk_graphics_draw_brush_destroy]
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    // [End ndk_graphics_draw_brush_destroy]
    OH_Drawing_RectDestroy(rect);
}

void SampleGraphics::DrawStroke(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_create_drawing_pen]
    // 创建画笔
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // [End ndk_graphics_draw_create_drawing_pen]
    // [Start ndk_graphics_draw_pen_set_color]
    // 设置画笔颜色为红色
    uint32_t color = 0xffff0000;
    OH_Drawing_PenSetColor(pen, color);
    // [End ndk_graphics_draw_pen_set_color]
    // [Start ndk_graphics_draw_pen_set_stroke_width]
    // 设置画笔的线宽为50像素
    float width = 50.0;
    OH_Drawing_PenSetWidth(pen, width);
    // [End ndk_graphics_draw_pen_set_stroke_width]
    // [Start ndk_graphics_draw_pen_set_antialias]
    // 设置画笔抗锯齿
    OH_Drawing_PenSetAntiAlias(pen, true);
    // [End ndk_graphics_draw_pen_set_antialias]
    // [Start ndk_graphics_draw_pen_set_cap_style]
    // 设置画笔线帽样式
    OH_Drawing_PenSetCap(pen, OH_Drawing_PenLineCapStyle::LINE_ROUND_CAP);
    // [End ndk_graphics_draw_pen_set_cap_style]
    // [Start ndk_graphics_draw_pen_set_join_style]
    // 设置画笔转角样式
    OH_Drawing_PenSetJoin(pen, OH_Drawing_PenLineJoinStyle::LINE_BEVEL_JOIN);
    // [End ndk_graphics_draw_pen_set_join_style]
    // [Start ndk_graphics_draw_canvas_attach_pen]
    // 设置画布的画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // [End ndk_graphics_draw_canvas_attach_pen]
    // 创建路径
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    float aX = value100_;
    float aY = value100_;
    float bX = value100_;
    float bY = value800_;
    float cX = value800_;
    float cY = value800_;
    float dX = value800_;
    float dY = value100_;
    // 到起始点
    OH_Drawing_PathMoveTo(path, aX, aY);
    // 绘制直线
    OH_Drawing_PathLineTo(path, bX, bY);
    OH_Drawing_PathLineTo(path, cX, cY);
    OH_Drawing_PathLineTo(path, dX, dY);
    // 绘制闭合路径
    OH_Drawing_CanvasDrawPath(canvas, path);
    // [Start ndk_graphics_draw_canvas_detach_pen]
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // [End ndk_graphics_draw_canvas_detach_pen]
    // [Start ndk_graphics_draw_pen_destroy]
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    // [End ndk_graphics_draw_pen_destroy]
    OH_Drawing_PathDestroy(path);
}

void SampleGraphics::DrawMixedMode(OH_Drawing_Canvas *canvas)
{
    OH_Drawing_CanvasClear(canvas, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MIN, RGBA_MIN, RGBA_MIN));
    // [Start ndk_graphics_draw_mixed_mode]
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置目标像素颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 将目标像素的画刷效果设置到Canvas中
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形对象
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value600_, value600_);
    // 绘制矩形（目标像素）
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 设置源像素颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MIN, RGBA_MIN, 0xFF));
    // 设置混合模式为叠加模式
    OH_Drawing_BrushSetBlendMode(brush, OH_Drawing_BlendMode::BLEND_MODE_PLUS);
    // 将源像素的画刷效果设置到Canvas中
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建圆心的点对象
    OH_Drawing_Point *point = OH_Drawing_PointCreate(value600_, value600_);
    // 绘制圆（源像素）
    OH_Drawing_CanvasDrawCircle(canvas, point, value300_);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PointDestroy(point);
    // [End ndk_graphics_draw_mixed_mode]
}

void SampleGraphics::DrawPathEffect(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_path_effect]
    // 创建画笔
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, 0xffff0000);
    // 设置画笔线宽为10
    OH_Drawing_PenSetWidth(pen, 10);
    // 表示10px的实线，5px的间隔，2px的实线，5px的间隔，以此循环
    float intervals[] = {10, 5, 2, 5};
    // 设置虚线路径效果
    OH_Drawing_PathEffect *pathEffect = OH_Drawing_CreateDashPathEffect(intervals, 4, 0.0);
    OH_Drawing_PenSetPathEffect(pen, pathEffect);
    // 在画布上设置画笔，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_PathEffectDestroy(pathEffect);
    // [End ndk_graphics_draw_path_effect]
}

void SampleGraphics::DrawLinearGradient(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_linear_gradient]
    // 开始点
    OH_Drawing_Point *startPt = OH_Drawing_PointCreate(20, 20);
    // 结束点
    OH_Drawing_Point *endPt = OH_Drawing_PointCreate(value900_, value900_);
    // 颜色数组
    uint32_t colors[] = {0xFFFFFF00, 0xFFFF0000, 0xFF0000FF};
    // 相对位置数组
    float pos[] = {0.0f, 0.5f, 1.0f};
    // 创建线性渐变着色器效果
    OH_Drawing_ShaderEffect *colorShaderEffect =
        OH_Drawing_ShaderEffectCreateLinearGradient(startPt, endPt, colors, pos, 3, OH_Drawing_TileMode::CLAMP);
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 基于画刷设置着色器效果
    OH_Drawing_BrushSetShaderEffect(brush, colorShaderEffect);
    // 在画布上设置画刷，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value900_, value900_);
     // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(colorShaderEffect);
    OH_Drawing_PointDestroy(startPt);
    OH_Drawing_PointDestroy(endPt);
    // [End ndk_graphics_draw_linear_gradient]
}

void SampleGraphics::DrawPathGradient(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_path_gradient]
    // 圆心坐标
    OH_Drawing_Point *centerPt = OH_Drawing_PointCreate(value500_, value500_);
    // 半径
    float radius = value600_;
    // 颜色数组
    uint32_t gColors[] = {0xFFFF0000, 0xFF00FF00, 0xFF0000FF};
    // 相对位置数组
    float_t gPos[] = {0.0f, 0.25f, 0.75f};
    // 创建径向渐变着色器效果
    OH_Drawing_ShaderEffect *colorShaderEffect =
        OH_Drawing_ShaderEffectCreateRadialGradient(centerPt, radius, gColors, gPos, 3, OH_Drawing_TileMode::REPEAT);
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 基于画刷设置着色器效果
    OH_Drawing_BrushSetShaderEffect(brush, colorShaderEffect);
    // 在画布上设置画刷，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value900_, value900_);
     // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(colorShaderEffect);
    OH_Drawing_PointDestroy(centerPt);
    // [End ndk_graphics_draw_path_gradient]
}

void SampleGraphics::DrawSectorGradient(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_sector_gradient]
    // 中心点
    OH_Drawing_Point *centerPt = OH_Drawing_PointCreate(value500_, value500_);
    // 颜色数组
    uint32_t colors[3] = {0xFF00FFFF, 0xFFFF00FF, 0xFFFFFF00};
    // 相对位置数组
    float pos[3] = {0.0f, 0.5f, 1.0f};
    // 创建扇形渐变着色器效果
    OH_Drawing_ShaderEffect* colorShaderEffect =
        OH_Drawing_ShaderEffectCreateSweepGradient(centerPt, colors, pos, 3, OH_Drawing_TileMode::CLAMP);
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 基于画刷设置着色器效果
    OH_Drawing_BrushSetShaderEffect(brush, colorShaderEffect);
    // 在画布上设置画刷，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value100_, value100_, value900_, value900_);
     // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_ShaderEffectDestroy(colorShaderEffect);
    OH_Drawing_PointDestroy(centerPt);
    // [End ndk_graphics_draw_sector_gradient]
}

void SampleGraphics::DrawColorFilter(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_color_filter]
    // 创建画刷
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    // 设置画刷抗锯齿
    OH_Drawing_BrushSetAntiAlias(brush, true);
    // 设置画刷填充颜色
    OH_Drawing_BrushSetColor(brush, 0xffff0000);
    // 设置颜色矩阵
    const float matrix[20] = {
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 0.5f, 0.5f, 0,
    0, 0, 0.5f, 0.5f, 0
    };
    
    // 创建滤波器颜色
    OH_Drawing_ColorFilter* colorFilter = OH_Drawing_ColorFilterCreateMatrix(matrix);
    // 创建一个滤波器对象
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    // 为滤波器对象设置颜色滤波器
    OH_Drawing_FilterSetColorFilter(filter, colorFilter);
    // 设置画刷的滤波器效果
    OH_Drawing_BrushSetFilter(brush, filter);
    // 在画布上设置画刷，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_ColorFilterDestroy(colorFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
    // [End ndk_graphics_draw_color_filter]
}

void SampleGraphics::DrawImageFilter(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_image_filter]
    // 创建画笔
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    // 设置画笔抗锯齿
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, 0xffff0000);
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, 20);
    // 创建图像滤波器实现模糊效果
    OH_Drawing_ImageFilter *imageFilter =
        OH_Drawing_ImageFilterCreateBlur(20.0f, 20.0f, OH_Drawing_TileMode::CLAMP, nullptr);
    // 创建一个滤波器对象
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    // 为滤波器对象设置图像滤波器
    OH_Drawing_FilterSetImageFilter(filter, imageFilter);
    // 设置画笔的滤波器效果
    OH_Drawing_PenSetFilter(pen, filter);
    // 在画布上设置画笔，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_ImageFilterDestroy(imageFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
    // [End ndk_graphics_draw_image_filter]
}

void SampleGraphics::DrawMaskFilter(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_mask_filter]
    // 创建画笔
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    // 设置画笔抗锯齿
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, 0xffff0000);
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, 20);
    // 创建蒙版滤波器
    OH_Drawing_MaskFilter *maskFilter = OH_Drawing_MaskFilterCreateBlur(OH_Drawing_BlurType::NORMAL, 20, true);
    // 创建一个滤波器对象
    OH_Drawing_Filter *filter = OH_Drawing_FilterCreate();
    // 为滤波器对象设置蒙版滤波器
    OH_Drawing_FilterSetMaskFilter(filter, maskFilter);
    // 设置画笔的滤波器效果
    OH_Drawing_PenSetFilter(pen, filter);
    // 在画布上设置画笔，请确保已获取得到画布对象
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建矩形
    OH_Drawing_Rect *rect = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_MaskFilterDestroy(maskFilter);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_FilterDestroy(filter);
    // [End ndk_graphics_draw_mask_filter]
}

void SampleGraphics::DrawPoint(OH_Drawing_Canvas *canvas)
{
    SAMPLE_LOGI("DrawPoint");
    // [Start ndk_graphics_draw_point]
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画笔线宽为40
    OH_Drawing_PenSetWidth(pen, 40);
    // 设置画布的画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 绘制5个点
    AdaptationUtil* adaptationUtil = AdaptationUtil::GetInstance();
    OH_Drawing_Point2D point1 = {value200_, value200_};
    OH_Drawing_CanvasDrawPoint(canvas, &point1);
    OH_Drawing_Point2D point2 = {value400_, value400_};
    OH_Drawing_CanvasDrawPoint(canvas, &point2);
    OH_Drawing_Point2D point3 = {value600_, value600_};
    OH_Drawing_CanvasDrawPoint(canvas, &point3);
    OH_Drawing_Point2D point4 = {value800_, value800_};
    OH_Drawing_CanvasDrawPoint(canvas, &point4);
    OH_Drawing_Point2D point5 = {value1000_, value1000_};
    OH_Drawing_CanvasDrawPoint(canvas, &point5);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    // [End ndk_graphics_draw_point]
}

void SampleGraphics::DrawArc(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_arc]
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, 20);
    // 设置画布的画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建矩形对象，左上坐标为（100，200）右下坐标为（500，300）
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(100, 200, 500, 300);
    // 基于矩形对象绘制圆弧，其实角度10°，扫描角度200°
    OH_Drawing_CanvasDrawArc(canvas, rect, 10, 200);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_RectDestroy(rect);
    // [End ndk_graphics_draw_arc]
}

void SampleGraphics::DrawCircle(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_circle]
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画笔线宽为20
    OH_Drawing_PenSetWidth(pen, 20);
    // 设置画布的画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建圆心点
    OH_Drawing_Point *point = OH_Drawing_PointCreate(value700_, value700_);
    // 基于圆心点和半径在画布上绘制圆
    OH_Drawing_CanvasDrawCircle(canvas, point, value600_);
    // 去除掉画布中的画笔
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_PointDestroy(point);
    // [End ndk_graphics_draw_circle]
}

void SampleGraphics::DrawPath(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_path]
    // 创建画笔对象
    OH_Drawing_Pen* pen = OH_Drawing_PenCreate();
    // 设置画笔描边颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画笔线宽为10
    OH_Drawing_PenSetWidth(pen, 10);
    // 设置 画笔转角样式
    OH_Drawing_PenSetJoin(pen, LINE_ROUND_JOIN);
    // 设置画布中的画笔
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建画刷，此例对闭合路径进行了颜色填充，所以需要使用画刷
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MIN, RGBA_MAX, RGBA_MIN));
    // 设置画布中的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    int len = value551_;
    float aX = value630_;
    float aY = value551_;
    float dX = aX - len * std::sin(18.0f);
    float dY = aY + len * std::cos(18.0f);
    float cX = aX + len * std::sin(18.0f);
    float cY = dY;
    float bX = aX + (len / 2.0);
    float bY = aY + std::sqrt((cX - dX) * (cX - dX) + (len / 2.0) * (len / 2.0));
    float eX = aX - (len / 2.0);
    float eY = bY;
    // 创建路径
    OH_Drawing_Path* path = OH_Drawing_PathCreate();
    // 到起始点
    OH_Drawing_PathMoveTo(path, aX, aY);
    // 绘制直线
    OH_Drawing_PathLineTo(path, bX, bY);
    OH_Drawing_PathLineTo(path, cX, cY);
    OH_Drawing_PathLineTo(path, dX, dY);
    OH_Drawing_PathLineTo(path, eX, eY);
    // 直线闭合，形成五角星
    OH_Drawing_PathClose(path);
    // 绘制闭合路径
    OH_Drawing_CanvasDrawPath(canvas, path);
    // 去除掉画布中的画笔和画刷
    OH_Drawing_CanvasDetachPen(canvas);
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_PenDestroy(pen);
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_PathDestroy(path);
    // [End ndk_graphics_draw_path]
}

void SampleGraphics::DrawRegion(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_region]
    // 创建画刷对象
    OH_Drawing_Brush* brush = OH_Drawing_BrushCreate();
    // 设置画刷填充颜色
    OH_Drawing_BrushSetColor(brush, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置画布的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 矩形区域1
    OH_Drawing_Region *region1 = OH_Drawing_RegionCreate();
    OH_Drawing_Rect *rect1 = OH_Drawing_RectCreate(value100_, value100_, value600_, value600_);
    OH_Drawing_RegionSetRect(region1, rect1);
    // 矩形区域2
    OH_Drawing_Region *region2 = OH_Drawing_RegionCreate();
    OH_Drawing_Rect *rect2 = OH_Drawing_RectCreate(value300_, value300_, value900_, value900_);
    OH_Drawing_RegionSetRect(region2, rect2);
    // 两个矩形区域组合
    OH_Drawing_RegionOp(region1, region2, OH_Drawing_RegionOpMode::REGION_OP_MODE_XOR);
    OH_Drawing_CanvasDrawRegion(canvas, region1);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RegionDestroy(region1);
    OH_Drawing_RegionDestroy(region2);
    OH_Drawing_RectDestroy(rect1);
    OH_Drawing_RectDestroy(rect2);
    // [End ndk_graphics_draw_region]
}

void SampleGraphics::DrawRect(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_rect]
    // 创建画刷对象
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    // 设置画刷的填充颜色
    OH_Drawing_BrushSetColor(brush, 0xffff0000);
    // 设置画布的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(0, 0, value800_, value800_);
    // 绘制矩形
    OH_Drawing_CanvasDrawRect(canvas, rect);
    // 去除画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    // [End ndk_graphics_draw_rect]
}

void SampleGraphics::DrawRoundRect(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_round_rect]
    // 创建画刷对象
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    // 设置画刷的填充颜色
    OH_Drawing_BrushSetColor(brush, 0xffff0000);
    // 设置画布的画刷
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建矩形
    OH_Drawing_Rect* rect = OH_Drawing_RectCreate(value100_, value100_, value900_, value600_);
    // 创建圆角矩形
    OH_Drawing_RoundRect* roundRect = OH_Drawing_RoundRectCreate(rect, 30, 30);
    // 绘制圆角矩形
    OH_Drawing_CanvasDrawRoundRect(canvas, roundRect);
    // 去除掉画布中的画刷
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_BrushDestroy(brush);
    OH_Drawing_RectDestroy(rect);
    OH_Drawing_RoundRectDestroy(roundRect);
    // [End ndk_graphics_draw_round_rect]
}

void SampleGraphics::DrawPixelMap(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_image]
    // 图片宽高分别为 600 * 400
    uint32_t width = 600;
    uint32_t height = 400;
    // 字节长度，RGBA_8888每个像素占4字节
    size_t bufferSize = width * height * 4;
    uint8_t *pixels = new uint8_t[bufferSize];
    for (uint32_t i = 0; i < width * height; ++i) {
        // 遍历并编辑每个像素，从而形成红绿蓝相间的条纹
        uint32_t n = i / 20 % 3;
        pixels[i * RGBA_SIZE] = RGBA_MIN; // 红色通道
        pixels[i * RGBA_SIZE + 1] = RGBA_MIN; // +1表示绿色通道
        pixels[i * RGBA_SIZE + 2] = RGBA_MIN; // +2表示蓝色通道
        pixels[i * RGBA_SIZE + 3] = 0xFF; // +3表示不透明度通道
        if (n == 0) {
            pixels[i * RGBA_SIZE] = 0xFF; // 红色通道赋值，颜色显红色
        } else if (n == 1) {
            pixels[i * RGBA_SIZE + 1] = 0xFF; // +1表示绿色通道赋值，其余通道为0，颜色显绿色
        } else {
            pixels[i * RGBA_SIZE + 2] = 0xFF; // +2表示蓝色通道赋值，其余通道为0，颜色显蓝色
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
    OH_Drawing_PixelMap *pixelMap = OH_Drawing_PixelMapGetFromOhPixelMapNative(pixelMapNative);
    // PixelMap中像素的截取区域
    OH_Drawing_Rect *src = OH_Drawing_RectCreate(0, 0, 600, 400);
    // 画布中显示的区域
    OH_Drawing_Rect *dst = OH_Drawing_RectCreate(value200_, value200_, value800_, value600_);
    // 采样选项对象
    OH_Drawing_SamplingOptions* samplingOptions = OH_Drawing_SamplingOptionsCreate(
        OH_Drawing_FilterMode::FILTER_MODE_LINEAR, OH_Drawing_MipmapMode::MIPMAP_MODE_LINEAR);
    // 绘制PixelMap
    OH_Drawing_CanvasDrawPixelMapRect(canvas, pixelMap, src, dst, samplingOptions);
    OH_PixelmapNative_Release(pixelMapNative);
    delete[] pixels;
    // [End ndk_graphics_draw_image]
}

void SampleGraphics::DrawBaseText(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_base_text]
    // 创建字体对象
    OH_Drawing_Font *font = OH_Drawing_FontCreate();
    // 设置字体大小
    OH_Drawing_FontSetTextSize(font, value100_);
    // 需要绘制的文字
    const char *str = "Hello world";
    // 创建字块对象
    OH_Drawing_TextBlob *textBlob =
        OH_Drawing_TextBlobCreateFromString(str, font, OH_Drawing_TextEncoding::TEXT_ENCODING_UTF8);
    // 绘制字块
    OH_Drawing_CanvasDrawTextBlob(canvas, textBlob, value200_, value800_);
    // 释放字块对象
    OH_Drawing_TextBlobDestroy(textBlob);
    // 释放字体对象
    OH_Drawing_FontDestroy(font);
    // [End ndk_graphics_draw_base_text]
}

void SampleGraphics::DrawStrokeText(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_stroke_text]
    // 创建画笔
    OH_Drawing_Pen *pen = OH_Drawing_PenCreate();
    // 设置抗锯齿
    OH_Drawing_PenSetAntiAlias(pen, true);
    // 设置描边颜色
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(RGBA_MAX, RGBA_MAX, RGBA_MIN, RGBA_MIN));
    // 设置描边线宽为3
    OH_Drawing_PenSetWidth(pen, 3);
    // 设置画笔描边效果
    OH_Drawing_CanvasAttachPen(canvas, pen);
    // 创建字型对象
    OH_Drawing_Font *font = OH_Drawing_FontCreate();
    // 设置字体大小
    OH_Drawing_FontSetTextSize(font, value150_);
    const char *str = "Hello world";
    // 创建字块对象
    OH_Drawing_TextBlob *textBlob =
        OH_Drawing_TextBlobCreateFromString(str, font, OH_Drawing_TextEncoding::TEXT_ENCODING_UTF8);
    // 绘制字块
    OH_Drawing_CanvasDrawTextBlob(canvas, textBlob, value200_, value800_);
    // 去除描边效果
    OH_Drawing_CanvasDetachPen(canvas);
    // 销毁各类对象
    OH_Drawing_TextBlobDestroy(textBlob);
    OH_Drawing_FontDestroy(font);
    OH_Drawing_PenDestroy(pen);
    // [End ndk_graphics_draw_stroke_text]
}

void SampleGraphics::DrawGradientText(OH_Drawing_Canvas *canvas)
{
    // [Start ndk_graphics_draw_gradient_text]
    // 开始点
    OH_Drawing_Point *startPt = OH_Drawing_PointCreate(value100_, value100_);
    // 结束点
    OH_Drawing_Point *endPt = OH_Drawing_PointCreate(value900_, value900_);
    // 颜色数组
    uint32_t colors[] = {0xFFFFFF00, 0xFFFF0000, 0xFF0000FF};
    // 相对位置数组
    float pos[] = {0.0f, 0.5f, 1.0f};
    // 创建线性渐变着色器效果
    OH_Drawing_ShaderEffect *colorShaderEffect =
        OH_Drawing_ShaderEffectCreateLinearGradient(startPt, endPt, colors, pos, 3, OH_Drawing_TileMode::CLAMP);
    // 创建画刷对象
    OH_Drawing_Brush *brush = OH_Drawing_BrushCreate();
    // 基于画刷设置着色器效果
    OH_Drawing_BrushSetShaderEffect(brush, colorShaderEffect);
    // 设置画刷填充效果
    OH_Drawing_CanvasAttachBrush(canvas, brush);
    // 创建字型对象
    OH_Drawing_Font *font = OH_Drawing_FontCreate();
    // 设置字体大小
    OH_Drawing_FontSetTextSize(font, value150_);
    const char *str = "Hello world";
    // 创建字块对象
    OH_Drawing_TextBlob *textBlob =
        OH_Drawing_TextBlobCreateFromString(str, font, OH_Drawing_TextEncoding::TEXT_ENCODING_UTF8);
    // 绘制字块
    OH_Drawing_CanvasDrawTextBlob(canvas, textBlob, value200_, value800_);
    // 取消填充效果
    OH_Drawing_CanvasDetachBrush(canvas);
    // 销毁各类对象
    OH_Drawing_TextBlobDestroy(textBlob);
    OH_Drawing_FontDestroy(font);
    OH_Drawing_BrushDestroy(brush);
    // [End ndk_graphics_draw_gradient_text]
}

void SampleGraphics::InitDrawFunction(std::string id)
{
    if (strcmp(id.c_str(), "canvasGetResultXComponent") == 0) {
        this->drawFunctionMap_.insert({"Point", &SampleGraphics::DrawPoint});
        this->drawFunctionMap_.insert({"Arc", &SampleGraphics::DrawArc});
        this->drawFunctionMap_.insert({"Circle", &SampleGraphics::DrawCircle});
    } else if (strcmp(id.c_str(), "canvasOperationStateXComponent") == 0) {
        this->drawFunctionMap_.insert({"ClipOperation", &SampleGraphics::DrawClipOperation});
        this->drawFunctionMap_.insert({"TranslationOperation", &SampleGraphics::DrawTranslationOperation});
        this->drawFunctionMap_.insert({"RotationOperation", &SampleGraphics::DrawRotationOperation});
        this->drawFunctionMap_.insert({"ScaleOperation", &SampleGraphics::DrawScaleOperation});
        this->drawFunctionMap_.insert({"StateOperation", &SampleGraphics::DrawStateOperation});
    } else if (strcmp(id.c_str(), "basicEffectXComponent") == 0) {
        this->drawFunctionMap_.insert({"Filling", &SampleGraphics::DrawFilling});
        this->drawFunctionMap_.insert({"Stroke", &SampleGraphics::DrawStroke});
    } else if (strcmp(id.c_str(), "complexEffectXComponent") == 0) {
        this->drawFunctionMap_.insert({"MixedMode", &SampleGraphics::DrawMixedMode});
        this->drawFunctionMap_.insert({"PathEffect", &SampleGraphics::DrawPathEffect});
        this->drawFunctionMap_.insert({"LinearGradient", &SampleGraphics::DrawLinearGradient});
        this->drawFunctionMap_.insert({"PathGradient", &SampleGraphics::DrawPathGradient});
        this->drawFunctionMap_.insert({"SectorGradient", &SampleGraphics::DrawSectorGradient});
        this->drawFunctionMap_.insert({"ColorFilter", &SampleGraphics::DrawColorFilter});
        this->drawFunctionMap_.insert({"ImageFilter", &SampleGraphics::DrawImageFilter});
        this->drawFunctionMap_.insert({"MaskFilter", &SampleGraphics::DrawMaskFilter});
    } else if (strcmp(id.c_str(), "shapeDrawingXComponent") == 0) {
        this->drawFunctionMap_.insert({"Point", &SampleGraphics::DrawPoint});
        this->drawFunctionMap_.insert({"Arc", &SampleGraphics::DrawArc});
        this->drawFunctionMap_.insert({"Circle", &SampleGraphics::DrawCircle});
        this->drawFunctionMap_.insert({"Path", &SampleGraphics::DrawPath});
        this->drawFunctionMap_.insert({"Region", &SampleGraphics::DrawRegion});
        this->drawFunctionMap_.insert({"Rect", &SampleGraphics::DrawRect});
        this->drawFunctionMap_.insert({"RoundRect", &SampleGraphics::DrawRoundRect});
    } else if (strcmp(id.c_str(), "pixelMapDrawingXComponent") == 0) {
        this->drawFunctionMap_.insert({"PixelMap", &SampleGraphics::DrawPixelMap});
    } else if (strcmp(id.c_str(), "textBlockDrawingXComponent") == 0) {
        this->drawFunctionMap_.insert({"BaseText", &SampleGraphics::DrawBaseText});
        this->drawFunctionMap_.insert({"StrokeText", &SampleGraphics::DrawStrokeText});
        this->drawFunctionMap_.insert({"GradientText", &SampleGraphics::DrawGradientText});
    }
}

void SampleGraphics::DoRender(SampleGraphics *render, char* canvasType, char* shapeType)
{
    SAMPLE_LOGI("DoRender");
    render->Prepare();
    // 不同画布
    if (strcmp(canvasType, "CanvasGet") == 0) {
            SAMPLE_LOGI("CanvasGet");
        render->Create();
        // 绘制图案
        auto it = render->drawFunctionMap_.find(shapeType);
        if (it != render->drawFunctionMap_.end()) {
            (render->*(it->second))(render->cScreenCanvas_);
        } else {
            SAMPLE_LOGI("Unsupported shape type: %{public}s", shapeType);
        }
        render->DisPlay();
    } else if (strcmp(canvasType, "CanvasGetByCPU") == 0) {
        render->CreateByCPU();
        // 绘制图案
        auto it = render->drawFunctionMap_.find(shapeType);
        if (it != render->drawFunctionMap_.end()) {
            (render->*(it->second))(render->cCPUCanvas_);
        } else {
            SAMPLE_LOGI("Unsupported shape type: %{public}s", shapeType);
        }
        render->DisPlayCPU();
    } else if (strcmp(canvasType, "CanvasGetByGPU") == 0) {
        render->CreateByGPU();
         // 绘制图案
        auto it = render->drawFunctionMap_.find(shapeType);
        if (it != render->drawFunctionMap_.end()) {
            (render->*(it->second))(render->cGPUCanvas_);
        } else {
            SAMPLE_LOGI("Unsupported shape type: %{public}s", shapeType);
        }
        render->DisPlayGPU();
    }
    render->Destroy();
}

napi_value SampleGraphics::Draw(napi_env env, napi_callback_info info)
{
    SAMPLE_LOGI("Draw");
    if ((env == nullptr) || (info == nullptr)) {
        SAMPLE_LOGE("NapiRegister: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    size_t argc = 2;
    napi_value args[2];
    if (napi_get_cb_info(env, info, &argc, args, &thisArg, nullptr) != napi_ok) {
        SAMPLE_LOGE("NapiRegister: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        SAMPLE_LOGE("NapiRegister: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        SAMPLE_LOGE("NapiRegister: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("NapiRegister: Unable to get XComponent id");
        return nullptr;
    }
    SAMPLE_LOGI("RegisterID = %{public}s", idStr);
    std::string id(idStr);
    
    // 获取形状参数
    char canvasType[32] = {0};
    napi_get_value_string_utf8(env, args[0], canvasType, sizeof(canvasType), nullptr);
    
    // 获取形状参数
    char shapeType[32] = {0};
    napi_get_value_string_utf8(env, args[1], shapeType, sizeof(shapeType), nullptr);
    
    SampleGraphics *render = SampleGraphics().GetInstance(id);
    if (render != nullptr) {
        render->DoRender(render, canvasType, shapeType);
    }
    return nullptr;
}

SampleGraphics::~SampleGraphics()
{
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cScreenCanvas_);
    cScreenCanvas_ = nullptr;
    OH_Drawing_CanvasDestroy(cCPUCanvas_);
    cCPUCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cScreenBitmap_);
    cScreenBitmap_ = nullptr;
    OH_Drawing_BitmapDestroy(cOffScreenBitmap_);
    cOffScreenBitmap_ = nullptr;
    
    buffer_ = nullptr;
    bufferHandle_ = nullptr;
    nativeWindow_ = nullptr;
    mappedAddr_ = nullptr;
    DeInitializeEglContext();
}

void SampleGraphics::Destroy()
{
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cScreenCanvas_);
    cScreenCanvas_ = nullptr;
    OH_Drawing_CanvasDestroy(cCPUCanvas_);
    cCPUCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cScreenBitmap_);
    cScreenBitmap_ = nullptr;
    OH_Drawing_BitmapDestroy(cOffScreenBitmap_);
    cOffScreenBitmap_ = nullptr;
    DeInitializeEglContext();
}

void SampleGraphics::Release(std::string &id)
{
    SampleGraphics *render = SampleGraphics::GetInstance(id);
    if (render != nullptr) {
        delete render;
        render = nullptr;
        g_instance.erase(g_instance.find(id));
    }
}

void SampleGraphics::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        SAMPLE_LOGE("Export: env or exports is null");
        return;
    }
    napi_property_descriptor desc[] = {
        {"draw", nullptr, SampleGraphics::Draw, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        SAMPLE_LOGE("Export: napi_define_properties failed");
    }
}

void SampleGraphics::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    SAMPLE_LOGI("register callback");
    renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    // Callback must be initialized
    renderCallback_.DispatchTouchEvent = nullptr;
    renderCallback_.OnSurfaceChanged = nullptr;
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
}


SampleGraphics *SampleGraphics::GetInstance(std::string &id)
{
    if (g_instance.find(id) == g_instance.end()) {
        SampleGraphics *render = new SampleGraphics(id);
        g_instance[id] = render;
        render->InitDrawFunction(id);
        return render;
    } else {
        return g_instance[id];
    }
}