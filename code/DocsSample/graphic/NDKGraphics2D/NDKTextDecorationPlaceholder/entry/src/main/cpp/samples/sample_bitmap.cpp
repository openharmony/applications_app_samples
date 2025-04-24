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

#include <bits/alltypes.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_register_font.h>
#include <native_buffer/native_buffer.h>

#include "common/log_common.h"
#include "sample_bitmap.h"
#include "plugin/plugin_manager.h"

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceCreatedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    auto render = SampleBitMap::GetInstance(id);
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    render->SetNativeWindow(nativeWindow);

    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    if ((xSize == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) && (render != nullptr)) {
        render->SetHeight(height);
        render->SetWidth(width);
        DRAWING_LOGI("xComponent width = %{public}llu, height = %{public}llu", width, height);
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceDestroyedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    SampleBitMap::Release(id);
}

static std::unordered_map<std::string, SampleBitMap *> g_instance;

void SampleBitMap::SetWidth(uint64_t width)
{
    width_ = width;
}

void SampleBitMap::SetHeight(uint64_t height)
{
    height_ = height;
}

void SampleBitMap::SetNativeWindow(OHNativeWindow *nativeWindow)
{
    nativeWindow_ = nativeWindow;
}

void SampleBitMap::Prepare()
{
    if (nativeWindow_ == nullptr) {
        DRAWING_LOGE("nativeWindow_ is nullptr");
        return;
    }
    // 这里的nativeWindow是从上一步骤中的回调函数中获得的
    int32_t usage = NATIVEBUFFER_USAGE_CPU_READ | NATIVEBUFFER_USAGE_CPU_WRITE | NATIVEBUFFER_USAGE_MEM_DMA;
    int ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_USAGE, usage);
    if (ret != 0) {
        DRAWING_LOGE("failed to OH_NativeWindow_NativeWindowHandleOpt");
        return;
    }
    // 通过 OH_NativeWindow_NativeWindowRequestBuffer 获取 OHNativeWindowBuffer 实例
    ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer_, &fenceFd_);
    DRAWING_LOGI("request buffer ret = %{public}d", ret);
    // 通过 OH_NativeWindow_GetBufferHandleFromNative 获取 buffer 的 handle
    bufferHandle_ = OH_NativeWindow_GetBufferHandleFromNative(buffer_);
    // 使用系统mmap接口拿到bufferHandle的内存虚拟地址
    mappedAddr_ = static_cast<uint32_t *>(
        mmap(bufferHandle_->virAddr, bufferHandle_->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle_->fd, 0));
    if (mappedAddr_ == MAP_FAILED) {
        DRAWING_LOGE("mmap failed");
    }
}

void SampleBitMap::DisPlay()
{
    // 画完后获取像素地址，地址指向的内存包含画布画的像素数据
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cBitmap_);
    uint32_t *value = static_cast<uint32_t *>(bitmapAddr);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr_); // 使用mmap获取到的地址来访问内存
    if (pixel == nullptr) {
        DRAWING_LOGE("pixel is null");
        return;
    }
    if (value == nullptr) {
        DRAWING_LOGE("value is null");
        return;
    }
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    for (uint32_t x = 0; x < width; x++) {
        for (uint32_t y = 0; y < height_; y++) {
            *pixel++ = *value++;
        }
    }
    // 设置刷新区域，如果Region中的Rect为nullptr,或者rectNumber为0，则认为OHNativeWindowBuffer全部有内容更改。
    Region region {nullptr, 0};
    // 通过OH_NativeWindow_NativeWindowFlushBuffer 提交给消费者使用，例如：显示在屏幕上。
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer_, fenceFd_, region);
    // 内存使用完记得去掉内存映射
    int result = munmap(mappedAddr_, bufferHandle_->size);
    if (result == -1) {
        DRAWING_LOGE("munmap failed!");
    }
}

void SampleBitMap::Create()
{
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    // 创建一个bitmap对象
    cBitmap_ = OH_Drawing_BitmapCreate();
    // 定义bitmap的像素格式
    OH_Drawing_BitmapFormat cFormat {COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cBitmap_, width, height_, &cFormat);

    // 创建一个canvas对象
    cCanvas_ = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cCanvas_, cBitmap_);
    // 使用白色清除画布内容
    OH_Drawing_CanvasClear(cCanvas_, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0xFF, 0xFF));
}

