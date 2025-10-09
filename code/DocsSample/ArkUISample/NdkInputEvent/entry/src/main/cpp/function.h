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

#ifndef NDKINPUTEVENT_FUNCTION_H
#define NDKINPUTEVENT_FUNCTION_H

#include "common.h"
#include "container.h"
#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <hilog/log.h>

namespace NativeXComponentSample {

ArkUI_NodeHandle column1;
ArkUI_NodeHandle infoText = nullptr;
ArkUI_NodeHandle titleText = nullptr;

void PrintMultiHistoryInfos(ArkUI_UIInputEvent* inputEvent, uint32_t pointerIndex)
{
    auto size = OH_ArkUI_PointerEvent_GetHistorySize(inputEvent);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
        "%{public}d: historySize = %{public}d", pointerIndex, size);
    for (int historyIndex = 0; historyIndex < size; historyIndex++) {
        auto time = OH_ArkUI_PointerEvent_GetHistoryEventTime(inputEvent, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyEventTime = %{public}ld", time);
        auto pointerCount = OH_ArkUI_PointerEvent_GetHistoryPointerCount(inputEvent, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyPointerCount = %{public}d", pointerCount);
        auto pointerId = OH_ArkUI_PointerEvent_GetHistoryPointerId(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyPointerId = %{public}d", pointerId);
        auto historyX = OH_ArkUI_PointerEvent_GetHistoryX(inputEvent, pointerIndex, historyIndex);
        auto historyY = OH_ArkUI_PointerEvent_GetHistoryY(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyX/Y = %{public}f/%{public}f", historyX, historyY);
        auto historyWindowX = OH_ArkUI_PointerEvent_GetHistoryWindowX(inputEvent, pointerIndex, historyIndex);
        auto historyWindowY = OH_ArkUI_PointerEvent_GetHistoryWindowY(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyWindowX/Y = %{public}f/%{public}f", historyWindowX, historyWindowY);
        auto historyDisplayX = OH_ArkUI_PointerEvent_GetHistoryDisplayX(inputEvent, pointerIndex, historyIndex);
        auto historyDisplayY = OH_ArkUI_PointerEvent_GetHistoryDisplayY(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyDisplayX/Y = %{public}f/%{public}f", historyDisplayX, historyDisplayY);
        auto historyGlobalDisplayX = OH_ArkUI_PointerEvent_GetHistoryGlobalDisplayX(inputEvent,
            pointerIndex, historyIndex);
        auto historyGlobalDisplayY = OH_ArkUI_PointerEvent_GetHistoryGlobalDisplayY(inputEvent,
            pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyGlobalDisplayX/Y = %{public}f/%{public}f", historyGlobalDisplayX, historyGlobalDisplayY);
        auto historyPressure = OH_ArkUI_PointerEvent_GetHistoryPressure(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyPressure = %{public}f", historyPressure);
        auto historyTiltX = OH_ArkUI_PointerEvent_GetHistoryTiltX(inputEvent, pointerIndex, historyIndex);
        auto historyTiltY = OH_ArkUI_PointerEvent_GetHistoryTiltY(inputEvent, pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyTiltX/Y = %{public}f/%{public}f", historyTiltX, historyTiltY);
        auto historyTouchAreaWidth = OH_ArkUI_PointerEvent_GetHistoryTouchAreaWidth(inputEvent,
            pointerIndex, historyIndex);
        auto historyTouchAreaHeight = OH_ArkUI_PointerEvent_GetHistoryTouchAreaHeight(inputEvent,
            pointerIndex, historyIndex);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "historyTouchAreaWidth/Height = %{public}f/%{public}f", historyTouchAreaWidth, historyTouchAreaHeight);
    }
}

void ShowMultiInfos(ArkUI_UIInputEvent* inputEvent)
{
    g_ss.str("");
    uint32_t pointerIndex = 0;
    OH_ArkUI_PointerEvent_GetChangedPointerId(inputEvent, &pointerIndex);
    g_ss << "pointerIndex: " << pointerIndex << std::endl;
    auto id = OH_ArkUI_PointerEvent_GetPointerId(inputEvent, pointerIndex);
    g_ss << "pointerId: " << id << std::endl;
    auto pressedTime = OH_ArkUI_PointerEvent_GetPressedTimeByIndex(inputEvent, pointerIndex);
    g_ss << "pressedTime: " << pressedTime << std::endl;
    auto x = OH_ArkUI_PointerEvent_GetXByIndex(inputEvent, pointerIndex);
    auto y = OH_ArkUI_PointerEvent_GetYByIndex(inputEvent, pointerIndex);
    g_ss << "x/y: " << x << "/" << y << std::endl;
    auto windowX = OH_ArkUI_PointerEvent_GetWindowXByIndex(inputEvent, pointerIndex);
    auto windowY = OH_ArkUI_PointerEvent_GetWindowYByIndex(inputEvent, pointerIndex);
    g_ss << "windowX/Y: " << windowX << "/" << windowY << std::endl;
    auto displayX = OH_ArkUI_PointerEvent_GetDisplayXByIndex(inputEvent, pointerIndex);
    auto displayY = OH_ArkUI_PointerEvent_GetDisplayYByIndex(inputEvent, pointerIndex);
    g_ss << "displayX/Y: " << displayX << "/" << displayY << std::endl;
    auto globalDisplayX = OH_ArkUI_PointerEvent_GetGlobalDisplayXByIndex(inputEvent, pointerIndex);
    auto globalDisplayY = OH_ArkUI_PointerEvent_GetGlobalDisplayYByIndex(inputEvent, pointerIndex);
    g_ss << "globalDisplayX/Y: " << globalDisplayX << "/" << globalDisplayY << std::endl;
    auto pressure = OH_ArkUI_PointerEvent_GetPressure(inputEvent, pointerIndex);
    g_ss << "pressure: " << pressure << std::endl;
    auto tiltX = OH_ArkUI_PointerEvent_GetTiltX(inputEvent, pointerIndex);
    auto tiltY = OH_ArkUI_PointerEvent_GetTiltY(inputEvent, pointerIndex);
    g_ss << "tiltX/Y: " << tiltX << "/" << tiltY << std::endl;
    ArkUI_InteractionHand hand;
    OH_ArkUI_PointerEvent_GetInteractionHandByIndex(inputEvent, pointerIndex, &hand);
    if (hand == ARKUI_EVENT_HAND_LEFT) {
        g_ss << "hand: LEFT" << std::endl;
    } else if (hand == ARKUI_EVENT_HAND_RIGHT) {
        g_ss << "hand: RIGHT" << std::endl;
    } else {
        g_ss << "hand: NONE" << std::endl;
    }
    auto touchAreaWidth = OH_ArkUI_PointerEvent_GetTouchAreaWidth(inputEvent, pointerIndex);
    auto touchAreaHeight = OH_ArkUI_PointerEvent_GetTouchAreaHeight(inputEvent, pointerIndex);
    g_ss << "touchAreaWidth/Height: " << touchAreaWidth << "/" << touchAreaHeight << std::endl;
    SetText(infoText, g_ss.str().c_str(), TEXT_FONT_SIZE_15);
    PrintMultiHistoryInfos(inputEvent, pointerIndex);
}

void ShowSimplePosInfo(ArkUI_UIInputEvent *inputEvent)
{
    auto x = OH_ArkUI_PointerEvent_GetX(inputEvent);
    auto y = OH_ArkUI_PointerEvent_GetY(inputEvent);
    g_ss << "x/y: " << x << "/" << y << std::endl;
    auto windowX = OH_ArkUI_PointerEvent_GetWindowX(inputEvent);
    auto windowY = OH_ArkUI_PointerEvent_GetWindowY(inputEvent);
    g_ss << "windowX/Y: " << windowX << "/" << windowY << std::endl;
    auto displayX = OH_ArkUI_PointerEvent_GetDisplayX(inputEvent);
    auto displayY = OH_ArkUI_PointerEvent_GetDisplayY(inputEvent);
    g_ss << "displayX/Y: " << displayX << "/" << displayY << std::endl;
    auto globalDisplayX = OH_ArkUI_PointerEvent_GetGlobalDisplayX(inputEvent);
    auto globalDisplayY = OH_ArkUI_PointerEvent_GetGlobalDisplayY(inputEvent);
    g_ss << "globalDisplayX/Y: " << globalDisplayX << "/" << globalDisplayY << std::endl;
}

void ShowSimpleTarInfo(ArkUI_UIInputEvent *inputEvent)
{
    auto targetWidth = OH_ArkUI_UIInputEvent_GetEventTargetWidth(inputEvent);
    g_ss << "targetWidth: " << targetWidth << std::endl;
    auto targetHeight = OH_ArkUI_UIInputEvent_GetEventTargetHeight(inputEvent);
    g_ss << "targetHeight: " << targetHeight << std::endl;
    auto positionX = OH_ArkUI_UIInputEvent_GetEventTargetPositionX(inputEvent);
    auto positionY = OH_ArkUI_UIInputEvent_GetEventTargetPositionY(inputEvent);
    g_ss << "targetPositionX/Y: " << positionX << "/" << positionY << std::endl;
    auto globalPositionX = OH_ArkUI_UIInputEvent_GetEventTargetGlobalPositionX(inputEvent);
    auto globalPositionY = OH_ArkUI_UIInputEvent_GetEventTargetGlobalPositionY(inputEvent);
    g_ss << "targetGlobalPositionX/Y: " << globalPositionX << "/" << globalPositionY << std::endl;
}

void ShowSimpleInfo(ArkUI_UIInputEvent* inputEvent)
{
    g_ss.str("");
    auto displayId = OH_ArkUI_UIInputEvent_GetTargetDisplayId(inputEvent);
    g_ss << "displayId: " << displayId << std::endl;
    auto eventTime = OH_ArkUI_UIInputEvent_GetEventTime(inputEvent);
    g_ss << "eventTime: " << eventTime << std::endl;
    // 触摸事件位置信息
    ShowSimplePosInfo(inputEvent);
    // 手指触摸事件显示信息
    auto type = OH_ArkUI_UIInputEvent_GetToolType(inputEvent);
    if (type == UI_INPUT_EVENT_TOOL_TYPE_FINGER) {
        ArkUI_InteractionHand hand;
        OH_ArkUI_PointerEvent_GetInteractionHand(inputEvent, &hand);
        if (hand == ARKUI_EVENT_HAND_LEFT) {
            g_ss << "hand: LEFT" << std::endl;
        } else if (hand == ARKUI_EVENT_HAND_RIGHT) {
            g_ss << "hand: RIGHT" << std::endl;
        } else {
            g_ss << "hand: NONE" << std::endl;
        }
    } else if (type == UI_INPUT_EVENT_TOOL_TYPE_PEN) {
        double rollAngle = 0;
        OH_ArkUI_PointerEvent_GetRollAngle(inputEvent, &rollAngle);
        g_ss << "rollAngle: " << rollAngle << std::endl;
    }
    // 命中组件信息
    ShowSimpleTarInfo(inputEvent);
    SetText(infoText, g_ss.str().c_str(), TEXT_FONT_SIZE_15);
}

void PrintClonedEventInfos(ArkUI_UIInputEvent* inputEvent, ArkUI_UIInputEvent* clonedEvent)
{
    float x = 0;
    float y = 0;
    OH_ArkUI_PointerEvent_SetClonedEventLocalPosition(clonedEvent, x, y);
    OH_ArkUI_PointerEvent_SetClonedEventActionType(clonedEvent, UI_TOUCH_EVENT_ACTION_DOWN);
    OH_ArkUI_PointerEvent_SetClonedEventChangedFingerId(clonedEvent, 0);
    if (OH_ArkUI_UIInputEvent_GetLatestStatus() == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_ArkUI_PointerEvent_PostClonedEvent(column1, clonedEvent);
    }
}

void PrintMultiClonedEventInfos(ArkUI_UIInputEvent* clonedEvent)
{
    float x = 0;
    float y = 0;
    OH_ArkUI_PointerEvent_SetClonedEventLocalPositionByIndex(clonedEvent, x, y, 0);
    OH_ArkUI_PointerEvent_SetClonedEventActionType(clonedEvent, UI_TOUCH_EVENT_ACTION_DOWN);
    OH_ArkUI_PointerEvent_SetClonedEventFingerIdByIndex(clonedEvent, 0, 0);
    if (OH_ArkUI_UIInputEvent_GetLatestStatus() == ARKUI_ERROR_CODE_NO_ERROR) {
        OH_ArkUI_PointerEvent_PostClonedEvent(column1, clonedEvent);
    }
}

void BgEventReceiver(ArkUI_NodeHandle& node)
{
    nodeAPI->registerNodeEvent(node, NODE_TOUCH_EVENT, 1, &node);
    nodeAPI->registerNodeEvent(node, NODE_ON_AXIS, 1, &node);
    nodeAPI->addNodeEventReceiver(node, [](ArkUI_NodeEvent *event) {
        ArkUI_NodeHandle *node = (ArkUI_NodeHandle *)OH_ArkUI_NodeEvent_GetUserData(event);
        SetBackgroundColor(*node, 0xFFFFFF00);
    });
}

void TouchEventOperator(ArkUI_UIInputEvent* inputEvent, ArkUI_NodeHandle* button)
{
    auto count = OH_ArkUI_PointerEvent_GetPointerCount(inputEvent);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
        "pointerCount = %{public}d", count);
    if (OH_ArkUI_UIInputEvent_GetSourceType(inputEvent) != UI_INPUT_EVENT_SOURCE_TYPE_TOUCH_SCREEN) {
        return;
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
        "ARKUI_UIINPUTEVENT_TYPE_TOUCH EventReceiver");
    OH_ArkUI_PointerEvent_SetStopPropagation(inputEvent, true);
    ArkUI_UIInputEvent* clonedEvent = nullptr;
    OH_ArkUI_PointerEvent_CreateClonedEvent(inputEvent, &clonedEvent);
    switch (OH_ArkUI_UIInputEvent_GetAction(inputEvent)) {
        case UI_TOUCH_EVENT_ACTION_DOWN: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                "UI_TOUCH_EVENT_ACTION_DOWN EventReceiver");
            SetText(titleText, "");
            if (count == 1) {
                SetBackgroundColor(*button, 0xFFFF0000);
                PrintClonedEventInfos(inputEvent, clonedEvent);
            } else if (count > 1) {
                SetBackgroundColor(*button, 0xFF932F60);
                PrintMultiClonedEventInfos(clonedEvent);
            }
            break;
        }
        case UI_TOUCH_EVENT_ACTION_MOVE: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                "UI_TOUCH_EVENT_ACTION_MOVE EventReceiver");
            if (count == 1) {
                ShowSimpleInfo(inputEvent);
            } else if (count > 1) {
                ShowMultiInfos(inputEvent);
            }
            break;
        }
        case UI_TOUCH_EVENT_ACTION_UP: {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                "UI_TOUCH_EVENT_ACTION_UP EventReceiver");
            SetBackgroundColor(*button, 0xFF0000FF);
            SetBackgroundColor(column1, 0xFFF6F6F6);
            OH_ArkUI_PointerEvent_DestroyClonedEvent(clonedEvent);
            break;
        }
        default: {
            break;
        }
    }
}

void ShowAxisInfos(ArkUI_UIInputEvent* inputEvent)
{
    g_ss.str("");
    auto verticalAxisValue = OH_ArkUI_AxisEvent_GetVerticalAxisValue(inputEvent);
    g_ss << "verticalAxisValue: " << verticalAxisValue << std::endl;
    auto horizontalAxisValue = OH_ArkUI_AxisEvent_GetHorizontalAxisValue(inputEvent);
    g_ss << "horizontalAxisValue: " << horizontalAxisValue << std::endl;
    auto pinchAxisScaleValue = OH_ArkUI_AxisEvent_GetPinchAxisScaleValue(inputEvent);
    g_ss << "pinchAxisScaleValue: " << pinchAxisScaleValue << std::endl;
    auto scrollStep = OH_ArkUI_AxisEvent_GetScrollStep(inputEvent);
    g_ss << "scrollStep: " << scrollStep << std::endl;
    SetText(infoText, g_ss.str().c_str(), TEXT_FONT_SIZE_20);
}

void AxisEventOperator(ArkUI_UIInputEvent* inputEvent)
{
    auto toolType = OH_ArkUI_UIInputEvent_GetToolType(inputEvent);
    if (toolType == UI_INPUT_EVENT_TOOL_TYPE_TOUCHPAD) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "ARKUI_UIINPUTEVENT_TYPE_AXIS EventReceiver");
        OH_ArkUI_AxisEvent_SetPropagation(inputEvent, false);
        auto action = OH_ArkUI_AxisEvent_GetAxisAction(inputEvent);
        switch (action) {
            case UI_AXIS_EVENT_ACTION_BEGIN: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_AXIS_EVENT_ACTION_BEGIN EventReceiver");
                break;
            }
            case UI_AXIS_EVENT_ACTION_UPDATE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_AXIS_EVENT_ACTION_UPDATE EventReceiver");
                ShowAxisInfos(inputEvent);
                break;
            }
            case UI_AXIS_EVENT_ACTION_END: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_AXIS_EVENT_ACTION_END EventReceiver");
                SetBackgroundColor(column1, 0xFFF6F6F6);
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_AXIS_EVENT_ACTION_UNKNOWN EventReceiver");
                break;
            }
        }
    }
}

