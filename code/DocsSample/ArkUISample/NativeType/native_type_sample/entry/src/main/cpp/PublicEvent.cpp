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

#include <ace/xcomponent/native_interface_xcomponent.h>
#include <arkui/native_animate.h>
#include <arkui/native_gesture.h>
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <cstdio>
#include <sstream>
#include <string>
#include <hilog/log.h>
#include <arkui/drag_and_drop.h>

#include "manager.h"
#include "PublicEvent.h"

const int32_t TARGET_ID_2 = 2;
const int32_t TARGET_ID_3 = 3;
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
const int32_t TARGET_ID_18 = 18;
const int32_t TARGET_ID_19 = 19;
const int32_t TARGET_ID_20 = 20;
const int32_t TARGET_ID_21 = 21;
const float B = 0.95;
const int32_t SRGB = 4;

static bool g_isEnable = true;
OH_PixelmapNative *pixelMap = nullptr;
static int g_num = 0;
static int g_num1 = 0;
ArkUI_NodeHandle buttonFocusMove1 = nullptr;
ArkUI_NodeHandle buttonFocusMove2 = nullptr;
ArkUI_NodeHandle buttonFocusMove3 = nullptr;
ArkUI_NodeHandle buttonFocusMove4 = nullptr;
ArkUI_NodeHandle image2 = nullptr;
ArkUI_AttributeItem NODE_IMAGE_SRC_Item;
ArkUI_SnapshotOptions* options_test = nullptr;
ArkUI_NodeHandle scroll;

void SetWidthPercent(ArkUI_NodeHandle &node, float width)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    ArkUI_NumberValue nodeWidthValue[] = {width};
    ArkUI_AttributeItem nodeWidthItem = {nodeWidthValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &nodeWidthItem);
}

void SetScrollAttribute(ArkUI_NodeHandle &scroll)
{
    if (!Manager::nodeAPI_) {
        return;
    }
    SetWidthPercent(scroll, 1);
    ArkUI_AttributeItem scrollNodeIdItem = {.string = "testScroll"};
    Manager::nodeAPI_->setAttribute(scroll, NODE_ID, &scrollNodeIdItem);
}

ArkUI_NodeHandle CreateStack()
{
    ArkUI_NodeHandle stack = Manager::nodeAPI_->createNode(ARKUI_NODE_STACK);
    SetWidthPercent(stack, B);
    ArkUI_NumberValue marginWidthValue[] = {5};
    ArkUI_AttributeItem marginWidthItem = {marginWidthValue, 1};
    Manager::nodeAPI_->setAttribute(stack, NODE_MARGIN, &marginWidthItem);
    return stack;
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

void SetButtonAttributeTwo(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.75};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {90};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem butItem = {.string = "button150"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &butItem);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
}

void SetButtonAttributeThree(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.25};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {30};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem butItem = {.string = "button50"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &butItem);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
}

void SetHitTest(ArkUI_NodeHandle &node, ArkUI_HitTestMode hitTestMode)
{
    ArkUI_NumberValue hitTestValue[] = {{.i32 = hitTestMode}};
    ArkUI_AttributeItem hitTestItem = {hitTestValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_HIT_TEST_BEHAVIOR, &hitTestItem);
}

void SetTextAttribute(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.75};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
}

void SetButtonAttributeFour(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.45};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {30};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem butItem = {.string = "button inner 3"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &butItem);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
    SetHitTest(node, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(node, NODE_TOUCH_EVENT, TARGET_ID_21, nullptr);
}

void SetButtonAttributeSceneThree(ArkUI_NodeHandle &node)
{
    ArkUI_NumberValue btnWidthValue[] = {0.65};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {30};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);\
    ArkUI_AttributeItem butItem = {.string = "button outer 3"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &butItem);
    Manager::nodeAPI_->registerNodeEvent(node, NODE_TOUCH_EVENT, TARGET_ID_19, nullptr);
}

