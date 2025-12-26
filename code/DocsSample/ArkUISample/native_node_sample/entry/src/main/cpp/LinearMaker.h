/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#ifndef LINEAR_MAKER_H
#define LINEAR_MAKER_H

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_gesture.h>
#include <arkui/native_node.h>

class LinearMaker {
public:
    LinearMaker() {};
    ~LinearMaker() {};

    static ArkUI_NodeHandle CreateNativeNode();
};
#endif // LINEAR_MAKER_H
