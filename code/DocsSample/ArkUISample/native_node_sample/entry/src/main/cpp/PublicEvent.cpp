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
const int32_t TARGET_ID_9 = 9;
const int32_t TARGET_ID_10 = 10;
const int32_t TARGET_ID_11 = 11;
const int32_t TARGET_ID_12 = 12;
const int32_t TARGET_ID_13 = 13;
const int32_t TARGET_ID_14 = 14;
const int32_t TARGET_ID_15 = 15;
const int32_t TARGET_ID_16 = 16;
const int32_t TARGET_ID_17 = 17;

typedef struct {
    ArkUI_NodeHandle columnControl;
    ArkUI_NodeHandle buttonTwo;
} MyData;

void CreateNodeWithCommonAttribute(ArkUI_NodeHandle parent, const char *attributeName,
                                   std::function<void(ArkUI_NodeHandle node)> func)
{
    if (!Manager::nodeAPI_ || !parent) {
        return;
    }
    static auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    // row设置宽高、边框
    ArkUI_NumberValue rowWidthValue[] = {400};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {400};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    ArkUI_AttributeItem idItem = {.string = attributeName};
    Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
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

void StatesChangeHandler(int32_t currentStates, void *userData)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "UI state changed to: %{public}d", currentStates);

    // 根据当前状态调整UI样式
    if (currentStates == ArkUI_UIState::UI_STATE_NORMAL) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "UIStates", "Button is in NORMAL state");
    } else {
        if (currentStates & ArkUI_UIState::UI_STATE_PRESSED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is PRESSED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_FOCUSED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is FOCUSED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_DISABLED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is DISABLED");
        }
        if (currentStates & ArkUI_UIState::UI_STATE_SELECTED) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo UIStates", "Button is SELECTED");
        }
    }
}

void SetScrollAttribute(ArkUI_NodeHandle &scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue scrollWidthValue[] = {500};
    ArkUI_AttributeItem scrollWidthItem = {scrollWidthValue, 1};
    Manager::nodeAPI_->setAttribute(scroll, NODE_WIDTH, &scrollWidthItem);
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
        ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        ArkUI_NumberValue rowWidthValue[] = {400};
        ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
        ArkUI_NumberValue rowHeightValue[] = {100};
        ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
        Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
        Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);
        ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NodeHandle button2 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {20};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
        Manager::nodeAPI_->setAttribute(button1, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button1, NODE_MARGIN, &btnMarginItem);
        Manager::nodeAPI_->setAttribute(button2, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button2, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button2, NODE_MARGIN, &btnMarginItem);
        ArkUI_AttributeItem btn1TextItem = {.string = "Enabled Button"};
        Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &btn1TextItem);
        ArkUI_AttributeItem idItem = {.string = "enabledButton"};
        Manager::nodeAPI_->setAttribute(button1, NODE_ID, &idItem);
        ArkUI_AttributeItem btn2TextItem = {.string = "Not Enabled Button"};
        Manager::nodeAPI_->setAttribute(button2, NODE_BUTTON_LABEL, &btn2TextItem);
        ArkUI_AttributeItem idItem1 = {.string = "notEnabledButton"};
        Manager::nodeAPI_->setAttribute(button2, NODE_ID, &idItem1);
        // 为button1设置NODE_ENABLED属性
        ArkUI_NumberValue enableValue[] = {{.i32 = false}};
        ArkUI_AttributeItem enableItem = {enableValue, 1};
        Manager::nodeAPI_->setAttribute(button1, NODE_ENABLED, &enableItem);
        // 将按钮添加到Row中
        Manager::nodeAPI_->addChild(row, button1);
        Manager::nodeAPI_->addChild(row, button2);
        // 将Row添加到传入的node中
        Manager::nodeAPI_->addChild(node, row);
    });
}

ArkUI_NodeHandle CreateNodeZIndexStack()
{
    ArkUI_NodeHandle stack = Manager::nodeAPI_->createNode(ARKUI_NODE_STACK);
    ArkUI_NumberValue stackWidthValue[] = {400};
    ArkUI_AttributeItem stackWidthItem = {stackWidthValue, 1};
    ArkUI_NumberValue stackHeightValue[] = {400};
    ArkUI_AttributeItem stackHeightItem = {stackHeightValue, 1};
    Manager::nodeAPI_->setAttribute(stack, NODE_WIDTH, &stackWidthItem);
    Manager::nodeAPI_->setAttribute(stack, NODE_HEIGHT, &stackHeightItem);
    return stack;
}

