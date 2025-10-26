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
#include "manager.h"
// [Start contentslot_native]
#include "napi/native_api.h"
#include "arkui/native_type.h"
#include "arkui/native_node.h"
#include "arkui/native_node_napi.h"
#include "arkui/native_interface.h"
#include "hilog/log.h"
// [StartExclude contentslot_native]
namespace NativeNodeManager {
// [EndExclude contentslot_native]
ArkUI_NodeContentHandle nodeContentHandle_ = nullptr;
ArkUI_NativeNodeAPI_1 *nodeAPI;
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

// 在Native侧创建一个宽高为480vp*480vp、背景色为0xFFFF0000（红色）的Column组件。对于更详细的节点树创建方法，请参考ArkUI API文档的C API章节。
ArkUI_NodeHandle NodeManager::CreateNodeHandle()
{
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue value[] = {480};
    ArkUI_AttributeItem item{value, 1};
    nodeAPI->setAttribute(column, NODE_WIDTH, &item);
    nodeAPI->setAttribute(column, NODE_HEIGHT, &item);
    value[0].u32 = 0xFFFF0000;
    nodeAPI->setAttribute(column, NODE_BACKGROUND_COLOR, &item);
    return column;
}
    
// ArkTS侧createNativeNode方法在Native侧的具体实现
napi_value NodeManager::CreateNativeNode(napi_env env, napi_callback_info info)
{
    // napi相关处理空指针&数据越界等问题
    if ((env == nullptr) || (info == nullptr)) {
        return nullptr;
    }

    size_t argc = 1;
    napi_value args[1] = { nullptr };
    if (napi_get_cb_info(env, info, &argc, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "CreateNativeNode napi_get_cb_info failed");
    }

    if (argc != 1) {
        return nullptr;
    }

    nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));

    // 将nodeContentHandle_指向ArkTS侧传入的nodeContent
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle_);

    if (nodeAPI != nullptr) {
        if (nodeAPI->createNode != nullptr && nodeAPI->addChild != nullptr) {
            // [Start contentslot_add]
            ArkUI_NodeHandle component;
            // 创建C侧组件
            component = CreateNodeHandle();
            // 将组件添加到nodeContent管理器中
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle_, component);
            // [End contentslot_add]
            // [StartExclude contentslot_native]
            // [Start contentslot_insert]
            size_t position = 0;
            ArkUI_NodeHandle component1 = CreateNodeHandle();
            // 将组件插入nodeContent管理器对应位置
            OH_ArkUI_NodeContent_InsertNode(nodeContentHandle_, component1, position);
            // [End contentslot_insert]
            // [Start contentslot_remove]
            // 在nodeContent中移除对应组件
            OH_ArkUI_NodeContent_RemoveNode(nodeContentHandle_, component1);
            // [End contentslot_remove]
            // [EndExclude contentslot_native]
        }
    }
    return nullptr;
}
// [End contentslot_native]
 
void *NodeManager::CreateUserData()
{
    auto data = new int32_t(123);
    return static_cast<void*>(data);
}
 
void *NodeManager::GetUserData()
{
    // [Start contentslot_get_data]
    void *userData = OH_ArkUI_NodeContent_GetUserData(nodeContentHandle_);
    // [End contentslot_get_data]
    return userData;
}

void NodeManager::SetUserData()
{
    // [Start contentslot_set_data]
    // 创建需要定义的自定义数据
    void *userData = CreateUserData();
    OH_ArkUI_NodeContent_SetUserData(nodeContentHandle_, userData);
    // [End contentslot_set_data]
}

void NodeManager::RegisterEvent()
{
    // [Start contentslot_register_event]
    auto nodeContentEvent = [](ArkUI_NodeContentEvent *event) {
        ArkUI_NodeContentHandle content = OH_ArkUI_NodeContentEvent_GetNodeContentHandle(event);
        // 针对不同content需要额外做的逻辑
        if (OH_ArkUI_NodeContentEvent_GetEventType(event) == NODE_CONTENT_EVENT_ON_ATTACH_TO_WINDOW) {
            // ContentSlot上树时需要触发的逻辑
            // [StartExclude contentslot_register_event]
            OH_ArkUI_NodeContent_SetUserData(content, new int32_t(123));
            // [EndExclude contentslot_register_event]
        } else if (OH_ArkUI_NodeContentEvent_GetEventType(event) == NODE_CONTENT_EVENT_ON_DETACH_FROM_WINDOW) {
            // ContentSlot下树时需要触发的逻辑
            // [StartExclude contentslot_register_event]
            int32_t *userData = reinterpret_cast<int32_t *>(OH_ArkUI_NodeContent_GetUserData(content));
            if (userData) {
                delete userData;
                userData = nullptr;
            }
            // [EndExclude contentslot_register_event]
        };
    };
    // 将该事件注册到nodeContent上
    OH_ArkUI_NodeContent_RegisterCallback(nodeContentHandle_, nodeContentEvent);
    // [End contentslot_register_event]
}
} // namespace NativeNodeManager
