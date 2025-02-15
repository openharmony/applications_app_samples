/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "EglCore.h"
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <EGL/eglplatform.h>
#include <GLES3/gl3.h>
#include <cmath>
#include <hilog/log.h>
#include "PluginRender.h"

#undef LOG_TAG
#define LOG_TAG "EGLCORE"

namespace NativeXComponentSample {
namespace {
constexpr uint32_t LOG_PRINT_DOMAIN = 0xFF00;
constexpr int32_t NUM_4 = 4;
/**
 * Vertex shader.
 */
const char VERTEX_SHADER[] = "#version 300 es\n"
                             "layout(location = 0) in vec4 a_position;\n"
                             "layout(location = 1) in vec4 a_color;   \n"
                             "out vec4 v_color;                       \n"
                             "void main()                             \n"
                             "{                                       \n"
                             "   gl_Position = a_position;            \n"
                             "   v_color = a_color;                   \n"
                             "}                                       \n";

/**
 * Fragment shader.
 */
const char FRAGMENT_SHADER[] = "#version 300 es\n"
                               "precision mediump float;                  \n"
                               "in vec4 v_color;                          \n"
                               "out vec4 fragColor;                       \n"
                               "void main()                               \n"
                               "{                                         \n"
                               "   fragColor = v_color;                   \n"
                               "}                                         \n";

/**
 * Background color #f4f4f4.
 */
const GLfloat BACKGROUND_COLOR[] = {244.0f / 255, 244.0f / 255, 244.0f / 255, 1.0f};

/**
 * Draw color #7E8FFB.
 */
const GLfloat DRAW_COLOR[] = {126.0f / 255, 143.0f / 255, 251.0f / 255, 1.0f};

/**
 * Change color #92D6CC.
 */
const GLfloat CHANGE_COLOR[] = {146.0f / 255, 214.0f / 255, 204.0f / 255, 1.0f};

/**
 * Background area.
 */
const GLfloat BACKGROUND_RECTANGLE_VERTICES[] = {-1.0f, 1.0f, 1.0f, 1.0f, 1.0f, -1.0f, -1.0f, -1.0f};

/**
 * Get context parameter count.
 */
const size_t GET_CONTEXT_PARAM_CNT = 1;

/**
 * Fifty percent.
 */
const float FIFTY_PERCENT = 0.5;

/**
 * Pointer size.
 */
const GLint POINTER_SIZE = 2;

/**
 * Triangle fan size.
 */
const GLsizei TRIANGLE_FAN_SIZE = 4;

/**
 * Egl red size default.
 */
const int EGL_RED_SIZE_DEFAULT = 8;

/**
 * Egl green size default.
 */
const int EGL_GREEN_SIZE_DEFAULT = 8;

/**
 * Egl blue size default.
 */
const int EGL_BLUE_SIZE_DEFAULT = 8;

/**
 * Egl alpha size default.
 */
const int EGL_ALPHA_SIZE_DEFAULT = 8;

/**
 * Default x position.
 */
const int DEFAULT_X_POSITION = 0;

/**
 * Default y position.
 */
const int DEFAULT_Y_POSITION = 0;

/**
 * Gl red default.
 */
const GLfloat GL_RED_DEFAULT = 0.0;

/**
 * Gl green default.
 */
const GLfloat GL_GREEN_DEFAULT = 0.0;

/**
 * Gl blue default.
 */
const GLfloat GL_BLUE_DEFAULT = 0.0;

/**
 * Gl alpha default.
 */
const GLfloat GL_ALPHA_DEFAULT = 1.0;

/**
 * Program error.
 */
const GLuint PROGRAM_ERROR = 0;

/**
 * Shape vertices size.
 */
const int SHAPE_VERTICES_SIZE = 8;

/**
 * Position handle name.
 */
const char POSITION_NAME[] = "a_position";

/**
 * Position error.
 */
const GLint POSITION_ERROR = -1;

/**
 * Config attribute list.
 */
const EGLint ATTRIB_LIST[] = {
    // Key,value.
    EGL_SURFACE_TYPE, EGL_WINDOW_BIT, EGL_RED_SIZE, EGL_RED_SIZE_DEFAULT, EGL_GREEN_SIZE, EGL_GREEN_SIZE_DEFAULT,
    EGL_BLUE_SIZE, EGL_BLUE_SIZE_DEFAULT, EGL_ALPHA_SIZE, EGL_ALPHA_SIZE_DEFAULT, EGL_RENDERABLE_TYPE,
    EGL_OPENGL_ES2_BIT,
    // End.
    EGL_NONE};

/**
 * Context attributes.
 */
const EGLint CONTEXT_ATTRIBS[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};
} // namespace

bool EGLCore::EglContextInit(void *window, int width, int height)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "EGLCore", "EglContextInit execute");
    if ((window == nullptr) || (width <= 0) || (height <= 0)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "EglContextInit: param error");
        return false;
    }

    UpdateSize(width, height);
    eglWindow_ = reinterpret_cast<EGLNativeWindowType>(window);

    // Init display.
    eglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    if (eglDisplay == EGL_NO_DISPLAY) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "eglGetDisplay: unable to get EGL display");
        return false;
    }

    EGLint majorVersion;
    EGLint minorVersion;
    if (!eglInitialize(eglDisplay, &majorVersion, &minorVersion)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore",
                     "eglInitialize: unable to get initialize EGL display");
        return false;
    }

    // Select configuration.
    const EGLint maxConfigSize = 1;
    EGLint numConfigs;
    if (!eglChooseConfig(eglDisplay, ATTRIB_LIST, &eglConfig, maxConfigSize, &numConfigs)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "eglChooseConfig: unable to choose configs");
        return false;
    }

    return CreateEnvironment();
}

