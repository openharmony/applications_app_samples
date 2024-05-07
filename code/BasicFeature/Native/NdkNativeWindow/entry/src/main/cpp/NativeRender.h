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

#ifndef NdkNativeWindow_NativeRender_H
#define NdkNativeWindow_NativeRender_H
#include <napi/native_api.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <native_buffer/native_buffer.h>
#include <native_window/external_window.h>

namespace NativeWindowSample {
class NativeRender {
public:
    ~NativeRender() {}
    static NativeRender* GetInstance();
    static napi_value GetNativeRender(napi_env env, napi_callback_info info);
    static napi_value NapiOnDraw(napi_env env, napi_callback_info info);
    static napi_value NapiOnChangeScalingMode(napi_env env, napi_callback_info info);
    static void Release();
    bool Export(napi_env env, napi_value exports);
    void DrawBaseColor();
    void ChangeColor();
    void ChangeScalingMode();
    void SetNativeWindow(OHNativeWindow* nativeWindow, uint64_t width,  uint64_t height);

private:
    void NativeBufferApi();
    OH_NativeXComponent_Callback callback_;
    bool flag_ = false;
    bool flagFit_ = false;
    OHNativeWindow* nativeWindow_ = nullptr;
    uint64_t height_;
    uint64_t width_;
};
}
#endif // NdkNativeWindow_NativeRender_H
