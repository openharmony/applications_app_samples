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

#ifndef NATIVE_IMAGE_RENDERER_H
#define NATIVE_IMAGE_RENDERER_H

#include <atomic>
#include <EGL/egl.h>
#include <GLES2/gl2.h>

class ImageRender {
public:
    ImageRender() = default;
    ~ImageRender();

    void Update(uint64_t width, uint64_t height, EGLNativeWindowType window);
    void Cleanup();
    void Render();
    bool InitEGL();

    // 添加 SetTexture 方法，用于接收 RenderEngine 提供的纹理
    void SetTexture(GLuint textureId, GLuint textureTarget);

    void SetTransformMatrix(const float matrix[16]);

private:
    GLuint CompileShader(GLenum type, const char* source);
    bool InitializeEGLDisplay();
    bool ChooseEGLConfig(EGLConfig& config);
    bool CreateEGLSurface(EGLConfig config);
    bool CreateEGLContext(EGLConfig config);
    bool MakeCurrentContext();
    void SetupViewport();
    bool CompileAndLinkShaders();
    void PrintProgramLinkError(GLuint program);

    uint64_t width_ = 0;
    uint64_t height_ = 0;

    EGLDisplay display_ = EGL_NO_DISPLAY;
    EGLSurface surface_ = EGL_NO_SURFACE;
    EGLContext context_ = EGL_NO_CONTEXT;
    EGLNativeWindowType window_ = 0;
    std::atomic<bool> isInit_{false};

    GLuint shaderProgram_ = 0;
    GLint positionAttrib_ = -1;
    GLint texCoordAttrib_ = -1;
    GLint textureUniform_ = -1;
    GLuint textureId_ = 0;
    GLuint textureTarget_ = 0;

    float transformMatrix_[16] = { 0.0f };
};

#endif // NATIVE_IMAGE_RENDERER_H
