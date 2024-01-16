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

#ifndef RECTANGLE_H
#define RECTANGLE_H

#include <cstdint>
#include "shader.h"
#include "base_shape.h"

class Rectangle : public BaseShape {
public:
    int32_t Init() override;
    void Update(void) override;
    int32_t Quit(void) override;
    void Animate(void) override;

protected:
    Shader *ourShader = nullptr;
    unsigned int vao;
    unsigned int vbo;
    unsigned int ebo;

    // 动画属性更新
    float stride = 0;
};


#endif // RECTANGLE_H
