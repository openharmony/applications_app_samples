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

#ifndef NdkNativeWindow_NativeImageAdaptor_H
#define NdkNativeWindow_NativeImageAdaptor_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <bits/alltypes.h>
#include <napi/native_api.h>
#include <native_buffer/native_buffer.h>
#include <native_image/native_image.h>
#include <native_window/external_window.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>
#include <sys/mman.h>
#include <mutex>

namespace NativeWindowSample {
class NativeImageAdaptor {
public:
    ~NativeImageAdaptor();
    static NativeImageAdaptor *GetInstance();
    static napi_value GetAvailableCount(napi_env env, napi_callback_info info);
    static napi_value NapiOnProduceBuffer(napi_env env, napi_callback_info info);
    static void OnFrameAvailable(void *context);
    void DealCallback(void *context);
    bool Export(napi_env env, napi_value exports);
    void ProduceBuffer(uint32_t value);
    void InitEGLEnv();
    EGLDisplay GetPlatformEglDisplay(EGLenum platform, void *native_display, const EGLint *attrib_list);
    bool CheckEglExtension(const char *eglExtensions, const char *eglExtension);
    int32_t GetCount();
private:
    void SetConfigAndGetValue();
    OHNativeWindow *nativeWindow_;
    OH_NativeImage *image_;
    int32_t height_;
    int32_t width_;
    int32_t availableBufferCount_;
    EGLConfig config_;
    EGLContext eglContext_;
    EGLDisplay eglDisplay_;
    std::mutex opMutex_;
};
}
#endif // NdkNativeWindow_NativeImageAdaptor_H
