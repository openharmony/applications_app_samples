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

#include "ContainerPickerIndicatorMaker.h"

#include <functional>
#include <memory>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== Picker 配置常量 =====
constexpr int32_t K_OPTION_COUNT = 10;
constexpr float K_PICKER_WIDTH_RATIO = 0.8f;
constexpr float K_PICKER_HEIGHT_RATIO = 0.3f;
constexpr int32_t K_INITIAL_SELECTED_INDEX = 2;
constexpr bool K_CAN_LOOP = true;
constexpr bool K_HAPTIC_FEEDBACK = true;
// ===== 颜色常量 =====
constexpr uint32_t K_COLOR_PINK = 0xFFFFC0CB;
constexpr uint32_t K_COLOR_GRAY = 0xFF808080;
constexpr uint32_t K_COLOR_BLUE = 0xFF2196F3;
constexpr uint32_t K_COLOR_GREEN = 0xFF4CAF50;
constexpr uint32_t K_COLOR_RED = 0xFFF44336;
constexpr uint32_t K_COLOR_BLACK = 0xFF000000;
constexpr uint32_t K_COLOR_WHITE = 0xFFFFFFFF;
constexpr uint32_t K_COLOR_LIGHT_GRAY = 0xFFE0E0E0;
constexpr uint32_t K_COLOR_TRANSPARENT = 0x00000000;
// ===== 尺寸常量 =====
constexpr float K_SIZE_2VP = 2.0f;
constexpr float K_SIZE_10VP = 10.0f;
// ===== Button 配置常量 =====
constexpr int32_t K_BUTTON_BG_EVENT_ID = 100;
constexpr int32_t K_BUTTON_DIVIDER_EVENT_ID = 101;
constexpr int32_t K_BUTTON_CLEAR_EVENT_ID = 102;
constexpr int32_t K_BUTTON_BG_CORNER_2VP_ID = 103;
constexpr int32_t K_BUTTON_BG_CORNER_10VP_ID = 104;
constexpr int32_t K_BUTTON_BG_COLOR_PINK_ID = 105;
constexpr int32_t K_BUTTON_BG_COLOR_GRAY_ID = 106;
constexpr int32_t K_BUTTON_DIVIDER_WIDTH_2VP_ID = 107;
constexpr int32_t K_BUTTON_DIVIDER_WIDTH_10VP_ID = 108;
constexpr int32_t K_BUTTON_DIVIDER_MARGIN_2VP_ID = 109;
constexpr int32_t K_BUTTON_DIVIDER_MARGIN_10VP_ID = 110;
constexpr int32_t K_BUTTON_DIVIDER_COLOR_PINK_ID = 111;
constexpr int32_t K_BUTTON_DIVIDER_COLOR_GRAY_ID = 112;
constexpr float K_BUTTON_WIDTH = 90.0f;
constexpr float K_BUTTON_HEIGHT = 36.0f;
constexpr float K_BUTTON_MARGIN = 4.0f;
constexpr float K_LABEL_FONT_SIZE = 14.0f;
} // namespace

