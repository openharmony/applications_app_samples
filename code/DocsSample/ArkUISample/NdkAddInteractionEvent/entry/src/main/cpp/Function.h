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

#ifndef NDKCOMPONENTLISTEN_FUNCTION_H
#define NDKCOMPONENTLISTEN_FUNCTION_H

#include "Common.h"

#include <arkui/native_key_event.h>
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <cstdint>
#include <arkui/native_gesture.h>
#include <arkui/native_interface.h>
#include <hilog/log.h>

namespace NativeModule {

const unsigned int WIDTH_SIZE = 200;
const unsigned int GINGERS_NUM_1 = 1;
const unsigned int NUMBER_10 = 10;
const unsigned int DURATION_NUM_100 = 100;
const unsigned int DURATION_NUM_1000 = 1000;
const unsigned int HEIGHT_50 = 50;
const unsigned int HEIGHT_70 = 70;
const float PERCENT_WIDTH = 0.3f;
const float PERCENT_HEIGHT = 0.3f;
const float PERCENT_HEIGHT_5 = 0.5f;
const unsigned int COUNT_NUM_1 = 1;
const unsigned int DISTANCE_NUM_1 = 1;
const unsigned int SPEED_NUM_50 = 50;
const unsigned int LOG_PRINT_DOMAIN = 0xF811;
const unsigned int ITEM_SIZE_ONE = 1;
const unsigned int ITEM_SIZE_TWO = 2;
const unsigned int HEIGHT_SIZE = 200;
const unsigned int GINGERS_NUM = 1;
const unsigned int DURATION_NUM = 5;
const unsigned int ITEM_SIZE_FIVE = 5;
const unsigned int DURATION_NUM_500 = 500;
const unsigned int LOOP_SIZE = 30;
const unsigned int FONT_SIZE = 16;
const float PERCENT_WIDTH_1 = 1;
const float PERCENT_HEIGHT_1 = 1;

// [Start shade_change_event]
struct ColorModeInfo {
    const char* lightMsg;
    const char* darkMsg;
};

// 注册回调函数
void onColorModeChange(ArkUI_SystemColorMode colorMode, void *userData)
{
    ColorModeInfo* info = static_cast<ColorModeInfo*>(userData);
    if (colorMode == ARKUI_SYSTEM_COLOR_MODE_LIGHT) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_Light mode: ", info->lightMsg);
    } else if (colorMode == ARKUI_SYSTEM_COLOR_MODE_DARK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_Dark mode: ", info->darkMsg);
    }
}

