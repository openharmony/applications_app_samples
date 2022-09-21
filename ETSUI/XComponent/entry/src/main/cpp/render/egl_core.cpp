/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

#include "egl_core.h"

#include <EGL/egl.h>
#include <GLES3/gl3.h>
#include "plugin_common.h"
#include "plugin_render.h"

static EGLConfig getConfig(int version, EGLDisplay eglDisplay) 
{
    int attribList[] = {
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_NONE
    };
    EGLConfig configs = NULL;
    int configsNum;
    if (!eglChooseConfig(eglDisplay, attribList, &configs, 1, &configsNum)) {
        LOGE("eglChooseConfig ERROR");
        return NULL;
    }
    return configs;
}

char vertexShader[] =
    "#version 300 es\n"
    "layout(location = 0) in vec4 a_position;\n"
    "layout(location = 1) in vec4 a_color;\n"
    "out vec4 v_color;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = a_position;\n"
    "   v_color = a_color;\n"
    "}\n";

char fragmentShader[] =
    "#version 300 es\n"
    "precision mediump float;\n"
    "in vec4 v_color;\n"
    "out vec4 fragColor;\n"
    "void main()\n"
    "{\n"
    "   fragColor = v_color;\n"
    "}\n";

void EGLCore::GLContextInit(void* window, int w, int h)
{
    LOGD("EGLCore::GLContextInit window = %{public}p, w = %{public}d, h = %{public}d.", window, w, h);
    width_ = w;
    height_ = h;
    mEglWindow = static_cast<EGLNativeWindowType>(window);

    // 1. create sharedcontext
    mEGLDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (mEGLDisplay == EGL_NO_DISPLAY) {
        LOGE("EGLCore::unable to get EGL display.");
        return;
    }

    EGLint eglMajVers, eglMinVers;
    if (!eglInitialize(mEGLDisplay, &eglMajVers, &eglMinVers)) {
        mEGLDisplay = EGL_NO_DISPLAY;
        LOGE("EGLCore::unable to initialize display");
        return;
    }

    mEGLConfig = getConfig(3, mEGLDisplay); // 获取的目标值为3
    if (mEGLConfig == nullptr) {
        LOGE("EGLCore::GLContextInit config ERROR");
        return;
    }

    // 2. Create EGL Surface from Native Window
    EGLint winAttribs[] = {EGL_GL_COLORSPACE_KHR, EGL_GL_COLORSPACE_SRGB_KHR, EGL_NONE};
    if (mEglWindow) {
        mEGLSurface = eglCreateWindowSurface(mEGLDisplay, mEGLConfig, mEglWindow, winAttribs);
        if (mEGLSurface == nullptr) {
            LOGE("EGLCore::eglCreateContext eglSurface is null");
            return;
        }
    }

    // 3. Create EGLContext from
    int attrib3_list[] = {
        EGL_CONTEXT_CLIENT_VERSION, 2,
        EGL_NONE
    };
    mEGLContext = eglCreateContext(mEGLDisplay, mEGLConfig, mSharedEGLContext, attrib3_list);
    if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext)) {
        LOGE("EGLCore::eglMakeCurrent error = %{public}d", eglGetError());
    }
    mProgramHandle = CreateProgram(vertexShader, fragmentShader);
    if (!mProgramHandle) {
        LOGE("EGLCore::Could not create CreateProgram");
        return;
    }

    DrawTriangle();
}

void EGLCore::DrawTriangle()
{
    GLfloat color[] = {
        0.5f, 0.6f, 0.3f, 1.0f
    };

    const GLfloat triangleVertices[] = {
        0.0f, 1.0f,
        -1.0f, -1.0f,
        1.0f, -1.0f
    };
    glViewport(0, 0, width_, height_);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(mProgramHandle);
    GLint positionHandle = glGetAttribLocation(mProgramHandle, "a_position");
    glVertexAttribPointer(positionHandle, 2, GL_FLOAT, GL_FALSE, 0, triangleVertices); // 位置索引从2开始
    glEnableVertexAttribArray(positionHandle);
    glVertexAttrib4fv(1, color);
    glDrawArrays(GL_TRIANGLES, 0, 3); // 三角形边数为3
    glDisableVertexAttribArray(positionHandle);

    glFlush();
    glFinish();
    eglSwapBuffers(mEGLDisplay, mEGLSurface);
}

void EGLCore::ChangeShape()
{
    if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext)) {
        LOGE("EGLCore::eglMakeCurrent error = %{public}d", eglGetError());
    }

    GLfloat color[] = {
        0.7f, 0.2f, 0.2f, 1.0f
    };

    const GLfloat triangleVertices[] = {
        -1.0f, 1.0f,
        -1.0f, -1.0f,
        1.0f, 0.0f
    };

    glViewport(0, 0, width_, height_);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(mProgramHandle);
    GLint positionHandle = glGetAttribLocation(mProgramHandle, "a_position");
    glVertexAttribPointer(positionHandle, 2, GL_FLOAT, GL_FALSE, 0, triangleVertices); // 位置索引从2开始
    glEnableVertexAttribArray(positionHandle);
    glVertexAttrib4fv(1, color);
    glDrawArrays(GL_TRIANGLES, 0, 3); // 三角形边数为3
    glDisableVertexAttribArray(positionHandle);

    Update();
}

