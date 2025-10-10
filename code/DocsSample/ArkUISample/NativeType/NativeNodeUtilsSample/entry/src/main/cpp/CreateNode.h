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
// CreateNode.h
#ifndef MYAPPLICATION_CREATENODE_H
#define MYAPPLICATION_CREATENODE_H

#include "ArkUINode.h"
#include <js_native_api.h>

namespace NativeModule {
    // 封装Button组件。
    class ArkUIButtonNode : public ArkUINode {
    public:
        ArkUIButtonNode()
            : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_BUTTON)) {}
        int32_t SetLabel(ArkUI_AttributeItem &label_item)
        {
            return nativeModule_->setAttribute(handle_, NODE_BUTTON_LABEL, &label_item);
        }
        int32_t SetMargin(ArkUI_AttributeItem &item)
        {
            return nativeModule_->setAttribute(handle_, NODE_MARGIN, &item);
        }
    };

    // 封装Row组件。
    class ArkUIRowNode : public ArkUINode {
    public:
        ArkUIRowNode()
            : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_ROW)) {}
    };

    // 封装Scroll组件。
    class ArkUIScrollNode : public ArkUINode {
    public:
        ArkUIScrollNode()
            : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_SCROLL)) {}
    };

    // 封装Column组件。
    class ArkUIColumnNode : public ArkUINode {
    public:
        ArkUIColumnNode()
            : ArkUINode(NativeModuleInstance::GetInstance()->GetNativeNodeAPI()->createNode(ARKUI_NODE_COLUMN)) {}
    };

    // 多线程创建组件。
    napi_value CreateNodeTreeOnMultiThread(napi_env env, napi_callback_info info);
    // 释放多线程创建的组件。
    napi_value DisposeNodeTreeOnMultiThread(napi_env env, napi_callback_info info);
} // namespace NativeModule

#endif // MYAPPLICATION_CREATENODE_H