ArkUI_NodeHandle CreateSceneOne()
{
    auto stack = CreateStack();
    ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttribute(button1);
    ArkUI_AttributeItem btn1TextItem = {.string = "outer button"};
    Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &btn1TextItem);
    Manager::nodeAPI_->registerNodeEvent(button1, NODE_TOUCH_EVENT, TARGET_ID_6, nullptr);
    
    ArkUI_NodeHandle button2 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttribute(button2);
    ArkUI_AttributeItem btn1TextItem2 = {.string = "inner button"};
    Manager::nodeAPI_->setAttribute(button2, NODE_BUTTON_LABEL, &btn1TextItem2);
    Manager::nodeAPI_->registerNodeEvent(button2, NODE_TOUCH_EVENT, TARGET_ID_8, nullptr);

    auto stack2 = CreateStack();
    SetHitTest(stack2, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_BLOCK);
    Manager::nodeAPI_->registerNodeEvent(stack2, NODE_TOUCH_EVENT, TARGET_ID_7, nullptr);
    
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem = {.string = "transparent"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem);
    SetHitTest(text, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(text, NODE_TOUCH_EVENT, TARGET_ID_9, nullptr);

    Manager::nodeAPI_->addChild(stack2, button2);
    Manager::nodeAPI_->addChild(stack, button1);
    Manager::nodeAPI_->addChild(stack, stack2);
    Manager::nodeAPI_->addChild(stack, text);
    return stack;
}

