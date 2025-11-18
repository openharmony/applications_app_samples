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

#include "napi/native_api.h"
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

#include "manager.h"
#include "PublicEvent.h"

const int32_t TARGET_ID_2 = 2;
const int32_t TARGET_ID_3 = 3;
const int32_t TARGET_ID_4 = 4;
const int32_t TARGET_ID_5 = 5;
const int32_t TARGET_ID_6 = 6;
const int32_t TARGET_ID_7 = 7;
const int32_t TARGET_ID_8 = 8;
const int32_t TARGET_ID_10 = 10;
const int32_t TARGET_ID_11 = 11;
const int32_t TARGET_ID_12 = 12;
const int32_t TARGET_ID_13 = 13;
const int32_t TARGET_ID_15 = 15;
const int32_t TARGET_ID_16 = 16;
const int32_t TARGET_ID_18 = 18;
const int32_t TARGET_ID_19 = 19;
const int32_t TARGET_ID_20 = 20;
const int32_t TARGET_ID_21 = 21;
const int32_t TARGET_ID_22 = 22;
const int32_t TARGET_ID_23 = 23;
const int32_t TARGET_ID_24 = 24;
const float A_VALUE = 0.8;
const float B_VALUE = 0.95;
const float C_VALUE = 0.35;
ArkUI_NodeHandle buttonUIState = nullptr;
ArkUI_NodeHandle buttonArea = nullptr;
ArkUI_NodeHandle buttonResponse = nullptr;
ArkUI_NodeHandle textResponse = nullptr;
ArkUI_NodeHandle rowTouchIntercept = nullptr;
ArkUI_NodeHandle radioTwo = nullptr;
ArkUI_NodeHandle nodeUIState = nullptr;
int32_t g_globalStatesToSupported = static_cast<int32_t>(UI_STATE_NORMAL);
ArkUI_VisibleAreaEventOptions* options;
int g_cControl = 1;
int g_cArea = 0;
int g_cEnable = 0;
int g_cSelect = 0;

typedef struct {
    ArkUI_NodeHandle columnControl;
    ArkUI_NodeHandle buttonTwo;
} MyData;

void SetWidthPercent(ArkUI_NodeHandle &node, float width)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeWidthValue[] = {width};
    ArkUI_AttributeItem nodeWidthItem = {nodeWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &nodeWidthItem);
}

void SetHeightPercent(ArkUI_NodeHandle &node, float height)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeHeightValue[] = {height};
    ArkUI_AttributeItem nodeHeightItem = {nodeHeightValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT_PERCENT, &nodeHeightItem);
}

void SetEnable(ArkUI_NodeHandle &node, int32_t num)
{
    if (num == 0) {
        ArkUI_NumberValue enableValue[] = {{.i32 = false}};
        ArkUI_AttributeItem enableItem = {enableValue, 1};
        Manager::nodeAPI_->setAttribute(node, NODE_ENABLED, &enableItem);
    } else {
        ArkUI_NumberValue enableValue[] = {{.i32 = true}};
        ArkUI_AttributeItem enableItem = {enableValue, 1};
        Manager::nodeAPI_->setAttribute(node, NODE_ENABLED, &enableItem);
    }
}

void SetButtonAttribute(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.5};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
}

void CreateNodeWithCommonAttribute(ArkUI_NodeHandle parent, const char *attributeName,
                                   std::function<void(ArkUI_NodeHandle node)> func)
{
    if (!Manager::nodeAPI_ || !parent) {
        return;
    }
    auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    float columnWidth = B_VALUE;
    SetWidthPercent(column, columnWidth);
    // row设置宽高、边框
    SetWidthPercent(row, 1);
    ArkUI_NumberValue rowHeightValue[] = {500};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    ArkUI_AttributeItem idItem = {.string = attributeName};
    Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);
    Manager::nodeAPI_->setAttribute(row, NODE_BORDER_WIDTH, &borderWidthItem);
    Manager::nodeAPI_->setAttribute(row, NODE_ID, &idItem);
    func(row);
    // text设置文本内容
    std::string str = "通用属性: ";
    str += attributeName;
    ArkUI_AttributeItem contentItem = {.string = str.c_str()};
    ArkUI_NumberValue marginWidthValue[] = {5};
    ArkUI_AttributeItem marginWidthItem = {marginWidthValue, 1};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &contentItem);
    Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &marginWidthItem);
    Manager::nodeAPI_->addChild(column, text);
    Manager::nodeAPI_->addChild(column, row);
    Manager::nodeAPI_->addChild(parent, column);
}

void SetScrollAttribute(ArkUI_NodeHandle &scroll)
{
    SetWidthPercent(scroll, 1);
    ArkUI_NumberValue scrollHeightValue[] = {750};
    ArkUI_AttributeItem scrollHeightItem = {scrollHeightValue, 1};
    Manager::nodeAPI_->setAttribute(scroll, NODE_HEIGHT, &scrollHeightItem);
    ArkUI_AttributeItem scrollNodeIdItem = {.string = "testScroll"};
    Manager::nodeAPI_->setAttribute(scroll, NODE_ID, &scrollNodeIdItem);
}

void CreateNodeBackGroundColor(ArkUI_NodeHandle &scroll, ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_BACKGROUND_COLOR", [](ArkUI_NodeHandle node) {
        if (node) {
            ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF009A61}};
            ArkUI_AttributeItem backColorItem = {backColorValue, 1};
            Manager::nodeAPI_->setAttribute(node, NODE_BACKGROUND_COLOR, &backColorItem);

            ArkUI_AttributeItem idItem = {.string = "backgroundColumn"};
            Manager::nodeAPI_->setAttribute(node, NODE_ID, &idItem);
        }
    });
}

