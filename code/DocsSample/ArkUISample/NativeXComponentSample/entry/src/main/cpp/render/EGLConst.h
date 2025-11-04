/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef NATIVEXCOMPONENT_EGLCONST_H
#define NATIVEXCOMPONENT_EGLCONST_H
// [Start egl_const_h]
// EGLConst.h
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl3.h>

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

/**
 * Program 错误
 */
const GLuint PROGRAM_ERROR = 0;

/**
 * 位置错误。
 */
const GLint POSITION_ERROR = -1;

/**
 * 默认x坐标。
 */
const int DEFAULT_X_POSITION = 0;

/**
 * 默认y坐标。
 */
const int DEFAULT_Y_POSITION = 0;

/**
 * Gl 红色默认值。
 */
const GLfloat GL_RED_DEFAULT = 0.0;

/**
 * Gl 绿色默认值。
 */
const GLfloat GL_GREEN_DEFAULT = 0.0;

/**
 * Gl 蓝色默认值。
 */
const GLfloat GL_BLUE_DEFAULT = 0.0;

/**
 * Gl 透明度。
 */
const GLfloat GL_ALPHA_DEFAULT = 1.0;

/**
 * Pointer 数量。
 */
const GLint POINTER_SIZE = 2;

/**
 * Triangle fan 尺寸。
 */
const GLsizei TRIANGLE_FAN_SIZE = 4;

/**
 * 50%。
 */
const float FIFTY_PERCENT = 0.5;

/**
 * 位置句柄名字。
 */
const char POSITION_NAME[] = "a_position";

// [StartExclude egl_const_h]
/**
 * numeric value 0.
 */
const int NUM_0 = 0;

/**
 * numeric value 4.
 */
const int NUM_4 = 4;
// [EndExclude egl_const_h]

/**
 * 背景色 #f4f4f4.
 */
const GLfloat BACKGROUND_COLOR[] = {244.0f / 255, 244.0f / 255, 244.0f / 255, 1.0f};

// [StartExclude egl_const_h]
/**
 * Background color #ffffff00.
 */
const GLfloat TRANSPARENT_COLOR[] = {255.0f / 255, 255.0f / 255, 255.0f / 255, 0.0f};
// [EndExclude egl_const_h]

/**
 * Draw 颜色 #7E8FFB.
 */
const GLfloat DRAW_COLOR[] = {126.0f / 255, 143.0f / 255, 251.0f / 255, 1.0f};

/**
 * Change 颜色 #92D6CC.
 */
const GLfloat CHANGE_COLOR[] = {146.0f / 255, 214.0f / 255, 204.0f / 255, 1.0f};

/**
 * 背景区域。
 */
const GLfloat BACKGROUND_RECTANGLE_VERTICES[] = {-1.0f, 1.0f, 1.0f, 1.0f, 1.0f, -1.0f, -1.0f, -1.0f};

const EGLint ATTRIB_LIST[] = {
    // 键，值。
    EGL_SURFACE_TYPE, EGL_WINDOW_BIT, EGL_RED_SIZE, 8, EGL_GREEN_SIZE, 8, EGL_BLUE_SIZE, 8, EGL_ALPHA_SIZE, 8,
    EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
    // 结束。
    EGL_NONE};

const EGLint CONTEXT_ATTRIBS[] = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE};

/**
 * 顶点着色器
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
 * 片元着色器。
 */
const char FRAGMENT_SHADER[] = "#version 300 es\n"
                               "precision mediump float;                  \n"
                               "in vec4 v_color;                          \n"
                               "out vec4 fragColor;                       \n"
                               "void main()                               \n"
                               "{                                         \n"
                               "   fragColor = v_color;                   \n"
                               "}                                         \n";
// [End egl_const_h]
#endif // NATIVEXCOMPONENT_EGLCONST_H