ArkUI_NodeHandle CreateNodeZIndexText1()
{
    ArkUI_NodeHandle text1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue text1WidthValue1[] = {100};
    ArkUI_AttributeItem text1WidthItem1 = {text1WidthValue1, 1};
    ArkUI_NumberValue text1HeightValue1[] = {100};
    ArkUI_AttributeItem text1HeightItem1 = {text1HeightValue1, 1};
    ArkUI_NumberValue backColorValue1[] = {{.u32 = 0xFFbbb2cb}};
    ArkUI_AttributeItem backColorItem1 = {backColorValue1, 1};
    Manager::nodeAPI_->setAttribute(text1, NODE_WIDTH, &text1WidthItem1);
    Manager::nodeAPI_->setAttribute(text1, NODE_HEIGHT, &text1HeightItem1);
    Manager::nodeAPI_->setAttribute(text1, NODE_BACKGROUND_COLOR, &backColorItem1);
    ArkUI_AttributeItem idItem1 = {.string = "zIndexText1"};
    Manager::nodeAPI_->setAttribute(text1, NODE_ID, &idItem1);
    ArkUI_NumberValue zIndexValue1[] = {{.i32 = 2}};
    ArkUI_AttributeItem zIndexItem1 = {zIndexValue1, 1};
    Manager::nodeAPI_->setAttribute(text1, NODE_Z_INDEX, &zIndexItem1);
    ArkUI_AttributeItem text1TextItem = {.string = "text1 \nzindex(2)"};
    Manager::nodeAPI_->setAttribute(text1, NODE_TEXT_CONTENT, &text1TextItem);
    return text1;
}

ArkUI_NodeHandle CreateNodeZIndexText2()
{
    ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue text2WidthValue2[] = {200};
    ArkUI_AttributeItem text2WidthItem2 = {text2WidthValue2, 1};
    ArkUI_NumberValue text2HeightValue2[] = {200};
    ArkUI_AttributeItem text2HeightItem2 = {text2HeightValue2, 1};
    ArkUI_NumberValue backColorValue2[] = {{.u32 = 0xFFd2cab3}};
    ArkUI_AttributeItem backColorItem2 = {backColorValue2, 1};
    Manager::nodeAPI_->setAttribute(text2, NODE_WIDTH, &text2WidthItem2);
    Manager::nodeAPI_->setAttribute(text2, NODE_HEIGHT, &text2HeightItem2);
    Manager::nodeAPI_->setAttribute(text2, NODE_BACKGROUND_COLOR, &backColorItem2);
    ArkUI_AttributeItem idItem2 = {.string = "zIndexText2"};
    Manager::nodeAPI_->setAttribute(text2, NODE_ID, &idItem2);
    ArkUI_NumberValue zIndexValue2[] = {{.i32 = 1}};
    ArkUI_AttributeItem zIndexItem2 = {zIndexValue2, 1};
    Manager::nodeAPI_->setAttribute(text2, NODE_Z_INDEX, &zIndexItem2);
    ArkUI_AttributeItem text2TextItem = {.string = "text2 \nzindex\n(1)"};
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
        ArkUI_NumberValue text3WidthValue3[] = {300};
        ArkUI_AttributeItem text3WidthItem3 = {text3WidthValue3, 1};
        ArkUI_NumberValue text3HeightValue3[] = {300};
        ArkUI_AttributeItem text3HeightItem3 = {text3HeightValue3, 1};
        ArkUI_NumberValue backColorValue3[] = {{.u32 = 0xFFc1ccab}};
        ArkUI_AttributeItem backColorItem3 = {backColorValue3, 1};

        Manager::nodeAPI_->setAttribute(text3, NODE_WIDTH, &text3WidthItem3);
        Manager::nodeAPI_->setAttribute(text3, NODE_HEIGHT, &text3HeightItem3);
        Manager::nodeAPI_->setAttribute(text3, NODE_BACKGROUND_COLOR, &backColorItem3);

        ArkUI_AttributeItem idItem3 = {.string = "zIndexText3"};
        Manager::nodeAPI_->setAttribute(text3, NODE_ID, &idItem3);

        ArkUI_NumberValue zIndexValue3[] = {{.i32 = 0}};
        ArkUI_AttributeItem zIndexItem3 = {zIndexValue3, 1};
        Manager::nodeAPI_->setAttribute(text3, NODE_Z_INDEX, &zIndexItem3);

        ArkUI_AttributeItem text3TextItem = {.string = "text3 \nzindex\n(0)"};
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
    ArkUI_NumberValue columnWidthValue[] = {400};
    ArkUI_AttributeItem columnWidthItem = {columnWidthValue, 1};
    ArkUI_NumberValue columnHeightValue[] = {400};
    ArkUI_AttributeItem columnHeightItem = {columnHeightValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_WIDTH, &columnWidthItem);
    Manager::nodeAPI_->setAttribute(column, NODE_HEIGHT, &columnHeightItem);
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
        // 创建两个Button按钮
        ArkUI_NodeHandle text1 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        ArkUI_NodeHandle text3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
        auto row1 = CreateNodeVisibilityRow1();
        auto row2 = CreateNodeVisibilityRow2();
        auto row3 = CreateNodeVisibilityRow3();
        // 为button1设置文本内容
        ArkUI_AttributeItem text1TextItem = {.string = "ARKUI_VISIBILITY_NONE"};
        Manager::nodeAPI_->setAttribute(text1, NODE_TEXT_CONTENT, &text1TextItem);
        // 为button2设置文本内容
        ArkUI_AttributeItem text2TextItem = {.string = "ARKUI_VISIBILITY_HIDDEN"};
        Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_CONTENT, &text2TextItem);
        // 为button2设置文本内容
        ArkUI_AttributeItem text3TextItem = {.string = "ARKUI_VISIBILITY_VISIBLE"};
        Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CONTENT, &text3TextItem);
        // 将按钮添加到Row中
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

