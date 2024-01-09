/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef MYXCOMPONENT_BASE_SHAPE_H
#define MYXCOMPONENT_BASE_SHAPE_H

#include <cstdint>

class BaseShape {
public:
    virtual int32_t Init() = 0;
    virtual void Update(void) = 0;
    virtual int32_t Quit(void) = 0;
    virtual void Animate(void) = 0;
};

#endif // MyXComponent_base_shape_H