void CreateNodeEnabled(ArkUI_NodeHandle &scroll, ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ENABLED", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        SetHeightPercent(column, 1);
        SetWidthPercent(column, 1);
        ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NodeHandle button2 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NodeHandle button3 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        SetButtonAttribute(button1);
        SetButtonAttribute(button2);
        SetButtonAttribute(button3);
        ArkUI_AttributeItem btn1TextItem = {.string = "Enabled is false"};
        Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &btn1TextItem);
        ArkUI_AttributeItem idItem1 = {.string = "enabledButton"};
        Manager::nodeAPI_->setAttribute(button1, NODE_ID, &idItem1);
        ArkUI_AttributeItem btn2TextItem = {.string = "Not set Enabled"};
        Manager::nodeAPI_->setAttribute(button2, NODE_BUTTON_LABEL, &btn2TextItem);
        ArkUI_AttributeItem idItem2 = {.string = "notEnabledButton"};
        Manager::nodeAPI_->setAttribute(button2, NODE_ID, &idItem2);
        ArkUI_AttributeItem btn3TextItem = {.string = "Enabled is true"};
        Manager::nodeAPI_->setAttribute(button3, NODE_BUTTON_LABEL, &btn3TextItem);
        ArkUI_AttributeItem idItem3 = {.string = "EnabledTrue"};
        Manager::nodeAPI_->setAttribute(button3, NODE_ID, &idItem3);
        // 为button1设置NODE_ENABLED属性为false
        SetEnable(button1, 0);
        // 为button3设置NODE_ENABLED属性为true
        SetEnable(button3, 1);
        // 将按钮添加到Column中
        Manager::nodeAPI_->addChild(column, button1);
        Manager::nodeAPI_->addChild(column, button2);
        Manager::nodeAPI_->addChild(column, button3);
        // 将Row添加到传入的node中
        Manager::nodeAPI_->addChild(node, column);
    });
}

ArkUI_NodeHandle CreateNodeZIndexStack()
{
    ArkUI_NodeHandle stack = Manager::nodeAPI_->createNode(ARKUI_NODE_STACK);
    SetWidthPercent(stack, 1);
    SetHeightPercent(stack, 1);
    return stack;
}

ArkUI_NodeHandle CreateNodeZIndexText1()
{
    ArkUI_NodeHandle text1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue text1WidthValue1[] = {0.25};
    ArkUI_AttributeItem text1WidthItem1 = {text1WidthValue1, 1};
    ArkUI_NumberValue text1HeightValue1[] = {100};
    ArkUI_AttributeItem text1HeightItem1 = {text1HeightValue1, 1};
    ArkUI_NumberValue backColorValue1[] = {{.u32 = 0xFFbbb2cb}};
    ArkUI_AttributeItem backColorItem1 = {backColorValue1, 1};
    Manager::nodeAPI_->setAttribute(text1, NODE_WIDTH_PERCENT, &text1WidthItem1);
    Manager::nodeAPI_->setAttribute(text1, NODE_HEIGHT, &text1HeightItem1);
    Manager::nodeAPI_->setAttribute(text1, NODE_BACKGROUND_COLOR, &backColorItem1);
    ArkUI_AttributeItem idItem1 = {.string = "zIndexText1"};
    Manager::nodeAPI_->setAttribute(text1, NODE_ID, &idItem1);
    ArkUI_NumberValue zIndexValue1[] = {{.i32 = 2}};
    ArkUI_AttributeItem zIndexItem1 = {zIndexValue1, 1};
    Manager::nodeAPI_->setAttribute(text1, NODE_Z_INDEX, &zIndexItem1);
    ArkUI_AttributeItem text1TextItem = {.string = "text1 \nzIndex(2)"};
    Manager::nodeAPI_->setAttribute(text1, NODE_TEXT_CONTENT, &text1TextItem);
    return text1;
}

ArkUI_NodeHandle CreateNodeZIndexText2()
{
    ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue text2WidthValue2[] = {0.5};
    ArkUI_AttributeItem text2WidthItem2 = {text2WidthValue2, 1};
    ArkUI_NumberValue text2HeightValue2[] = {200};
    ArkUI_AttributeItem text2HeightItem2 = {text2HeightValue2, 1};
    ArkUI_NumberValue backColorValue2[] = {{.u32 = 0xFFd2cab3}};
    ArkUI_AttributeItem backColorItem2 = {backColorValue2, 1};
    Manager::nodeAPI_->setAttribute(text2, NODE_WIDTH_PERCENT, &text2WidthItem2);
    Manager::nodeAPI_->setAttribute(text2, NODE_HEIGHT, &text2HeightItem2);
    Manager::nodeAPI_->setAttribute(text2, NODE_BACKGROUND_COLOR, &backColorItem2);
    ArkUI_AttributeItem idItem2 = {.string = "zIndexText2"};
    Manager::nodeAPI_->setAttribute(text2, NODE_ID, &idItem2);
    ArkUI_NumberValue zIndexValue2[] = {{.i32 = 1}};
    ArkUI_AttributeItem zIndexItem2 = {zIndexValue2, 1};
    Manager::nodeAPI_->setAttribute(text2, NODE_Z_INDEX, &zIndexItem2);
    ArkUI_AttributeItem text2TextItem = {.string = "text2 \nzIndex\n(1)"};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_CONTENT, &text2TextItem);

    return text2;
}

void CreateNodeZIndex(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_Z_INDEX", [](ArkUI_NodeHandle node) {
        auto stack = CreateNodeZIndexStack();
        auto text1 = CreateNodeZIndexText1();
        auto text2 = CreateNodeZIndexText2();

        ArkUI_NodeHandle text3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_NumberValue text3WidthValue3[] = {0.75};
        ArkUI_AttributeItem text3WidthItem3 = {text3WidthValue3, 1};
        ArkUI_NumberValue text3HeightValue3[] = {300};
        ArkUI_AttributeItem text3HeightItem3 = {text3HeightValue3, 1};
        ArkUI_NumberValue backColorValue3[] = {{.u32 = 0xFFc1ccab}};
        ArkUI_AttributeItem backColorItem3 = {backColorValue3, 1};

        Manager::nodeAPI_->setAttribute(text3, NODE_WIDTH_PERCENT, &text3WidthItem3);
        Manager::nodeAPI_->setAttribute(text3, NODE_HEIGHT, &text3HeightItem3);
        Manager::nodeAPI_->setAttribute(text3, NODE_BACKGROUND_COLOR, &backColorItem3);

        ArkUI_AttributeItem idItem3 = {.string = "zIndexText3"};
        Manager::nodeAPI_->setAttribute(text3, NODE_ID, &idItem3);

        ArkUI_NumberValue zIndexValue3[] = {{.i32 = 0}};
        ArkUI_AttributeItem zIndexItem3 = {zIndexValue3, 1};
        Manager::nodeAPI_->setAttribute(text3, NODE_Z_INDEX, &zIndexItem3);

        ArkUI_AttributeItem text3TextItem = {.string = "text3 \nzIndex\n(0)"};
        Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CONTENT, &text3TextItem);
        Manager::nodeAPI_->addChild(stack, text1);
        Manager::nodeAPI_->addChild(stack, text2);
        Manager::nodeAPI_->addChild(stack, text3);
        Manager::nodeAPI_->addChild(node, stack);
    });
}

