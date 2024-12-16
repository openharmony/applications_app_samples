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

#include <bits/alltypes.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_display_soloist/native_display_soloist.h>
#include <unistd.h>
#include "common/log_common.h"
#include "sample_xcomponent.h"

static std::unordered_map<std::string, OH_DisplaySoloist *> g_displaySync;

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
    auto render = SampleXComponent::GetInstance(id);
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
    SampleXComponent::Release(id);
}


static void TestCallback(long long timestamp, long long targetTimestamp, void *data)
{
    SAMPLE_LOGI("test callback timestamp = %{public}llu, ", timestamp);
    OH_NativeXComponent *component = nullptr;
    component = static_cast<OH_NativeXComponent *>(data);
    if (component == nullptr) {
        SAMPLE_LOGE("TestCallback: component is null");
        return;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("TestCallback: Unable to get XComponent id");
        return;
    }

    std::string id(idStr);
    auto render = SampleXComponent::GetInstance(id);
    OHNativeWindow *nativeWindow = render->GetNativeWindow();
    uint64_t width;
    uint64_t height;

    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, nativeWindow, &width, &height);
    if ((xSize == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) && (render != nullptr)) {
        render->Prepare();
        render->Create();
        int offset = 8;
        render->ConstructPath(offset, offset, render->defaultOffsetY);
        render->SetPenAndBrush();
        render->DrawPath();
        render->DisPlay();
        render->Destroy();
    }
}

static std::unordered_map<std::string, SampleXComponent *> g_instance;

void SampleXComponent::SetWidth(uint64_t width) { width_ = width; }

void SampleXComponent::SetHeight(uint64_t height) { height_ = height; }

void SampleXComponent::SetNativeWindow(OHNativeWindow *nativeWindow) { nativeWindow_ = nativeWindow; }

OHNativeWindow *SampleXComponent::GetNativeWindow() { return nativeWindow_; }

void SampleXComponent::Prepare()
{
    if (nativeWindow_ == nullptr) {
        SAMPLE_LOGE("nativeWindow_ is nullptr");
        return;
    }
    int ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer_, &fenceFd_);
    SAMPLE_LOGI("request buffer ret = %{public}d", ret);
    bufferHandle_ = OH_NativeWindow_GetBufferHandleFromNative(buffer_);
    mappedAddr_ = static_cast<uint32_t *>(
        mmap(bufferHandle_->virAddr, bufferHandle_->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle_->fd, 0));
    if (mappedAddr_ == MAP_FAILED) {
        SAMPLE_LOGE("mmap failed");
    }
}

void SampleXComponent::DisPlay()
{
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cBitmap_);
    uint32_t *value = static_cast<uint32_t *>(bitmapAddr);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr_);
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
    Region region{nullptr, 0};
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer_, fenceFd_, region);
    int result = munmap(mappedAddr_, bufferHandle_->size);
    if (result == -1) {
        SAMPLE_LOGE("munmap failed!");
    }
}

void SampleXComponent::Create()
{
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    cBitmap_ = OH_Drawing_BitmapCreate();
    OH_Drawing_BitmapFormat cFormat{COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    OH_Drawing_BitmapBuild(cBitmap_, width, height_, &cFormat);

    cCanvas_ = OH_Drawing_CanvasCreate();
    OH_Drawing_CanvasBind(cCanvas_, cBitmap_);
    OH_Drawing_CanvasClear(cCanvas_, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0xFF, 0xFF));
}

void SampleXComponent::ConstructPath(int x, int y, int offsetY)
{
    float offsetOfAy = 100.0;
    float offsetOfCy = 200.0;
    
    aY = offsetOfAy + offsetY;
    cY = offsetOfCy + offsetY;

    if (desc) {
        float offset = 1.0;
        aX -= x * offset;
        bX -= x * offset;
    } else {
        float offset = 1.0;
        aX += x * offset;
        bX += x * offset;
    }

    if (bX >= width_) {
        desc = true;
    }

    if (aX <= 0) {
        desc = false;
    }

    float bY = aY;
    float cX = bX;
    float dX = aX;
    float dY = cY;

    cPath_ = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(cPath_, aX, aY);
    OH_Drawing_PathLineTo(cPath_, bX, bY);
    OH_Drawing_PathLineTo(cPath_, cX, cY);
    OH_Drawing_PathLineTo(cPath_, dX, dY);

    OH_Drawing_PathClose(cPath_);
}

void SampleXComponent::SetPenAndBrush()
{
    constexpr float penWidth = 10.0f; // pen width 10
    cPen_ = OH_Drawing_PenCreate();
    OH_Drawing_PenSetAntiAlias(cPen_, true);
    OH_Drawing_PenSetColor(cPen_, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0x00));
    OH_Drawing_PenSetWidth(cPen_, penWidth);
    OH_Drawing_PenSetJoin(cPen_, LINE_ROUND_JOIN);
    OH_Drawing_CanvasAttachPen(cCanvas_, cPen_);

    cBrush_ = OH_Drawing_BrushCreate();
    OH_Drawing_BrushSetColor(cBrush_, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0xFF, 0x00));

    OH_Drawing_CanvasAttachBrush(cCanvas_, cBrush_);
}

