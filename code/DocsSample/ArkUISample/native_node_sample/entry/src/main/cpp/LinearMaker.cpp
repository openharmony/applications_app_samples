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

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_animate.h>
#include <arkui/native_gesture.h>
#include <arkui/native_interface.h>
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <cstdio>
#include <hilog/log.h>
#include <iostream>
#include <string>

#include "LinearMaker.h"
#include "PublicEvent.h"
#include "ScrollableUtils.h"
#include "manager.h"
#include "napi/native_api.h"

const int32_t TARGET_ID_0 = 0;
const int32_t TARGET_ID_1 = 1;
const float HEIGHT_50 = 50;
const float WIDTH_PERCENT_40 = 0.4;
const float WIDTH_PERCENT_90 = 0.9;
const float NUMBER_2 = 2;
const float NUMBER_5 = 5;

typedef struct {
    ArkUI_NodeHandle row;
    ArkUI_NodeHandle column;
} MyData;

void SetScrollNode(ArkUI_NodeHandle& scroll)
{
    SetWidthPercent(scroll, 1);
    ArkUI_NumberValue scrollHeightValue[] = { 750 };
    ArkUI_AttributeItem scrollHeightItem = { scrollHeightValue, 1 };
    Manager::nodeAPI_->setAttribute(scroll, NODE_HEIGHT, &scrollHeightItem);
    ArkUI_AttributeItem scrollNodeIdItem = { .string = "testScroll" };
    Manager::nodeAPI_->setAttribute(scroll, NODE_ID, &scrollNodeIdItem);
}

void SetLinearReverse(ArkUI_NodeHandle& node, int32_t reverse)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeReverseValue[] = { { .i32 = reverse } };
    ArkUI_AttributeItem nodeReverseItem = { nodeReverseValue, 1 };
    Manager::nodeAPI_->setAttribute(node, NODE_LINEAR_LAYOUT_REVERSE, &nodeReverseItem);
}
void RegisterNodeEventReceiver()
{
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent* event) {
        auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        switch (targetId) {
            case TARGET_ID_0: {
                MyData* component = (MyData*)OH_ArkUI_NodeEvent_GetUserData(event);
                SetLinearReverse(component->column, true);
                SetLinearReverse(component->row, true);
                break;
            }
            case TARGET_ID_1: {
                MyData* component = (MyData*)OH_ArkUI_NodeEvent_GetUserData(event);
                SetLinearReverse(component->column, false);
                SetLinearReverse(component->row, false);
                break;
            }
            default:
                break;
        }
    });
}

ArkUI_NodeHandle CreateLinearTextNode(const char* textContent)
{
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem textContentValue = { .string = textContent };
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &textContentValue);
    SetHeight(text, HEIGHT_50);
    SetWidthPercent(text, WIDTH_PERCENT_40);
    SetBackGroundColor(text, 0xF5DEB300);
    return text;
}

void SetColumnJustifyContent(ArkUI_NodeHandle& node, int32_t value)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue justifyValue[] = { { .i32 = value } };
    ArkUI_AttributeItem justifyItem = { justifyValue, 1 };
    Manager::nodeAPI_->setAttribute(node, NODE_COLUMN_JUSTIFY_CONTENT, &justifyItem);
}

void SetLinearLayoutSpace(ArkUI_NodeHandle& node, float value)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue spaceValue[] = { { .f32 = value } };
    ArkUI_AttributeItem spaceItem = { spaceValue, 1 };
    Manager::nodeAPI_->setAttribute(node, NODE_LINEAR_LAYOUT_SPACE, &spaceItem);
}

void SetMargin(ArkUI_NodeHandle& node, float value)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue marginValue[] = { { .f32 = value } };
    ArkUI_AttributeItem marginValue_item1 = { marginValue, 1 };
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &marginValue_item1);
}

void SetLinearLayoutSpaceAttribute(ArkUI_NodeHandle& row, ArkUI_NodeHandle& column)
{
    // 设置组件基础属性
    SetBackGroundColor(column, 0xAFEEEE00);
    SetBackGroundColor(row, 0xAFEEEE00);
    SetWidthPercent(column, WIDTH_PERCENT_90);
    SetWidthPercent(row, WIDTH_PERCENT_90);
    SetMargin(column, NUMBER_2);
    SetMargin(row, NUMBER_2);
    SetColumnJustifyContent(column, ARKUI_FLEX_ALIGNMENT_START);
    SetColumnJustifyContent(row, ARKUI_FLEX_ALIGNMENT_START);
    // 设置组件的space和reverse属性
    SetLinearLayoutSpace(column, NUMBER_5);
    SetLinearLayoutSpace(row, NUMBER_5);
    SetLinearReverse(column, false);
    SetLinearReverse(row, false);
}