ArkUI_NodeHandle CreateNodeVisibilityColumn()
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    SetWidthPercent(column, 1);
    SetHeightPercent(column, 1);
    return column;
}

ArkUI_NodeHandle CreateNodeVisibilityRow1()
{
    ArkUI_NodeHandle row1 = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue row1WidthValue1[] = {100};
    ArkUI_AttributeItem row1WidthItem1 = {row1WidthValue1, 1};
    ArkUI_NumberValue row1HeightValue1[] = {100};
    ArkUI_AttributeItem row1HeightItem1 = {row1HeightValue1, 1};
    ArkUI_NumberValue backColorValue1[] = {{.u32 = 0xFFbbb2cb}};
    ArkUI_AttributeItem backColorItem1 = {backColorValue1, 1};
    ArkUI_NumberValue row1MarginValue[] = {20};
    ArkUI_AttributeItem row1MarginItem = {row1MarginValue, 1};
    Manager::nodeAPI_->setAttribute(row1, NODE_WIDTH, &row1WidthItem1);
    Manager::nodeAPI_->setAttribute(row1, NODE_HEIGHT, &row1HeightItem1);
    Manager::nodeAPI_->setAttribute(row1, NODE_BACKGROUND_COLOR, &backColorItem1);
    Manager::nodeAPI_->setAttribute(row1, NODE_MARGIN, &row1MarginItem);
    ArkUI_NumberValue visibility1Value[] = {{.i32 = ARKUI_VISIBILITY_NONE}};
    ArkUI_AttributeItem visibility1Item = {visibility1Value, 1};
    Manager::nodeAPI_->setAttribute(row1, NODE_VISIBILITY, &visibility1Item);
    ArkUI_AttributeItem idItem = {.string = "visibilityRow1"};
    Manager::nodeAPI_->setAttribute(row1, NODE_ID, &idItem);
    return row1;
}

ArkUI_NodeHandle CreateNodeVisibilityRow2()
{
    ArkUI_NodeHandle row2 = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue row2WidthValue2[] = {100};
    ArkUI_AttributeItem row2WidthItem2 = {row2WidthValue2, 1};
    ArkUI_NumberValue row2HeightValue2[] = {100};
    ArkUI_AttributeItem row2HeightItem2 = {row2HeightValue2, 1};
    ArkUI_NumberValue backColorValue2[] = {{.u32 = 0xFFd2cab3}};
    ArkUI_AttributeItem backColorItem2 = {backColorValue2, 1};
    ArkUI_NumberValue row2MarginValue[] = {20};
    ArkUI_AttributeItem row2MarginItem = {row2MarginValue, 1};
    Manager::nodeAPI_->setAttribute(row2, NODE_WIDTH, &row2WidthItem2);
    Manager::nodeAPI_->setAttribute(row2, NODE_HEIGHT, &row2HeightItem2);
    Manager::nodeAPI_->setAttribute(row2, NODE_BACKGROUND_COLOR, &backColorItem2);
    Manager::nodeAPI_->setAttribute(row2, NODE_MARGIN, &row2MarginItem);
    ArkUI_NumberValue visibility2Value[] = {{.i32 = ARKUI_VISIBILITY_HIDDEN}};
    ArkUI_AttributeItem visibility2Item = {visibility2Value, 1};
    Manager::nodeAPI_->setAttribute(row2, NODE_VISIBILITY, &visibility2Item);
    ArkUI_AttributeItem idItem = {.string = "visibilityRow2"};
    Manager::nodeAPI_->setAttribute(row2, NODE_ID, &idItem);
    return row2;
}

ArkUI_NodeHandle CreateNodeVisibilityRow3()
{
    ArkUI_NodeHandle row3 = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue row3WidthValue3[] = {100};
    ArkUI_AttributeItem row3WidthItem3 = {row3WidthValue3, 1};
    ArkUI_NumberValue row3HeightValue3[] = {100};
    ArkUI_AttributeItem row3HeightItem3 = {row3HeightValue3, 1};
    ArkUI_NumberValue backColorValue3[] = {{.u32 = 0xFFc1ccab}};
    ArkUI_AttributeItem backColorItem3 = {backColorValue3, 1};
    ArkUI_NumberValue row3MarginValue[] = {20};
    ArkUI_AttributeItem row3MarginItem = {row3MarginValue, 1};
    Manager::nodeAPI_->setAttribute(row3, NODE_WIDTH, &row3WidthItem3);
    Manager::nodeAPI_->setAttribute(row3, NODE_HEIGHT, &row3HeightItem3);
    Manager::nodeAPI_->setAttribute(row3, NODE_BACKGROUND_COLOR, &backColorItem3);
    Manager::nodeAPI_->setAttribute(row3, NODE_MARGIN, &row3MarginItem);
    ArkUI_NumberValue visibility3Value[] = {{.i32 = ARKUI_VISIBILITY_VISIBLE}};
    ArkUI_AttributeItem visibility3Item = {visibility3Value, 1};
    Manager::nodeAPI_->setAttribute(row3, NODE_VISIBILITY, &visibility3Item);
    ArkUI_AttributeItem idItem = {.string = "visibilityRow3"};
    Manager::nodeAPI_->setAttribute(row3, NODE_ID, &idItem);
    return row3;
}

void CreateNodeVisibility(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_VISIBILITY", [](ArkUI_NodeHandle node) {
        auto column = CreateNodeVisibilityColumn();
        // 创建三个Text文本
        ArkUI_NodeHandle text1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_NodeHandle text3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        auto row1 = CreateNodeVisibilityRow1();
        auto row2 = CreateNodeVisibilityRow2();
        auto row3 = CreateNodeVisibilityRow3();
        // 为text1设置文本内容
        ArkUI_AttributeItem text1TextItem = {.string = "ARKUI_VISIBILITY_NONE"};
        Manager::nodeAPI_->setAttribute(text1, NODE_TEXT_CONTENT, &text1TextItem);
        // 为text2设置文本内容
        ArkUI_AttributeItem text2TextItem = {.string = "ARKUI_VISIBILITY_HIDDEN"};
        Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_CONTENT, &text2TextItem);
        // 为text3设置文本内容
        ArkUI_AttributeItem text3TextItem = {.string = "ARKUI_VISIBILITY_VISIBLE"};
        Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CONTENT, &text3TextItem);
        // 将文本添加到Row中
        Manager::nodeAPI_->addChild(column, text1);
        Manager::nodeAPI_->addChild(column, row1);
        Manager::nodeAPI_->addChild(column, text2);
        Manager::nodeAPI_->addChild(column, row2);
        Manager::nodeAPI_->addChild(column, text3);
        Manager::nodeAPI_->addChild(column, row3);
        // 将Row添加到传入的node中
        Manager::nodeAPI_->addChild(node, column);
    });
}

