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

#ifndef MYAPPLICATION_ARKUISCROLLNODE_H
#define MYAPPLICATION_ARKUISCROLLNODE_H

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIScrollNode : public ArkUINode {
public:
    ArkUIScrollNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_SCROLL)) {}

    ~ArkUIScrollNode() override {}
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUISCROLLNODE_H