/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start Cpp_NormalNodeExample]
// NormalNodeExample.h
// 添加交互事件示例
#ifndef MYAPPLICATION_NORMALNODEEXAMPLE_H
#define MYAPPLICATION_NORMALNODEEXAMPLE_H

#include "ArkUIColumnNode.h"
#include "ArkUIButtonNode.h"
#include "ArkUITextInputNode.h"
#include "ArkUITextNode.h"
#include "NativeModule.h"
#include <arkui/native_key_event.h>
#include <arkui/ui_input_event.h>
#include <hilog/log.h>
#include <string>

#define DEFAULT_BLANK 20
#define DEFAULT_COMPONENT_HEIGHT 50.0f
#define DEFAULT_FONT_SIZE 16.0f
#define DEFAULT_SPACING 10.0f
#define DEFAULT_RADIUS 20.0f

namespace NativeModule {

#define LOG_PRINT_DOMAIN 0x0001

// 创建Button组件
std::shared_ptr<ArkUIButtonNode> CreateButtonComponent()
{
    auto button = std::make_shared<ArkUIButtonNode>();
    button->SetPercentWidth(1.0f);
    button->SetHeight(DEFAULT_COMPONENT_HEIGHT);
    button->SetLabel("test click");
    button->SetMargin(DEFAULT_BLANK, 0, DEFAULT_BLANK, 0);
    return button;
}

// 创建TextInput组件
std::shared_ptr<ArkUITextInputNode> CreateTextInputComponent()
{
    auto textInput = std::make_shared<ArkUITextInputNode>();
    textInput->SetPercentWidth(1.0f);
    textInput->SetHeight(DEFAULT_COMPONENT_HEIGHT);
    textInput->SetPlaceholder("test focus/blur/key");
    textInput->SetMargin(0, 0, DEFAULT_BLANK, 0);
    return textInput;
}

// 创建悬停区域Column组件
std::shared_ptr<ArkUIColumnNode> CreateHoverColumnComponent()
{
    auto hoverColumn = std::make_shared<ArkUIColumnNode>();
    hoverColumn->SetPercentWidth(1.0f);
    hoverColumn->SetHeight(DEFAULT_COMPONENT_HEIGHT);
    hoverColumn->SetBackgroundColor(0xFFF5F5F5);
    hoverColumn->SetBorderRadius(DEFAULT_RADIUS);

    auto hoverText = std::make_shared<ArkUITextNode>();
    hoverText->SetTextContent("test hover/mouse");
    hoverText->SetFontSize(DEFAULT_FONT_SIZE);
    hoverColumn->AddChild(hoverText);

    return hoverColumn;
}

// [Start handle_event_functions]
// 处理点击事件
void HandleClickEvent(ArkUI_NodeEvent *event, ArkUI_UIInputEvent *inputEvent)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Click event triggered (eventType=%{public}d)", eventType);

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

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "ClickEvent: %{public}s", eventInfo.c_str());
}

// 处理焦点事件
void HandleFocusEvent(ArkUI_NodeEvent *event)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Focus event triggered (eventType=%{public}d)", eventType);
    auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "FocusEvent: nodeHandle=%{public}p", nodeHandle);
}

// 处理失焦事件
void HandleBlurEvent(ArkUI_NodeEvent *event)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Blur event triggered (eventType=%{public}d)", eventType);
    auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "BlurEvent: nodeHandle=%{public}p", nodeHandle);
}

// 处理悬停事件
void HandleHoverEvent(ArkUI_NodeEvent *event, ArkUI_UIInputEvent *inputEvent)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Hover event triggered (eventType=%{public}d)", eventType);
    auto x = OH_ArkUI_PointerEvent_GetX(inputEvent);
    auto y = OH_ArkUI_PointerEvent_GetY(inputEvent);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "HoverEvent: x=%{public}f, y=%{public}f", x, y);
}

// 处理键盘事件
void HandleKeyEvent(ArkUI_NodeEvent *event, ArkUI_UIInputEvent *inputEvent)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Key event triggered (eventType=%{public}d)", eventType);

    // 获取按键键码
    auto keyCode = OH_ArkUI_KeyEvent_GetKeyCode(inputEvent);
    // 获取按键类型
    auto keyType = OH_ArkUI_KeyEvent_GetType(inputEvent);
    // 获取按键键值
    const char *keyText = OH_ArkUI_KeyEvent_GetKeyText(inputEvent);
    // 获取Unicode码值
    auto unicode = OH_ArkUI_KeyEvent_GetUnicode(inputEvent);
    // 获取按键动作
    auto action = OH_ArkUI_UIInputEvent_GetAction(inputEvent);

    // 获取CapsLock状态
    bool capsLockOn = false;
    auto capsLockResult = OH_ArkUI_KeyEvent_IsCapsLockOn(inputEvent, &capsLockOn);

    std::string keyInfo = "keyCode: " + std::to_string(keyCode) +
        ", keyType: " + std::to_string(keyType) +
        ", keyText: " + (keyText ? keyText : "null") +
        ", unicode: " + std::to_string(unicode) +
        ", action: " + std::to_string(action) +
        ", capsLock: " + (capsLockOn ? "ON" : "OFF");

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "KeyEvent: %{public}s", keyInfo.c_str());
}

