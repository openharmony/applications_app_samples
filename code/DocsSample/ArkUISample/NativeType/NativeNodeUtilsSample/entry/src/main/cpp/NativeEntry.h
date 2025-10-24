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
// NativeEntry.h
#ifndef MYAPPLICATION_NATIVEENTRY_H
#define MYAPPLICATION_NATIVEENTRY_H

#include <ArkUIBaseNode.h>
#include <arkui/native_type.h>
#include <js_native_api_types.h>

namespace NativeModule 
{

    napi_value CreateNativeRoot(napi_env env, napi_callback_info info);
    napi_value CreateNodeTreeOnMultiThread(napi_env env, napi_callback_info info);
    napi_value DisposeNodeTreeOnMultiThread(napi_env env, napi_callback_info info);
    napi_value DestroyNativeRoot(napi_env env, napi_callback_info info);
    napi_value GetContext(napi_env env, napi_callback_info info);
    napi_value GetNodeHandle(napi_env env, napi_callback_info info);
    napi_value GetNodeHandleById(napi_env env, napi_callback_info info);
    napi_value GetNodeHandleByUniqueId(napi_env env, napi_callback_info info);
    napi_value CreateDrawNode(napi_env env, napi_callback_info info);
    napi_value CreateNativeRoot(napi_env env, napi_callback_info info);
    napi_value DestroyNativeRoot(napi_env env, napi_callback_info info);

    const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
    // 管理Native组件的生命周期和内存。
    class NativeEntry {
    public:
        static NativeEntry *GetInstance()
        {
            static NativeEntry nativeEntry;
            return &nativeEntry;
        }

        void SetContentHandle(ArkUI_NodeContentHandle handle) { handle_ = handle; }

        void SetContextHandle(ArkUI_ContextHandle handle) { context_ = handle; }

        void SetNodeHandle(ArkUI_NodeHandle handle) { nodeHandle_ = handle; }

        void SetWindowName();

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

        void RegisterNodeEventReceiver();
        void UnregisterNodeEventReceiver();

        void AddNode(std::shared_ptr<ArkUIBaseNode> node) { nodes_.emplace(node->GetHandle(), node); }
        std::shared_ptr<ArkUIBaseNode> FindNodeByHandle(ArkUI_NodeHandle nodeHandle)
        {
            return nodes_.find(nodeHandle)->second;
        }
        void ClearNode() { nodes_.clear(); }

    private:
        std::shared_ptr<ArkUIBaseNode> root_;
        ArkUI_NodeContentHandle handle_;
        ArkUI_ContextHandle context_;
        ArkUI_NodeHandle nodeHandle_;
        const char *windowName_ = nullptr;

        // 管理生成的元素，通过map来查找nodeHandle和对应的BaseNode。
        std::unordered_map<ArkUI_NodeHandle, std::shared_ptr<ArkUIBaseNode>> nodes_;
    };

} // namespace NativeModule

#endif // MYAPPLICATION_NATIVEENTRY_H