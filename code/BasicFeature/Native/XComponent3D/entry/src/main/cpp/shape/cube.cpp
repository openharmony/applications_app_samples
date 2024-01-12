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

#include "cube.h"
#include "Vector3.h"
#include "camera.h"
#include "log.h"

namespace {
    float g_vertices[] = {
        -0.5f, -0.5f, -0.5f, 0.0f,  0.0f,  -1.0f, 0.0f, 0.0f, 0.5f,  -0.5f, -0.5f, 0.0f,  0.0f,  -1.0f, 1.0f, 0.0f,
        0.5f,  0.5f,  -0.5f, 0.0f,  0.0f,  -1.0f, 1.0f, 1.0f, 0.5f,  0.5f,  -0.5f, 0.0f,  0.0f,  -1.0f, 1.0f, 1.0f,
        -0.5f, 0.5f,  -0.5f, 0.0f,  0.0f,  -1.0f, 0.0f, 1.0f, -0.5f, -0.5f, -0.5f, 0.0f,  0.0f,  -1.0f, 0.0f, 0.0f,

        -0.5f, -0.5f, 0.5f,  0.0f,  0.0f,  1.0f,  0.0f, 0.0f, 0.5f,  -0.5f, 0.5f,  0.0f,  0.0f,  1.0f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,  1.0f, 1.0f, 0.5f,  0.5f,  0.5f,  0.0f,  0.0f,  1.0f,  1.0f, 1.0f,
        -0.5f, 0.5f,  0.5f,  0.0f,  0.0f,  1.0f,  0.0f, 1.0f, -0.5f, -0.5f, 0.5f,  0.0f,  0.0f,  1.0f,  0.0f, 0.0f,

        -0.5f, 0.5f,  0.5f,  -1.0f, 0.0f,  0.0f,  1.0f, 0.0f, -0.5f, 0.5f,  -0.5f, -1.0f, 0.0f,  0.0f,  1.0f, 1.0f,
        -0.5f, -0.5f, -0.5f, -1.0f, 0.0f,  0.0f,  0.0f, 1.0f, -0.5f, -0.5f, -0.5f, -1.0f, 0.0f,  0.0f,  0.0f, 1.0f,
        -0.5f, -0.5f, 0.5f,  -1.0f, 0.0f,  0.0f,  0.0f, 0.0f, -0.5f, 0.5f,  0.5f,  -1.0f, 0.0f,  0.0f,  1.0f, 0.0f,

        0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f, 0.5f,  0.5f,  -0.5f, 1.0f,  0.0f,  0.0f,  1.0f, 1.0f,
        0.5f,  -0.5f, -0.5f, 1.0f,  0.0f,  0.0f,  0.0f, 1.0f, 0.5f,  -0.5f, -0.5f, 1.0f,  0.0f,  0.0f,  0.0f, 1.0f,
        0.5f,  -0.5f, 0.5f,  1.0f,  0.0f,  0.0f,  0.0f, 0.0f, 0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,  1.0f, 0.0f,

        -0.5f, -0.5f, -0.5f, 0.0f,  -1.0f, 0.0f,  0.0f, 1.0f, 0.5f,  -0.5f, -0.5f, 0.0f,  -1.0f, 0.0f,  1.0f, 1.0f,
        0.5f,  -0.5f, 0.5f,  0.0f,  -1.0f, 0.0f,  1.0f, 0.0f, 0.5f,  -0.5f, 0.5f,  0.0f,  -1.0f, 0.0f,  1.0f, 0.0f,
        -0.5f, -0.5f, 0.5f,  0.0f,  -1.0f, 0.0f,  0.0f, 0.0f, -0.5f, -0.5f, -0.5f, 0.0f,  -1.0f, 0.0f,  0.0f, 1.0f,

        -0.5f, 0.5f,  -0.5f, 0.0f,  1.0f,  0.0f,  0.0f, 1.0f, 0.5f,  0.5f,  -0.5f, 0.0f,  1.0f,  0.0f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f, 0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  1.0f, 0.0f,
        -0.5f, 0.5f,  0.5f,  0.0f,  1.0f,  0.0f,  0.0f, 0.0f, -0.5f, 0.5f,  -0.5f, 0.0f,  1.0f,  0.0f,  0.0f, 1.0f};

    // 阴影着色
    char g_shaderfs[] = "#version 300 es\n"
                        "precision mediump float;\n"
                        "out vec4 FragColor; \n"
                        "struct Material { \n"
                        "vec3 ambient; \n"
                        "vec3 diffuse; \n"
                        "vec3 specular; \n"
                        "float shininess; \n"
                        "}; \n"

                        "struct Light { \n"
                        "vec3 position; \n"
                        "vec3 ambient; \n"
                        "vec3 diffuse; \n"
                        "vec3 specular; \n"
                        "}; \n"

                        "in vec3 Normal;\n"
                        "in vec3 FragPos;\n"

                        "uniform vec3 viewPos;\n"
                        "uniform Material material;\n"
                        "uniform Light light; \n"

                        "void main() \n"
                        "{\n"
                        "vec3 ambient = light.ambient * material.ambient; \n"

                        "vec3 norm = normalize(Normal); \n"
                        "vec3 lightDir = normalize(light.position - FragPos); \n"
                        "float diff = max(dot(norm, lightDir), 0.0); \n"
                        "vec3 diffuse = light.diffuse * (diff * material.diffuse);\n"
                        "vec3 viewDir = normalize(viewPos - FragPos); \n"
                        "vec3 reflectDir = reflect(-lightDir, norm); \n"
                        "float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess); \n"
                        "vec3 specular = light.specular * (spec * material.specular); \n"
                        "vec3 result = ambient + diffuse + specular; \n"
                        "FragColor = vec4(result, 1.0); \n"
                        "}\n";