void SampleXComponent::DrawPath()
{
    OH_Drawing_CanvasDrawPath(cCanvas_, cPath_);
}

void ExecuteDisplaySoloist(std::string id, DisplaySoloist_ExpectedRateRange range, bool useExclusiveThread,
                           OH_NativeXComponent *nativeXComponent)
{
    OH_DisplaySoloist *nativeDisplaySoloist = nullptr;
    if (g_displaySync.find(id) == g_displaySync.end()) {
        g_displaySync[id] = OH_DisplaySoloist_Create(useExclusiveThread);
    }
    nativeDisplaySoloist = g_displaySync[id];
    OH_DisplaySoloist_SetExpectedFrameRateRange(nativeDisplaySoloist, &range);
    OH_DisplaySoloist_Start(nativeDisplaySoloist, TestCallback, nativeXComponent);
}

napi_value SampleXComponent::NapiRegister(napi_env env, napi_callback_info info)
{
    SAMPLE_LOGI("NapiRegister");
    if ((env == nullptr) || (info == nullptr)) {
        SAMPLE_LOGE("NapiRegister: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
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
    SampleXComponent *render = SampleXComponent().GetInstance(id);
    if (render != nullptr) {
        DisplaySoloist_ExpectedRateRange range;
        bool useExclusiveThread = false;
        if (id == "xcomponentId30") {
            range = {30, 120, 30};
        }

        if (id == "xcomponentId60") {
            range = {30, 120, 60};
            useExclusiveThread = true;
        }

        if (id == "xcomponentId120") {
            range = {30, 120, 120};
        }
        ExecuteDisplaySoloist(id, range, useExclusiveThread, nativeXComponent);
    }
    return nullptr;
}

napi_value SampleXComponent::NapiUnregister(napi_env env, napi_callback_info info)
{
    SAMPLE_LOGI("NapiUnregister");
    if ((env == nullptr) || (info == nullptr)) {
        SAMPLE_LOGE("NapiUnregister: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        SAMPLE_LOGE("NapiUnregister: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        SAMPLE_LOGE("NapiUnregister: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        SAMPLE_LOGE("NapiUnregister: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("NapiUnregister: Unable to get XComponent id");
        return nullptr;
    }
    SAMPLE_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleXComponent *render = SampleXComponent().GetInstance(id);
    if (render != nullptr) {
        OH_DisplaySoloist_Stop(g_displaySync[id]);
        SAMPLE_LOGI("NapiUnregister executed");
    } else {
        SAMPLE_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleXComponent::NapiDestroy(napi_env env, napi_callback_info info)
{
    SAMPLE_LOGI("NapiUnregister");
    if ((env == nullptr) || (info == nullptr)) {
        SAMPLE_LOGE("NapiDestroy: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        SAMPLE_LOGE("NapiDestroy: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        SAMPLE_LOGE("NapiDestroy: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        SAMPLE_LOGE("NapiDestroy: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        SAMPLE_LOGE("NapiDestroy: Unable to get XComponent id");
        return nullptr;
    }
    SAMPLE_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleXComponent *render = SampleXComponent().GetInstance(id);
    if (render != nullptr) {
        OH_DisplaySoloist_Destroy(g_displaySync[id]);
        g_displaySync.erase(id);
        SAMPLE_LOGI("NapiUnregister executed");
    } else {
        SAMPLE_LOGE("render is nullptr");
    }
    return nullptr;
}

SampleXComponent::~SampleXComponent()
{
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    OH_Drawing_BitmapDestroy(cBitmap_);
    cBitmap_ = nullptr;

    buffer_ = nullptr;
    bufferHandle_ = nullptr;
    nativeWindow_ = nullptr;
    mappedAddr_ = nullptr;
}

void SampleXComponent::Destroy()
{
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    OH_Drawing_BitmapDestroy(cBitmap_);
    cBitmap_ = nullptr;
}

void SampleXComponent::Release(std::string &id)
{
    SampleXComponent *render = SampleXComponent::GetInstance(id);
    if (render != nullptr) {
        delete render;
        render = nullptr;
        g_instance.erase(g_instance.find(id));
    }
}

void SampleXComponent::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        SAMPLE_LOGE("Export: env or exports is null");
        return;
    }
    napi_property_descriptor desc[] = {
        {"register", nullptr, SampleXComponent::NapiRegister, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"unregister", nullptr, SampleXComponent::NapiUnregister, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroy", nullptr, SampleXComponent::NapiDestroy, nullptr, nullptr, nullptr, napi_default, nullptr}};

    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        SAMPLE_LOGE("Export: napi_define_properties failed");
    }
}

void SampleXComponent::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    SAMPLE_LOGI("register callback");
    renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    // Callback must be initialized
    renderCallback_.DispatchTouchEvent = nullptr;
    renderCallback_.OnSurfaceChanged = nullptr;
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
}

SampleXComponent *SampleXComponent::GetInstance(std::string &id)
{
    if (g_instance.find(id) == g_instance.end()) {
        SampleXComponent *render = new SampleXComponent(id);
        g_instance[id] = render;
        return render;
    } else {
        return g_instance[id];
    }
}