/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

#include "ContainerPickerCanLoopMaker.h"

#include <functional>
#include <memory>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== Picker 配置常量 =====
constexpr int K_MONTH_COUNT = 12;
constexpr float K_PICKER_WIDTH_RATIO = 0.5f;
constexpr float K_PICKER_HEIGHT_RATIO = 0.5f;
constexpr int32_t K_INITIAL_SELECTED_INDEX = 2;
constexpr bool K_CAN_LOOP = true;
constexpr bool K_HAPTIC_FEEDBACK = true;
constexpr uint32_t K_INDICATOR_BG_COLOR = 0xD3D3D3D3;
constexpr float K_INDICATOR_CORNER_RADIUS = 10.0f;
constexpr int32_t K_CHANGE_EVENT_ID = 2;
constexpr int32_t K_SCROLL_STOP_EVENT_ID = 3;
// ===== Button 配置常量 =====
constexpr int32_t K_BUTTON_1_EVENT_ID = 100;
constexpr int32_t K_BUTTON_2_EVENT_ID = 101;
constexpr float K_BUTTON_WIDTH = 150.0f;
constexpr float K_BUTTON_HEIGHT = 60.0f;
constexpr float K_BUTTON_MARGIN = 20.0f;
constexpr uint32_t K_BUTTON_BG_COLOR = 0xFF2196F3;
constexpr uint32_t K_BUTTON_DISABLED_COLOR = 0xFF9E9E9E;
} // namespace

// ---------- 生成数据 ----------
static std::vector<std::string> MakeData() { return {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}; }

// ---------- 创建Picker选项 ----------
static ArkUI_NodeHandle CreatePickerOption(ArkUI_NativeNodeAPI_1 *api, const std::string &data)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = data.c_str()};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue alignmentValue = {.i32 = ARKUI_TEXT_CONTENT_ALIGN_CENTER};
    ArkUI_AttributeItem alignmentItem = {&alignmentValue, sizeof(alignmentValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_TEXT_CONTENT_ALIGN, &alignmentItem);
    return textNode;
}

// ---------- 创建按钮 ----------
static ArkUI_NodeHandle CreateButton(ArkUI_NativeNodeAPI_1 *api, const char *buttonText, int32_t eventId)
{
    ArkUI_NodeHandle button = api->createNode(ARKUI_NODE_BUTTON);
    if (button == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem textItem = {.string = buttonText};
    api->setAttribute(button, NODE_BUTTON_LABEL, &textItem);
    ArkUI_NumberValue widthValue = {.f32 = K_BUTTON_WIDTH};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue heightValue = {.f32 = K_BUTTON_HEIGHT};
    ArkUI_AttributeItem heightItem = {&heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue marginValue = {.f32 = K_BUTTON_MARGIN};
    ArkUI_AttributeItem marginItem = {&marginValue, sizeof(marginValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue enabledValue = {.i32 = true};
    ArkUI_AttributeItem enabledItem = {&enabledValue, sizeof(enabledValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_ENABLED, &enabledItem);
    api->registerNodeEvent(button, NODE_ON_CLICK, eventId, nullptr);
    return button;
}

// ---------- 更新按钮文本 ----------
static void UpdateButtonText(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle button, const char *newText)
{
    if (api && button) {
        ArkUI_AttributeItem textItem = {.string = newText};
        api->setAttribute(button, NODE_BUTTON_LABEL, &textItem);
    }
}

// ---------- 全局状态管理 ----------
struct PickerState {
    std::shared_ptr<ContainerPickerCanLoopMaker> picker;
    ArkUI_NodeHandle button1 = nullptr;
    ArkUI_NodeHandle button2 = nullptr;
    bool canLoopEnabled = K_CAN_LOOP;
    bool hapticFeedbackEnabled = K_HAPTIC_FEEDBACK;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
};

static std::shared_ptr<PickerState> g_pickerState;

// ---------- 按钮事件回调函数 ----------
static void OnButton1Clicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->picker || !g_pickerState->api) {
        return;
    }
    g_pickerState->canLoopEnabled = !g_pickerState->canLoopEnabled;
    g_pickerState->picker->SetCanLoop(g_pickerState->canLoopEnabled);
    std::string buttonText = g_pickerState->canLoopEnabled ? "canLoop: true" : "canLoop: false";
    UpdateButtonText(g_pickerState->api, g_pickerState->button1, buttonText.c_str());
    ArkUI_NumberValue colorValue;
    ArkUI_AttributeItem colorItem;
    if (g_pickerState->canLoopEnabled) {
        colorValue.u32 = K_BUTTON_BG_COLOR;
    } else {
        colorValue.u32 = K_BUTTON_DISABLED_COLOR;
    }
    colorItem = {&colorValue, 1};
    g_pickerState->api->setAttribute(g_pickerState->button1, NODE_BACKGROUND_COLOR, &colorItem);
}

static void OnButton2Clicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->picker || !g_pickerState->api) {
        return;
    }
    g_pickerState->hapticFeedbackEnabled = !g_pickerState->hapticFeedbackEnabled;
    g_pickerState->picker->SetHapticFeedback(g_pickerState->hapticFeedbackEnabled);
    std::string buttonText = g_pickerState->hapticFeedbackEnabled ? "hapticFeedback: true" : "hapticFeedback: false";
    UpdateButtonText(g_pickerState->api, g_pickerState->button2, buttonText.c_str());
    ArkUI_NumberValue colorValue;
    ArkUI_AttributeItem colorItem;
    if (g_pickerState->hapticFeedbackEnabled) {
        colorValue.u32 = K_BUTTON_BG_COLOR;
    } else {
        colorValue.u32 = K_BUTTON_DISABLED_COLOR;
    }
    colorItem = {&colorValue, 1};
    g_pickerState->api->setAttribute(g_pickerState->button2, NODE_BACKGROUND_COLOR, &colorItem);
}

// ---------- 全局事件接收器 ----------
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == K_BUTTON_1_EVENT_ID) {
        OnButton1Clicked(event);
    } else if (eventId == K_BUTTON_2_EVENT_ID) {
        OnButton2Clicked(event);
    }
}

