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
#ifndef XCOMPONENT3D_BASE_SHAPE_H
#define XCOMPONENT3D_BASE_SHAPE_H

#include <cstdint>

class BaseShape {
public:
    virtual int32_t Init() = 0;
    virtual void Update(void) = 0;
    virtual int32_t Quit(void) = 0;
    virtual void Animate(void) = 0;
};

#endif // XCOMPONENT3D_BASE_SHAPE_H