ArkUI_NodeHandle CreateSceneTwo()
{
    auto stack = CreateStack();
    Manager::nodeAPI_->registerNodeEvent(stack, NODE_TOUCH_EVENT, TARGET_ID_10, nullptr);
    auto stack2 = CreateStack();
    Manager::nodeAPI_->registerNodeEvent(stack2, NODE_TOUCH_EVENT, TARGET_ID_11, nullptr);
    ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttribute(button1);
    SetHitTest(button1, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_DEFAULT);
    ArkUI_AttributeItem btn1TextItem = {.string = "outer two button"};
    Manager::nodeAPI_->setAttribute(button1, NODE_BUTTON_LABEL, &btn1TextItem);
    Manager::nodeAPI_->registerNodeEvent(button1, NODE_TOUCH_EVENT, TARGET_ID_12, nullptr);

    auto stack3 = CreateStack();
    SetHitTest(stack3, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_BLOCK_HIERARCHY);
    Manager::nodeAPI_->registerNodeEvent(stack3, NODE_TOUCH_EVENT, TARGET_ID_14, nullptr);
    
    ArkUI_NodeHandle button150 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttributeTwo(button150);
    SetHitTest(button150, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(button150, NODE_TOUCH_EVENT, TARGET_ID_15, nullptr);
    
    ArkUI_NodeHandle button100 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttribute(button100);
    ArkUI_AttributeItem butItem = {.string = "button100"};
    Manager::nodeAPI_->setAttribute(button100, NODE_BUTTON_LABEL, &butItem);
    SetHitTest(button100, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(button100, NODE_TOUCH_EVENT, TARGET_ID_16, nullptr);
    
    ArkUI_NodeHandle button50 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttributeThree(button50);
    SetHitTest(button50, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(button50, NODE_TOUCH_EVENT, TARGET_ID_17, nullptr);

    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "transparent"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    SetHitTest(text, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(text, NODE_TOUCH_EVENT, TARGET_ID_13, nullptr);
    
    Manager::nodeAPI_->addChild(stack3, button150);
    Manager::nodeAPI_->addChild(stack3, button100);
    Manager::nodeAPI_->addChild(stack3, button50);
    Manager::nodeAPI_->addChild(stack2, button1);
    Manager::nodeAPI_->addChild(stack2, stack3);
    Manager::nodeAPI_->addChild(stack2, text);
    Manager::nodeAPI_->addChild(stack, stack2);
    return stack;
}

ArkUI_NodeHandle CreateSceneThree()
{
    auto stack = CreateStack();
    Manager::nodeAPI_->registerNodeEvent(stack, NODE_TOUCH_EVENT, TARGET_ID_18, nullptr);
    
    ArkUI_NodeHandle button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttributeSceneThree(button);
    
    auto stack1 = CreateStack();
    Manager::nodeAPI_->registerNodeEvent(stack1, NODE_TOUCH_EVENT, TARGET_ID_20, nullptr);
    SetHitTest(stack1, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_BLOCK_DESCENDANTS);
    
    ArkUI_NodeHandle button1 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    SetButtonAttributeFour(button1);
    
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    SetTextAttribute(text);
    ArkUI_AttributeItem TextItem1 = {.string = "transparent"};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &TextItem1);
    SetHitTest(text, ArkUI_HitTestMode::ARKUI_HIT_TEST_MODE_TRANSPARENT);
    Manager::nodeAPI_->registerNodeEvent(text, NODE_TOUCH_EVENT, TARGET_ID_13, nullptr);
    
    Manager::nodeAPI_->addChild(stack1, button1);
    Manager::nodeAPI_->addChild(stack, button);
    Manager::nodeAPI_->addChild(stack, stack1);
    Manager::nodeAPI_->addChild(stack, text);
    return stack;
}

ArkUI_NodeHandle SetFocusButtonAttribute1()
{
    auto node = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btnWidthValue[] = {0.40};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {10};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem buttonLabel = {.string = "button1"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
    return node;
}

ArkUI_NodeHandle SetFocusButtonAttribute2()
{
    auto node = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btnWidthValue[] = {0.40};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {10};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem buttonLabel = {.string = "button2"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
    return node;
}

ArkUI_NodeHandle SetFocusButtonAttribute3()
{
    auto node = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btnWidthValue[] = {0.40};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {10};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem buttonLabel = {.string = "button3"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
    return node;
}

ArkUI_NodeHandle SetFocusButtonAttribute4()
{
    auto node = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue btnWidthValue[] = {0.40};
    ArkUI_AttributeItem btnWidthItem = {btnWidthValue, 1};
    ArkUI_NumberValue btnHeightValue[] = {60};
    ArkUI_AttributeItem btnHeightItem = {btnHeightValue, 1};
    ArkUI_NumberValue btnMarginValue[] = {10};
    ArkUI_AttributeItem btnMarginItem = {btnMarginValue, 1};
    ArkUI_AttributeItem buttonLabel = {.string = "button4"};
    Manager::nodeAPI_->setAttribute(node, NODE_BUTTON_LABEL, &buttonLabel);
    Manager::nodeAPI_->setAttribute(node, NODE_WIDTH_PERCENT, &btnWidthItem);
    Manager::nodeAPI_->setAttribute(node, NODE_HEIGHT, &btnHeightItem);
    Manager::nodeAPI_->setAttribute(node, NODE_MARGIN, &btnMarginItem);
    return node;
}

ArkUI_NodeHandle CreateRow()
{
    ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    SetWidthPercent(row, B);
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(row, NODE_BORDER_WIDTH, &borderWidthItem);
    return row;
}


ArkUI_NodeHandle CreateRowSpace()
{
    ArkUI_NodeHandle row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue nodeHeightValue[] = {20};
    ArkUI_AttributeItem nodeHeightItem = {nodeHeightValue, 1};
    Manager::nodeAPI_->setAttribute(row, NODE_HEIGHT, &nodeHeightItem);
    return row;
}

void MoveFocus(ArkUI_NodeHandle &node1, ArkUI_NodeHandle &node2, ArkUI_FocusMove focusMove)
{
    if (focusMove == ARKUI_FOCUS_MOVE_FORWARD) {
        ArkUI_NumberValue directionValue[] = {{.i32 = 0}};
        ArkUI_AttributeItem nextFocusItem = {.value = directionValue, .size = 1, .object = node2};
        Manager::nodeAPI_->setAttribute(node1, NODE_NEXT_FOCUS, &nextFocusItem);
    } else if (focusMove == ARKUI_FOCUS_MOVE_BACKWARD) {
        ArkUI_NumberValue directionValue1[] = {{.i32 = 1}};
        ArkUI_AttributeItem nextFocusItem1 = {.value = directionValue1, .size = 1, .object = buttonFocusMove2};
        Manager::nodeAPI_->setAttribute(buttonFocusMove4, NODE_NEXT_FOCUS, &nextFocusItem1);
    } else if (focusMove == ARKUI_FOCUS_MOVE_UP) {
        ArkUI_NumberValue directionValue2[] = {{.i32 = 2}};
        ArkUI_AttributeItem nextFocusItem2 = {.value = directionValue2, .size = 1, .object = buttonFocusMove1};
        Manager::nodeAPI_->setAttribute(buttonFocusMove4, NODE_NEXT_FOCUS, &nextFocusItem2);
    } else if (focusMove == ARKUI_FOCUS_MOVE_DOWN) {
        ArkUI_NumberValue directionValue3[] = {{.i32 = 3}};
        ArkUI_AttributeItem nextFocusItem3 = {.value = directionValue3, .size = 1, .object = buttonFocusMove3};
        Manager::nodeAPI_->setAttribute(buttonFocusMove3, NODE_NEXT_FOCUS, &nextFocusItem3);
    } else if (focusMove == ARKUI_FOCUS_MOVE_LEFT) {
        ArkUI_NumberValue directionValue4[] = {{.i32 = 4}};
        ArkUI_AttributeItem nextFocusItem4 = {.value = directionValue4, .size = 1, .object = buttonFocusMove4};
        Manager::nodeAPI_->setAttribute(buttonFocusMove3, NODE_NEXT_FOCUS, &nextFocusItem4);
    } else if (focusMove == ARKUI_FOCUS_MOVE_RIGHT) {
        ArkUI_NumberValue directionValue5[] = {{.i32 = 5}};
        ArkUI_AttributeItem nextFocusItem5 = {.value = directionValue5, .size = 1, .object = buttonFocusMove3};
        Manager::nodeAPI_->setAttribute(buttonFocusMove4, NODE_NEXT_FOCUS, &nextFocusItem5);
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Focus", "set attribute failed");
    }
}

void FocusMoveDemo(ArkUI_NodeHandle &node)
{
    auto text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    std::string str =
        "走焦设置：\n button1 tab -> button4  \n button4 shift+tab -> button2 \n "
        "button4 方向上键 -> button1 \n button3 方向下键 -> button3 \n button3 方向左键 -> button4 \n button4 "
        "方向右键 -> button3";
    ArkUI_AttributeItem contentItem = {.string = str.c_str()};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &contentItem);
    auto row1 = CreateRow();
    buttonFocusMove1 = SetFocusButtonAttribute1();
    buttonFocusMove2 = SetFocusButtonAttribute2();
    auto rowSpace = CreateRowSpace();
    auto row2 = CreateRow();
    buttonFocusMove3 = SetFocusButtonAttribute3();
    buttonFocusMove4 = SetFocusButtonAttribute4();
    
    MoveFocus(buttonFocusMove1, buttonFocusMove4, ARKUI_FOCUS_MOVE_FORWARD);
    MoveFocus(buttonFocusMove4, buttonFocusMove2, ARKUI_FOCUS_MOVE_BACKWARD);
    MoveFocus(buttonFocusMove4, buttonFocusMove1, ARKUI_FOCUS_MOVE_UP);
    MoveFocus(buttonFocusMove3, buttonFocusMove3, ARKUI_FOCUS_MOVE_DOWN);
    MoveFocus(buttonFocusMove3, buttonFocusMove4, ARKUI_FOCUS_MOVE_LEFT);
    MoveFocus(buttonFocusMove4, buttonFocusMove3, ARKUI_FOCUS_MOVE_RIGHT);
    Manager::nodeAPI_->registerNodeEvent(buttonFocusMove1, NODE_ON_FOCUS, TARGET_ID_3, nullptr);
    Manager::nodeAPI_->addChild(node, text);
    Manager::nodeAPI_->addChild(row1, buttonFocusMove1);
    Manager::nodeAPI_->addChild(row1, buttonFocusMove2);
    Manager::nodeAPI_->addChild(row2, buttonFocusMove3);
    Manager::nodeAPI_->addChild(row2, buttonFocusMove4);
    Manager::nodeAPI_->addChild(node, row1);
    Manager::nodeAPI_->addChild(node, rowSpace);
    Manager::nodeAPI_->addChild(node, row2);
}

void TargetIdTwo()
{
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "C-api test demo create gs button1");
    auto options_test = OH_ArkUI_CreateSnapshotOptions();
    auto scale = 0.5;
    OH_ArkUI_SnapshotOptions_SetScale(options_test, scale);
    auto setColorModeResult = OH_ArkUI_SnapshotOptions_SetColorMode(options_test, SRGB, false);
    if (ARKUI_ERROR_CODE_NO_ERROR == setColorModeResult) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ComponentSnapshot",
            "C-api test demo set color mode success!");
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
            "C-api test demo set color mode error, result is %{public}d", setColorModeResult);
    }
    auto setDynamicRangeModeResult = OH_ArkUI_SnapshotOptions_SetDynamicRangeMode(
        options_test, ARKUI_DYNAMIC_RANGE_MODE_STANDARD, false);
    if (ARKUI_ERROR_CODE_NO_ERROR == setDynamicRangeModeResult) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "ComponentSnapshot",
            "C-api test demo set dynamic range mode success!");
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
            "C-api test demo set dynamic range mode error, result is %{public}d", setDynamicRangeModeResult);
    }
    auto options_test1 = OH_ArkUI_GetNodeSnapshot(scroll, options_test, &pixelMap);
    if (options_test1 == ARKUI_ERROR_CODE_COMPONENT_SNAPSHOT_TIMEOUT) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot",
            "C-api test demo create pixelmap error, result is %{public}d", options_test1);
    }
    auto drawable = OH_ArkUI_DrawableDescriptor_CreateFromPixelMap(pixelMap);
    ArkUI_AttributeItem NODE_IMAGE2_SRC_Item = {.object = drawable};
    Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_SRC, &NODE_IMAGE2_SRC_Item);
    OH_PixelmapNative_Release(pixelMap);
}

