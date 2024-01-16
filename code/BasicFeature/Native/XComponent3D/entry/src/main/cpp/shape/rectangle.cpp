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

#include "rectangle.h"
#include "log.h"

namespace {
    float g_vertices[] = {
        0.5f,  0.5f,  0.0f, 1.0f, 0.0f, 0.0f, 0.5f, 0.5f, 0.5f,  -0.5f, 0.0f, 0.0f, 1.0f, 0.0f, 0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, -0.5f, 0.5f,  0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.5f,
    };

    unsigned int g_indices[] = {0, 1, 3, 1, 2, 3};

    char g_shadervsTransform[] = "#version 300 es\n"
                               "layout(location = 0) in vec3 aPos;\n"
                               "layout(location = 1) in vec3 aColor;\n"
                               "uniform mat4 transform;\n"
                               "out vec3 ourColor;\n"
                               "void main()\n"
                               "{\n"
                               "gl_Position = transform * vec4(aPos, 1.0);\n"
                               "ourColor = aColor;\n"
                               "}\n";

    char g_shaderfsTransform[] = "#version 300 es\n"
                               "precision mediump float;\n"
                               "out vec4 fragColor;\n"
                               "in vec3 ourColor;\n"
                               "void main()\n"
                               "{\n"
                               "fragColor =vec4(ourColor, 1.0);\n"
                               "}\n";
} // namespace

int32_t Rectangle::Init()
{
    ourShader = new Shader(false, g_shadervsTransform, g_shaderfsTransform);
    return 0;
}

// 绘图转换
void Rectangle::Update()
{
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    ourShader->use();

    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);

    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertices), g_vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, kThree, GL_FLOAT, GL_FALSE, kEight * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);

    glVertexAttribPointer(1, kThree, GL_FLOAT, GL_FALSE, kEight * sizeof(float), (void *)(kThree * sizeof(float)));
    glEnableVertexAttribArray(1);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(g_indices), g_indices, GL_STATIC_DRAW);

    // 先旋转再位移
    Matrix4x4 trans = Matrix4x4::Identity();
    trans.MakeTranslation(Vector3(0.5f, -0.5f, 0.0f));

    Matrix4x4 rotate = Matrix4x4::Identity();
    rotate.MakeRoate(stride, Vector3(0.0f, 0.0f, 1.0f));

    // 先旋转再位移
    Matrix4x4 transform = Matrix4x4::Identity();
    Matrix4x4::Multiply(trans, rotate, transform);

    ourShader->use();
    ourShader->SetMatrix4x4("transform", transform);

    glBindVertexArray(vao);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glDrawElements(GL_TRIANGLES, kSix, GL_UNSIGNED_INT, 0);

    // 画第二个图
    trans = Matrix4x4::Identity();
    trans.MakeTranslation(Vector3(-0.5f, 0.5f, 0.0f));
    float scaleValue = sin(stride);
    Matrix4x4 scale = Matrix4x4::Identity();
    scale.MakeScale(Vector3(scaleValue, scaleValue, scaleValue));

    transform = Matrix4x4::Identity();
    Matrix4x4::Multiply(trans, scale, transform);

    ourShader->SetMatrix4x4("transform", transform);
    glDrawElements(GL_TRIANGLES, kSix, GL_UNSIGNED_INT, 0);
}

int32_t Rectangle::Quit(void)
{
    glDeleteVertexArrays(1, &vao);
    glDeleteBuffers(1, &vbo);
    glDeleteBuffers(1, &ebo);
    glDeleteProgram(ourShader->ID);

    delete ourShader;
    ourShader = nullptr;

    LOGE("MagicCube Quit success.");
    return 0;
}

void Rectangle::Animate() { stride = stride + 0.05; } // K0.05