ArkUI_NodeHandle CreateNodeHitTestBehaviorColumn()
{
    ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue columnWidthValue[] = {200};
    ArkUI_AttributeItem columnWidthItem = {columnWidthValue, 1};
    ArkUI_NumberValue columnHeightValue[] = {400};
    ArkUI_AttributeItem columnHeightItem = {columnHeightValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_WIDTH, &columnWidthItem);
    Manager::nodeAPI_->setAttribute(column, NODE_HEIGHT, &columnHeightItem);
    return column;
}

ArkUI_NodeHandle CreateNodeHitTestBehaviorRow()
{
    ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue rowWidthValue[] = {200};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {100};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
    Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);
    return row;
}

ArkUI_NodeHandle CreateNodeHitTestBehaviorRow1()
{
    ArkUI_NodeHandle row1 = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    // 设置Row属性
    ArkUI_NumberValue rowWidthValue[] = {200};
    ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
    ArkUI_NumberValue rowHeightValue[] = {100};
    ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
    Manager::nodeAPI_->setAttribute(row1, NODE_WIDTH, &rowWidthItem);
    Manager::nodeAPI_->setAttribute(row1, NODE_HEIGHT, &rowHeightItem);
    return row1;
}

ArkUI_NodeHandle CreateNodeHitTestBehaviorText()
{
    static ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {20};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_NumberValue btnWidthValue1[] = {300};
    ArkUI_AttributeItem btnWidthItem1 = {btnWidthValue1, 1};
    Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &btnWidthItem1);
    Manager::nodeAPI_->setAttribute(text, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &btnMarginItem);
    ArkUI_AttributeItem TextItem = {.string = "NODE_HIT_TEST_BEHAVIOR"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem);
    return text;
}

