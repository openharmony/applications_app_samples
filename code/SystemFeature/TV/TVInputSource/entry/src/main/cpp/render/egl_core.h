/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef NATIVE_XCOMPONENT_EGL_CORE_H
#define NATIVE_XCOMPONENT_EGL_CORE_H

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>

namespace NativeXComponent {
class EGLCore {
public:
    explicit EGLCore() {};
    ~EGLCore() {}
    bool EglContextInit(void* window);
    bool CreateEnvironment();
    void Draw();
    void Release();
    void UpdateSize(int width, int height);

private:
    EGLNativeWindowType eglWindow_ = nullptr;
    EGLDisplay eglDisplay_ = EGL_NO_DISPLAY;
    EGLConfig eglConfig_ = EGL_NO_CONFIG_KHR;
    EGLSurface eglSurface_ = EGL_NO_SURFACE;
    EGLContext eglContext_ = EGL_NO_CONTEXT;
    GLuint program_ = 0;
    bool flag_ = false;
    int width_ = 0;
    int height_ = 0;
    GLfloat widthPercent_ = 0;
};
} // namespace NativeXComponentSample
#endif // NATIVE_XCOMPONENT_EGL_CORE_H