void TargetIdFive()
{
    OH_ArkUI_DestroySnapshotOptions(options_test);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "ComponentSnapshot", "Snapshot destroy");
    Manager::nodeAPI_->resetAttribute(image2, NODE_IMAGE_SRC);
}

void HitTestModeRegisterThree(int32_t targetId)
{
    if (targetId == TARGET_ID_18) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "grandfather3 stack touch default");
    } else if (targetId == TARGET_ID_19) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button outer 3 touch default");
    } else if (targetId == TARGET_ID_20) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button outer 3 touch block descendants");
    } else {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button outer 3 touch block default");
    }
}

void HitTestModeRegisterTwo(int32_t targetId)
{
    if (targetId == TARGET_ID_10) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "grandfather stack touch default");
    } else if (targetId == TARGET_ID_11) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "father stack touch default");
    } else if (targetId == TARGET_ID_12) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "outer two button touch default");
    } else if (targetId == TARGET_ID_13) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "text touch transparent");
    } else if (targetId == TARGET_ID_14) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "stack touch block hierarchy");
    } else if (targetId == TARGET_ID_15) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button150 touch transparent");
    } else if (targetId == TARGET_ID_16) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button100 touch transparent");
    } else if (targetId == TARGET_ID_17) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "button50 touch transparent");
    } else {
        HitTestModeRegisterThree(targetId);
    }
}

