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

#include "image_render.h"
#include "common/common.h"
#include <GLES2/gl2ext.h>
#include <hilog/log.h>
#include <memory>
#include <cmath>
#include <algorithm>
#include <EGL/eglext.h>

namespace {
    constexpr int MATRIX_SIZE = 16;
    constexpr int MATRIX_DIAGONAL_STEP = 5;
    constexpr float IDENTITY_DIAGONAL = 1.0f;
    constexpr float IDENTITY_OTHER = 0.0f;
    constexpr uint32_t NUM_VERTICES = 4;
    constexpr uint32_t POSITION_COMPONENT_COUNT = 3;
    constexpr uint32_t TEX_COORD_COMPONENT_COUNT = 2;
    constexpr uint32_t STRIDE = (POSITION_COMPONENT_COUNT + TEX_COORD_COMPONENT_COUNT) * sizeof(GLfloat);
    const char* g_vertexShaderSource = R"(
        attribute vec4 aPosition;
        attribute vec2 aTexCoord;
        varying vec2 vTexCoord;
        uniform mat4 uTransformMatrix;
        void main() {
            gl_Position = aPosition;
            vTexCoord = (uTransformMatrix * vec4(aTexCoord, 0.0, 1.0)).xy;
        }
    )";

    const char* g_fragmentShaderSource = R"(
        #extension GL_OES_EGL_image_external : require
        precision mediump float;
        uniform samplerExternalOES uTexture;
        varying vec2 vTexCoord;
        void main() {
            gl_FragColor = texture2D(uTexture, vTexCoord);
        }
    )";
}

ImageRender::ImageRender()
{
    // Initialize transformMatrix_ as an identity matrix
    for (int i = 0; i < MATRIX_SIZE; ++i) {
        transformMatrix_[i] = (i % MATRIX_DIAGONAL_STEP == 0) ? IDENTITY_DIAGONAL : IDENTITY_OTHER;
    }
}

ImageRender::~ImageRender()
{
    Cleanup();
}

bool ImageRender::InitEGL(EGLNativeWindowType window, uint64_t width, uint64_t height)
{
    window_ = window;
    width_ = width;
    height_ = height;

    if (!InitializeEGLDisplay() || !ChooseEGLConfig() || !CreateEGLContext() || !CreateEGLSurface()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to initialize EGL");
        return false;
    }

    if (!MakeCurrentContext()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to make EGL context current");
        return false;
    }

    if (!CompileAndLinkShaders()) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to compile and link shaders");
        return false;
    }

    UpdateViewport();

    return true;
}

void ImageRender::UpdateWindowInfo(uint64_t width, uint64_t height)
{
    width_ = width;
    height_ = height;
}

bool ImageRender::InitializeEGLDisplay()
{
    display_ = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (display_ == EGL_NO_DISPLAY) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to get EGL display");
        return false;
    }

    if (!eglInitialize(display_, nullptr, nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to initialize EGL");
        return false;
    }

    return true;
}

bool ImageRender::ChooseEGLConfig()
{
    const EGLint attribs[] = {
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_NONE
    };

    EGLint numConfigs;
    if (!eglChooseConfig(display_, attribs, &config_, 1, &numConfigs) || numConfigs == 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to choose EGL config");
        return false;
    }
    return true;
}

bool ImageRender::CreateEGLContext()
{
    const EGLint contextAttribs[] = { EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE };
    context_ = eglCreateContext(display_, config_, EGL_NO_CONTEXT, contextAttribs);
    if (context_ == EGL_NO_CONTEXT) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to create EGL context");
        return false;
    }
    return true;
}

bool ImageRender::CreateEGLSurface()
{
    surface_ = eglCreateWindowSurface(display_, config_, window_, nullptr);
    if (surface_ == EGL_NO_SURFACE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to create EGL surface");
        return false;
    }
    return true;
}

bool ImageRender::MakeCurrentContext()
{
    if (!eglMakeCurrent(display_, surface_, surface_, context_)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to make EGL context current");
        return false;
    }
    return true;
}

void ImageRender::UpdateViewport()
{
    glViewport(0, 0, static_cast<GLsizei>(width_), static_cast<GLsizei>(height_));
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ImageRender",
                 "Viewport updated to %{public}llu x %{public}llu", width_, height_);
}

bool ImageRender::CompileAndLinkShaders()
{
    GLuint vertexShader = CompileShader(GL_VERTEX_SHADER, g_vertexShaderSource);
    if (vertexShader == 0) {
        return false;
    }

    GLuint fragmentShader = CompileShader(GL_FRAGMENT_SHADER, g_fragmentShaderSource);
    if (fragmentShader == 0) {
        glDeleteShader(vertexShader);
        return false;
    }

    shaderProgram_ = glCreateProgram();
    glAttachShader(shaderProgram_, vertexShader);
    glAttachShader(shaderProgram_, fragmentShader);
    glLinkProgram(shaderProgram_);

    GLint linked;
    glGetProgramiv(shaderProgram_, GL_LINK_STATUS, &linked);
    if (!linked) {
        PrintProgramLinkError(shaderProgram_);
        glDeleteProgram(shaderProgram_);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return false;
    }

    glUseProgram(shaderProgram_);

    positionAttrib_ = glGetAttribLocation(shaderProgram_, "aPosition");
    texCoordAttrib_ = glGetAttribLocation(shaderProgram_, "aTexCoord");
    textureUniform_ = glGetUniformLocation(shaderProgram_, "uTexture");

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return true;
}