void CreateNodeClickDistance(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_CLICK_DISTANCE", [](ArkUI_NodeHandle node) {
        // 创建Column容器
        ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        // 设置Column属性
        SetHeightPercent(column, 1);
        SetWidthPercent(column, 1);

        // 创建Button按钮
        ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        static ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);

        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {25};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};

        Manager::nodeAPI_->setAttribute(button1, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_MARGIN, &btnMarginItem);
        ArkUI_NumberValue enableValue[] = {{.i32 = 5}};
        ArkUI_AttributeItem enableItem = {enableValue, 1};
        Manager::nodeAPI_->setAttribute(button1, NODE_CLICK_DISTANCE, &enableItem);
        Manager::nodeAPI_->registerNodeEvent(button1, NODE_ON_CLICK, TARGET_ID_8, text);

        ArkUI_NumberValue btnWidthValue1[] = {150};
        ArkUI_AttributeItem btnWidthItem1 = {btnWidthValue1, 1};
        Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &btnWidthItem1);
        Manager::nodeAPI_->setAttribute(text, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &btnMarginItem);

        Manager::nodeAPI_->addChild(column, button1);
        Manager::nodeAPI_->addChild(column, text);
        // 将Column添加到传入的node中
        Manager::nodeAPI_->addChild(node, column);
    });
}

void SetAttributeRowVisibleAreaApproximateChangeRatio(ArkUI_NodeHandle &row)
{
    ArkUI_NumberValue rowWidthValue[] = {400};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {200};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF666666}};
    ArkUI_AttributeItem backColorItem = {backColorValue, 1};
    ArkUI_NumberValue backOffsetValue[] = {{.f32 = 0}, {.f32 = 50}};
    ArkUI_AttributeItem backOffsetItem = {backOffsetValue, 2};
    Manager::nodeAPI_->setAttribute(row, NODE_OFFSET, &backOffsetItem);
    Manager::nodeAPI_->setAttribute(row, NODE_BACKGROUND_COLOR, &backColorItem);
    Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
    Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);
}

void SetAttributeRowVisibleAreaApproximateChangeRatioOne(ArkUI_NodeHandle &row)
{
    ArkUI_NumberValue rowClipValue[] = {{.i32 = 1}};
    ArkUI_AttributeItem rowClipItem = {rowClipValue, 1};
    ArkUI_NumberValue rowWidthValue[] = {400};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {200};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF999999}};
    ArkUI_AttributeItem backColorItem = {backColorValue, 1};
    Manager::nodeAPI_->setAttribute(row, NODE_BACKGROUND_COLOR, &backColorItem);
    Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
    Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);
    Manager::nodeAPI_->setAttribute(row, NODE_CLIP, &rowClipItem);
}

void CreateNodeVisibleAreaApproximateChangeRatio(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO ", [](ArkUI_NodeHandle node) {
        // 创建Row容器
        ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        ArkUI_NodeHandle rowOne = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        SetAttributeRowVisibleAreaApproximateChangeRatio(row);
        SetAttributeRowVisibleAreaApproximateChangeRatioOne(rowOne);
        auto *option = OH_ArkUI_VisibleAreaEventOptions_Create();
        OH_ArkUI_VisibleAreaEventOptions_Dispose(option);
        options = OH_ArkUI_VisibleAreaEventOptions_Create();
        float *ratiosArray = new float[1];
        ratiosArray[0] = 0;
        ratiosArray[1] = 1.0;
        OH_ArkUI_VisibleAreaEventOptions_SetRatios(options, ratiosArray, TARGET_ID_2);
        auto value = 1000;
        OH_ArkUI_VisibleAreaEventOptions_SetExpectedUpdateInterval(options, value);
        OH_ArkUI_VisibleAreaEventOptions_SetMeasureFromViewport(options, true);
        ArkUI_AttributeItem areaItem = {.object = options};
        Manager::nodeAPI_->setAttribute(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO, &areaItem);
        auto item = Manager::nodeAPI_->getAttribute(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO);
        auto optionObject = reinterpret_cast<ArkUI_VisibleAreaEventOptions *>(item->object);
        int size = 3;
        float *ratiosGet = new float[3];
        OH_ArkUI_VisibleAreaEventOptions_GetRatios(optionObject, ratiosGet, &size);
        auto expectedUpdateInterval = OH_ArkUI_VisibleAreaEventOptions_GetExpectedUpdateInterval(optionObject);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  size == %{public}d", size);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "CreateNativeNode  ratiosGet ratiosGet[0] == %{public}f ratiosGet[1] == %{public}f", ratiosGet[0],
                     ratiosGet[1]);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "CreateNativeNode  expectedUpdateInterval == %{public}d", expectedUpdateInterval);
        Manager::nodeAPI_->registerNodeEvent(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_EVENT, 0, nullptr);
        ArkUI_NumberValue areaChangeValue[] = {{.f32 = 0.5}};
        ArkUI_AttributeItem areaChangeItem = {areaChangeValue, 1};
        Manager::nodeAPI_->setAttribute(row, NODE_VISIBLE_AREA_CHANGE_RATIO, &areaChangeItem);
        Manager::nodeAPI_->registerNodeEvent(row, NODE_EVENT_ON_VISIBLE_AREA_CHANGE, TARGET_ID_19, nullptr);
        Manager::nodeAPI_->addChild(rowOne, row);
        Manager::nodeAPI_->addChild(node, rowOne);
    });
}

void SetRowAttribute(ArkUI_NodeHandle node)
{
    ArkUI_NumberValue widthValue[] = {1};
    ArkUI_AttributeItem widthItem = {widthValue, 1};
    ArkUI_NumberValue heightValue[] = {100};
    ArkUI_AttributeItem heightItem = {heightValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &widthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &heightItem);
    Manager::nodeAPI_->registerNodeEvent(node, NODE_TOUCH_EVENT, TARGET_ID_2, nullptr);
}

