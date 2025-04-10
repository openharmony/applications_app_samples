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

#ifndef OPENGLDRAW_H
#define OPENGLDRAW_H

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <cstdint>
#include "base_shape.h"

class OpenglDraw {
public:
    int32_t Init(EGLNativeWindowType window, int width, int height);
    void Update(void);
    int32_t Quit(void);
    void ChangeShape(int32_t shapeIndex);
    void Animate(void);

protected:
    EGLNativeWindowType mEglWindow;
    EGLDisplay mEGLDisplay = EGL_NO_DISPLAY;
    EGLConfig mEGLConfig = nullptr;
    EGLContext mEGLContext = EGL_NO_CONTEXT;
    EGLContext mSharedEGLContext = EGL_NO_CONTEXT;
    EGLSurface mEGLSurface = nullptr;

    // 渲染物体
    BaseShape *baseShape = nullptr;
};

#endif // OPENGLDRAW_H