ArkUI_NodeHandle testColorModeChange(ArkUI_NativeNodeAPI_1 *nodeAPI) {
    ArkUI_NodeHandle text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    static ColorModeInfo info = {"Light mode", "Dark mode"};
    OH_ArkUI_RegisterSystemColorModeChangeEvent(text, &info, onColorModeChange);

    ArkUI_AttributeItem itemstring = {nullptr, 0, ("test_light_dark")};
    nodeAPI->setAttribute(text, NODE_TEXT_CONTENT, &itemstring);

    return text;
}
// [End shade_change_event]
// [Start node_event_receiver]
void NodeEventReceiver(ArkUI_NodeEvent *event) {
  // 设置对应的事件类型触发时进行的操作，如NODE_ON_CLICK_EVENT
};
// [End node_event_receiver]
void FirstModule(ArkUI_NodeHandle &root)
{
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetId(column, "bg");
    SetWidthPercent(column, PERCENT_WIDTH);
    SetHeightPercent(column, PERCENT_HEIGHT);
    // [Start create_and_register_node]
    auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    nodeAPI->addNodeEventReceiver(button, NodeEventReceiver);
    nodeAPI->registerNodeEvent(button, NODE_ON_CLICK_EVENT, 0, nullptr);
    // [End create_and_register_node]
    SetWidthPercent(button, BORDER_WIDTH_1);
    SetHeight(button, HEIGHT_50);
    SetButtonLabel(button, "test");
    nodeAPI->addChild(column, button);
    
    // [Start get_event_information]
    // 注册click事件
    nodeAPI->registerNodeEvent(button, NODE_ON_CLICK_EVENT, 0, nullptr);
    // 设置组件事件的全局监听
    // [Start register_global_event]
    nodeAPI->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        // 从组件事件中获取基础事件对象
        auto *inputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        // 从组件事件获取事件类型
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
        // [StartExclude register_global_event]
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfo inputEvent = %{public}p", inputEvent);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfo eventType = %{public}d", eventType);
        auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        // 获取组件事件中的数字类型数据
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfo componentEvent = %{public}p", componentEvent);
        // 获取触发该事件的组件对象
        auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfo nodeHandle = %{public}p", nodeHandle);
        // 根据eventType来区分事件类型，进行差异化处理，其他获取事件信息的接口也可类似方式来进行差异化的处理
        // [EndExclude register_global_event]
        switch (eventType) {
            case NODE_ON_CLICK_EVENT: {
                // 触发点击事件所进行的操作，从基础事件获取事件信息
                // [StartExclude register_global_event]
                auto x = OH_ArkUI_PointerEvent_GetX(inputEvent);
                auto y = OH_ArkUI_PointerEvent_GetY(inputEvent);
                auto displayX = OH_ArkUI_PointerEvent_GetDisplayX(inputEvent);
                auto displayY = OH_ArkUI_PointerEvent_GetDisplayY(inputEvent);
                auto windowX = OH_ArkUI_PointerEvent_GetWindowX(inputEvent);
                auto windowY = OH_ArkUI_PointerEvent_GetWindowY(inputEvent);
                auto pointerCount = OH_ArkUI_PointerEvent_GetPointerCount(inputEvent);
                auto xByIndex = OH_ArkUI_PointerEvent_GetXByIndex(inputEvent, 0);
                auto yByIndex = OH_ArkUI_PointerEvent_GetYByIndex(inputEvent, 0);
                auto displayXByIndex = OH_ArkUI_PointerEvent_GetDisplayXByIndex(inputEvent, 0);
                auto displayYByIndex = OH_ArkUI_PointerEvent_GetDisplayYByIndex(inputEvent, 0);
                auto windowXByIndex = OH_ArkUI_PointerEvent_GetWindowXByIndex(inputEvent, 0);
                auto windowYByIndex = OH_ArkUI_PointerEvent_GetWindowYByIndex(inputEvent, 0);
                auto pointerId = OH_ArkUI_PointerEvent_GetPointerId(inputEvent, 0);
                auto pressure = OH_ArkUI_PointerEvent_GetPressure(inputEvent, 0);
                auto action = OH_ArkUI_UIInputEvent_GetAction(inputEvent);
                auto eventTime = OH_ArkUI_UIInputEvent_GetEventTime(inputEvent);
                auto sourceType = OH_ArkUI_UIInputEvent_GetSourceType(inputEvent);
                auto type = OH_ArkUI_UIInputEvent_GetType(inputEvent);
                std::string eventInfo =
                    "x: " + std::to_string(x) + ", y: " + std::to_string(y) +
                    ", displayX: " + std::to_string(displayX) + ", displayY: " + std::to_string(displayY) +
                    ", windowX: " + std::to_string(windowX) + ", windowY: " + std::to_string(windowY) +
                    ", pointerCount: " + std::to_string(pointerCount) + ", xByIndex: " + std::to_string(xByIndex) +
                    ", yByIndex: " + std::to_string(yByIndex) +
                    ", displayXByIndex: " + std::to_string(displayXByIndex) +
                    ", displayYByIndex: " + std::to_string(displayYByIndex) +
                    ", windowXByIndex: " + std::to_string(windowXByIndex) +
                    ", windowYByIndex: " + std::to_string(windowYByIndex) +
                    ", pointerId: " + std::to_string(pointerId) + ", pressure: " + std::to_string(pressure) +
                    ", action: " + std::to_string(action) + ", eventTime: " + std::to_string(eventTime) +
                    ", sourceType: " + std::to_string(sourceType) + ", type: " + std::to_string(type);
                OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                             "NdkAddInteractionEvent_eventInfoOfCommonEvent eventInfo = %{public}s",
                             eventInfo.c_str());
                break;
                // [EndExclude register_global_event]
            }
            default: {
                break;
            }
        }
    });
    // [End register_global_event]
    // [End get_event_information]
    nodeAPI->addChild(root, column);
}

