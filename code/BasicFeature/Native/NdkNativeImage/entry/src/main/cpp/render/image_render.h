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

#ifndef IMAGE_RENDER_H
#define IMAGE_RENDER_H

#include <EGL/egl.h>
#include <GLES2/gl2.h>

class ImageRender {
public:
    ImageRender();
    ~ImageRender();

    bool InitEGL(EGLNativeWindowType window, uint64_t width, uint64_t height);
    bool MakeCurrentContext();
    void UpdateViewport();
    void UpdateWindowInfo(uint64_t width, uint64_t height);
    void SetTexture(GLuint textureId, GLuint textureTarget);
    void Render();
    void Cleanup();
    void SetTransformMatrix(const float matrix[16]);

private:
    void SetupVertexAttributes();
    void DisableVertexAttributes();
    bool InitializeEGLDisplay();
    bool ChooseEGLConfig();
    bool CreateEGLContext();
    bool CreateEGLSurface();
    bool CompileAndLinkShaders();
    void PrintProgramLinkError(GLuint program);
    GLuint CompileShader(GLenum type, const char* source);
    void PrintShaderCompileError(GLuint shader);

    EGLDisplay display_ = EGL_NO_DISPLAY;
    EGLSurface surface_ = EGL_NO_SURFACE;
    EGLContext context_ = EGL_NO_CONTEXT;
    EGLConfig config_ = nullptr;
    EGLNativeWindowType window_ = 0;
    uint64_t width_ = 0;
    uint64_t height_ = 0;
    GLuint shaderProgram_ = 0;
    GLint positionAttrib_ = -1;
    GLint texCoordAttrib_ = -1;
    GLint textureUniform_ = -1;
    GLuint textureId_ = 0;
    GLuint textureTarget_ = 0;
    float transformMatrix_[16] = { 0.0f };
};

#endif // IMAGE_RENDER_H