void HitTestModeRegister(int32_t targetId)
{
    if (targetId == TARGET_ID_6) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "outer button touch default");
    } else if (targetId == TARGET_ID_7) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "stack touch block");
    } else if (targetId == TARGET_ID_8) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "inner button touch default");
    } else if (targetId == TARGET_ID_9) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "HitTestMode", "text touch transparent");
    } else {
        HitTestModeRegisterTwo(targetId);
    }
}

void AllRegisterNodeEventReceiver()
{
    Manager::nodeAPI_->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        auto targetId = OH_ArkUI_NodeEvent_GetTargetId(event);
        switch (eventType) {
            case NODE_ON_CLICK: {
                switch (targetId) {
                    case TARGET_ID_2: {
                        TargetIdTwo();
                        break;
                    }
                    case TARGET_ID_5: {
                        TargetIdFive();
                        break;
                    }
                    default:
                        break;
                }
            }
            case NODE_ON_FOCUS: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Focus", "button1 on focus");
                break;
            }
            case NODE_TOUCH_EVENT: {
                HitTestModeRegister(targetId);
                break;
            }
            default:
                break;
        }
    });
}

void SnapshotOptionsDemo(ArkUI_NodeHandle &touchEvent)
{
    auto button = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item = {.string = "截图"};
    Manager::nodeAPI_->setAttribute(button, NODE_BUTTON_LABEL, &LABEL_Item);
    Manager::nodeAPI_->addChild(touchEvent, button);
    auto button3 = Manager::nodeAPI_->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item3 = {.string = "销毁截图选项"};
    Manager::nodeAPI_->setAttribute(button3, NODE_BUTTON_LABEL, &LABEL_Item3);
    Manager::nodeAPI_->addChild(touchEvent, button3);

    Manager::nodeAPI_->registerNodeEvent(button, NODE_ON_CLICK, TARGET_ID_2, nullptr);
    Manager::nodeAPI_->registerNodeEvent(button3, NODE_ON_CLICK, TARGET_ID_5, nullptr);
    
    auto row = Manager::nodeAPI_->createNode(ARKUI_NODE_ROW);
    ArkUI_NumberValue imageWidthValue[] = {B};
    ArkUI_AttributeItem imageWidthItem = {imageWidthValue, 1};
    ArkUI_NumberValue imageHeightValue[] = {300};
    ArkUI_AttributeItem imageHeightItem = {imageHeightValue, 1};
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};

    ArkUI_AttributeItem attributeItem = {};
    ArkUI_NumberValue numberValue = {};
    numberValue.i32 = static_cast<int32_t>(ArkUI_ObjectFit::ARKUI_OBJECT_FIT_NONE);
    attributeItem.value = &numberValue;
    attributeItem.size = 1;
    image2 = Manager::nodeAPI_->createNode(ARKUI_NODE_IMAGE);
    Manager::nodeAPI_->setAttribute(image2, NODE_BORDER_WIDTH, &borderWidthItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_WIDTH_PERCENT, &imageWidthItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_HEIGHT, &imageHeightItem);
    Manager::nodeAPI_->setAttribute(image2, NODE_IMAGE_OBJECT_FIT, &attributeItem);
    Manager::nodeAPI_->addChild(row, image2);
    
    Manager::nodeAPI_->addChild(touchEvent, row);
    AllRegisterNodeEventReceiver();
}

