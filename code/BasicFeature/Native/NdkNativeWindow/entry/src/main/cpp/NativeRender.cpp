/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

#include "NativeRender.h"
#include <native_window/external_window.h>
#include <sys/mman.h>
#include "logger_common.h"

namespace NativeWindowSample {
void OnSurfaceCreatedCB(OH_NativeXComponent* component, void* window)
{
    LOGD("OnSurfaceCreatedCB begin");
    uint64_t width = 0;
    uint64_t height = 0;
    int32_t ret = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    OHNativeWindow* nativeWindow = (NativeWindow*) (window);
    NativeRender::GetInstance()->SetNativeWindow(nativeWindow, width, height);
    NativeRender::GetInstance()->DrawBaseColor();
}

void OnSurfaceChangedCB(OH_NativeXComponent* component, void* window)
{
    (void)component;
    (void)window;
}

void OnSurfaceDestroyedCB(OH_NativeXComponent* component, void* window)
{
    (void)component;
    (void)window;
}

NativeRender* NativeRender::GetInstance()
{
    static NativeRender nativeRender;
    return &nativeRender;
}

napi_value NativeRender::GetNativeRender(napi_env env, napi_callback_info info)
{
    LOGD("NativeRender::GetNativeRender is coming");
    napi_status status;
    napi_value exports;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    if (argc != 1) {
        napi_throw_type_error(env, NULL, "Wrong number of arguments");
        return nullptr;
    }
    napi_valuetype valuetype;
    status = napi_typeof(env, args[0], &valuetype);
    if (status != napi_ok) {
        return nullptr;
    }
    if (valuetype != napi_number) {
        napi_throw_type_error(env, NULL, "Wrong type of arguments");
        return nullptr;
    }
    LOGD(" NativeRender::GetNativeRender is ends");
    return exports;
}

bool NativeRender::Export(napi_env env, napi_value exports)
{
    LOGD("NativeRender::Export is coming");
    napi_status status;

    napi_property_descriptor desc[] = {
        { "DrawColor", nullptr, NativeRender::NapiOnDraw, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    callback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    callback_.OnSurfaceChanged = OnSurfaceChangedCB;
    callback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    
    napi_value exportInstance = nullptr;
    OH_NativeXComponent *nativeXComponent = nullptr;
    int32_t ret;
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;

    status = napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance);
    if (status != napi_ok) {
        return false;
    }

    status = napi_unwrap(env, exportInstance, reinterpret_cast<void**>(&nativeXComponent));
    if (status != napi_ok) {
        return false;
    }

    ret = OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize);
    if (ret != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return false;
    }
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &callback_);
    return true;
}

void NativeRender::SetNativeWindow(OHNativeWindow* nativeWindow, uint64_t width,  uint64_t height)
{
    nativeWindow_ = nativeWindow;
    height_ = height;
    width_ = width;
}

napi_value NativeRender::NapiOnDraw(napi_env env, napi_callback_info info)
{
    NativeRender::GetInstance()->DrawBaseColor();
    return nullptr;
}

void NativeRender::DrawBaseColor()
{
    uint32_t value = (flag_ = !flag_) ? 0xfff0000f : 0xff00ffff;
    OH_NativeBuffer_Config config {
        .width = 0x100,
        .height = 0x100,
        .format = NATIVEBUFFER_PIXEL_FMT_RGBA_8888,
        .usage = NATIVEBUFFER_USAGE_CPU_READ | NATIVEBUFFER_USAGE_CPU_WRITE | NATIVEBUFFER_USAGE_MEM_DMA,
    };

    OH_NativeBuffer *nativeBuffer = OH_NativeBuffer_Alloc(&config);
    // Besides, you can directly create nativeWindowBuffer
    OHNativeWindowBuffer *nativeWindowBuffer =
        OH_NativeWindow_CreateNativeWindowBufferFromNativeBuffer(nativeBuffer);
    if (nativeWindowBuffer == nullptr) {
        LOGE("OH_NativeWindow_CreateNativeWindowBufferFromNativeBuffer fail, nativeBuffer is null");
        return;
    }
    // Set colors pace to device, the hardware may not support this setting
    auto ret = OH_NativeBuffer_SetColorSpace(nativeBuffer, OH_COLORSPACE_SRGB_FULL);
    if (ret != 0) {
        LOGE("OH_NativeBuffer_SetColorSpace fail");
    }
    int fenceFd = -1;
    ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &nativeWindowBuffer, &fenceFd);
    BufferHandle *bufferHandle = OH_NativeWindow_GetBufferHandleFromNative(nativeWindowBuffer);
    void *mappedAddr =
        mmap(bufferHandle->virAddr, bufferHandle->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle->fd, 0);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr);
    for (uint64_t x = 0; x < bufferHandle->width; x++) {
        for (uint64_t y = 0; y < bufferHandle->height; y++) {
            *pixel++ = value;
        }
    }
    struct Region *region = new Region();
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, nativeWindowBuffer, fenceFd, *region);
    if (munmap(mappedAddr, bufferHandle->size) < 0) {
        LOGE("munmap failed");
    }
    OHNativeWindowBuffer* lastFlushedBuffer;
    ret = OH_NativeWindow_GetLastFlushedBuffer(nativeWindow_, &lastFlushedBuffer);
    if (ret != 0) {
        LOGE("OH_NativeWindow_GetLastFlushedBuffer fail, ret = %{public}d", ret);
    }
    BufferHandle *lastHandle = OH_NativeWindow_GetBufferHandleFromNative(lastFlushedBuffer);
    if (lastHandle != nullptr && bufferHandle != nullptr && lastHandle->virAddr != bufferHandle->virAddr) {
        LOGE("OH_NativeWindow_GetLastFlushedBuffer fail, the virAddr is different");
    }
}
}