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
#include "XComponentMaker.h"
#include "manager.h"
#include <arkui/native_interface.h>
#include <arkui/native_type.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_declaration.h>
#include <sstream>
#include "napi/native_api.h"
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <string>

#define ON_ERROR_CODE_DEMO_103501 103501
#define ON_ERROR_CODE_DEMO_106104 106104
#define COLUMN_MARGIN 10
#define VALUEF f32
#define VALUEU u32
#define VALUEI i32
#define XC_TWO 2
static void xOnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d", ARKUI_ERROR_CODE_NODE_EVENT_PARAM_INVALID);
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    auto nodeHandler = OH_ArkUI_NodeEvent_GetNodeHandle(event);
    switch (eventId) {
        // XComponent状态异常
        case ON_ERROR_CODE_DEMO_103501: {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d",
                ARKUI_ERROR_CODE_XCOMPONENT_STATE_INVALID);
            return;
        }
        // 懒加载适配器未绑定到组件上
        case ON_ERROR_CODE_DEMO_106104: {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "manager", "错误码: %d", ARKUI_ERROR_CODE_ADAPTER_NOT_BOUND);
            return;
        }
        default:
            break;
        }
}
ArkUI_NodeHandle XComponentMaker::CreateNodeHandle(const std::string &tag)
{
    ArkUI_NodeHandle xc;
    ArkUI_NodeHandle XCHandle;
    ArkUI_NodeHandle column = Manager::XnodeAPI->createNode(ARKUI_NODE_COLUMN);
    XCHandle = Manager::XnodeAPI->createNode(ARKUI_NODE_XCOMPONENT);
    ArkUI_NumberValue value_xc[] = {{.VALUEF = 200}};
    ArkUI_AttributeItem item_xc = {value_xc, 1};
    ArkUI_NumberValue valuexc[] = {480};
    ArkUI_NumberValue value1xc[] = {{.VALUEU = 15}, {.VALUEF = 15}};
    ArkUI_AttributeItem itemxc = {valuexc, 1, "changeSize"};
    ArkUI_AttributeItem item1xc = {value1xc, 2};
    Manager::XnodeAPI->setAttribute(column, NODE_WIDTH, &itemxc);
    valuexc[0].VALUEF = COLUMN_MARGIN;
    Manager::XnodeAPI->setAttribute(column, NODE_MARGIN, &itemxc);
    xc = Manager::XnodeAPI->createNode(ARKUI_NODE_XCOMPONENT_TEXTURE); // 使用示例
    xc = Manager::XnodeAPI->createNode(ARKUI_NODE_XCOMPONENT);
    valuexc[0].VALUEU = ARKUI_XCOMPONENT_TYPE_SURFACE;
    Manager::XnodeAPI->setAttribute(xc, NODE_XCOMPONENT_TYPE, &itemxc);
    Manager::XnodeAPI->setAttribute(xc, NODE_XCOMPONENT_ID, &itemxc);
    Manager::XnodeAPI->setAttribute(xc, NODE_XCOMPONENT_SURFACE_SIZE, &item1xc);
    Manager::XnodeAPI->setAttribute(xc, NODE_XCOMPONENT_SURFACE_RECT, &item1xc);
    Manager::XnodeAPI->setAttribute(xc, NODE_XCOMPONENT_ENABLE_ANALYZER, &item1xc);
    valuexc[0].VALUEI = ARKUI_XCOMPONENT_TYPE_TEXTURE; // 使用示例
    valuexc[0].VALUEI = ARKUI_XCOMPONENT_TYPE_SURFACE;
    int32_t ret = Manager::XnodeAPI->setAttribute(XCHandle, NODE_XCOMPONENT_TYPE, &item_xc);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0xff00, "XComponent_Native", "CYC_ set NODE_XCOMPONENT_TYPE ret=%{public}d", ret);
    OH_NativeXComponent *nativeXComponent = OH_NativeXComponent_GetNativeXComponent(XCHandle);
    ArkUI_NumberValue value[] = {{.VALUEF = 1}};
    ArkUI_AttributeItem item = {value, 1};
    ArkUI_AttributeItem content = {.string = tag.c_str()};
    Manager::XnodeAPI->setAttribute(column, NODE_WIDTH_PERCENT, &item);
    value[0].VALUEF = 40;
    Manager::XnodeAPI->setAttribute(column, NODE_HEIGHT, &item);
    value[0].VALUEF = 10;
    Manager::XnodeAPI->setAttribute(column, NODE_MARGIN, &item);
    Manager::XnodeAPI->setAttribute(column, NODE_ID, &content);
    ArkUI_NodeHandle text = Manager::XnodeAPI->createNode(ARKUI_NODE_TEXT);
    content = {.string = "本实例仅展示接口的使用方法，不涉及具体图像的创建"};
    Manager::XnodeAPI->setAttribute(text, NODE_TEXT_CONTENT, &content);
    Manager::XnodeAPI->registerNodeEvent(column, NODE_ON_CLICK, 1, nullptr);
    Manager::XnodeAPI->addChild(column, text);
    Manager::XnodeAPI->addChild(column, XCHandle);
    Manager::XnodeAPI->addChild(column, xc);
    xOnEventReceive(nullptr); //test
    return column;
}