// ---------- 配置 Picker 外观/交互 ----------
static void ConfigurePicker(const std::shared_ptr<ContainerPickerCanLoopMaker> &picker,
                            const std::shared_ptr<std::vector<std::string>> &data)
{
    if (!picker || !picker->GetHandle()) {
        return;
    }
    picker->SetPickerWidthPercent(K_PICKER_WIDTH_RATIO);
    picker->SetPickerHeightPercent(K_PICKER_HEIGHT_RATIO);
    picker->SetSelectedIndex(K_INITIAL_SELECTED_INDEX);
    picker->SetCanLoop(K_CAN_LOOP);
    picker->SetHapticFeedback(K_HAPTIC_FEEDBACK);
    picker->SetSelectionIndicatorBackground(K_INDICATOR_BG_COLOR, K_INDICATOR_CORNER_RADIUS);
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

// ---------- 整体构建 Picker ----------
static std::shared_ptr<ContainerPickerCanLoopMaker> BuildPicker()
{
    auto picker = std::make_shared<ContainerPickerCanLoopMaker>();
    auto data = std::make_shared<std::vector<std::string>>(MakeData());
    ConfigurePicker(picker, data);
    return picker;
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerCanLoopMaker::CreateNativeNode()
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
    std::shared_ptr<ContainerPickerCanLoopMaker> picker = BuildPicker();
    if (picker && picker->GetHandle() != nullptr) {
        api->addChild(rootContainer, picker->GetHandle());
    }
    ArkUI_NodeHandle buttonContainer = api->createNode(ARKUI_NODE_ROW);
    if (buttonContainer != nullptr) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, sizeof(alignValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(buttonContainer, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        g_pickerState = std::make_shared<PickerState>();
        g_pickerState->picker = picker;
        g_pickerState->api = api;
        g_pickerState->button1 = CreateButton(api, "canLoop: true", K_BUTTON_1_EVENT_ID);
        if (g_pickerState->button1 != nullptr) {
            ArkUI_NumberValue colorValue = {.u32 = K_BUTTON_BG_COLOR};
            ArkUI_AttributeItem colorItem = {&colorValue, 1};
            api->setAttribute(g_pickerState->button1, NODE_BACKGROUND_COLOR, &colorItem);
            api->addChild(buttonContainer, g_pickerState->button1);
        }
        g_pickerState->button2 = CreateButton(api, "hapticFeedback: true", K_BUTTON_2_EVENT_ID);
        if (g_pickerState->button2 != nullptr) {
            ArkUI_NumberValue colorValue = {.u32 = K_BUTTON_BG_COLOR};
            ArkUI_AttributeItem colorItem = {&colorValue, 1};
            api->setAttribute(g_pickerState->button2, NODE_BACKGROUND_COLOR, &colorItem);
            api->addChild(buttonContainer, g_pickerState->button2);
        }
        api->addChild(rootContainer, buttonContainer);
    }
    api->registerNodeEventReceiver(&OnEventReceive);
    return rootContainer;
}