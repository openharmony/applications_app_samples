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

// [Start ndknodequeryoperate5_start]
// MoveToExample.h
#ifndef MYAPPLICATION_MOVETO_H
#define MYAPPLICATION_MOVETO_H

#include "ArkUINode.h"
#include <hilog/log.h>

namespace NativeModule {

std::shared_ptr<ArkUIBaseNode> CreateMoveToExample()
{
    auto nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();

    // 创建传入事件节点结构体
    struct A {
        ArkUI_NodeHandle node;
        ArkUI_NodeHandle targetParent;
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
    ArkUI_AttributeItem column_id = {.string = "Column_CAPI"};
    nodeAPI->setAttribute(column, NODE_ID, &column_id);

    // 创建Row
    ArkUI_NumberValue text_height[] = {50};
    ArkUI_AttributeItem text_item1 = {text_height, sizeof(text_height) / sizeof(ArkUI_NumberValue)};
    ArkUI_NumberValue margin[] = {10};
    ArkUI_AttributeItem item_margin = {margin, sizeof(margin) / sizeof(ArkUI_NumberValue)};
    ArkUI_NodeHandle row0 = nodeAPI->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue width_value[] = {{.f32=330}};
    ArkUI_AttributeItem width_item = {width_value, sizeof(width_value) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(row0, NODE_WIDTH, &width_item);
    nodeAPI->setAttribute(row0, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(row0, NODE_MARGIN, &item_margin);

    ArkUI_NodeHandle row1 = nodeAPI->createNode(ARKUI_NODE_ROW);
    nodeAPI->setAttribute(row1, NODE_WIDTH, &width_item);
    nodeAPI->setAttribute(row1, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(row1, NODE_MARGIN, &item_margin);
    a->targetParent = row1;

    ArkUI_NodeHandle row2 = nodeAPI->createNode(ARKUI_NODE_ROW);
    nodeAPI->setAttribute(row2, NODE_WIDTH, &width_item);
    nodeAPI->setAttribute(row2, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(row2, NODE_MARGIN, &item_margin);

    // 创建Stack
    ArkUI_NodeHandle stack0 = nodeAPI->createNode(ARKUI_NODE_STACK);
    ArkUI_NumberValue stack_value[] = {{.f32=50}};
    ArkUI_AttributeItem stack_item1 = {stack_value, sizeof(width_value) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(stack0, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack0, NODE_HEIGHT, &stack_item1);
    ArkUI_NumberValue stack_bc[] = {{.u32 = 0xFFFFB6C1}};
    ArkUI_AttributeItem stack_item2 = {stack_bc, 1};
    nodeAPI->setAttribute(stack0, NODE_BACKGROUND_COLOR, &stack_item2);
    a->node = stack0;

    ArkUI_NodeHandle stack1 = nodeAPI->createNode(ARKUI_NODE_STACK);
    nodeAPI->setAttribute(stack1, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack1, NODE_HEIGHT, &stack_item1);
    ArkUI_NumberValue stack_bc1[] = {{.u32 = 0xFF6495ED}};
    ArkUI_AttributeItem stack_item3 = {stack_bc1, 1};
    nodeAPI->setAttribute(stack1, NODE_BACKGROUND_COLOR, &stack_item3);

    ArkUI_NodeHandle stack2 = nodeAPI->createNode(ARKUI_NODE_STACK);
    nodeAPI->setAttribute(stack2, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack2, NODE_HEIGHT, &stack_item1);
    ArkUI_NumberValue stack_bc2[] = {{.u32 = 0xFF90EE90}};
    ArkUI_AttributeItem stack_item4 = {stack_bc2, 1};
    nodeAPI->setAttribute(stack2, NODE_BACKGROUND_COLOR, &stack_item4);

    ArkUI_NodeHandle stack3 = nodeAPI->createNode(ARKUI_NODE_STACK);
    nodeAPI->setAttribute(stack3, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack3, NODE_HEIGHT, &stack_item1);
    nodeAPI->setAttribute(stack3, NODE_BACKGROUND_COLOR, &stack_item2);

    ArkUI_NodeHandle stack4 = nodeAPI->createNode(ARKUI_NODE_STACK);
    nodeAPI->setAttribute(stack4, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack4, NODE_HEIGHT, &stack_item1);
    nodeAPI->setAttribute(stack4, NODE_BACKGROUND_COLOR, &stack_item3);
    
    ArkUI_NodeHandle stack5 = nodeAPI->createNode(ARKUI_NODE_STACK);
    nodeAPI->setAttribute(stack5, NODE_WIDTH, &stack_item1);
    nodeAPI->setAttribute(stack5, NODE_HEIGHT, &stack_item1);
    nodeAPI->setAttribute(stack5, NODE_BACKGROUND_COLOR, &stack_item4);

    // 创建Button
    ArkUI_NodeHandle bt0 = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btn_width[] = {150};
    ArkUI_AttributeItem btn_item0 = {btn_width, sizeof(btn_width) / sizeof(ArkUI_NumberValue)};
    nodeAPI->setAttribute(bt0, NODE_WIDTH, &btn_item0);
    nodeAPI->setAttribute(bt0, NODE_HEIGHT, &text_item1);
    nodeAPI->setAttribute(bt0, NODE_MARGIN, &item_margin);
    ArkUI_AttributeItem bt0_item = {.string = "MoveTo"};
    nodeAPI->setAttribute(bt0, NODE_BUTTON_LABEL, &bt0_item);
    nodeAPI->registerNodeEvent(bt0, NODE_ON_CLICK, 0, a);

    // 注册事件
    auto onClick = [](ArkUI_NodeEvent *event) {
        ArkUI_NodeHandle node = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        auto nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();
        
        if (OH_ArkUI_NodeEvent_GetTargetId(event) == 0) {  // MoveTo
            A* a = (A*)OH_ArkUI_NodeEvent_GetUserData(event);
            auto res = OH_ArkUI_NodeUtils_MoveTo(a->node, a->targetParent, 2);
        }
    };
    nodeAPI->registerNodeEventReceiver(onClick);

    // 节点添加
    nodeAPI->addChild(scroll, column);
    nodeAPI->addChild(column, row0);
    nodeAPI->addChild(column, row1);
    nodeAPI->addChild(column, row2);
    nodeAPI->addChild(row0, stack0);
    nodeAPI->addChild(row0, stack1);
    nodeAPI->addChild(row0, stack2);
    nodeAPI->addChild(row1, stack3);
    nodeAPI->addChild(row1, stack4);
    nodeAPI->addChild(row1, stack5);
    nodeAPI->addChild(row2, bt0);

    return std::make_shared<ArkUINode>(scroll);
}
} // namespace NativeModule

#endif //MYAPPLICATION_MOVETO_H
// [End ndknodequeryoperate5_start]