bool EGLCore::CreateEnvironment()
{
    // Create surface.
    if (!eglWindow_) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "eglWindow_ is null");
        return false;
    }
    eglSurface = eglCreateWindowSurface(eglDisplay, eglConfig, eglWindow_, NULL);
    if (eglSurface == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore",
                     "eglCreateWindowSurface: unable to create surface");
        return false;
    }
    // Create context.
    eglContext = eglCreateContext(eglDisplay, eglConfig, EGL_NO_CONTEXT, CONTEXT_ATTRIBS);
    if (!eglMakeCurrent(eglDisplay, eglSurface, eglSurface, eglContext)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "eglMakeCurrent failed");
        return false;
    }
    // Create program.
    program = CreateProgram(VERTEX_SHADER, FRAGMENT_SHADER);
    if (program == PROGRAM_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "CreateProgram: unable to create program");
        return false;
    }
    return true;
}

GLuint EGLCore::LoadShader(GLenum type, const char *shaderSrc)
{
    if ((type <= 0) || (shaderSrc == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "glCreateShader type or shaderSrc error");
        return PROGRAM_ERROR;
    }

    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "glCreateShader unable to load shader");
        return PROGRAM_ERROR;
    }

    // The gl function has no return value.
    glShaderSource(shader, 1, &shaderSrc, nullptr);
    glCompileShader(shader);

    GLint compiled;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (compiled != 0) {
        return shader;
    }

    GLint infoLen = 0;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen <= 1) {
        glDeleteShader(shader);
        return PROGRAM_ERROR;
    }

    char *infoLog = (char *)malloc(sizeof(char) * (infoLen + 1));
    if (infoLog != nullptr) {
        for (GLint i = 0; i < infoLen + 1; i++) {
            infoLog[i] = 0;
        }
        glGetShaderInfoLog(shader, infoLen, nullptr, infoLog);
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "glCompileShader error = %s", infoLog);
        free(infoLog);
        infoLog = nullptr;
    }
    glDeleteShader(shader);
    return PROGRAM_ERROR;
}

GLuint EGLCore::CreateProgram(const char *vertexShader, const char *fragShader)
{
    if ((vertexShader == nullptr) || (fragShader == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore",
                     "createProgram: vertexShader or fragShader is null");
        return PROGRAM_ERROR;
    }

    GLuint vertex = LoadShader(GL_VERTEX_SHADER, vertexShader);
    if (vertex == PROGRAM_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "createProgram vertex error");
        return PROGRAM_ERROR;
    }

    GLuint fragment = LoadShader(GL_FRAGMENT_SHADER, fragShader);
    if (fragment == PROGRAM_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "createProgram fragment error");
        return PROGRAM_ERROR;
    }

    GLuint program = glCreateProgram();
    if (program == PROGRAM_ERROR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "createProgram program error");
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return PROGRAM_ERROR;
    }

    // The gl function has no return value.
    glAttachShader(program, vertex);
    glAttachShader(program, fragment);
    glLinkProgram(program);

    GLint linked;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (linked != 0) {
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return program;
    }
    
    GLint infoLen = 0;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
    if (infoLen > 1) {
        char *infoLog = (char *)malloc(sizeof(char) * (infoLen + 1));
        for (GLint i = 0; i < infoLen + 1; i++) {
            infoLog[i] = 0;
        }
        glGetProgramInfoLog(program, infoLen, nullptr, infoLog);
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "glLinkProgram error = %s", infoLog);
        free(infoLog);
        infoLog = nullptr;
    }
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    glDeleteProgram(program);
    return PROGRAM_ERROR;
}

void EGLCore::UpdateSize(int width, int height)
{
    windowWidth = width;
    windowHeight = height;
    if (windowWidth > 0) {
        widthPercent = FIFTY_PERCENT * windowHeight / windowWidth;
    }
}

void EGLCore::Release()
{
    if ((eglDisplay == nullptr) || (eglSurface == nullptr) || (!eglDestroySurface(eglDisplay, eglSurface))) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "Release eglDestroySurface failed");
    }

    if ((eglDisplay == nullptr) || (eglContext == nullptr) || (!eglDestroyContext(eglDisplay, eglContext))) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "Release eglDestroyContext failed");
    }

    if ((eglDisplay == nullptr) || (!eglTerminate(eglDisplay))) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "EGLCore", "Release eglTerminate failed");
    }
}
} // namespace NativeXComponentSample