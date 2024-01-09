/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
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