// ---------- 生成数据 ----------
static std::vector<std::string> MakeData()
{
    std::vector<std::string> data;
    for (int i = 1; i <= K_OPTION_COUNT; i++) {
        data.push_back(std::to_string(i));
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
    ArkUI_NumberValue alignmentValue = {.i32 = ARKUI_TEXT_CONTENT_ALIGN_CENTER};
    ArkUI_AttributeItem alignmentItem = {&alignmentValue, sizeof(alignmentValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_TEXT_CONTENT_ALIGN, &alignmentItem);
    return textNode;
}

// ---------- 创建按钮 ----------
static ArkUI_NodeHandle CreateButton(ArkUI_NativeNodeAPI_1 *api, const char *buttonText, int32_t eventId,
                                     uint32_t bgColor = K_COLOR_BLUE)
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
    ArkUI_NumberValue colorValue = {.u32 = bgColor};
    ArkUI_AttributeItem colorItem = {&colorValue, sizeof(colorValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_BACKGROUND_COLOR, &colorItem);
    ArkUI_NumberValue textColorValue = {.u32 = K_COLOR_WHITE};
    ArkUI_AttributeItem textColorItem = {&textColorValue, sizeof(textColorValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_FONT_COLOR, &textColorItem);
    ArkUI_NumberValue radiusValue = {.f32 = 5.0f};
    ArkUI_AttributeItem radiusItem = {&radiusValue, sizeof(radiusValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(button, NODE_BORDER_RADIUS, &radiusItem);
    api->registerNodeEvent(button, NODE_ON_CLICK, eventId, nullptr);
    return button;
}

// ---------- 创建文本标签 ----------
static ArkUI_NodeHandle CreateLabel(ArkUI_NativeNodeAPI_1 *api, const char *text, uint32_t color = K_COLOR_BLACK)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = text};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue colorValue = {.u32 = color};
    ArkUI_AttributeItem colorItem = {&colorValue, 1};
    api->setAttribute(textNode, NODE_FONT_COLOR, &colorItem);
    ArkUI_NumberValue fontSizeValue = {.f32 = K_LABEL_FONT_SIZE};
    ArkUI_AttributeItem fontSizeItem = {&fontSizeValue, 1};
    api->setAttribute(textNode, NODE_FONT_SIZE, &fontSizeItem);
    return textNode;
}

// ---------- 全局状态管理 ----------
struct PickerIndicatorState {
    std::shared_ptr<ContainerPickerIndicatorMaker> picker;
    ArkUI_NodeHandle buttonBg = nullptr;
    ArkUI_NodeHandle buttonDivider = nullptr;
    ArkUI_NodeHandle buttonReset = nullptr;
    ArkUI_NodeHandle buttonBgCorner2VP = nullptr;
    ArkUI_NodeHandle buttonBgCorner10VP = nullptr;
    ArkUI_NodeHandle buttonBgColorPink = nullptr;
    ArkUI_NodeHandle buttonBgColorGray = nullptr;
    ArkUI_NodeHandle buttonDividerWidth2VP = nullptr;
    ArkUI_NodeHandle buttonDividerWidth10VP = nullptr;
    ArkUI_NodeHandle buttonDividerMargin2VP = nullptr;
    ArkUI_NodeHandle buttonDividerMargin10VP = nullptr;
    ArkUI_NodeHandle buttonDividerColorPink = nullptr;
    ArkUI_NodeHandle buttonDividerColorGray = nullptr;
    bool bgActive = false;
    bool dividerActive = false;
    uint32_t bgColor = K_COLOR_LIGHT_GRAY;
    float bgCornerRadius = K_SIZE_10VP;
    uint32_t dividerColor = K_COLOR_BLUE;
    float dividerStrokeWidth = K_SIZE_2VP;
    float dividerStartMargin = K_SIZE_10VP;
    float dividerEndMargin = K_SIZE_10VP;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
};

static std::shared_ptr<PickerIndicatorState> g_pickerState;

// ---------- 更新按钮颜色 ----------
static void UpdateButtonColor(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle button, uint32_t color)
{
    if (api && button) {
        ArkUI_NumberValue colorValue = {.u32 = color};
        ArkUI_AttributeItem colorItem = {&colorValue, 1};
        api->setAttribute(button, NODE_BACKGROUND_COLOR, &colorItem);
    }
}

// ---------- 清除所有按钮的绿色状态 ----------
static void ClearAllGreenStates()
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *api = g_pickerState->api;
    UpdateButtonColor(api, g_pickerState->buttonBg, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonReset, K_COLOR_RED);
    UpdateButtonColor(api, g_pickerState->buttonBgCorner2VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonBgCorner10VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonBgColorPink, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonBgColorGray, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerWidth2VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerWidth10VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerMargin2VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerMargin10VP, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerColorPink, K_COLOR_BLUE);
    UpdateButtonColor(api, g_pickerState->buttonDividerColorGray, K_COLOR_BLUE);
}

// ---------- 应用背景指示器 ----------
static void ApplyBackgroundIndicator()
{
    if (!g_pickerState || !g_pickerState->picker || !g_pickerState->api) {
        return;
    }
    ClearAllGreenStates();
    g_pickerState->picker->SetSelectionIndicatorBackground(g_pickerState->bgColor, g_pickerState->bgCornerRadius);
    g_pickerState->bgActive = true;
    g_pickerState->dividerActive = false;
    UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBg, K_COLOR_GREEN);
    if (g_pickerState->bgCornerRadius == K_SIZE_2VP) {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgCorner2VP, K_COLOR_GREEN);
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgCorner10VP, K_COLOR_GREEN);
    }
    if (g_pickerState->bgColor == K_COLOR_PINK) {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgColorPink, K_COLOR_GREEN);
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgColorGray, K_COLOR_GREEN);
    }
}