void EGLCore::ChangeColor()
{
    if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext)) {
        LOGE("EGLCore::eglMakeCurrent error = %{public}d", eglGetError());
    }

    GLfloat color[] = {
        0.9f, 0.5f, 0.7f, 1.0f
    };

    const GLfloat triangleVertices[] = {
        0.0f, 1.0f,
        -1.0f, -1.0f,
        1.0f, -1.0f
    };

    glViewport(0, 0, width_, height_);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(mProgramHandle);
    GLint positionHandle = glGetAttribLocation(mProgramHandle, "a_position");
    glVertexAttribPointer(positionHandle, 2, GL_FLOAT, GL_FALSE, 0, triangleVertices); // 位置索引从2开始
    glEnableVertexAttribArray(positionHandle);
    glVertexAttrib4fv(1, color);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(positionHandle);

    Update();
}

void EGLCore::Update()
{
    eglSwapBuffers(mEGLDisplay, mEGLSurface);
}

GLuint EGLCore::LoadShader(GLenum type, const char *shaderSrc)
{
    GLuint shader_;
    GLint compiled_;

    shader_ = glCreateShader(type);
    LOGE(" Create the shader object");
    if (shader_ == 0) {
        LOGE("LoadShader shader_ error");
        return 0;
    }
    glShaderSource(shader_, 1, &shaderSrc, nullptr);
    LOGE("Load the shader source success");
    glCompileShader(shader_);
    LOGE("Compile the shader success");
    glGetShaderiv(shader_, GL_COMPILE_STATUS, &compiled_);
    LOGE("Check the  Compile status success");
    if (!compiled_) {
        LOGE("the  Compile is null");
        GLint infoLen = 0;
        glGetShaderiv(shader_, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = (char*)malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog(shader_, infoLen, nullptr, infoLog);
            LOGE("glGetShaderInfoLog success");
            free(infoLog);
        }
        glDeleteShader(shader_);
        return 0;
    }
    return shader_;
}

GLuint EGLCore::CreateProgram(const char *vertexShader, const char *fragShader)
{
    GLuint vertex_;
    GLuint fragment_;
    GLuint program_;
    GLint linked_;
    vertex_ = LoadShader(GL_VERTEX_SHADER, vertexShader);
    fragment_ = LoadShader(GL_FRAGMENT_SHADER, fragShader);
    program_ = glCreateProgram();
    if (vertex_ == 0 || fragment_ == 0 || program_ == 0) {
        CreateProgramError(vertexShader, fragShader);
        return 0;
    }
    glAttachShader(program_, vertex_);
    LOGE("glAttachShader  success");
    glAttachShader(program_, fragment_);
    LOGE("glAttachShader2  success");
    glLinkProgram(program_);
    LOGE("glLinkProgram  success");
    glGetProgramiv(program_, GL_LINK_STATUS, &linked_);
    LOGE("glGetProgramiv  success");
    if (!linked_) {
        LOGE("CreateProgram linked error");
        GLint infoLen = 0;
        glGetProgramiv(program_, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = (char *)malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(program_, infoLen, nullptr, infoLog);
            free(infoLog);
        }
        glDeleteShader(vertex_);
        glDeleteShader(fragment_);
        glDeleteProgram(program_);
        return 0;
    }
    glDeleteShader(vertex_);
    glDeleteShader(fragment_);

    return program_;
}

GLuint EGLCore::CreateProgramError(const char *vertexShader, const char *fragShader)
{
    GLuint vertex;
    GLuint fragment;
    GLuint program;
    GLint linked;

    vertex = LoadShader(GL_VERTEX_SHADER, vertexShader);
    if (vertex == 0) {
        LOGE("CreateProgram vertex error");
        return 0;
    }

    fragment = LoadShader(GL_FRAGMENT_SHADER, fragShader);
    if (fragment == 0) {
        LOGE("CreateProgram fragment error");
        glDeleteShader(vertex);
        return 0;
    }

    program = glCreateProgram();
    if (program == 0) {
        LOGE("CreateProgram program error");
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return 0;
    }
    return 0;
}

bool EGLCore::checkGlError(const char* op)
{
    LOGE("EGL ERROR CODE = %{public}x", eglGetError());
    for (GLint error = glGetError(); error; error = glGetError()) {
        LOGE("ERROR: %{public}s, ERROR CODE = %{public}x", op, error);
        return true;
    }
    return false;
}