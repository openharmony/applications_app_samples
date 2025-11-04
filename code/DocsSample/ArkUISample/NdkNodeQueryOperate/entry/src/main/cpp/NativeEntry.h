/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef NDKNODEQUERYOPERATE_NATIVEENTRY_H
#define NDKNODEQUERYOPERATE_NATIVEENTRY_H

#include "ArkUIBaseNode.h"
#include <arkui/native_type.h>
#include <js_native_api_types.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <js_native_api.h>

namespace NativeModule {
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

napi_value DestroyNativeRoot(napi_env env, napi_callback_info info);

// 管理Native组件的生命周期和内存。
class NativeEntry {
public:
    static NativeEntry *GetInstance()
    {
        static NativeEntry nativeEntry;
        return &nativeEntry;
    }

    void SetContentHandle(ArkUI_NodeContentHandle handle)
    {
        handle_ = handle;
    }

    void SetRootNode(const std::shared_ptr<ArkUIBaseNode> &baseNode)
    {
        root_ = baseNode;
        // 添加Native组件到NodeContent上用于挂载显示。
        OH_ArkUI_NodeContent_AddNode(handle_, root_->GetHandle());
    }
    void DisposeRootNode()
    {
        // 从NodeContent上卸载组件并销毁Native组件。
        OH_ArkUI_NodeContent_RemoveNode(handle_, root_->GetHandle());
        root_.reset();
    }

private:
    std::shared_ptr<ArkUIBaseNode> root_;
    ArkUI_NodeContentHandle handle_;
};

class Manager {
public:
    static ArkUI_NativeNodeAPI_1 *nodeAPI_;
    ~Manager(){};

    static napi_value CreateInquireUniqueIdNode(napi_env env, napi_callback_info info);
    static napi_value CreateMoveToNode(napi_env env, napi_callback_info info);
    static napi_value CreateUserIdNode(napi_env env, napi_callback_info info);
    static napi_value ShowSubcomponentInfo(napi_env env, napi_callback_info info);
private:
    static Manager manager_;
};

} // namespace NativeModule

#endif // NDKNODEQUERYOPERATE_NATIVEENTRY_H