void SecondModule(ArkUI_NodeHandle &root)
{
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetId(column, "bg1");
    SetWidthPercent(column, PERCENT_WIDTH);
    SetHeightPercent(column, PERCENT_HEIGHT);
    
    auto text = testColorModeChange(nodeAPI);
    nodeAPI->addChild(column, text);
    nodeAPI->addChild(root, column);
}

void ThirdModule(ArkUI_NodeHandle &root)
{
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetId(column, "bg2");
    SetWidthPercent(column, PERCENT_WIDTH);
    SetHeightPercent(column, PERCENT_HEIGHT_5);
    
    auto button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    SetWidthPercent(button, BORDER_WIDTH_1);
    SetHeight(button, HEIGHT_70);
    SetButtonLabel(button, "test_unregister");
    
    // [Start unregister_node_event_receicer]
    nodeAPI->unregisterNodeEventReceiver();
    // [End unregister_node_event_receicer]
    // [Start unregister_node_event]
    nodeAPI->unregisterNodeEvent(button, NODE_ON_CLICK_EVENT);
    // [End unregister_node_event]
    // [Start remove_node_evect_receiver]
    nodeAPI->removeNodeEventReceiver(button, NodeEventReceiver);
    // [End remove_node_evect_receiver]
    nodeAPI->addChild(column, button);
    nodeAPI->addChild(root, column);
}

ArkUI_GestureRecognizer* CreateTapGesture()
{
    // [Start create_tap_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建点击手势
    auto tapGesture = gestureApi->createTapGesture(1, 1);
    // [End create_tap_gesture]
    return tapGesture;
}

ArkUI_GestureRecognizer* CreatePanGesture()
{
    // [Start create_pan_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建滑动手势
    auto panGesture = gestureApi->createPanGesture(1, GESTURE_DIRECTION_ALL, 1);
    // [End create_pan_gesture]
    return panGesture;
}

ArkUI_GestureRecognizer* CreateLongPressGesture()
{
    // [Start create_long_press_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建长按手势
    // DURATION_NUM_1000 = 1000
    auto longPressGesture = gestureApi->createLongPressGesture(1, true, DURATION_NUM_1000);
    // [End create_long_press_gesture]
    return longPressGesture;
}

ArkUI_GestureRecognizer* CreatePinchGesture()
{
    // [Start create_pinch_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建捏合手势
    // NUMBER_10 = 10
    auto pinchGesture = gestureApi->createPinchGesture(1, NUMBER_10);
    // [End create_pinch_gesture]
    return pinchGesture;
}

ArkUI_GestureRecognizer* CreateRotationGesture()
{
    // [Start create_rotation_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建旋转手势
    // NUMBER_10 = 10
    auto rotationGesture = gestureApi->createRotationGesture(1, NUMBER_10);
    // [End create_rotation_gesture]
    return rotationGesture;
}

ArkUI_GestureRecognizer* CreateSwiperGesture()
{
    // [Start create_swiper_gesture]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建快滑手势
    // SPEED_NUM_50 = 50
    auto swipeGesture = gestureApi->createSwipeGesture(1, GESTURE_DIRECTION_ALL, SPEED_NUM_50);
    // [End create_swiper_gesture]
    return swipeGesture;
}