// ---------- 应用分割线指示器 ----------
static void ApplyDividerIndicator()
{
    if (!g_pickerState || !g_pickerState->picker || !g_pickerState->api) {
        return;
    }
    ClearAllGreenStates();
    g_pickerState->picker->SetSelectionIndicatorDivider(g_pickerState->dividerColor, g_pickerState->dividerStrokeWidth,
                                                        g_pickerState->dividerStartMargin,
                                                        g_pickerState->dividerEndMargin);
    g_pickerState->dividerActive = true;
    g_pickerState->bgActive = false;
    UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_GREEN);
    if (g_pickerState->dividerStrokeWidth == K_SIZE_2VP) {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerWidth2VP, K_COLOR_GREEN);
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerWidth10VP, K_COLOR_GREEN);
    }
    if (g_pickerState->dividerStartMargin == K_SIZE_2VP) {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerMargin2VP, K_COLOR_GREEN);
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerMargin10VP, K_COLOR_GREEN);
    }
    if (g_pickerState->dividerColor == K_COLOR_PINK) {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerColorPink, K_COLOR_GREEN);
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerColorGray, K_COLOR_GREEN);
    }
}

// ---------- 按钮事件回调函数 ----------
static void OnBackgroundClicked(ArkUI_NodeEvent *event) { ApplyBackgroundIndicator(); }

static void OnDividerClicked(ArkUI_NodeEvent *event) { ApplyDividerIndicator(); }

static void OnResetClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->picker || !g_pickerState->api) {
        return;
    }
    g_pickerState->picker->SetSelectionIndicatorBackground(K_COLOR_TRANSPARENT);
    ClearAllGreenStates();
    g_pickerState->bgColor = K_COLOR_LIGHT_GRAY;
    g_pickerState->bgCornerRadius = K_SIZE_10VP;
    g_pickerState->dividerColor = K_COLOR_BLUE;
    g_pickerState->dividerStrokeWidth = K_SIZE_2VP;
    g_pickerState->dividerStartMargin = K_SIZE_10VP;
    g_pickerState->dividerEndMargin = K_SIZE_10VP;
    g_pickerState->bgActive = false;
    g_pickerState->dividerActive = false;
}

static void OnBgCorner2VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->bgCornerRadius = K_SIZE_2VP;
    ClearAllGreenStates();
    if (g_pickerState->bgActive) {
        ApplyBackgroundIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgCorner2VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBg, K_COLOR_BLUE);
    }
}

static void OnBgCorner10VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->bgCornerRadius = K_SIZE_10VP;
    ClearAllGreenStates();
    if (g_pickerState->bgActive) {
        ApplyBackgroundIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgCorner10VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBg, K_COLOR_BLUE);
    }
}

static void OnBgColorPinkClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->bgColor = K_COLOR_PINK;
    ClearAllGreenStates();
    if (g_pickerState->bgActive) {
        ApplyBackgroundIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgColorPink, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBg, K_COLOR_BLUE);
    }
}

static void OnBgColorGrayClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->bgColor = K_COLOR_GRAY;
    ClearAllGreenStates();
    if (g_pickerState->bgActive) {
        ApplyBackgroundIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBgColorGray, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonBg, K_COLOR_BLUE);
    }
}

static void OnDividerWidth2VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerStrokeWidth = K_SIZE_2VP;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerWidth2VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    }
}

static void OnDividerWidth10VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerStrokeWidth = K_SIZE_10VP;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerWidth10VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    }
}

static void OnDividerMargin2VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerStartMargin = K_SIZE_2VP;
    g_pickerState->dividerEndMargin = K_SIZE_2VP;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerMargin2VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    }
}

static void OnDividerMargin10VPClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerStartMargin = K_SIZE_10VP;
    g_pickerState->dividerEndMargin = K_SIZE_10VP;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerMargin10VP, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    }
}

static void OnDividerColorPinkClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerColor = K_COLOR_PINK;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerColorPink, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
    }
}

