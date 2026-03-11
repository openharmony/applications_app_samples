/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start flex_flex_node]
#ifndef NDKFLEXSAMPLE_ARKUIFLEXNODE_H
#define NDKFLEXSAMPLE_ARKUIFLEXNODE_H

#include "ArkUINode.h"

namespace NativeModule {
class ArkUIFlexNode : public ArkUINode {
public:
    ArkUIFlexNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_FLEX)) {}

    ~ArkUIFlexNode() override = default;

    void SetFlexOption(ArkUI_FlexDirection direction, ArkUI_FlexWrap wrap, ArkUI_FlexAlignment justifyContent,
        ArkUI_ItemAlignment alignItems, ArkUI_FlexAlignment alignContent)
    {
        ArkUI_NumberValue value[] = {
            {.i32 = direction},
            {.i32 = wrap},
            {.i32 = justifyContent},
            {.i32 = alignItems},
            {.i32 = alignContent}
        };
        ArkUI_AttributeItem item = {value, 5};
        nativeModule_->setAttribute(handle_, NODE_FLEX_OPTION, &item);
    }
};
} // namespace NativeModule

#endif // NDKFLEXSAMPLE_ARKUIFLEXNODE_H
// [End flex_flex_node]