void CreateNodeTouchEvent(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_TOUCH_EVENT ", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        rowTouchIntercept = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        SetRowAttribute(rowTouchIntercept);
        ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {20};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};

        ArkUI_AttributeItem buttonLabel1 = {.string = "button1"};
        Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &buttonLabel1);

        Manager::nodeAPI_->setAttribute(button1, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_MARGIN, &btnMarginItem);
        Manager::nodeAPI_->registerNodeEvent(button1, NODE_TOUCH_EVENT, 1, nullptr);
        
        Manager::nodeAPI_->addChild(rowTouchIntercept, button1);
        Manager::nodeAPI_->addChild(node, rowTouchIntercept);
    });
}

void CreateNodeEventOnAreaChange(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_EVENT_ON_AREA_CHANGE ", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        buttonArea = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NumberValue rowWidthValue[] = {200};
        ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
        ArkUI_NumberValue rowHeightValue[] = {200};
        ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
        Manager::nodeAPI_->setAttribute(buttonArea, NODE_WIDTH, &rowWidthItem);
        Manager::nodeAPI_->setAttribute(buttonArea, NODE_HEIGHT, &rowHeightItem);
        ArkUI_AttributeItem buttonLabel1 = {.string = "click me"};
        Manager::nodeAPI_->setAttribute(buttonArea, NODE_BUTTON_LABEL, &buttonLabel1);
        
        Manager::nodeAPI_->registerNodeEvent(buttonArea, NODE_EVENT_ON_AREA_CHANGE, TARGET_ID_7, nullptr);
        Manager::nodeAPI_->registerNodeEvent(buttonArea, NODE_ON_CLICK, TARGET_ID_7, nullptr);
        Manager::nodeAPI_->addChild(node, buttonArea);
    });
}

void CreateNodeOnHover(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ON_HOVER", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_HOVER, TARGET_ID_10, nullptr);
    });
}

void CreateNodeOnMouse(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ON_MOUSE", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_MOUSE, TARGET_ID_11, nullptr);
    });
}

void CreateNodeOnHoverEvent(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ON_HOVER_EVENT", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_HOVER_EVENT, TARGET_ID_15, nullptr);
    });
}

void CreateNodeOnHoverMove(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ON_HOVER_MOVE", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_HOVER_MOVE, TARGET_ID_16, nullptr);
    });
}

void SetResponseRegionAttribute(ArkUI_NodeHandle &node)
{
    ArkUI_AttributeItem buttonLabel1 = {.string = "x:0 y:0 width:50% height:50% "};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel1);
    ArkUI_NumberValue btnAttributeValue[] = {0, 0, 50, 100};
    ArkUI_AttributeItem buttonAttributeItem = {btnAttributeValue, 4};
    Manager::nodeAPI_->setAttribute(node, NODE_RESPONSE_REGION, &buttonAttributeItem);
    Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_CLICK, TARGET_ID_20, nullptr);
}

void SetResponseRegionAttributeTwo(ArkUI_NodeHandle &node)
{
    ArkUI_AttributeItem buttonLabel1 = {.string = "x:0 y:0 width:100% height:100% "};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel1);
    ArkUI_NumberValue btnAttributeValue[] = {0, 0, 100, 100};
    ArkUI_AttributeItem buttonAttributeItem = {btnAttributeValue, 4};
    Manager::nodeAPI_->setAttribute(node, NODE_RESPONSE_REGION, &buttonAttributeItem);
    Manager::nodeAPI_->registerNodeEvent(node, NODE_ON_CLICK, TARGET_ID_21, nullptr);
}

void AddResponseRegion(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_RESPONSE_REGION", [](ArkUI_NodeHandle node) {
        static auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        SetWidthPercent(column, 1);
        SetHeightPercent(column, 1);
        buttonResponse = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        SetButtonAttribute(buttonResponse);
        SetResponseRegionAttribute(buttonResponse);
        static auto buttonResponseTwo = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        SetButtonAttribute(buttonResponseTwo);
        SetResponseRegionAttributeTwo(buttonResponseTwo);
        
        textResponse = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_AttributeItem TextItem = {.string = "no touch"};
        Manager::nodeAPI_->setAttribute(textResponse, NODE_TEXT_CONTENT, &TextItem);
        
        SetButtonAttribute(textResponse);
        Manager::nodeAPI_->addChild(column, buttonResponse);
        Manager::nodeAPI_->addChild(column, buttonResponseTwo);
        Manager::nodeAPI_->addChild(column, textResponse);
        Manager::nodeAPI_->addChild(node, column);
    });
}

void AddOverlay(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_OVERLAY", [](ArkUI_NodeHandle node) {
        static auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        SetWidthPercent(column, 1);
        SetHeightPercent(column, 1);
        static auto buttonOver = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        SetButtonAttribute(buttonOver);
        ArkUI_AttributeItem buttonLabel1 = {.string = "0 width:50% height:100% 0"};
        Manager::nodeAPI_->setAttribute(buttonOver, NODE_BUTTON_LABEL, &buttonLabel1);
        ArkUI_NumberValue btnAttributeValue[] = {ARKUI_ALIGNMENT_TOP_START, 0, 15};
        ArkUI_AttributeItem buttonAttributeItem = {btnAttributeValue, 3, .string = "NODE_BUTTON_LABEL set is true"};
        Manager::nodeAPI_->setAttribute(buttonOver, NODE_OVERLAY, &buttonAttributeItem);
        Manager::nodeAPI_->addChild(column, buttonOver);
        Manager::nodeAPI_->addChild(node, column);
    });
}