static void OnDividerColorGrayClicked(ArkUI_NodeEvent *event)
{
    if (!g_pickerState || !g_pickerState->api) {
        return;
    }
    g_pickerState->dividerColor = K_COLOR_GRAY;
    ClearAllGreenStates();
    if (g_pickerState->dividerActive) {
        ApplyDividerIndicator();
    } else {
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDividerColorGray, K_COLOR_GREEN);
        UpdateButtonColor(g_pickerState->api, g_pickerState->buttonDivider, K_COLOR_BLUE);
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
        case K_BUTTON_BG_EVENT_ID:
            OnBackgroundClicked(event);
            break;
        case K_BUTTON_DIVIDER_EVENT_ID:
            OnDividerClicked(event);
            break;
        case K_BUTTON_CLEAR_EVENT_ID:
            OnResetClicked(event);
            break;
        case K_BUTTON_BG_CORNER_2VP_ID:
            OnBgCorner2VPClicked(event);
            break;
        case K_BUTTON_BG_CORNER_10VP_ID:
            OnBgCorner10VPClicked(event);
            break;
        case K_BUTTON_BG_COLOR_PINK_ID:
            OnBgColorPinkClicked(event);
            break;
        case K_BUTTON_BG_COLOR_GRAY_ID:
            OnBgColorGrayClicked(event);
            break;
        case K_BUTTON_DIVIDER_WIDTH_2VP_ID:
            OnDividerWidth2VPClicked(event);
            break;
        case K_BUTTON_DIVIDER_WIDTH_10VP_ID:
            OnDividerWidth10VPClicked(event);
            break;
        case K_BUTTON_DIVIDER_MARGIN_2VP_ID:
            OnDividerMargin2VPClicked(event);
            break;
        case K_BUTTON_DIVIDER_MARGIN_10VP_ID:
            OnDividerMargin10VPClicked(event);
            break;
        case K_BUTTON_DIVIDER_COLOR_PINK_ID:
            OnDividerColorPinkClicked(event);
            break;
        case K_BUTTON_DIVIDER_COLOR_GRAY_ID:
            OnDividerColorGrayClicked(event);
            break;
        default:
            break;
    }
}

// ---------- 配置 Picker ----------
static void ConfigurePicker(const std::shared_ptr<ContainerPickerIndicatorMaker> &picker,
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
static std::shared_ptr<ContainerPickerIndicatorMaker> BuildPicker()
{
    auto picker = std::make_shared<ContainerPickerIndicatorMaker>();
    auto data = std::make_shared<std::vector<std::string>>(MakeData());
    ConfigurePicker(picker, data);
    return picker;
}

// ---------- 创建主控制行 ----------
static ArkUI_NodeHandle CreateMainControlRow(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    ArkUI_NodeHandle mainControlRow = api->createNode(ARKUI_NODE_ROW);
    if (!mainControlRow) {
        return nullptr;
    }
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    api->setAttribute(mainControlRow, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
    g_pickerState->buttonBg = CreateButton(api, "背景指示器", K_BUTTON_BG_EVENT_ID);
    g_pickerState->buttonDivider = CreateButton(api, "分割线指示器", K_BUTTON_DIVIDER_EVENT_ID);
    g_pickerState->buttonReset = CreateButton(api, "清除", K_BUTTON_CLEAR_EVENT_ID, K_COLOR_RED);
    if (g_pickerState->buttonBg)
        api->addChild(mainControlRow, g_pickerState->buttonBg);
    if (g_pickerState->buttonDivider)
        api->addChild(mainControlRow, g_pickerState->buttonDivider);
    if (g_pickerState->buttonReset)
        api->addChild(mainControlRow, g_pickerState->buttonReset);
    return mainControlRow;
}

// ---------- 创建背景圆角行 ----------
static ArkUI_NodeHandle CreateBgCornerRow(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle bgRow1 = api->createNode(ARKUI_NODE_ROW);
    if (bgRow1) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, 1};
        api->setAttribute(bgRow1, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        ArkUI_NodeHandle cornerLabel = CreateLabel(api, "圆角:");
        g_pickerState->buttonBgCorner2VP = CreateButton(api, "2vp", K_BUTTON_BG_CORNER_2VP_ID);
        g_pickerState->buttonBgCorner10VP = CreateButton(api, "10vp", K_BUTTON_BG_CORNER_10VP_ID);
        if (cornerLabel)
            api->addChild(bgRow1, cornerLabel);
        if (g_pickerState->buttonBgCorner2VP)
            api->addChild(bgRow1, g_pickerState->buttonBgCorner2VP);
        if (g_pickerState->buttonBgCorner10VP)
            api->addChild(bgRow1, g_pickerState->buttonBgCorner10VP);
    }
    return bgRow1;
}

// ---------- 创建背景颜色行 ----------
static ArkUI_NodeHandle CreateBgColorRow(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle bgRow2 = api->createNode(ARKUI_NODE_ROW);
    if (bgRow2) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, 1};
        api->setAttribute(bgRow2, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        ArkUI_NodeHandle colorLabel = CreateLabel(api, "颜色:");
        g_pickerState->buttonBgColorPink = CreateButton(api, "粉色", K_BUTTON_BG_COLOR_PINK_ID);
        g_pickerState->buttonBgColorGray = CreateButton(api, "灰色", K_BUTTON_BG_COLOR_GRAY_ID);
        if (colorLabel)
            api->addChild(bgRow2, colorLabel);
        if (g_pickerState->buttonBgColorPink)
            api->addChild(bgRow2, g_pickerState->buttonBgColorPink);
        if (g_pickerState->buttonBgColorGray)
            api->addChild(bgRow2, g_pickerState->buttonBgColorGray);
    }
    return bgRow2;
}