void MouseEventOperator(ArkUI_UIInputEvent* inputEvent, ArkUI_NodeHandle *button)
{
    OH_ArkUI_PointerEvent_SetInterceptHitTestMode(inputEvent, HTM_DEFAULT);
    auto toolType = OH_ArkUI_UIInputEvent_GetToolType(inputEvent);
    if (toolType == UI_INPUT_EVENT_TOOL_TYPE_MOUSE) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "ARKUI_UIINPUTEVENT_TYPE_MOUSE EventReceiver");
        auto action = OH_ArkUI_MouseEvent_GetMouseAction(inputEvent);
        auto mouseButton = OH_ArkUI_MouseEvent_GetMouseButton(inputEvent);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest", "MOUSE BUTTON %{public}d", mouseButton);
        if (action == UI_MOUSE_EVENT_ACTION_PRESS && mouseButton == UI_MOUSE_EVENT_BUTTON_MIDDLE) {
            return;
        }
        switch (action) {
            case UI_MOUSE_EVENT_ACTION_PRESS: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_MOUSE_EVENT_ACTION_PRESS EventReceiver");
                SetBackgroundColor(*button, 0xFFFF0000);
                break;
            }
            case UI_MOUSE_EVENT_ACTION_MOVE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_MOUSE_EVENT_ACTION_MOVE EventReceiver");
                g_ss.str("");
                auto rawDeltaX = OH_ArkUI_MouseEvent_GetRawDeltaX(inputEvent);
                auto rawDeltaY = OH_ArkUI_MouseEvent_GetRawDeltaY(inputEvent);
                g_ss << "rawDeltaX: " << rawDeltaX << std::endl << "rawDeltaY: " << rawDeltaY << std::endl;
                SetText(infoText, g_ss.str().c_str(), TEXT_FONT_SIZE_20);
                break;
            }
            case UI_MOUSE_EVENT_ACTION_RELEASE: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_MOUSE_EVENT_ACTION_RELEASE EventReceiver");
                SetBackgroundColor(*button, 0xFF0000FF);
                SetBackgroundColor(column1, 0xFFF6F6F6);
                break;
            }
            default: {
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                    "UI_MOUSE_EVENT_ACTION_UNKNOWN EventReceiver");
                break;
            }
        }
    }
}