void ImageRender::PrintProgramLinkError(GLuint program)
{
    GLint infoLen = 0;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 1) {
        std::unique_ptr<char[]> infoLog = std::make_unique<char[]>(infoLen);
        glGetProgramInfoLog(program, infoLen, nullptr, infoLog.get());
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                     "ImageRender", "Error linking program: %{public}s", infoLog.get());
    }
}

void ImageRender::SetTransformMatrix(const float matrix[MATRIX_SIZE])
{
    std::copy(matrix, matrix + MATRIX_SIZE, transformMatrix_);
}

void ImageRender::SetTexture(GLuint textureId, GLuint textureTarget)
{
    textureId_ = textureId;
    textureTarget_ = textureTarget;
}

void ImageRender::SetupVertexAttributes()
{
    static const GLfloat vertices[] = {
        -1.0f, -1.0f, 0.0f,      0.0f, 0.0f,    // 左下
        1.0f, -1.0f, 0.0f,      1.0f, 0.0f,     // 右下
        -1.0f,  1.0f, 0.0f,      0.0f, 1.0f,    // 左上
        1.0f,  1.0f, 0.0f,      1.0f, 1.0f      // 右上
    };

    // Enable and set the position attribute
    glEnableVertexAttribArray(positionAttrib_);
    glVertexAttribPointer(positionAttrib_, POSITION_COMPONENT_COUNT, GL_FLOAT, GL_FALSE,
                          STRIDE, vertices);

    // Enable and set the texture coordinate attribute
    glEnableVertexAttribArray(texCoordAttrib_);
    glVertexAttribPointer(texCoordAttrib_, TEX_COORD_COMPONENT_COUNT, GL_FLOAT, GL_FALSE,
                          STRIDE, vertices + POSITION_COMPONENT_COUNT);
}

void ImageRender::DisableVertexAttributes()
{
    // Disable the vertex attribute arrays after rendering
    glDisableVertexAttribArray(positionAttrib_);
    glDisableVertexAttribArray(texCoordAttrib_);
}

void ImageRender::Render()
{
    if (surface_ == EGL_NO_SURFACE) {
        return;
    }

    if (!eglMakeCurrent(display_, surface_, surface_, context_)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to make context current in Render");
        return;
    }

    // Clear the color buffer
    glClearColor(0.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    // Use the shader program
    glUseProgram(shaderProgram_);

    // Bind the texture
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(textureTarget_, textureId_);

    // Set the texture sampler to texture unit 0
    glUniform1i(textureUniform_, 0);

    // Set the transformation matrix
    GLint matrixLocation = glGetUniformLocation(shaderProgram_, "uTransformMatrix");
    if (matrixLocation != -1) {
        glUniformMatrix4fv(matrixLocation, 1, GL_FALSE, transformMatrix_);
    }

    // Set up vertex attributes
    SetupVertexAttributes();

    // Draw the textured quad
    glDrawArrays(GL_TRIANGLE_STRIP, 0, NUM_VERTICES);

    // Disable vertex attributes
    DisableVertexAttributes();

    // Swap the buffers to display the rendered image
    if (!eglSwapBuffers(display_, surface_)) {
        EGLint error = eglGetError();
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender",
            "eglSwapBuffers failed with error: %d", error);
    }
}

void ImageRender::Cleanup()
{
    if (display_ != EGL_NO_DISPLAY) {
        eglMakeCurrent(display_, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);

        if (context_ != EGL_NO_CONTEXT) {
            eglDestroyContext(display_, context_);
            context_ = EGL_NO_CONTEXT;
        }

        if (surface_ != EGL_NO_SURFACE) {
            eglDestroySurface(display_, surface_);
            surface_ = EGL_NO_SURFACE;
        }

        eglTerminate(display_);
        display_ = EGL_NO_DISPLAY;
    }

    if (shaderProgram_ != 0) {
        glDeleteProgram(shaderProgram_);
        shaderProgram_ = 0;
    }
}

GLuint ImageRender::CompileShader(GLenum type, const char* source)
{
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to create shader.");
        return 0;
    }

    glShaderSource(shader, 1, &source, nullptr);
    glCompileShader(shader);

    GLint compiled;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        PrintShaderCompileError(shader);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

void ImageRender::PrintShaderCompileError(GLuint shader)
{
    GLint infoLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 1) {
        auto infoLog = std::make_unique<char[]>(infoLen);
        glGetShaderInfoLog(shader, infoLen, nullptr, infoLog.get());
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender",
                     "Error compiling shader: %{public}s", infoLog.get());
    }
}