// ---------- 创建分割线宽度行 ----------
static ArkUI_NodeHandle CreateDividerWidthRow(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle dividerRow1 = api->createNode(ARKUI_NODE_ROW);
    if (dividerRow1) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, 1};
        api->setAttribute(dividerRow1, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        ArkUI_NodeHandle widthLabel = CreateLabel(api, "宽度:");
        g_pickerState->buttonDividerWidth2VP = CreateButton(api, "2vp", K_BUTTON_DIVIDER_WIDTH_2VP_ID);
        g_pickerState->buttonDividerWidth10VP = CreateButton(api, "10vp", K_BUTTON_DIVIDER_WIDTH_10VP_ID);
        if (widthLabel)
            api->addChild(dividerRow1, widthLabel);
        if (g_pickerState->buttonDividerWidth2VP)
            api->addChild(dividerRow1, g_pickerState->buttonDividerWidth2VP);
        if (g_pickerState->buttonDividerWidth10VP)
            api->addChild(dividerRow1, g_pickerState->buttonDividerWidth10VP);
    }
    return dividerRow1;
}

// ---------- 创建分割线边距行 ----------
static ArkUI_NodeHandle CreateDividerMarginRow(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle dividerRow2 = api->createNode(ARKUI_NODE_ROW);
    if (dividerRow2) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, 1};
        api->setAttribute(dividerRow2, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        ArkUI_NodeHandle marginLabel = CreateLabel(api, "边距:");
        g_pickerState->buttonDividerMargin2VP = CreateButton(api, "2vp", K_BUTTON_DIVIDER_MARGIN_2VP_ID);
        g_pickerState->buttonDividerMargin10VP = CreateButton(api, "10vp", K_BUTTON_DIVIDER_MARGIN_10VP_ID);
        if (marginLabel)
            api->addChild(dividerRow2, marginLabel);
        if (g_pickerState->buttonDividerMargin2VP)
            api->addChild(dividerRow2, g_pickerState->buttonDividerMargin2VP);
        if (g_pickerState->buttonDividerMargin10VP)
            api->addChild(dividerRow2, g_pickerState->buttonDividerMargin10VP);
    }
    return dividerRow2;
}