void SetAttributeRow(ArkUI_NodeHandle &node)
{
    radioTwo = Manager::nodeAPI_->createNode(ARKUI_NODE_RADIO);
    ArkUI_NumberValue btnWidthValue[] = {C_VALUE};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    Manager::nodeAPI_->setAttribute(radioTwo, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(radioTwo, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(radioTwo, NODE_MARGIN, &btnMarginItem);
    Manager::nodeAPI_->registerNodeEvent(radioTwo, NODE_ON_CLICK, TARGET_ID_24, nullptr);
    Manager::nodeAPI_->addChild(node, radioTwo);
}

void SetHeightPercentAdd(ArkUI_NodeHandle &node)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeHeightValue[] = {1};
    ArkUI_AttributeItem nodeHeightItem = {nodeHeightValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT_PERCENT, &nodeHeightItem);
}

void AddSupportedUIStates(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "SupportedUIStates", [](ArkUI_NodeHandle node) {
        static auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        SetWidthPercent(column, 1);
        SetHeightPercentAdd(column);
        static auto buttonUIstateControl = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        buttonUIState = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        auto buttonUIStateTwo = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        static auto buttonUIstateEnableControl = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        static auto row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        SetAttributeRow(row);
        SetButtonAttribute(buttonUIState);
        SetButtonAttribute(buttonUIStateTwo);
        SetButtonAttribute(buttonUIstateControl);
        ArkUI_AttributeItem buttonLabel1 = {.string = "buttonUIstate"};
        Manager::nodeAPI_->setAttribute(buttonUIState, NODE_BUTTON_LABEL, &buttonLabel1);
        ArkUI_AttributeItem buttonLabel2 = {.string = "AddSupportedUIStates for button"};
        Manager::nodeAPI_->setAttribute(buttonUIstateControl, NODE_BUTTON_LABEL, &buttonLabel2);
        ArkUI_AttributeItem buttonLabel3 = {.string = "setButtonUIstateEnableAttribute"};
        Manager::nodeAPI_->setAttribute(buttonUIstateEnableControl, NODE_BUTTON_LABEL, &buttonLabel3);
        ArkUI_AttributeItem buttonLabel4 = {.string = "AddSupportedUIStates for radio"};
        Manager::nodeAPI_->setAttribute(buttonUIStateTwo, NODE_BUTTON_LABEL, &buttonLabel4);
        static MyData componentUIStates;
        componentUIStates.columnControl = buttonUIState;
        componentUIStates.buttonTwo = buttonUIstateControl;
        Manager::nodeAPI_->registerNodeEvent(buttonUIstateControl, NODE_ON_CLICK_EVENT,
            TARGET_ID_18, &componentUIStates);
        Manager::nodeAPI_->registerNodeEvent(buttonUIstateEnableControl, NODE_ON_CLICK, TARGET_ID_22,
                                             &componentUIStates);
        Manager::nodeAPI_->registerNodeEvent(buttonUIStateTwo, NODE_ON_CLICK, TARGET_ID_23, &componentUIStates);
        Manager::nodeAPI_->addChild(column, buttonUIState);
        Manager::nodeAPI_->addChild(column, buttonUIstateControl);
        Manager::nodeAPI_->addChild(column, buttonUIstateEnableControl);
        Manager::nodeAPI_->addChild(column, buttonUIStateTwo);
        Manager::nodeAPI_->addChild(column, row);
        Manager::nodeAPI_->addChild(node, column);
    });
}

void AddUIStates(ArkUI_NodeHandle &node, ArkUI_NodeEvent *event)
{
    g_globalStatesToSupported = g_globalStatesToSupported | ArkUI_UIState::UI_STATE_PRESSED |
                               ArkUI_UIState::UI_STATE_FOCUSED | ArkUI_UIState::UI_STATE_DISABLED;
    auto result = OH_ArkUI_AddSupportedUIStates(
        buttonUIState, g_globalStatesToSupported,
        [](int32_t currentStates, void *userData) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "Add UI state changed to: %{public}d",
                         currentStates);
            if (currentStates == ArkUI_UIState::UI_STATE_NORMAL) {
                ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF000000}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(buttonUIState, NODE_BACKGROUND_COLOR, &backColorItem);
            }
            if (currentStates & ArkUI_UIState::UI_STATE_PRESSED) {
                ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF009A61}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(buttonUIState, NODE_BACKGROUND_COLOR, &backColorItem);
            }
            if (currentStates & ArkUI_UIState::UI_STATE_FOCUSED) {
                ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF888888}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(buttonUIState, NODE_BACKGROUND_COLOR, &backColorItem);
            }
            if (currentStates & ArkUI_UIState::UI_STATE_DISABLED) {
                ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF666666}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(buttonUIState, NODE_BACKGROUND_COLOR, &backColorItem);
            }
        },
        false, nullptr);
    if (result) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "AddUIStates errorCode is %{public}d", result);
    }
}

void AddUIStatesOne(ArkUI_NodeHandle &node, ArkUI_NodeEvent *event)
{
    g_globalStatesToSupported = g_globalStatesToSupported | ArkUI_UIState::UI_STATE_SELECTED;
    auto result = OH_ArkUI_AddSupportedUIStates(
        radioTwo, g_globalStatesToSupported,
        [](int32_t currentStates, void *userData) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "UI state changed to: %{public}d",
                         currentStates);
            if (currentStates & ArkUI_UIState::UI_STATE_SELECTED) {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "UI_STATE_SELECTED    ");
                ArkUI_NumberValue backColorValue[] = {{.u32 = 0xFF444444}, {.u32 = 0xFF444444}, {.u32 = 0xFF444444}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 3};
                Manager::nodeAPI_->setAttribute(radioTwo, NODE_RADIO_STYLE, &backColorItem);
            }
        },
        true, nullptr);
    if (result) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "AddUIStatesOne errorCode is %{public}d",
                     result);
    }
}

void RemoveUIStates(ArkUI_NodeHandle &node)
{
    auto result = OH_ArkUI_RemoveSupportedUIStates(
        node, ArkUI_UIState::UI_STATE_NORMAL | ArkUI_UIState::UI_STATE_PRESSED | ArkUI_UIState::UI_STATE_FOCUSED |
                  ArkUI_UIState::UI_STATE_DISABLED | ArkUI_UIState::UI_STATE_SELECTED);
    if (result) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "RemoveSupportedUIStates errorCode is %{public}d", result);
    }
}

void AllRegisterNodeEventReceiverOne(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case 0: {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_EVENT componentEvent->data[0].i32 == %{public}d",
                         componentEvent->data[0].i32);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_EVENT componentEvent->data[1].f32 == %{public}f",
                         componentEvent->data[1].f32);
            break;
        }
        case 1: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  button1 onTouch");
            auto uiEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
            auto result = OH_ArkUI_PointerEvent_SetStopPropagation(uiEvent, true);
            break;
        }
        case TARGET_ID_2: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  row onTouch");
            break;
        }
        case TARGET_ID_12: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_EVENT_ON_ATTACH ,the component on the tree");
            ArkUI_NumberValue *value;
            auto errorCode = OH_ArkUI_NodeEvent_GetNumberValue(event, 16, value);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "errorCode is %{public}d", errorCode);
        }
        default:
                break;
    }
}

