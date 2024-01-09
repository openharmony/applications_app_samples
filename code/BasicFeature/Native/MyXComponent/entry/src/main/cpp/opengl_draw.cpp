/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#include "opengl_draw.h"
#include "cube.h"
#include "log.h"
#include "rectangle.h"

namespace {
    EGLConfig GetConfig(int version, EGLDisplay eglDisplay)
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
            LOGE("eglChooseConfig ERROR");
            return NULL;
        }

        return configs;
    }
} // namespace

int32_t OpenglDraw::Init(EGLNativeWindowType window, int width, int height)
{
    LOGI("Init window  w = %{public}d, h = %{public}d.", width, height);
    mEglWindow = window;

    mEGLDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (mEGLDisplay == EGL_NO_DISPLAY) {
        LOGE("unable to get EGL display.");
        return -1;
    }

    EGLint eglMajVers;
    EGLint eglMinVers;
    if (!eglInitialize(mEGLDisplay, &eglMajVers, &eglMinVers)) {
        mEGLDisplay = EGL_NO_DISPLAY;
        LOGE("unable to initialize display");
        return -1;
    }
    LOGI("majver:%{public}d minver:%{public}d", eglMajVers, eglMinVers);

    mEGLConfig = GetConfig(kThree, mEGLDisplay);
    if (mEGLConfig == nullptr) {
        LOGE("GLContextInit config ERROR");
        return -1;
    }

    EGLint winAttribs[] = {EGL_GL_COLORSPACE_KHR, EGL_GL_COLORSPACE_SRGB_KHR, EGL_NONE};
    if (mEglWindow) {
        mEGLSurface = eglCreateWindowSurface(mEGLDisplay, mEGLConfig, mEglWindow, winAttribs);
        if (mEGLSurface == nullptr) {
            LOGE("eglCreateContext eglSurface is null");
            return -1;
        }
    }

    /* Create EGLContext from */
    int attrib3_list[] = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};

    mEGLContext = eglCreateContext(mEGLDisplay, mEGLConfig, mSharedEGLContext, attrib3_list);
    if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext)) {
        LOGE("eglMakeCurrent error = %{public}d", eglGetError());
    }

    glViewport(0, 0, width, height);
    LOGI("window size is %{public}d %{public}d", width, height);
    glEnable(GL_DEPTH_TEST);

    baseShape = new Cube();
    baseShape->Init();
    LOGI("Init success.");

    return 0;
}

void OpenglDraw::Update()
{
    glClearColor(0, 0, 0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    if (baseShape != nullptr) {
        baseShape->Update();
    }
    eglSwapBuffers(mEGLDisplay, mEGLSurface);
}

int32_t OpenglDraw::Quit(void)
{
    baseShape->Quit();
    EGLBoolean ret = eglDestroySurface(mEGLDisplay, mEGLSurface);
    if (!ret) {
        LOGW("eglDestroySurface failure.");
    }
    ret = eglDestroyContext(mEGLDisplay, mEGLContext);
    if (!ret) {
        LOGW("eglDestroyContext failure.");
    }
    ret = eglTerminate(mEGLDisplay);
    if (!ret) {
        LOGW("eglTerminate failure.");
    }
    mEGLSurface = nullptr;
    mEGLContext = nullptr;
    mEGLDisplay = nullptr;

    LOGE("Quit success.");
    return 0;
}

void OpenglDraw::ChangeShape(int32_t shapeIndex)
{
    if (baseShape != nullptr) {
        baseShape->Quit();
        baseShape = nullptr;
    }
    if (shapeIndex == 0) {
        LOGE("OpenglDraw ChangeShape Cube.");
        baseShape = new Cube();
    } else {
        LOGE("OpenglDraw ChangeShape Rectangle.");
        baseShape = new Rectangle();
    }
    baseShape->Init();
}

void OpenglDraw::Animate()
{
    if (baseShape != nullptr) {
        baseShape->Animate();
    }
}