void AddColumnChild(ArkUI_NodeHandle &column)
{
    ArkUI_NumberValue borderWidthValue[] = {2};
    ArkUI_AttributeItem borderWidthItem = {borderWidthValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_BORDER_WIDTH, &borderWidthItem);
    SetWidthPercent(column, 1);
    ArkUI_NumberValue marginWidthValue[] = {5};
    ArkUI_AttributeItem marginWidthItem = {marginWidthValue, 1};
    Manager::nodeAPI_->setAttribute(column, NODE_MARGIN, &marginWidthItem);
}

void AddScrollChild(ArkUI_NodeHandle &scroll)
{
    ArkUI_NodeHandle column1 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    AddColumnChild(column1);
    ArkUI_NodeHandle column2 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    SetWidthPercent(column2, B);
    ArkUI_NodeHandle column3 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    AddColumnChild(column3);
    ArkUI_NodeHandle column4 = Manager::nodeAPI_->createNode(ARKUI_NODE_COLUMN);
    AddColumnChild(column4);
    
    ArkUI_NodeHandle stack1 = CreateSceneOne();
    ArkUI_NodeHandle text = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    std::string str = "触摸测试Block和Transparent ";
    ArkUI_AttributeItem contentItem = {.string = str.c_str()};
    Manager::nodeAPI_->setAttribute(text, NODE_TEXT_CONTENT, &contentItem);
    
    ArkUI_NodeHandle stack2 = CreateSceneTwo();
    ArkUI_NodeHandle text2 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    std::string str2 = "触摸测试Block_hierarchy ";
    ArkUI_AttributeItem contentItem2 = {.string = str2.c_str()};
    Manager::nodeAPI_->setAttribute(text2, NODE_TEXT_CONTENT, &contentItem2);
    
    ArkUI_NodeHandle stack3 = CreateSceneThree();
    ArkUI_NodeHandle text3 = Manager::nodeAPI_->createNode(ARKUI_NODE_TEXT);
    std::string str3 = "触摸测试block_descendants ";
    ArkUI_AttributeItem contentItem3 = {.string = str3.c_str()};
    Manager::nodeAPI_->setAttribute(text3, NODE_TEXT_CONTENT, &contentItem3);
    
    FocusMoveDemo(column4);
    SnapshotOptionsDemo(column3);
    Manager::nodeAPI_->addChild(column1, text);
    Manager::nodeAPI_->addChild(column1, stack1);
    Manager::nodeAPI_->addChild(column1, text2);
    Manager::nodeAPI_->addChild(column1, stack2);
    Manager::nodeAPI_->addChild(column1, text3);
    Manager::nodeAPI_->addChild(column1, stack3);
    Manager::nodeAPI_->addChild(column2, column4);
    Manager::nodeAPI_->addChild(column2, column3);
    Manager::nodeAPI_->addChild(column2, column1);
    Manager::nodeAPI_->addChild(scroll, column2);
}

ArkUI_NodeHandle PublicMaker::CreateNativeNode()
{
    if (!Manager::nodeAPI_) {
        return nullptr;
    }
    // 创建父子滚动容器
    scroll = Manager::nodeAPI_->createNode(ARKUI_NODE_SCROLL);
    // 设置属性
    SetScrollAttribute(scroll);
    AddScrollChild(scroll);
    return scroll;
}