void AreaChange(ArkUI_NodeEvent *event)
{
    if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_CLICK) {
        if (g_cArea == 0) {
            g_cArea = 1;
            ArkUI_NumberValue rowWidthValue[] = {300};
            ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
            ArkUI_NumberValue rowHeightValue[] = {300};
            ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
            Manager::nodeAPI_->setAttribute(buttonArea, NODE_WIDTH, &rowWidthItem);
            Manager::nodeAPI_->setAttribute(buttonArea, NODE_HEIGHT, &rowHeightItem);
        } else {
            g_cArea = 0;
            ArkUI_NumberValue rowWidthValue[] = {200};
            ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
            ArkUI_NumberValue rowHeightValue[] = {200};
            ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
            Manager::nodeAPI_->setAttribute(buttonArea, NODE_WIDTH, &rowWidthItem);
            Manager::nodeAPI_->setAttribute(buttonArea, NODE_HEIGHT, &rowHeightItem);
        }
    } else {
        auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "NODE_EVENT_ON_AREA_CHANGE  componentEvent->data[0].i32 == %{public}d",
                     componentEvent->data[0].i32);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "NODE_EVENT_ON_AREA_CHANGE  componentEvent->data[6].i32 == %{public}d",
                     componentEvent->data[TARGET_ID_6].i32);
        auto uiEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        auto result = OH_ArkUI_PointerEvent_SetStopPropagation(uiEvent, true);
    }
}

void AllRegisterNodeEventReceiverTwo(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case TARGET_ID_3: {
            auto uiNode = OH_ArkUI_NodeEvent_GetNodeHandle(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "buttonTwo of the type = %{public}d onAppear",
                         OH_ArkUI_NodeUtils_GetNodeType(uiNode));
            auto snapshotOptions = OH_ArkUI_CreateSnapshotOptions();
            OH_PixelmapNative *pixelmap;
            auto errorCode = OH_ArkUI_GetNodeSnapshot(uiNode, snapshotOptions, &pixelmap);
            if (errorCode) {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "errorCode is %{public}d", errorCode);
            }
            break;
        }
        case TARGET_ID_13: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_EVENT_ON_DETACH ,the component is moved on the tree");
            ArkUI_NumberValue *value;
            auto errorCode = OH_ArkUI_NodeEvent_SetReturnNumberValue(event, value, 10);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "errorCode is %{public}d", errorCode);
        }
        case TARGET_ID_4: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "buttonTwo onDisAppear");
            break;
        }
        case TARGET_ID_5: {
            MyData *component = (MyData *)OH_ArkUI_NodeEvent_GetUserData(event);
            Manager::nodeAPI_->addChild(component->columnControl, component->buttonTwo);
            break;
        }
        case TARGET_ID_6: {
            MyData *component = (MyData *)OH_ArkUI_NodeEvent_GetUserData(event);
            Manager::nodeAPI_->removeChild(component->columnControl, component->buttonTwo);
            break;
        }
        case TARGET_ID_7: {
                AreaChange(event);
            break;
        }
        default:
                break;
    }
}

void AllRegisterNodeEventReceiverThree(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case TARGET_ID_8: {
            auto text = OH_ArkUI_NodeEvent_GetUserData(event);
            ArkUI_AttributeItem TextItem = {.string = "click distance is true"};
            Manager::nodeAPI_->setAttribute(static_cast<ArkUI_NodeHandle>(text), NODE_TEXT_CONTENT, &TextItem);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "click distance is true");
            break;
        }
        case TARGET_ID_10: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_ON_HOVER is used");
            break;
        }
        case TARGET_ID_11: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_ON_MOUSE ,the mouse click or move, event type is %{public}p",
                         OH_ArkUI_NodeEvent_GetEventType(event));
            break;
        }
        case TARGET_ID_15: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "NODE_ON_HOVER_EVENT is used");
            break;
        }
        case TARGET_ID_16: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "NODE_ON_HOVER_MOVE is used");
            break;
        }
        default:
                break;
    }
}

void AllRegisterNodeEventReceiverFour(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case TARGET_ID_18: {
            MyData *component = (MyData *)OH_ArkUI_NodeEvent_GetUserData(event);
            if (g_cControl == 1) {
                ArkUI_AttributeItem butItem = {.string = "removeSupportedUIStates"};
                Manager::nodeAPI_->setAttribute(component->buttonTwo, NODE_BUTTON_LABEL, &butItem);
                AddUIStates(component->columnControl, event);
                g_cControl = 0;
            } else {
                ArkUI_AttributeItem butItem = {.string = "addSupportedUIStates"};
                Manager::nodeAPI_->setAttribute(component->buttonTwo, NODE_BUTTON_LABEL, &butItem);
                RemoveUIStates(component->columnControl);
                g_cControl = 1;
            }
            break;
        }
        case TARGET_ID_19: {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_EVENT_ON_VISIBLE_AREA_CHANGE componentEvent->data[0].i32 == %{public}d",
                         componentEvent->data[0].i32);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_EVENT_ON_VISIBLE_AREA_CHANGE componentEvent->data[1].f32 == %{public}f",
                         componentEvent->data[1].f32);
            break;
        }
        case TARGET_ID_20: {
            ArkUI_AttributeItem TextItem = {.string = "button1 click"};
            Manager::nodeAPI_->setAttribute(textResponse, NODE_TEXT_CONTENT, &TextItem);
            break;
        }
        case TARGET_ID_21: {
            ArkUI_AttributeItem TextItem = {.string = "button2 click"};
            Manager::nodeAPI_->setAttribute(textResponse, NODE_TEXT_CONTENT, &TextItem);
            break;
        }
        default:
            break;
    }
}

void AllRegisterNodeEventReceiverAdd(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case TARGET_ID_22: {
            MyData *component = (MyData *)OH_ArkUI_NodeEvent_GetUserData(event);
            if (g_cEnable == 0) {
                SetEnable(component->columnControl, false);
                g_cEnable = 1;
            } else {
                SetEnable(component->columnControl, true);
                g_cEnable = 0;
            }
            break;
        }
        case TARGET_ID_23: {
                AddUIStatesOne(radioTwo, event);
            break;
        }
        case TARGET_ID_24: {
            if (g_cSelect == 0) {
                ArkUI_NumberValue backColorValue[] = {{.i32 = true}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(radioTwo, NODE_RADIO_CHECKED, &backColorItem);
                g_cSelect = 1;
            } else {
                ArkUI_NumberValue backColorValue[] = {{.i32 = false}};
                ArkUI_AttributeItem backColorItem = {backColorValue, 1};
                Manager::nodeAPI_->setAttribute(radioTwo, NODE_RADIO_CHECKED, &backColorItem);
                g_cSelect = 0;
            }
                break;
            }
        default:
            break;
    }
}

