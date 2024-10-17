#include "image_render.h"
#include "common/common.h"
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <hilog/log.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <cmath>

ImageRender::~ImageRender()
{
    Cleanup();
}

void ImageRender::SetTexture(GLuint textureId, GLuint textureTarget)
{
    textureId_ = textureId;
    textureTarget_ = textureTarget;
}

void ImageRender::Update(uint64_t width, uint64_t height, EGLNativeWindowType window)
{
    width_ = width;
    height_ = height;
    window_ = window;

    if (isInit_) {
        Cleanup();
        InitEGL();
    }
}

bool ImageRender::InitEGL()
{
    if (isInit_) {
        return true;
    }

    display_ = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (display_ == EGL_NO_DISPLAY) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to get EGL display.");
        return false;
    }

    if (!eglInitialize(display_, nullptr, nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to initialize EGL.");
        return false;
    }

    EGLConfig config;
    EGLint numConfigs;
    EGLint attribs[] = {
        EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_NONE
    };

    if (!eglChooseConfig(display_, attribs, &config, 1, &numConfigs) || numConfigs == 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to choose EGL config.");
        return false;
    }

    surface_ = eglCreateWindowSurface(display_, config, window_, nullptr);
    if (surface_ == EGL_NO_SURFACE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to create EGL surface.");
        return false;
    }

    EGLint contextAttribs[] = { EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE };
    context_ = eglCreateContext(display_, config, EGL_NO_CONTEXT, contextAttribs);
    if (context_ == EGL_NO_CONTEXT) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to create EGL context.");
        return false;
    }

    if (!eglMakeCurrent(display_, surface_, surface_, context_)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Failed to make EGL context current.");
        return false;
    }

    // 设置视口
    glViewport(0, 0, width_, height_);
    glEnable(GL_DEPTH_TEST);

    // 编译着色器并链接程序
    const char* vertexShaderSource = R"(
        attribute vec4 aPosition;
        attribute vec2 aTexCoord;
        varying vec2 vTexCoord;
        void main() {
            gl_Position = aPosition;
            vTexCoord = aTexCoord;
        }
    )";

    const char* fragmentShaderSource = R"(
        #extension GL_OES_EGL_image_external : require
        precision mediump float;
        uniform samplerExternalOES uTexture;
        varying vec2 vTexCoord;
        void main() {
            gl_FragColor = texture2D(uTexture, vTexCoord);
        }
    )";

    GLuint vertexShader = CompileShader(GL_VERTEX_SHADER, vertexShaderSource);
    if (vertexShader == 0) {
        return false;
    }

    GLuint fragmentShader = CompileShader(GL_FRAGMENT_SHADER, fragmentShaderSource);
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
        GLint infoLen = 0;
        glGetProgramiv(shaderProgram_, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char* infoLog = new char[infoLen];
            glGetProgramInfoLog(shaderProgram_, infoLen, nullptr, infoLog);
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Error linking program: %s", infoLog);
            delete[] infoLog;
        }
        glDeleteProgram(shaderProgram_);
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return false;
    }

    glUseProgram(shaderProgram_);

    // 获取属性位置
    positionAttrib_ = glGetAttribLocation(shaderProgram_, "aPosition");
    texCoordAttrib_ = glGetAttribLocation(shaderProgram_, "aTexCoord");

    // 获取纹理统一变量位置
    textureUniform_ = glGetUniformLocation(shaderProgram_, "uTexture");

    // 清理着色器对象
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    isInit_ = true;
    return true;
}

void ImageRender::Render()
{
    if (surface_ == EGL_NO_SURFACE) {
        return;
    }
    
    eglMakeCurrent(display_, surface_, surface_, context_);

    // 清除屏幕
    glClearColor(0.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // 使用着色器程序
    glUseProgram(shaderProgram_);

    // 绑定纹理
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(textureTarget_, textureId_);

    // 设置纹理采样器
    glUniform1i(textureUniform_, 0);

    // 设置顶点数据和属性
    GLfloat vertices[] = {
        // Positions         // Texture Coords
        -1.0f, -1.0f, 0.0f,   0.0f, 0.0f, // 左下角
         1.0f, -1.0f, 0.0f,   1.0f, 0.0f, // 右下角
        -1.0f,  1.0f, 0.0f,   0.0f, 1.0f, // 左上角
         1.0f,  1.0f, 0.0f,   1.0f, 1.0f, // 右上角
    };

    glEnableVertexAttribArray(positionAttrib_);
    glVertexAttribPointer(positionAttrib_, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), vertices);

    glEnableVertexAttribArray(texCoordAttrib_);
    glVertexAttribPointer(texCoordAttrib_, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), vertices + 3);

    // 绘制纹理
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    // 禁用属性
    glDisableVertexAttribArray(positionAttrib_);
    glDisableVertexAttribArray(texCoordAttrib_);

    // 交换缓冲区
    if (!eglSwapBuffers(display_, surface_)) {
        EGLint error = eglGetError();
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "eglSwapBuffers failed with error: %d", error);
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

    isInit_ = false;
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
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char* infoLog = new char[infoLen];
            glGetShaderInfoLog(shader, infoLen, nullptr, infoLog);
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ImageRender", "Error compiling shader: %s", infoLog);
            delete[] infoLog;
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}
