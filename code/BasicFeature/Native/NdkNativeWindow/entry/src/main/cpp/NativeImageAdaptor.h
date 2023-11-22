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
#include <napi/native_api.h>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <native_buffer/native_buffer.h>
#include <native_image/native_image.h>
#include <native_window/external_window.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <mutex>

class NativeImageAdaptor {
public:
    ~NativeImageAdaptor();
    static NativeImageAdaptor *GetInstance()
    { 
        return &NativeImageAdaptor::imageAdaptor_; 
    };
    static bool Export(napi_env env, napi_value exports);
    static void ProduceBuffer(uint32_t value);
    static void OnFrameAvailable(void *context);
    static void InitEGLEnv();
    static EGLDisplay GetPlatformEglDisplay(EGLenum platform, void *native_display, const EGLint *attrib_list);
    static bool CheckEglExtension(const char *extensions, const char *extension);
    static napi_value GetAvailableCount(napi_env env, napi_callback_info info);
    static napi_value NapiOnProduceBuffer(napi_env env, napi_callback_info info);

private:
    static NativeImageAdaptor imageAdaptor_;
    static OH_NativeXComponent_Callback callback_;
    static OHNativeWindow *nativeWindow_;
    static OH_NativeImage *image_;
    static int32_t height_;
    static int32_t width_;
    static int32_t availableBufferCount_;
    static EGLConfig config_;
    static EGLContext eglContext_;
    static EGLDisplay eglDisplay_;
    static std::mutex opMutex_;
    };

#endif // NdkNativeWindow_NativeImageAdaptor_H
