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

#ifndef MYAPPLICATION_ARKUIGRIDITEMNODE_H
#define MYAPPLICATION_ARKUIGRIDITEMNODE_H

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIGridItemNode : public ArkUINode {
public:
    ArkUIGridItemNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_GRID_ITEM))
    {
    }

    ~ArkUIGridItemNode() override {}
};
} // namespace NativeModule

#endif // MYAPPLICATION_ARKUIGRIDITEMNODE_H