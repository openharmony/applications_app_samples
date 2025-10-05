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
#ifndef CAPI_FORM_MANAGER_H
#define CAPI_FORM_MANAGER_H

#include <arkui/native_node.h>
#include <cstdint>
#include <functional>
#include <map>
#include <mutex>
#include <napi/native_api.h>
#include <unordered_map>

namespace NativeNode::Form {
using EventCallback = std::function<void(ArkUI_NodeEvent*)>;

// 指定对事件进行绑定还是解绑
enum EventOperation {
    BIND_EVENT,
    UNBIND_EVENT,
};

struct NodeRecord {
    ArkUI_NodeHandle nodeHandle;
    int32_t nodeType;
};

const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

class NodeManager {
public:
    ~NodeManager() = default;
    static NodeManager& GetInstance();
    static ArkUI_NativeNodeAPI_1* GetNodeApi();
    
    ArkUI_NodeHandle GetMainPageSroll();
    int32_t CreateNativeNode(int32_t nodeType);
    void RemoveOldNode(int32_t nodeId);
    int32_t SetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType);
    int32_t SetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType, int32_t value);
    int32_t ResetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType);
    const ArkUI_AttributeItem* GetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType);
    
private:
    NodeManager() = default;
    int32_t AddNativeNode(ArkUI_NodeHandle newNode, int32_t nodeType);
    NodeRecord GetNativeNode(int32_t id);
    void RemoveNativeNode(int32_t id);
    bool IsValidAttributeType(int32_t nodeType, int32_t attributeType);
    void BindEventByType(ArkUI_NodeHandle newNode, int32_t nodeType, EventOperation operation);
    void BindEventFunc(ArkUI_NodeHandle newNode, int32_t begin, int32_t end, EventOperation operation);
    
    std::unordered_map<int32_t, EventCallback> callbackMap_;
    std::map<int32_t, NodeRecord> nativeNodeMap_;
    std::mutex mutex_;
    int32_t nodeId_ = 1;
    
    ArkUI_NodeHandle mainPageScroll_ = nullptr;
};

class TransTool {
public:
    static napi_value CreateFormPage(napi_env env, napi_callback_info info);
    static napi_value CreateFormNode(napi_env env, napi_callback_info info);
    static napi_value RemoveFormNode(napi_env env, napi_callback_info info);
    static napi_value SetFormAttribute(napi_env env, napi_callback_info info);
    static napi_value ResetFormAttribute(napi_env env, napi_callback_info info);
    static napi_value GetFormAttribute(napi_env env, napi_callback_info info);
};
}
#endif //CAPI_FORM_MANAGER_H

