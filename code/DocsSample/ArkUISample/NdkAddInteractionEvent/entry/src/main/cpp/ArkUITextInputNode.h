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
// [Start Cpp_ArkUITextInputNode]
// ArkUITextInputNode.h
#ifndef MYAPPLICATION_ARKUITEXTINPUTNODE_H
#define MYAPPLICATION_ARKUITEXTINPUTNODE_H

#include "ArkUINode.h"
#include <string>

namespace NativeModule {

class ArkUITextInputNode : public ArkUINode {
public:
    ArkUITextInputNode()
        : ArkUINode((NativeModuleInstance::GetInstance()->GetNativeNodeAPI())->createNode(ARKUI_NODE_TEXT_INPUT)) {}

    ~ArkUITextInputNode() override {}

    void SetPlaceholder(const std::string &placeholder)
    {
        ArkUI_AttributeItem item = {nullptr, 0, placeholder.c_str()};
        nativeModule_->setAttribute(handle_, NODE_TEXT_INPUT_PLACEHOLDER, &item);
    }

    void SetType(ArkUI_TextInputType type)
    {
        ArkUI_NumberValue value[] = {{.i32 = type}};
        ArkUI_AttributeItem item = {value, 1};
        nativeModule_->setAttribute(handle_, NODE_TEXT_INPUT_TYPE, &item);
    }
};

} // namespace NativeModule

#endif // MYAPPLICATION_ARKUITEXTINPUTNODE_H
// [End Cpp_ArkUITextInputNode]