void CreateNodeLinearLayoutSpace(ArkUI_NodeHandle& node)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    auto root = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    // 创建Column和Row组件
    auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    auto row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    auto text = CreateTextNode("NODE_LINEAR_LAYOUT_SPACE & NODE_LINEAR_LAYOUT_REVERSE");

    SetLinearLayoutSpaceAttribute(row, column);
    
    // 为text设置文本内容
    auto text1 = CreateLinearTextNode("Column1");
    auto text2 = CreateLinearTextNode("Column2");
    auto text3 = CreateLinearTextNode("Column3");
    auto text5 = CreateLinearTextNode("Row1");
    auto text6 = CreateLinearTextNode("Row2");
    auto text7 = CreateLinearTextNode("Row3");

    static MyData component;
    component.row = row;
    component.column = column;
    // 为组件注册点击事件
    auto row1 = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    auto button1 = CreateButtonNode("reverse:true");
    auto button2 = CreateButtonNode("reverse:false");
    Manager::nodeAPI_->registerNodeEvent(button1, NODE_ON_CLICK_EVENT, TARGET_ID_0, &component);
    Manager::nodeAPI_->registerNodeEvent(button2, NODE_ON_CLICK_EVENT, TARGET_ID_1, &component);

    RegisterNodeEventReceiver();

    Manager::nodeAPI_->addChild(node, root);
    Manager::nodeAPI_->addChild(root, text);
    Manager::nodeAPI_->addChild(root, column);
    Manager::nodeAPI_->addChild(root, row);
    Manager::nodeAPI_->addChild(root, row1);
    Manager::nodeAPI_->addChild(row1, button1);
    Manager::nodeAPI_->addChild(row1, button2);
    Manager::nodeAPI_->addChild(column, text1);
    Manager::nodeAPI_->addChild(column, text2);
    Manager::nodeAPI_->addChild(column, text3);
    Manager::nodeAPI_->addChild(row, text5);
    Manager::nodeAPI_->addChild(row, text6);
    Manager::nodeAPI_->addChild(row, text7);
}

void CreateFlexSpace(ArkUI_NodeHandle& node)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    auto root = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    auto flex = Manager::nodeAPI_->createNode(ARKUI_NODE_FLEX);
    auto text = CreateTextNode("NODE_FLEX_SPACE");
    SetBackGroundColor(flex, 0xAFEEEE00);
    SetWidthPercent(flex, WIDTH_PERCENT_90);
    ArkUI_NumberValue marginValue1[] = { { .f32 = 2 }, { .f32 = 0 }, { .f32 = 2 }, { .f32 = 0 } };
    ArkUI_AttributeItem marginValue_item1 = { marginValue1, 4 };
    Manager::nodeAPI_->setAttribute(flex, NODE_MARGIN, &marginValue_item1);
    // 初始化Flex组件属性
    ArkUI_NumberValue WarpValue[] = { { .i32 = ARKUI_FLEX_DIRECTION_ROW }, { .i32 = ARKUI_FLEX_WRAP_WRAP },
        { .i32 = ARKUI_FLEX_ALIGNMENT_START } };
    ArkUI_AttributeItem WarpItem = { WarpValue, sizeof(WarpValue) / sizeof(ArkUI_NumberValue) };
    Manager::nodeAPI_->setAttribute(flex, NODE_FLEX_OPTION, &WarpItem);
    // 设置space属性
    ArkUI_NumberValue FlexSpaceValue[] = { { .f32 = 10 }, { .f32 = 5 } };
    ArkUI_AttributeItem FlexSpaceItem = { FlexSpaceValue, sizeof(FlexSpaceValue) / sizeof(ArkUI_NumberValue) };
    Manager::nodeAPI_->setAttribute(flex, NODE_FLEX_SPACE, &FlexSpaceItem);
    // 为text设置文本内容
    auto text1 = CreateLinearTextNode("Flex1");
    auto text2 = CreateLinearTextNode("Flex2");
    auto text3 = CreateLinearTextNode("Flex3");
    auto text4 = CreateLinearTextNode("Flex4");
    auto text5 = CreateLinearTextNode("Flex5");
    auto text6 = CreateLinearTextNode("Flex6");
    // 将文本添加到Flex中
    Manager::nodeAPI_->addChild(node, root);
    Manager::nodeAPI_->addChild(root, text);
    Manager::nodeAPI_->addChild(root, flex);
    Manager::nodeAPI_->addChild(flex, text1);
    Manager::nodeAPI_->addChild(flex, text2);
    Manager::nodeAPI_->addChild(flex, text3);
    Manager::nodeAPI_->addChild(flex, text4);
    Manager::nodeAPI_->addChild(flex, text5);
    Manager::nodeAPI_->addChild(flex, text6);
}

void SetLinearTest(ArkUI_NodeHandle& scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NodeHandle node = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    // NODE_LINEAR_LAYOUT_SPACE NODE_LINEAR_LAYOUT_REVERSE
    CreateNodeLinearLayoutSpace(node);
    // NODE_FLEX_SPACE
    CreateFlexSpace(node);
    Manager::nodeAPI_->addChild(scroll, node);
}

ArkUI_NodeHandle LinearMaker::CreateNativeNode()
{
    // 创建父子滚动容器
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    // 设置属性
    SetScrollNode(scroll);
    SetLinearTest(scroll);
    return scroll;
}