void GetEventsForGesture(ArkUI_NodeHandle &columnNode)
{
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    // 设置背景色
    ArkUI_NumberValue value[] = {{.u32 = 0xff445566}};
    ArkUI_AttributeItem item = {value, 1};
    nodeAPI->setAttribute(column, NODE_BACKGROUND_COLOR, &item);
    // 设置宽度
    ArkUI_NumberValue widthValue[] = {{DURATION_NUM_100}};
    ArkUI_AttributeItem width = {widthValue, 1};
    nodeAPI->setAttribute(column, NODE_WIDTH, &width);
    // 设置高度
    ArkUI_NumberValue heightValue[] = {{DURATION_NUM_100}};
    ArkUI_AttributeItem height = {heightValue, 1};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &height);
    nodeAPI->addChild(columnNode, column);

    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // [Start gesture_callback]
    // 设置回调，在触发手势事件时执行回调处理手势事件
    auto onActionCallback = [](ArkUI_GestureEvent *event, void *extraParams) {
        // 从手势事件获取基础事件对象
        auto *inputEvent = OH_ArkUI_GestureEvent_GetRawInputEvent(event);
        // 从基础事件获取事件信息
        auto x = OH_ArkUI_PointerEvent_GetX(inputEvent);
        auto y = OH_ArkUI_PointerEvent_GetY(inputEvent);
        auto displayX = OH_ArkUI_PointerEvent_GetDisplayX(inputEvent);
        auto displayY = OH_ArkUI_PointerEvent_GetDisplayY(inputEvent);
        auto windowX = OH_ArkUI_PointerEvent_GetWindowX(inputEvent);
        auto windowY = OH_ArkUI_PointerEvent_GetWindowY(inputEvent);
        auto pointerCount = OH_ArkUI_PointerEvent_GetPointerCount(inputEvent);
        auto xByIndex = OH_ArkUI_PointerEvent_GetXByIndex(inputEvent, 0);
        auto yByIndex = OH_ArkUI_PointerEvent_GetYByIndex(inputEvent, 0);
        auto displayXByIndex = OH_ArkUI_PointerEvent_GetDisplayXByIndex(inputEvent, 0);
        auto displayYByIndex = OH_ArkUI_PointerEvent_GetDisplayYByIndex(inputEvent, 0);
        auto windowXByIndex = OH_ArkUI_PointerEvent_GetWindowXByIndex(inputEvent, 0);
        auto windowYByIndex = OH_ArkUI_PointerEvent_GetWindowYByIndex(inputEvent, 0);
        auto pointerId = OH_ArkUI_PointerEvent_GetPointerId(inputEvent, 0);
        auto pressure = OH_ArkUI_PointerEvent_GetPressure(inputEvent, 0);
        auto action = OH_ArkUI_UIInputEvent_GetAction(inputEvent);
        auto eventTime = OH_ArkUI_UIInputEvent_GetEventTime(inputEvent);
        auto sourceType = OH_ArkUI_UIInputEvent_GetSourceType(inputEvent);
        auto type = OH_ArkUI_UIInputEvent_GetType(inputEvent);
        std::string eventInfo =
            "x: " + std::to_string(x) + ", y: " + std::to_string(y) +
            ", displayX: " + std::to_string(displayX) + ", displayY: " + std::to_string(displayY) +
            ", windowX: " + std::to_string(windowX) + ", windowY: " + std::to_string(windowY) + "\n" +
            ", pointerCount: " + std::to_string(pointerCount) + ", xByIndex: " + std::to_string(xByIndex) +
            ", yByIndex: " + std::to_string(yByIndex) +
            ", displayXByIndex: " + std::to_string(displayXByIndex) +
            ", displayYByIndex: " + std::to_string(displayYByIndex) +
            ", windowXByIndex: " + std::to_string(windowXByIndex) +
            ", windowYByIndex: " + std::to_string(windowYByIndex) + "\n" +
            ", pointerId: " + std::to_string(pointerId) + ", pressure: " + std::to_string(pressure) +
            ", action: " + std::to_string(action) + ", eventTime: " + std::to_string(eventTime) +
            ", sourceType: " + std::to_string(sourceType) + ", type: " + std::to_string(type);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfoOfCommonEvent eventInfo = %{public}s", eventInfo.c_str());
    };
    // 创建一个单指点击手势
    auto TapGesture = gestureApi->createTapGesture(COUNT_NUM_1, GINGERS_NUM_1);
    // 将事件回调绑定到TapGesture上，触发手势后，通过回调函数处理手势事件
    gestureApi->setGestureEventTarget(TapGesture,
                                      GESTURE_EVENT_ACTION_ACCEPT | GESTURE_EVENT_ACTION_UPDATE |
                                      GESTURE_EVENT_ACTION_END | GESTURE_EVENT_ACTION_CANCEL,
                                      column, onActionCallback);
    // 将手势添加到column组件上，使column组件可以触发单指点击手势
    gestureApi->addGestureToNode(column, TapGesture, ArkUI_GesturePriority::PARALLEL,
                                 ArkUI_GestureMask::NORMAL_GESTURE_MASK);
    // [End gesture_callback]
    nodeAPI->addChild(columnNode, column);
}

