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

#ifndef XCOMPONENTDEMO_SHADER_H
#define XCOMPONENTDEMO_SHADER_H

#include <string.h>
#include <fstream>
#include <sstream>
#include <iostream>
#include <GLES3/gl3.h>

#include "algorithm/Vector3.h"
#include "algorithm/Matrix4x4.h"
#include "log.h"

class Shader {
public:
    unsigned int ID;
    // 构造函数动态生成着色器
    // ------------------------------------------------------------------------
    Shader(bool isText, const char *vShaderCode, const char *fShaderCode)
    {
        // 2. 编译着色器
        unsigned int vertex;
        unsigned int fragment;
        // 顶点着色器
        vertex = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertex, 1, &vShaderCode, NULL);
        glCompileShader(vertex);
        checkCompileErrors(vertex, "VERTEX");
        // 片段着色器
        fragment = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragment, 1, &fShaderCode, NULL);
        glCompileShader(fragment);
        checkCompileErrors(fragment, "FRAGMENT");
        // 如果给定了几何体着色器，请编译几何体着色器
        // 着色器程序
        ID = glCreateProgram();
        glAttachShader(ID, vertex);
        glAttachShader(ID, fragment);
        glLinkProgram(ID);
        checkCompileErrors(ID, "PROGRAM");
        // 删除着色器，因为它们现在链接到着色器程序中，不再需要了
        glDeleteShader(vertex);
        glDeleteShader(fragment);
    }

    // 选择着色器程序
    // ------------------------------------------------------------------------
    void use() { glUseProgram(ID); }
    // uniform的实用函数
    // ------------------------------------------------------------------------
    void SetBool(const std::string &name, bool value) const
    {
        glUniform1i(glGetUniformLocation(ID, name.c_str()), (int)value);
    }
    // ------------------------------------------------------------------------
    void SetInt(const std::string &name, int value) const
    {
        glUniform1i(glGetUniformLocation(ID, name.c_str()), value);
    }
    // ------------------------------------------------------------------------
    void SetFloat(const std::string &name, float value) const
    {
        glUniform1f(glGetUniformLocation(ID, name.c_str()), value);
    }
    // ------------------------------------------------------------------------
    void SetVec2(const std::string &name, float x, float y) const
    {
        glUniform2f(glGetUniformLocation(ID, name.c_str()), x, y);
    }
    // ------------------------------------------------------------------------
    void SetVec3(const std::string &name, float x, float y, float z) const
    {
        glUniform3f(glGetUniformLocation(ID, name.c_str()), x, y, z);
    }
    // ------------------------------------------------------------------------
    void SetVector3(const std::string &name, Vector3 &value) const
    {
        glUniform3f(glGetUniformLocation(ID, name.c_str()), value.GetDataX(), value.GetDataY(), value.GetDataZ());
    }
    void SetVec4(const std::string &name, float x, float y, float z, float w) const
    {
        glUniform4f(glGetUniformLocation(ID, name.c_str()), x, y, z, w);
    }

    // ------------------------------------------------------------------------
    void SetMatrix4x4(const std::string &name, Matrix4x4 &mat) const
    {
        glUniformMatrix4fv(glGetUniformLocation(ID, name.c_str()), 1, GL_FALSE, &mat.GetValues()[0]);
    }
    void SetMat4fv(const std::string &name, const GLfloat *mat) const
    {
        GLuint loc = glGetUniformLocation(ID, name.c_str());
        glUniformMatrix4fv(loc, 1, GL_FALSE, mat);
    }

private:
    // 用于检查着色器编译/链接错误的实用函数。
    // ------------------------------------------------------------------------
    void checkCompileErrors(GLuint shader, std::string type)
    {
        GLint success;
        GLchar infoLog[1024];
        if (type != "PROGRAM") {
            glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
            if (!success) {
                glGetShaderInfoLog(shader, 1024, NULL, infoLog); // glGetShaderInfoLog 1024
                LOGE("ERROR::SHADER_COMPILATION_ERROR of type: %{public}s ,  %{public}s", type.c_str(), infoLog);
            }
        } else {
            glGetProgramiv(shader, GL_LINK_STATUS, &success);
            if (!success) {
                glGetProgramInfoLog(shader, 1024, NULL, infoLog); // glGetShaderInfoLog 1024
                LOGE("ERROR::PROGRAM_LINKING_ERROR of type: %{public}s ,  %{public}s", type.c_str(), infoLog);
            }
        }
    }
};

#endif // XCOMPONENTDEMO_SHADER_H
