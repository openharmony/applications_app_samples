/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
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