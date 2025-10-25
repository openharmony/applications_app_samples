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

// [Start ndknodequeryoperate3_start]
// GetNodeByIdExample.h
#ifndef MYAPPLICATION_GETNODEBYID_H
#define MYAPPLICATION_GETNODEBYID_H

#include "ArkUINode.h"
#include <hilog/log.h>

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateGetNodeByIdExample()
{
    auto nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
    
    // 创建传入事件节点结构体
    struct A {
        ArkUI_NodeHandle node;
    };
    A* a = new A;
    
    // 创建根节点Scroll
    ArkUI_NodeHandle scroll = nodeAPI->createNode(ARKUI_NODE_SCROLL);
    ArkUI_NumberValue length_value[] = {{.f32 = 480}};
    ArkUI_AttributeItem length_item = {length_value, sizeof(length_value) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_WIDTH, &length_item);
    ArkUI_NumberValue length_value1[] = {{.f32 = 650}};
    ArkUI_AttributeItem length_item1 = {length_value1, sizeof(length_value1) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(scroll, NODE_HEIGHT, &length_item1);
    ArkUI_AttributeItem scroll_id = {.string = "Scroll_CAPI"};
    nodeAPI->setAttribute(scroll, NODE_ID, &scroll_id);
    
    // 创建Column
    ArkUI_NodeHandle column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue value[] = {480};
    ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(column, NODE_WIDTH, &item);
    ArkUI_NumberValue column_bc[] = {{.u32 = 0xFFF00BB}};
    ArkUI_AttributeItem column_item = {column_bc, 1};
    nodeAPI->setAttribute(column, NODE_BACKGROUND_COLOR, &column_item);
    ArkUI_AttributeItem column_id = {.string = "Column_CAPI"};
    nodeAPI->setAttribute(column, NODE_ID, &column_id);
    
    // 创建Text
    ArkUI_NodeHandle text0 = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue text_width[] = {300};
    ArkUI_AttributeItem text_item0 = {text_width, sizeof(text_width) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text0, NODE_WIDTH, &text_item0);
    ArkUI_NumberValue text_height[] = {50};
    ArkUI_AttributeItem text_item1 = {text_height, sizeof(text_height) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text0, NODE_HEIGHT, &text_item1);
    ArkUI_AttributeItem text_item = {.string = "示例Text节点"};
    nodeAPI->setAttribute(text0, NODE_TEXT_CONTENT, &text_item);
    ArkUI_NumberValue margin[] = {10};
    ArkUI_AttributeItem item_margin = {margin, sizeof(margin) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(text0, NODE_MARGIN, &item_margin);
    ArkUI_AttributeItem text0_id = {.string = "Text0_CAPI"};
    nodeAPI->setAttribute(text0, NODE_ID, &text0_id);
    a->node = text0;
    
    // 创建Row
    ArkUI_NodeHandle row0 = nodeAPI->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue width_value[] = {{.f32=330}};
    ArkUI_AttributeItem width_item = {width_value, sizeof(width_value) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(row0, NODE_WIDTH, &width_item);
    nodeAPI->setAttribute(row0, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(row0, NODE_MARGIN, &item_margin);
    
    // 创建Button
    ArkUI_NodeHandle bt0 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btn_width[] = {150};
    ArkUI_AttributeItem btn_item0 = {btn_width, sizeof(btn_width) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(bt0, NODE_WIDTH, &btn_item0);
    nodeAPI->setAttribute(bt0, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(bt0, NODE_MARGIN, &item_margin);
    ArkUI_AttributeItem bt0_item = {.string = "GetAttachedNodeHandleById"};
    nodeAPI->setAttribute(bt0, NODE_BUTTON_LABEL, &bt0_item);
    nodeAPI->registerNodeEvent(bt0, NODE_ON_CLICK, 0, a);
    
    // 注册事件
    auto onClick = [](ArkUI_NodeEvent *event) {
        ArkUI_NodeHandle node = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        auto nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
        
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == 0) {  // GetAttachedNodeHandleById
            A* a = (A*)OH_ArkUI_NodeEvent_GetUserData(event);
            ArkUI_NodeHandle node = nullptr;
            auto res = OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("Text0_CAPI", &node);
            if (node == a->node) {
                OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "GetNodeByIdExample", "get Text0_CAPI success");
            } else {
                OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "GetNodeByIdExample", "get Text0_CAPI failed");
            }
        }
    };
    nodeAPI->registerNodeEventReceiver(onClick);
    
    // 节点添加
    nodeAPI->addChild(scroll, column);
    nodeAPI->addChild(column, text0);
    nodeAPI->addChild(column, row0);
    nodeAPI->addChild(row0, bt0);
    
    return std::make_shared<ArkUINode>(scroll);
}
} // namespace NativeModule

#endif //MYAPPLICATION_GETNODEBYID_H
// [End ndknodequeryoperate3_start]