void AllRegisterNodeEventReceiver()
{
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        switch (targetId) {
            case 0:
            case 1:
            case TARGET_ID_2:
            case TARGET_ID_12: {
                AllRegisterNodeEventReceiverOne(targetId, event);
            }
            case TARGET_ID_3:
            case TARGET_ID_13:
            case TARGET_ID_4:
            case TARGET_ID_5:
            case TARGET_ID_6:
            case TARGET_ID_7: {
                AllRegisterNodeEventReceiverTwo(targetId, event);
                break;
            }
            case TARGET_ID_8:
            case TARGET_ID_10:
            case TARGET_ID_11:
            case TARGET_ID_15:
            case TARGET_ID_16: {
                AllRegisterNodeEventReceiverThree(targetId, event);
                break;
            }
            case TARGET_ID_18:
            case TARGET_ID_19:
            case TARGET_ID_20:
            case TARGET_ID_21:{
                AllRegisterNodeEventReceiverFour(targetId, event);
                break;
            }
            case TARGET_ID_22:
            case TARGET_ID_23:
            case TARGET_ID_24:{
                AllRegisterNodeEventReceiverAdd(targetId, event);
                break;
            }
            default:
                break;
        }
    });
}

ArkUI_NodeHandle CreateNodeEventOnAppearColumnControl()
{
    static auto columnControl = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue rowWidthValue[] = {400};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {400};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    Manager::nodeAPI_->setAttribute(columnControl, NODE_WIDTH, &rowWidthItem);
    Manager::nodeAPI_->setAttribute(columnControl, NODE_HEIGHT, &rowHeightItem);
    return columnControl;
}

void CreateNodeEventOnAppear(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_EVENT_ON_APPEAR NODE_EVENT_ON_DISAPPEAR", [](ArkUI_NodeHandle node) {
        auto columnControl = CreateNodeEventOnAppearColumnControl();
        static auto buttonControl = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        static auto buttonControl1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        static auto buttonTwo = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {20};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
        ArkUI_AttributeItem buttonLabel1 = {.string = "appear buttonTwo"};
        Manager::nodeAPI_->setAttribute(buttonControl, NODE_BUTTON_LABEL, &buttonLabel1);
        Manager::nodeAPI_->setAttribute(buttonControl, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(buttonControl, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(buttonControl, NODE_MARGIN, &btnMarginItem);
        ArkUI_AttributeItem buttonLabel2 = {.string = "disappear buttonTwo"};
        Manager::nodeAPI_->setAttribute(buttonControl1, NODE_BUTTON_LABEL, &buttonLabel2);
        Manager::nodeAPI_->setAttribute(buttonControl1, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(buttonControl1, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(buttonControl1, NODE_MARGIN, &btnMarginItem);
        ArkUI_AttributeItem buttonLabel3 = {.string = "buttonTwo"};
        Manager::nodeAPI_->setAttribute(buttonTwo, NODE_BUTTON_LABEL, &buttonLabel3);
        Manager::nodeAPI_->setAttribute(buttonTwo, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(buttonTwo, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(buttonTwo, NODE_MARGIN, &btnMarginItem);
        Manager::nodeAPI_->registerNodeEvent(buttonTwo, NODE_EVENT_ON_APPEAR, TARGET_ID_3, nullptr);
        Manager::nodeAPI_->registerNodeEvent(buttonTwo, NODE_EVENT_ON_DISAPPEAR, TARGET_ID_4, nullptr);
        static MyData component;
        component.buttonTwo = buttonTwo;
        component.columnControl = columnControl;
        Manager::nodeAPI_->registerNodeEvent(buttonControl, NODE_ON_CLICK_EVENT, TARGET_ID_5, &component);
        Manager::nodeAPI_->registerNodeEvent(buttonControl1, NODE_ON_CLICK_EVENT, TARGET_ID_6, &component);
        Manager::nodeAPI_->registerNodeEvent(buttonTwo, NODE_EVENT_ON_ATTACH, TARGET_ID_12, nullptr);
        Manager::nodeAPI_->registerNodeEvent(buttonTwo, NODE_EVENT_ON_DETACH, TARGET_ID_13, nullptr);
        AllRegisterNodeEventReceiver();
        Manager::nodeAPI_->addChild(columnControl, buttonControl);
        Manager::nodeAPI_->addChild(columnControl, buttonControl1);
        Manager::nodeAPI_->addChild(columnControl, buttonTwo);
        Manager::nodeAPI_->addChild(node, columnControl);
    });
}

void AddScrollChild(ArkUI_NodeHandle &scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    // NODE_BACKGROUND_COLOR
    CreateNodeBackGroundColor(scroll, column);
    // NODE_ENABLED
    CreateNodeEnabled(scroll, column);
    // NODE_Z_INDEX
    CreateNodeZIndex(column);
    // NODE_VISIBILITY
    CreateNodeVisibility(column);
    // NODE_CLICK_DISTANCE
    CreateNodeClickDistance(column);
    // NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO
    CreateNodeVisibleAreaApproximateChangeRatio(column);
    // NODE_TOUCH_EVENT
    CreateNodeTouchEvent(column);
    // NODE_EVENT_ON_AREA_CHANGE
    CreateNodeEventOnAreaChange(column);
    // NODE_ON_HOVER
    CreateNodeOnHover(column);
    // NODE_ON_MOUSE
    CreateNodeOnMouse(column);
    // NODE_ON_HOVER_EVENT
    CreateNodeOnHoverEvent(column);
    // NODE_ON_HOVER_MOVE
    CreateNodeOnHoverMove(column);
    // ArkUI_UIState
    AddSupportedUIStates(column);
    // NODE_RESPONSE_REGION
    AddResponseRegion(column);
    // NODE_OVERLAY
    AddOverlay(column);
    // NODE_EVENT_ON_APPEAR   NODE_EVENT_ON_DISAPPEAR
    CreateNodeEventOnAppear(column);
    Manager::nodeAPI_->addChild(scroll, column);
}

ArkUI_NodeHandle PublicMaker::CreateNativeNode()
{
    // 创建父子滚动容器
    ArkUI_NodeHandle scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    // 设置属性
    SetScrollAttribute(scroll);
    AddScrollChild(scroll);
    return scroll;
}