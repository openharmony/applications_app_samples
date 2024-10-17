#ifndef NDK_NATIVE_IAMGE_IMAGE_RENDER_H
#define NDK_NATIVE_IAMGE_IMAGE_RENDER_H

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

private:
    GLuint CompileShader(GLenum type, const char* source);

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
};

#endif // NDK_NATIVE_IAMGE_IMAGE_RENDER_INIT_H
