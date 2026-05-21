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
// [Start obtain_textarea_all]
#include "manager.h"
#include <sstream>
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>

#define CUSTOM_LOG_TAG "manager"
#define LOG_ERROR(...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0xD001400, CUSTOM_LOG_TAG, __VA_ARGS__)
#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, CUSTOM_LOG_TAG, __VA_ARGS__)

namespace ConstIde {
const uint32_t NUMBER_0 = 0;
const uint32_t NUMBER_1 = 1;
constexpr const char *K_LOG_DOMAIN = "Manager";
} // namespace ConstIde

Manager Manager::manager_;
ArkUI_NativeNodeAPI_1 *Manager::nodeAPI_ = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
template <class MakeNodeFn>
static napi_value CreateNativeNode(napi_env env, napi_callback_info info, const char *who, MakeNodeFn makeNodeFn)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s BEGIN", who);

    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s env or info is null",
                     who);
        return nullptr;
    }
    
    size_t argc = ConstIde::NUMBER_1;
    napi_value args[ConstIde::NUMBER_1] = {nullptr};
    napi_status st = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (st != napi_ok || argc < ConstIde::NUMBER_1) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s napi_get_cb_info failed",
                     who);
        return nullptr;
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[ConstIde::NUMBER_0], &nodeContentHandle);
    if (nodeContentHandle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN,
                     "%{public}s nodeContentHandle is null", who);
        return nullptr;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s after GetNodeContent", who);

    // 可选：保留对 nodeAPI_ 的健壮性检查（与你现有代码一致）
    if (Manager::nodeAPI_ == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s nodeAPI_ is null", who);
        return nullptr;
    }

    // 构建具体节点 & 挂载
    ArkUI_NodeHandle page = makeNodeFn();
    if (page == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "%{public}s makeNodeFn return null",
                     who);
        return nullptr;
    }

    OH_ArkUI_NodeContent_AddNode(nodeContentHandle, page);
    return nullptr;
}

constexpr int32_t NUM_10 = 10;
constexpr int32_t NUM_28 = 28;
constexpr int32_t NUM_400 = 400;

napi_value Manager::CreateTextAreaNativeNode(napi_env__* env, napi_callback_info__* info)
{
    return CreateNativeNode(env, info, "CreateTextAreaNativeNode",
                            []() -> ArkUI_NodeHandle { return CreateTextAreaNativeNode(); });
}

ArkUI_NodeHandle Manager::CreateTextAreaNativeNode()
{
    ArkUI_NativeNodeAPI_1 *nodeApi = Manager::nodeAPI_;
    
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);

    // [Start obtain_create_textarea]
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    // [StartExclude obtain_create_textarea]
    ArkUI_NumberValue textHeight[] = {{.f32 = 100}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    
    nodeApi->addChild(column, text);
    
    // [EndExclude obtain_create_textarea]
    ArkUI_NodeHandle selectionText = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue selectionTextWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem selectionTextWidthItem = {.value = selectionTextWidth, .size = 1};
    nodeApi->setAttribute(selectionText, NODE_WIDTH, &selectionTextWidthItem);
    // [StartExclude obtain_create_textarea]
    nodeApi->addChild(column, selectionText);
    ArkUI_NodeHandle textArea = nodeApi->createNode(ARKUI_NODE_TEXT_AREA);
    ArkUI_NumberValue textAreaWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem textAreaWidthItem = {.value = textAreaWidth, .size = 1};
    nodeApi->setAttribute(textArea, NODE_WIDTH, &textAreaWidthItem);

    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(textArea, NODE_BORDER_WIDTH, &borderWidthItem);

    // [EndExclude obtain_create_textarea]
    const ArkUI_AttributeItem *attributeItem = nodeApi->getAttribute(textArea, NODE_UNIQUE_ID);
    auto id = attributeItem->value[0].i32;
    nodeApi->registerNodeEvent(textArea, NODE_TEXT_AREA_ON_CHANGE, id, text);
    nodeApi->registerNodeEvent(textArea, NODE_TEXT_AREA_ON_PASTE, id, text);
    nodeApi->registerNodeEvent(textArea, NODE_TEXT_AREA_ON_TEXT_SELECTION_CHANGE, id, selectionText);
    // [End obtain_create_textarea]
    TextAreaNodeEventReceiver(nodeApi);
    nodeApi->addChild(column, textArea);
    return column;
}

void Manager::TextAreaNodeEventReceiver(ArkUI_NativeNodeAPI_1* nodeApi)
{
    // [Start obtain_textarea_NodeEventReceiver]
    nodeApi->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        ArkUI_NodeEventType eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        ArkUI_AttributeItem content;
        if (eventType == NODE_TEXT_AREA_ON_CHANGE || eventType == NODE_TEXT_AREA_ON_PASTE) {
            ArkUI_StringAsyncEvent *stringEvent = OH_ArkUI_NodeEvent_GetStringAsyncEvent(event);
            content = {.string = stringEvent->pStr };
        } else if (eventType == NODE_TEXT_AREA_ON_TEXT_SELECTION_CHANGE) {
            ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            std::stringstream selectContent;
            selectContent << "start: " << componentEvent->data[0].i32 << " , end: " << componentEvent->data[1].i32;
            content = {.string = selectContent.str().c_str() };
        } else {
            return;
        }
        ArkUI_NodeHandle textNode = reinterpret_cast<ArkUI_NodeHandle>(OH_ArkUI_NodeEvent_GetUserData(event));
        if (textNode) {
            ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
                OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
            nodeApi->setAttribute(textNode, NODE_TEXT_CONTENT, &content);
        }
    });
    // [End obtain_textarea_NodeEventReceiver]
}
// [End obtain_textarea_all]