ArkUI_NodeHandle CreateNodeHitTestBehaviorButton1()
{
    ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btnWidthValue[] = {150};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {20};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    Manager::nodeAPI_->setAttribute(button1, NODE_WIDTH, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(button1, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(button1, NODE_MARGIN, &btnMarginItem);
    ArkUI_AttributeItem btn1TextItem = {.string = "Hit Test Button 1"};
    Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &btn1TextItem);
    ArkUI_NumberValue enableValue[] = {{.i32 = ARKUI_HIT_TEST_MODE_DEFAULT}};
    ArkUI_AttributeItem enableItem = {enableValue, 1};
    Manager::nodeAPI_->setAttribute(button1, NODE_HIT_TEST_BEHAVIOR, &enableItem);
    return button1;
}

void CreateNodeHitTestBehavior(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_HIT_TEST_BEHAVIOR", [](ArkUI_NodeHandle node) {
        auto column = CreateNodeHitTestBehaviorColumn();
        auto row = CreateNodeHitTestBehaviorRow();
        auto row1 = CreateNodeHitTestBehaviorRow1();
        auto text = CreateNodeHitTestBehaviorText();
        // 创建两个Button按钮
        auto button1 = CreateNodeHitTestBehaviorButton1();
        ArkUI_NodeHandle button2 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {20};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};

        Manager::nodeAPI_->setAttribute(button2, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button2, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button2, NODE_MARGIN, &btnMarginItem);

        // 为button2设置文本内容
        ArkUI_AttributeItem btn2TextItem = {.string = "Hit Test Button 2"};
        Manager::nodeAPI_->setAttribute(button2, NODE_BUTTON_LABEL, &btn2TextItem);

        ArkUI_NumberValue enableValue2[] = {{.i32 = ARKUI_HIT_TEST_MODE_BLOCK}};
        ArkUI_AttributeItem enableItem2 = {enableValue2, 1};
        Manager::nodeAPI_->setAttribute(button2, NODE_HIT_TEST_BEHAVIOR, &enableItem2);

        // 为button1创建点击手势并绑定回调
        Manager::nodeAPI_->registerNodeEvent(button1, NODE_ON_CLICK_EVENT, TARGET_ID_9, text);
        Manager::nodeAPI_->registerNodeEvent(button2, NODE_ON_CLICK_EVENT, TARGET_ID_17, text);

        // 将按钮添加到Row中
        Manager::nodeAPI_->addChild(row, button1);
        Manager::nodeAPI_->addChild(row, button2);
        Manager::nodeAPI_->addChild(row1, text);

        // 将Row添加到传入的node中
        Manager::nodeAPI_->addChild(column, row);
        Manager::nodeAPI_->addChild(column, row1);
        Manager::nodeAPI_->addChild(node, column);
    });
}

void CreateNodeClickDistance(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_CLICK_DISTANCE", [](ArkUI_NodeHandle node) {
        // 创建Row容器
        ArkUI_NodeHandle column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        // 设置Row属性
        ArkUI_NumberValue rowWidthValue[] = {400};
        ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
        ArkUI_NumberValue rowHeightValue[] = {400};
        ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
        Manager::nodeAPI_->setAttribute(column, NODE_WIDTH, &rowWidthItem);
        Manager::nodeAPI_->setAttribute(column, NODE_HEIGHT, &rowHeightItem);

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
        Manager::nodeAPI_->registerNodeEvent(button1, NODE_ON_CLICK_EVENT, TARGET_ID_8, text);

        ArkUI_NumberValue btnWidthValue1[] = {150};
        ArkUI_AttributeItem btnWidthItem1 = {btnWidthValue1, 1};
        Manager::nodeAPI_->setAttribute(text, NODE_WIDTH, &btnWidthItem1);
        Manager::nodeAPI_->setAttribute(text, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(text, NODE_MARGIN, &btnMarginItem);

        Manager::nodeAPI_->addChild(column, button1);
        Manager::nodeAPI_->addChild(column, text);
        // 将Row添加到传入的node中
        Manager::nodeAPI_->addChild(node, column);
    });
}