void SampleBitMap::DrawText()
{
// 创建 FontCollection，FontCollection 用于管理字体匹配逻辑
    OH_Drawing_FontCollection *fc = OH_Drawing_CreateSharedFontCollection();

// 设置文字颜色、大小、字重，不设置 TextStyle 会使用 TypographyStyle 中的默认 TextStyle
    OH_Drawing_TextStyle *txtStyle = OH_Drawing_CreateTextStyle();
    OH_Drawing_SetTextStyleColor(txtStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(txtStyle, 50);
    OH_Drawing_SetTextStyleFontWeight(txtStyle, FONT_WEIGHT_400);

// 设置文本内容
    const char *text = "Hello World Drawing\n";
// 创建一个 TypographyStyle 创建 Typography 时需要使用
    OH_Drawing_TypographyStyle *typoStyle = OH_Drawing_CreateTypographyStyle();
// 设置文本对齐方式为居中
    OH_Drawing_SetTypographyTextAlign(typoStyle, TEXT_ALIGN_CENTER);
// 使用 FontCollection 和 之前创建的 TypographyStyle 创建 TypographyCreate。TypographyCreate 用于创建 Typography
    OH_Drawing_TypographyCreate *handlerWithPlaceholder = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
// 创建一个 placeholder，并且初始化其成员变量
    OH_Drawing_PlaceholderSpan placeholder;
    placeholder.width = 50.0;
    placeholder.height = 50.0;
    placeholder.alignment = OH_Drawing_PlaceholderVerticalAlignment::ALIGNMENT_ABOVE_BASELINE; // 基线对齐策略
    placeholder.baseline = OH_Drawing_TextBaseline::TEXT_BASELINE_ALPHABETIC; // 使用的文本基线类型
    placeholder.baselineOffset = 0.0; // 相比基线的偏移量。只有对齐策略是 OFFSET_AT_BASELINE 时生效

// 将 placeholder 放在开头
    OH_Drawing_TypographyHandlerAddPlaceholder(handlerWithPlaceholder, &placeholder);
// 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handlerWithPlaceholder, txtStyle);
// 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handlerWithPlaceholder, text);
    OH_Drawing_Typography *typographyWithPlaceholder = OH_Drawing_CreateTypography(handlerWithPlaceholder);
// 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typographyWithPlaceholder, maxWidth);
// 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typographyWithPlaceholder, cCanvas_, 50, 100);
// 创建 OH_Drawing_TypographyCreate
    OH_Drawing_TypographyCreate *handlerNoPlaceholder = OH_Drawing_CreateTypographyHandler(typoStyle, fc);
// 将之前创建的 TextStyle 加入 handler
    OH_Drawing_TypographyHandlerPushTextStyle(handlerNoPlaceholder, txtStyle);
// 将文本添加到 handler 中
    OH_Drawing_TypographyHandlerAddText(handlerNoPlaceholder, text);
    OH_Drawing_Typography *typographyNoPlaceholder = OH_Drawing_CreateTypography(handlerNoPlaceholder);
    OH_Drawing_TypographyLayout(typographyNoPlaceholder, maxWidth);
// 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typographyNoPlaceholder, cCanvas_, 0, 800);

// 释放内存
    OH_Drawing_DestroyFontCollection(fc);
    OH_Drawing_DestroyTextStyle(txtStyle);
    OH_Drawing_DestroyTypographyStyle(typoStyle);
    OH_Drawing_DestroyTypographyHandler(handlerWithPlaceholder);
    OH_Drawing_DestroyTypographyHandler(handlerNoPlaceholder);
    OH_Drawing_DestroyTypography(typographyWithPlaceholder);
    OH_Drawing_DestroyTypography(typographyNoPlaceholder);
}

napi_value SampleBitMap::NapiDrawText(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiDrawText");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiDrawPattern: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiDrawPattern: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->DrawText();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("DrawText executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

SampleBitMap::~SampleBitMap()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
    cBitmap_ = nullptr;

    buffer_ = nullptr;
    bufferHandle_ = nullptr;
    nativeWindow_ = nullptr;
    mappedAddr_ = nullptr;
}

void SampleBitMap::Destroy()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
}

void SampleBitMap::Release(std::string &id)
{
    PluginManager::GetInstance()->ReleaseRender(id);
    SampleBitMap *render = SampleBitMap::GetInstance(id);
    if (render != nullptr) {
        delete render;
        render = nullptr;
        g_instance.erase(g_instance.find(id));
    }
}

void SampleBitMap::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        DRAWING_LOGE("Export: env or exports is null");
        return;
    }
    napi_property_descriptor desc[] = {
        {"drawText", nullptr, SampleBitMap::NapiDrawText, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        DRAWING_LOGE("Export: napi_define_properties failed");
    }
}

void SampleBitMap::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    DRAWING_LOGI("register callback");
    renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    // Callback must be initialized
    renderCallback_.DispatchTouchEvent = nullptr;
    renderCallback_.OnSurfaceChanged = nullptr;
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
}

SampleBitMap *SampleBitMap::GetInstance(std::string &id)
{
    if (g_instance.find(id) == g_instance.end()) {
        SampleBitMap *render = new SampleBitMap(id);
        g_instance[id] = render;
        return render;
    } else {
        return g_instance[id];
    }
}