void FirstModuleForGesture(ArkUI_NodeHandle &root)
{
    auto columnNode = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    SetId(columnNode, "bg");
    SetWidthPercent(columnNode, GINGERS_NUM_1);
    SetHeightPercent(columnNode, GINGERS_NUM_1);
    
    // [Start create_column]
    // 创建Column节点
    auto column = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    // 设置背景色
    ArkUI_NumberValue value[] = {{.u32 = 0xff112233}};
    ArkUI_AttributeItem item = {value, 1};
    nodeAPI->setAttribute(column, NODE_BACKGROUND_COLOR, &item);
    // 设置宽度
    ArkUI_NumberValue widthValue[] = {{400}};
    ArkUI_AttributeItem width = {widthValue, 1};
    nodeAPI->setAttribute(column, NODE_WIDTH, &width);
    // 设置高度
    ArkUI_NumberValue heightValue[] = {{400}};
    ArkUI_AttributeItem height = {heightValue, 1};
    nodeAPI->setAttribute(column, NODE_HEIGHT, &height);
    // [End create_column]
    // [Start create_long_press]
    // 获取手势Native接口集合
    auto gestureApi = reinterpret_cast<ArkUI_NativeGestureAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_GESTURE, "ArkUI_NativeGestureAPI_1"));
    // 创建长按手势
    auto longPressGesture = gestureApi->createLongPressGesture(1, true, DURATION_NUM_1000);
    // [End create_long_press]
    // [Start bind_event]
    auto onActionCallBack = [](ArkUI_GestureEvent *event, void *extraParam) {
        // 回调内容
        // [StartExclude bind_event]
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
                     "NdkAddInteractionEvent_eventInfo componentEvent longPressGesture");
        // [EndExclude bind_event]
    };

    // 将手势设置到组件上
    gestureApi->setGestureEventTarget(
        longPressGesture, GESTURE_EVENT_ACTION_ACCEPT | GESTURE_EVENT_ACTION_UPDATE | GESTURE_EVENT_ACTION_END, column,
        onActionCallBack);

    gestureApi->addGestureToNode(column, longPressGesture, PARALLEL, NORMAL_GESTURE_MASK);
    // [End bind_event]
    // [Start create_custom_gestures]
    auto onInterruptCallback = [](ArkUI_GestureInterruptInfo *info) -> ArkUI_GestureInterruptResult {
        // 获取是否系统手势
        auto sysTag = OH_ArkUI_GestureInterruptInfo_GetSystemFlag(info);
        // 获取拦截的手势指针
        auto recognizer = OH_ArkUI_GestureInterruptInfo_GetRecognizer(info);
        // 获取系统手势类型
        auto systemRecognizerType = OH_ArkUI_GestureInterruptInfo_GetSystemRecognizerType(info);
        // 获取手势事件
        auto gestureEvent = OH_ArkUI_GestureInterruptInfo_GetGestureEvent(info);
        auto inputEvent = OH_ArkUI_GestureEvent_GetRawInputEvent(gestureEvent);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[Sample_NdkAddInteractionEvent]",
            "NdkAddInteractionEvent_eventInfo longPressGesture");
        if (sysTag) {
            // 如果是系统手势则不拦截
            return GESTURE_INTERRUPT_RESULT_CONTINUE;
        } else {
            // 不是系统手势则拒绝
            return GESTURE_INTERRUPT_RESULT_REJECT;
        }
    };
    // [End create_custom_gestures]
    // [Start bind_gestures]
    gestureApi->setGestureInterrupterToNode(column, onInterruptCallback);
    // [End bind_gestures]
    nodeAPI->addChild(columnNode, column);
    
    GetEventsForGesture(columnNode);

    nodeAPI->addChild(root, columnNode);
}

} // namespace NativeXComponentSample

#endif // NDKCOMPONENTLISTEN_FUNCTION_H