void KeyEventOperator(ArkUI_UIInputEvent* inputEvent)
{
    auto type = OH_ArkUI_KeyEvent_GetType(inputEvent);
    if (type == ARKUI_KEY_EVENT_DOWN) {
        int32_t pressedKeyCodes[BUTTON_LENGTH] = {};
        int32_t length = BUTTON_LENGTH;
        OH_ArkUI_UIInputEvent_GetPressedKeys(inputEvent, pressedKeyCodes, &length);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "pressedKeyCodes = %{public}d", pressedKeyCodes[0]);
        auto deviceId = OH_ArkUI_UIInputEvent_GetDeviceId(inputEvent);
        uint64_t keys = 0;
        OH_ArkUI_UIInputEvent_GetModifierKeyStates(inputEvent, &keys);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
            "deviceId = %{public}d, keys = %{public}lu", deviceId, keys);
    }
}

void BtEventReceiver(ArkUI_NodeHandle& button)
{
    nodeAPI->registerNodeEvent(button, NODE_TOUCH_EVENT, 1, &button);
    nodeAPI->registerNodeEvent(button, NODE_ON_AXIS, 1, &button);
    nodeAPI->registerNodeEvent(button, NODE_ON_MOUSE, 1, &button);
    nodeAPI->registerNodeEvent(button, NODE_ON_HOVER_EVENT, 1, &button);
    nodeAPI->registerNodeEvent(button, NODE_ON_KEY_EVENT, 1, &button);
    nodeAPI->addNodeEventReceiver(button, [](ArkUI_NodeEvent *event) {
        auto *inputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        auto eventType = OH_ArkUI_UIInputEvent_GetType(inputEvent);
        ArkUI_NodeHandle *button = (ArkUI_NodeHandle *)OH_ArkUI_NodeEvent_GetUserData(event);
        if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_HOVER_EVENT) {
            auto isHovered = OH_ArkUI_HoverEvent_IsHovered(inputEvent);
            if (isHovered) {
                SetBackgroundColor(*button, 0xFF009F40);
            } else {
                SetBackgroundColor(*button, 0xFF0000FF);
            }
        } else if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_FOCUS_AXIS) {
            OH_ArkUI_FocusAxisEvent_SetStopPropagation(inputEvent, true);
            auto abs_x = OH_ArkUI_FocusAxisEvent_GetAxisValue(inputEvent, UI_FOCUS_AXIS_EVENT_ABS_X);
            auto abs_y = OH_ArkUI_FocusAxisEvent_GetAxisValue(inputEvent, UI_FOCUS_AXIS_EVENT_ABS_Y);
            auto abs_z = OH_ArkUI_FocusAxisEvent_GetAxisValue(inputEvent, UI_FOCUS_AXIS_EVENT_ABS_Z);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "inputTest",
                "abs_x/abs_y/abs_z = %{public}f/%{public}f/%{public}f", abs_x, abs_y, abs_z);
        } else if (OH_ArkUI_NodeEvent_GetEventType(event) == NODE_ON_KEY_EVENT) {
            KeyEventOperator(inputEvent);
        }
        if (eventType == ARKUI_UIINPUTEVENT_TYPE_TOUCH) {
            TouchEventOperator(inputEvent, button);
        } else if (eventType == ARKUI_UIINPUTEVENT_TYPE_AXIS) {
            AxisEventOperator(inputEvent);
        } else if (eventType == ARKUI_UIINPUTEVENT_TYPE_MOUSE) {
            // 鼠标按键数
            int32_t pressedButtons[BUTTON_LENGTH] = {};
            int32_t length;
            OH_ArkUI_MouseEvent_GetPressedButtons(inputEvent, pressedButtons, &length);
            g_ss.str("");
            g_ss << "PressedButtonCount: " << length << std::endl;
            SetText(titleText, g_ss.str().c_str(), TEXT_FONT_SIZE_20);
            MouseEventOperator(inputEvent, button);
        }
    });
}