void CreateNodeVisibleAreaApproximateChangeRatio(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO ", [](ArkUI_NodeHandle node) {
        // 创建Row容器
        ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
        ArkUI_NumberValue rowWidthValue[] = {400};
        ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
        ArkUI_NumberValue rowHeightValue[] = {100};
        ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
        Manager::nodeAPI_->setAttribute(row, NODE_WIDTH, &rowWidthItem);
        Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &rowHeightItem);

        ArkUI_NumberValue areaApproximateValue[] = {0.5};
        ArkUI_AttributeItem areaApproximateItem = {areaApproximateValue, 1};

        auto *option = OH_ArkUI_VisibleAreaEventOptions_Create();
        OH_ArkUI_VisibleAreaEventOptions_Dispose(option);
        auto *options = OH_ArkUI_VisibleAreaEventOptions_Create();
        float *ratiosArray = new float[1];
        ratiosArray[0] = 0;
        ratiosArray[1] = 1.0;
        OH_ArkUI_VisibleAreaEventOptions_SetRatios(options, ratiosArray, TARGET_ID_2);
        auto value = 1000;
        OH_ArkUI_VisibleAreaEventOptions_SetExpectedUpdateInterval(options, value);
        ArkUI_AttributeItem areaItem = {.object = options};

        Manager::nodeAPI_->setAttribute(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO, &areaItem);
        auto item = Manager::nodeAPI_->getAttribute(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_RATIO);
        auto optionObject = reinterpret_cast<ArkUI_VisibleAreaEventOptions *>(item->object);
        int size = 3;
        float *ratiosGet = new float[3];

        OH_ArkUI_VisibleAreaEventOptions_GetRatios(optionObject, ratiosGet, &size);

        auto expectedUpdateInterva = OH_ArkUI_VisibleAreaEventOptions_GetExpectedUpdateInterval(optionObject);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  size == %{public}d", size);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "CreateNativeNode  ratiosGet ratiosGet[0] == %{public}f ratiosGet[1] == %{public}f", ratiosGet[0],
                     ratiosGet[1]);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "CreateNativeNode  expectedUpdateInterva == %{public}d", expectedUpdateInterva);
        Manager::nodeAPI_->registerNodeEvent(row, NODE_VISIBLE_AREA_APPROXIMATE_CHANGE_EVENT, 0, nullptr);
        Manager::nodeAPI_->addChild(node, row);
    });
}

void CreateNodeTouchEvent(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_TOUCH_EVENT ", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
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
        Manager::nodeAPI_->registerNodeEvent(node, NODE_TOUCH_EVENT, TARGET_ID_2, nullptr);
        Manager::nodeAPI_->addChild(node, button1);
    });
}

void CreateNodeEventOnAreaChange(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_EVENT_ON_AREA_CHANGE ", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }

        // 清除原有的子节点
        Manager::nodeAPI_->removeAllChildren(node);

        auto column = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
        ArkUI_NumberValue rowWidthValue[] = {400};
        ArkUI_AttributeItem rowWidthItem = {rowWidthValue, 1};
        ArkUI_NumberValue rowHeightValue[] = {400};
        ArkUI_AttributeItem rowHeightItem = {rowHeightValue, 1};
        Manager::nodeAPI_->setAttribute(column, NODE_WIDTH, &rowWidthItem);
        Manager::nodeAPI_->setAttribute(column, NODE_HEIGHT, &rowHeightItem);
        
        Manager::nodeAPI_->registerNodeEvent(column, NODE_EVENT_ON_AREA_CHANGE, TARGET_ID_7, nullptr);
        Manager::nodeAPI_->addChild(node, column);
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

void CreateNodeOnFocusAxis(ArkUI_NodeHandle &column)
{
    CreateNodeWithCommonAttribute(column, "NODE_ON_FOCUS_AXIS", [](ArkUI_NodeHandle node) {
        if (!Manager::nodeAPI_ || !node) {
            return;
        }
        ArkUI_NumberValue btnWidthValue[] = {150};
        ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
        ArkUI_NumberValue btnHeightValue[] = {60};
        ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
        ArkUI_NumberValue btnMarginValue[] = {20};
        ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};

        auto button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);

        ArkUI_AttributeItem buttonLabel1 = {.string = "NODE_ON_FOCUS_AXIS"};
        Manager::nodeAPI_->setAttribute(button, NODE_BUTTON_LABEL, &buttonLabel1);

        Manager::nodeAPI_->setAttribute(button, NODE_WIDTH, &btnWidthItem);
        Manager::nodeAPI_->setAttribute(button, NODE_HEIGHT, &btnHeightItem);
        Manager::nodeAPI_->setAttribute(button, NODE_MARGIN, &btnMarginItem);
        Manager::nodeAPI_->registerNodeEvent(button, NODE_ON_FOCUS_AXIS, TARGET_ID_14, nullptr);
        Manager::nodeAPI_->addChild(node, button);
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

void AllRegisterNodeEventReceiverOne(int32_t targetId, ArkUI_NodeEvent *event)
{
    switch (targetId) {
        case 0: {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "CreateNativeNode  componentEvent->data[0].i32 == %{public}d", componentEvent->data[0].i32);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "CreateNativeNode  componentEvent->data[1].f32 == %{public}f", componentEvent->data[1].f32);
            break;
        }
        case 1: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  button1 onTouch");
            auto uiEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
            auto result = OH_ArkUI_PointerEvent_SetStopPropagation(uiEvent, true);
            break;
        }
        case TARGET_ID_2: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  column onTouch");
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
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "CreateNativeNode  componentEvent->data[0].i32 == %{public}d", componentEvent->data[0].i32);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "NODE_EVENT_ON_AREA_CHANGE");
            auto uiEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
            auto result = OH_ArkUI_PointerEvent_SetStopPropagation(uiEvent, true);
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
        case TARGET_ID_9: {
            auto text = OH_ArkUI_NodeEvent_GetUserData(event);
            ArkUI_AttributeItem TextItem = {.string = "ARKUI_HIT_TEST_MODE_DEFAULT"};
            Manager::nodeAPI_->setAttribute(static_cast<ArkUI_NodeHandle>(text), NODE_TEXT_CONTENT, &TextItem);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "HitTestMode inner button touched type ARKUI_HIT_TEST_MODE_DEFAULT:  = %{public}p",
                         OH_ArkUI_NodeEvent_GetEventType(event));
            break;
        }
        case TARGET_ID_10: {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_ON_HOVER ,the mouse on the component : %{public}p", componentEvent->data[0].i32);
            break;
        }
        case TARGET_ID_11: {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                         "NODE_ON_MOUSE ,the mouse click or move on the component : %{public}p",
                         componentEvent->data[0].i32);
            break;
        }
        case TARGET_ID_14: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "NODE_ON_FOCUS_AXIS is used");
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

