/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
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