    // 遮光板
    char g_lightshaderfs[] = "#version 300 es\n"
                             "precision mediump float;\n"
                             "out vec4 FragColor;\n"
                             "void main()\n"
                             "{\n"
                             "   FragColor = vec4(1.0);\n"
                             "}\n";

    // VS着色
    char g_shadervs[] = "#version 300 es\n"
                        "layout (location = 0) in vec3 aPos;\n"
                        "layout (location = 1) in vec3 aNormal;\n"
                        "layout (location = 2) in vec2 aTexCoords;\n"

                        "out vec3 Normal;\n"
                        "out vec3 FragPos;\n"
                        "out vec2 TexCoords;\n"

                        "uniform mat4 model;\n"
                        "uniform mat4 view; \n"
                        "uniform mat4 projection; \n"

                        "void main()\n"
                        "{\n"
                        "  TexCoords = aTexCoords;\n"
                        "  FragPos = vec3(model * vec4(aPos, 1.0));\n"
                        "  Normal = mat3(transpose(inverse(model))) * aNormal; \n"
                        "  gl_Position = projection*view*model*vec4(aPos, 1.0);\n"
                        "}\n";
} // namespace

int32_t Cube::Init()
{
    camera = new Camera(Vector3(0, 0, 3.0f));
    ourShader = new Shader(false, g_shadervs, g_shaderfs);
    lightShader = new Shader(false, g_shadervs, g_lightshaderfs);
    lightPos = new Vector3(1.2f, 1.0f, 2.0f);
    return 0;
}

// 绘图转换
void Cube::Update()
{
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertices), g_vertices, GL_STATIC_DRAW);
    // 位置属性
    glVertexAttribPointer(0, kThree, GL_FLOAT, GL_FALSE, kEight * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    // 法线
    glVertexAttribPointer(1, kThree, GL_FLOAT, GL_FALSE, kEight * sizeof(float), (void *)(kThree * sizeof(float)));
    glEnableVertexAttribArray(1);
    // ST
    glVertexAttribPointer(kTwo, kTwo, GL_FLOAT, GL_FALSE, kEight * sizeof(float), (void *)(kSix * sizeof(float)));
    glEnableVertexAttribArray(kTwo);
    ourShader->use();
    ourShader->SetInt("material.diffuse", 0);
    ourShader->SetInt("material.specular", 1);
    Update1();
}

// 绘图转换
void Cube::Update1()
{
    const unsigned int scrWidth = 800;
    const unsigned int scrHeight = 600;
    // 将投影矩阵传递给着色器（请注意，在这种情况下，它可能会更改每一帧）
    Matrix4x4 projection =
        Algorithm::Perspective(Algorithm::Radians(camera->Zoom), (float)scrWidth / (float)scrHeight, 0.1f, 100.0f);
    ourShader->SetMatrix4x4("projection", projection);
    // 摄影机/视图变换
    Matrix4x4 view = camera->GetViewMatrix();
    ourShader->SetMatrix4x4("view", view);
    // 渲染框
    glBindVertexArray(vao);
    // 计算每个对象的模型矩阵，并在绘制之前将其传递给着色器
    // 确保先将矩阵初始化为单位矩阵
    Matrix4x4 model = Matrix4x4::Identity();
    // 光源属性
    ourShader->SetVec3("light.ambient", 1.0f, 1.0f, 1.0f);
    ourShader->SetVec3("light.diffuse", 1.0f, 1.0f, 1.0f);
    ourShader->SetVec3("light.specular", 1.0f, 1.0f, 1.0f);
    // 材料属性
    ourShader->SetVec3("material.ambient", 0.0f, 0.1f, 0.06f);
    ourShader->SetVec3("material.diffuse", 0.0f, 0.50980392f, 0.50980392f);
    ourShader->SetVec3("material.specular", 0.50196078f, 0.50196078f, 0.50196078f);
    ourShader->SetFloat("material.shininess", 32.0f);
    lightPos->SetDataX(sin(position) * 3.0f);
    lightPos->SetDataZ(cos(position) * 3.0f);
    ourShader->SetVector3("light.position", *lightPos);

    model.MakeRoate(1, Vector3(0, 1, 0));
    ourShader->SetMatrix4x4("model", model);

    ourShader->SetVector3("viewPos", camera->Position);
    glDrawArrays(GL_TRIANGLES, 0, 36); // K36

    model = Matrix4x4::Identity();
    Matrix4x4 translate = Matrix4x4::Identity();
    translate.MakeTranslation(*lightPos);
    Matrix4x4 scale = Matrix4x4::Identity();
    scale.MakeScale(Vector3(0.2f, 0.2f, 0.2f));
    Matrix4x4::Multiply(translate, scale, model);

    lightShader->use();
    lightShader->SetMatrix4x4("model", model);
    lightShader->SetMatrix4x4("projection", projection);
    lightShader->SetMatrix4x4("view", view);
    glDrawArrays(GL_TRIANGLES, 0, 36); // K36
}

int32_t Cube::Quit(void)
{
    glDeleteVertexArrays(1, &vao);
    glDeleteBuffers(1, &vbo);

    glDeleteProgram(ourShader->ID);
    glDeleteProgram(lightShader->ID);

    delete ourShader;
    ourShader = nullptr;
    delete lightShader;
    lightShader = nullptr;
    delete camera;
    camera = nullptr;
    delete lightPos;
    lightPos = nullptr;
    LOGE("Cube Quit success.");
    return 0;
}

void Cube::Animate()
{
    if (position >= 10.5) { // max = 10.5
        positive = -1;
    }
    if (position <= 8.5) { // min 8.5
        positive = 1;
    }
    position = position + 0.005 * positive; // K0.005
}