// ---------- 创建分割线颜色行 ----------
static ArkUI_NodeHandle CreateDividerColorRow(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle dividerRow3 = api->createNode(ARKUI_NODE_ROW);
    if (dividerRow3) {
        ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem alignItem = {&alignValue, 1};
        api->setAttribute(dividerRow3, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
        ArkUI_NodeHandle colorLabel = CreateLabel(api, "颜色:");
        g_pickerState->buttonDividerColorPink = CreateButton(api, "粉色", K_BUTTON_DIVIDER_COLOR_PINK_ID);
        g_pickerState->buttonDividerColorGray = CreateButton(api, "灰色", K_BUTTON_DIVIDER_COLOR_GRAY_ID);
        if (colorLabel)
            api->addChild(dividerRow3, colorLabel);
        if (g_pickerState->buttonDividerColorPink)
            api->addChild(dividerRow3, g_pickerState->buttonDividerColorPink);
        if (g_pickerState->buttonDividerColorGray)
            api->addChild(dividerRow3, g_pickerState->buttonDividerColorGray);
    }
    return dividerRow3;
}

// ---------- 创建背景指示器控件 ----------
static ArkUI_NodeHandle CreateBackgroundIndicatorControls(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    ArkUI_NodeHandle container = api->createNode(ARKUI_NODE_COLUMN);
    if (!container) {
        return nullptr;
    }
    ArkUI_NodeHandle bgTitle = CreateLabel(api, "背景指示器属性:");
    if (bgTitle) {
        api->addChild(container, bgTitle);
    }
    ArkUI_NodeHandle bgCornerRow = CreateBgCornerRow(api);
    if (bgCornerRow) {
        api->addChild(container, bgCornerRow);
    }
    ArkUI_NodeHandle bgColorRow = CreateBgColorRow(api);
    if (bgColorRow) {
        api->addChild(container, bgColorRow);
    }
    return container;
}

// ---------- 创建分割线指示器控件 ----------
static ArkUI_NodeHandle CreateDividerIndicatorControls(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    ArkUI_NodeHandle container = api->createNode(ARKUI_NODE_COLUMN);
    if (!container) {
        return nullptr;
    }
    ArkUI_NodeHandle dividerTitle = CreateLabel(api, "分割线指示器属性:");
    if (dividerTitle) {
        api->addChild(container, dividerTitle);
    }
    ArkUI_NodeHandle dividerWidthRow = CreateDividerWidthRow(api);
    if (dividerWidthRow) {
        api->addChild(container, dividerWidthRow);
    }
    ArkUI_NodeHandle dividerMarginRow = CreateDividerMarginRow(api);
    if (dividerMarginRow) {
        api->addChild(container, dividerMarginRow);
    }
    ArkUI_NodeHandle dividerColorRow = CreateDividerColorRow(api);
    if (dividerColorRow) {
        api->addChild(container, dividerColorRow);
    }
    return container;
}

// ---------- 创建控制面板 ----------
static ArkUI_NodeHandle CreateControlPanel(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    ArkUI_NodeHandle panel = api->createNode(ARKUI_NODE_COLUMN);
    if (!panel) {
        return nullptr;
    }
    ArkUI_NumberValue widthValue = {.f32 = 0.9f};
    ArkUI_AttributeItem widthItem = {&widthValue, 1};
    api->setAttribute(panel, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    api->setAttribute(panel, NODE_COLUMN_JUSTIFY_CONTENT, &alignItem);
    ArkUI_NodeHandle mainControlRow = CreateMainControlRow(api);
    if (mainControlRow) {
        api->addChild(panel, mainControlRow);
    }
    ArkUI_NodeHandle bgControls = CreateBackgroundIndicatorControls(api);
    if (bgControls) {
        api->addChild(panel, bgControls);
    }
    ArkUI_NodeHandle dividerControls = CreateDividerIndicatorControls(api);
    if (dividerControls) {
        api->addChild(panel, dividerControls);
    }
    return panel;
}

// ---------- 创建根容器 ----------
static ArkUI_NodeHandle CreateRootContainer(ArkUI_NativeNodeAPI_1 *api)
{
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
    std::shared_ptr<ContainerPickerIndicatorMaker> picker = BuildPicker();
    if (picker && picker->GetHandle() != nullptr) {
        api->addChild(rootContainer, picker->GetHandle());
    }
    g_pickerState = std::make_shared<PickerIndicatorState>();
    g_pickerState->picker = picker;
    g_pickerState->api = api;
    ArkUI_NodeHandle controlPanel = CreateControlPanel(api);
    if (controlPanel != nullptr) {
        api->addChild(rootContainer, controlPanel);
    }
    api->registerNodeEventReceiver(&OnEventReceive);
    return rootContainer;
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerIndicatorMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }
    return CreateRootContainer(api);
}