// 处理鼠标事件
void HandleMouseEvent(ArkUI_NodeEvent *event, ArkUI_UIInputEvent *inputEvent)
{
    auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "Mouse event triggered (eventType=%{public}d)", eventType);

    // 获取坐标信息
    auto x = OH_ArkUI_PointerEvent_GetX(inputEvent);
    auto y = OH_ArkUI_PointerEvent_GetY(inputEvent);
    // 获取鼠标按键类型
    auto mouseButton = OH_ArkUI_MouseEvent_GetMouseButton(inputEvent);
    // 获取鼠标动作类型
    auto mouseAction = OH_ArkUI_MouseEvent_GetMouseAction(inputEvent);
    // 获取鼠标移动增量
    auto deltaX = OH_ArkUI_MouseEvent_GetRawDeltaX(inputEvent);
    auto deltaY = OH_ArkUI_MouseEvent_GetRawDeltaY(inputEvent);
    // 获取事件时间
    auto eventTime = OH_ArkUI_UIInputEvent_GetEventTime(inputEvent);

    std::string mouseInfo = "x: " + std::to_string(x) +
        ", y: " + std::to_string(y) +
        ", button: " + std::to_string(mouseButton) +
        ", action: " + std::to_string(mouseAction) +
        ", deltaX: " + std::to_string(deltaX) +
        ", deltaY: " + std::to_string(deltaY) +
        ", eventTime: " + std::to_string(eventTime);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                 "MouseEvent: %{public}s", mouseInfo.c_str());
}
// [End handle_event_functions]

// [Start register_node_events]
// 注册节点事件
void RegisterNodeEvents(ArkUI_NativeNodeAPI_1 *nodeAPI,
                        std::shared_ptr<ArkUIButtonNode> button,
                        std::shared_ptr<ArkUITextInputNode> textInput,
                        std::shared_ptr<ArkUIColumnNode> hoverColumn)
{
    // 注册点击事件
    nodeAPI->registerNodeEvent(button->GetHandle(), NODE_ON_CLICK_EVENT, 0, nullptr);
    // 注册焦点事件
    nodeAPI->registerNodeEvent(textInput->GetHandle(), NODE_ON_FOCUS, 0, nullptr);
    // 注册失焦事件
    nodeAPI->registerNodeEvent(textInput->GetHandle(), NODE_ON_BLUR, 0, nullptr);
    // 注册悬停事件
    nodeAPI->registerNodeEvent(hoverColumn->GetHandle(), NODE_ON_HOVER_EVENT, 0, nullptr);
    // 注册键盘事件
    nodeAPI->registerNodeEvent(textInput->GetHandle(), NODE_ON_KEY_EVENT, 0, nullptr);
    // 注册鼠标事件
    nodeAPI->registerNodeEvent(hoverColumn->GetHandle(), NODE_ON_MOUSE, 0, nullptr);
}
// [End register_node_events]

// [Start register_global_event_receiver]
// 注册全局事件监听器
void RegisterGlobalEventReceiver(ArkUI_NativeNodeAPI_1 *nodeAPI)
{
    nodeAPI->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto *inputEvent = OH_ArkUI_NodeEvent_GetInputEvent(event);
        auto eventType = OH_ArkUI_NodeEvent_GetEventType(event);

        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                     "Event received: eventType=%{public}d", eventType);

        auto nodeHandle = OH_ArkUI_NodeEvent_GetNodeHandle(event);
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "[InteractionEventExample]",
                     "NodeHandle: nodeHandle=%{public}p", nodeHandle);

        switch (eventType) {
            case NODE_ON_CLICK_EVENT:
                HandleClickEvent(event, inputEvent);
                break;
            case NODE_ON_FOCUS:
                HandleFocusEvent(event);
                break;
            case NODE_ON_BLUR:
                HandleBlurEvent(event);
                break;
            case NODE_ON_HOVER_EVENT:
                HandleHoverEvent(event, inputEvent);
                break;
            case NODE_ON_KEY_EVENT:
                HandleKeyEvent(event, inputEvent);
                break;
            case NODE_ON_MOUSE:
                HandleMouseEvent(event, inputEvent);
                break;
            default:
                break;
        }
    });
}
// [End register_global_event_receiver]

// 创建交互事件示例
std::shared_ptr<ArkUIBaseNode> CreateExample()
{
    auto *nodeAPI = NativeModuleInstance::GetInstance()->GetNativeNodeAPI();

    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetPercentWidth(1.0f);
    column->SetPercentHeight(1.0f);

    // 创建Button组件用于注册点击事件
    auto button = CreateButtonComponent();
    column->AddChild(button);

    // 创建TextInput组件用于注册焦点、失焦、键盘事件
    auto textInput = CreateTextInputComponent();
    column->AddChild(textInput);

    // 创建Column组件用于注册悬停、鼠标事件
    auto hoverColumn = CreateHoverColumnComponent();
    column->AddChild(hoverColumn);

    // 注册各组件的节点事件
    RegisterNodeEvents(nodeAPI, button, textInput, hoverColumn);

    // 设置全局事件监听器
    RegisterGlobalEventReceiver(nodeAPI);

    return column;
}

} // namespace NativeModule

#endif // MYAPPLICATION_NORMALNODEEXAMPLE_H
// [End Cpp_NormalNodeExample]