void FirstModule(ArkUI_NodeHandle &root)
{
    column1 = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetId(column1, "bg");
    SetWidthPercent(column1, 1);
    SetHeightPercent(column1, 1);
    SetColumnJustifyContent(column1, ARKUI_FLEX_ALIGNMENT_START);
    SetColumnAlignItem(column1, ARKUI_HORIZONTAL_ALIGNMENT_CENTER);
    SetPadding(column1, BLANK_10);
    BgEventReceiver(column1);
    
    static auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetId(button, "bt");
    SetButtonLabel(button, "输入事件测试按键");
    SetWidthPercent(button, 1);
    SetHeight(button, SIZE_200);
    SetBackgroundColor(button, 0xFF0000FF);
    ArkUI_NumberValue enable[] = {1};
    ArkUI_AttributeItem focusableItem = {enable, 1};
    nodeAPI->setAttribute(button, NODE_FOCUSABLE, &focusableItem);
    BtEventReceiver(button);
    nodeAPI->addChild(column1, button);
    
    auto blank = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetHeight(blank, BLANK_10);
    nodeAPI->addChild(column1, blank);
    
    titleText = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetId(titleText, "title");
    nodeAPI->addChild(column1, titleText);
    
    infoText = nodeAPI->createNode(ARKUI_NODE_TEXT);
    SetId(infoText, "info");
    nodeAPI->addChild(column1, infoText);
    
    nodeAPI->addChild(root, column1);
}

} // namespace NativeXComponentSample

#endif // NDKINPUTEVENT_FUNCTION_H