void AllRegisterNodeEventReceiver()
{
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "CreateNativeNode  targetId == %{public}d",
                     targetId);
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
            case TARGET_ID_9:
            case TARGET_ID_10:
            case TARGET_ID_11:
            case TARGET_ID_14:
            case TARGET_ID_15:
            case TARGET_ID_16: {
                AllRegisterNodeEventReceiverThree(targetId, event);
                break;
            }
            case TARGET_ID_17: {
                auto text = OH_ArkUI_NodeEvent_GetUserData(event);
                ArkUI_AttributeItem TextItem = {.string = "ARKUI_HIT_TEST_MODE_BLOCK"};
                Manager::nodeAPI_->setAttribute(static_cast<ArkUI_NodeHandle>(text), NODE_TEXT_CONTENT, &TextItem);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                             "HitTestMode inner button touched type ARKUI_HIT_TEST_MODE_BLOCK:  = %{public}p",
                             OH_ArkUI_NodeEvent_GetEventType(event));
                break;
            }
            default:
                break;
        }
    });
}

void AddAndRemoveUIStates(ArkUI_NodeHandle &buttonControl1)
{
    int32_t targetStates = ArkUI_UIState::UI_STATE_SELECTED | ArkUI_UIState::UI_STATE_PRESSED;
    auto arkUIErrorCode =
        OH_ArkUI_AddSupportedUIStates(buttonControl1, targetStates, StatesChangeHandler, false, nullptr);
    if (arkUIErrorCode) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo", "AddSupportedUIStates errorCode is %{public}d",
                     arkUIErrorCode);
    }
    auto result = OH_ArkUI_RemoveSupportedUIStates(buttonControl1,
                                                   ArkUI_UIState::UI_STATE_SELECTED | ArkUI_UIState::UI_STATE_PRESSED);
    if (result) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "publicInfo",
                     "RemoveSupportedUIStates errorCode is %{public}d", result);
    }
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
        AddAndRemoveUIStates(buttonControl1);
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
    // NODE_HIT_TEST_BEHAVIOR
    CreateNodeHitTestBehavior(column);
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
    // NODE_ON_FOCUS_AXIS
    CreateNodeOnFocusAxis(column);
    // NODE_ON_HOVER_EVENT
    CreateNodeOnHoverEvent(column);
    // NODE_ON_HOVER_MOVE
    CreateNodeOnHoverMove(column);
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