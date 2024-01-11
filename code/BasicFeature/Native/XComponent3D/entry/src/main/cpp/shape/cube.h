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

#ifndef MAGICCUBE_CUBE_H
#define MAGICCUBE_CUBE_H

#include <cstdint>
#include "Vector3.h"
#include "camera.h"
#include "shader.h"
#include "base_shape.h"

class Cube : public BaseShape {
public:
    int32_t Init() override;
    void Update(void) override;
    void Update1(void);
    int32_t Quit(void) override;
    void Animate(void) override;

protected:
    Camera *camera = nullptr;

    Vector3 *lightPos = nullptr;
    Shader *lightShader = nullptr;

    Shader *ourShader = nullptr;

    unsigned int vao;
    unsigned int vbo;

    // 动画属性更新
    float position = 10;
    int positive = 1;
};


#endif // MAGICCUBE_CUBE_H