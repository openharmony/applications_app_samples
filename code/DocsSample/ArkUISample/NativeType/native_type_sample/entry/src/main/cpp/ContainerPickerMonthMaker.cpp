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

#include "ContainerPickerMonthMaker.h"

#include <functional>
#include <memory>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== 配置常量 =====
constexpr int32_t K_MONTH_COUNT = 12;
constexpr float K_PICKER_WIDTH_RATIO = 0.7f;
constexpr int32_t K_FONT_SIZE = 20;
constexpr uint32_t K_FONT_COLOR = 0xFF000000;
constexpr bool K_CAN_LOOP = true;
constexpr bool K_HAPTIC_FEEDBACK = false;
// ===== 事件ID常量 =====
constexpr int32_t K_EVENT_ON_CHANGE = 1000;
constexpr int32_t K_EVENT_ON_SCROLL_STOP = 1001;
} // namespace

// ---------- 全局状态 ----------
static std::shared_ptr<std::vector<std::string>> g_monthData;

// ---------- 生成月份数据 ----------
static std::vector<std::string> MakeMonthData()
{
    std::vector<std::string> data;
    for (int i = 1; i <= K_MONTH_COUNT; i++) {
        data.push_back(std::to_string(i) + "月");
    }
    return data;
}

// ---------- 创建Picker选项 ----------
static ArkUI_NodeHandle CreatePickerOption(ArkUI_NativeNodeAPI_1 *api, const std::string &data)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = data.c_str()};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue fontSizeValue = {.f32 = K_FONT_SIZE};
    ArkUI_AttributeItem fontSizeItem = {&fontSizeValue, sizeof(fontSizeValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_NumberValue colorValue = {.u32 = K_FONT_COLOR};
    ArkUI_AttributeItem colorItem = {&colorValue, sizeof(colorValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_FONT_COLOR, &colorItem);
    return textNode;
}

// ---------- 配置 Picker ----------
static void ConfigurePicker(const std::shared_ptr<ContainerPickerMonthMaker> &picker,
                            const std::shared_ptr<std::vector<std::string>> &data)
{
    if (!picker || !picker->GetHandle()) {
        return;
    }
    picker->SetPickerWidthPercent(K_PICKER_WIDTH_RATIO);
    picker->SetCanLoop(K_CAN_LOOP);
    picker->SetHapticFeedback(K_HAPTIC_FEEDBACK);
    picker->SetSelectionIndicatorDivider(0xFF0000FF, 2.0f, 20.0f, 20.0f);
    ArkUI_NativeNodeAPI_1 *api = picker->GetNodeAPI();
    if (api && data) {
        for (size_t i = 0; i < data->size(); ++i) {
            ArkUI_NodeHandle textNode = CreatePickerOption(api, (*data)[i]);
            if (textNode != nullptr) {
                api->addChild(picker->GetHandle(), textNode);
            }
        }
    }
}

// ---------- 构建 Picker ----------
static std::shared_ptr<ContainerPickerMonthMaker> BuildPicker()
{
    auto picker = std::make_shared<ContainerPickerMonthMaker>();
    g_monthData = std::make_shared<std::vector<std::string>>(MakeMonthData());
    ConfigurePicker(picker, g_monthData);
    return picker;
}

// ---------- 事件回调函数 ----------
static void OnPickerChange(ArkUI_NodeEvent *event)
{
    if (event == nullptr || !g_monthData) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    if (selectedIndex >= 0 && selectedIndex < static_cast<int32_t>(g_monthData->size())) {
        printf("Picker item changed: %s\n", (*g_monthData)[selectedIndex].c_str());
    }
}

static void OnPickerScrollStop(ArkUI_NodeEvent *event)
{
    if (event == nullptr || !g_monthData) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    if (selectedIndex >= 0 && selectedIndex < static_cast<int32_t>(g_monthData->size())) {
        printf("Picker scroll stopped: %s\n", (*g_monthData)[selectedIndex].c_str());
    }
}

// ---------- 全局事件接收器 ----------
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    switch (eventId) {
        case K_EVENT_ON_CHANGE:
            OnPickerChange(event);
            break;
        case K_EVENT_ON_SCROLL_STOP:
            OnPickerScrollStop(event);
            break;
        default:
            break;
    }
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerMonthMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }
    ArkUI_NodeHandle rootContainer = api->createNode(ARKUI_NODE_COLUMN);
    if (rootContainer == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue widthValue = {.f32 = 1.0f};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootContainer, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue heightValue = {.f32 = 1.0f};
    ArkUI_AttributeItem heightItem = {&heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootContainer, NODE_HEIGHT_PERCENT, &heightItem);
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem justifyItem = {&justifyValue, sizeof(justifyValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootContainer, NODE_COLUMN_JUSTIFY_CONTENT, &justifyItem);
    std::shared_ptr<ContainerPickerMonthMaker> picker = BuildPicker();
    if (picker && picker->GetHandle() != nullptr) {
        api->registerNodeEvent(picker->GetHandle(), NODE_PICKER_EVENT_ON_CHANGE, K_EVENT_ON_CHANGE, nullptr);
        api->registerNodeEvent(picker->GetHandle(), NODE_PICKER_EVENT_ON_SCROLL_STOP, K_EVENT_ON_SCROLL_STOP, nullptr);
        api->addChild(rootContainer, picker->GetHandle());
    }
    api->registerNodeEventReceiver(&OnEventReceive);
    return rootContainer;
}