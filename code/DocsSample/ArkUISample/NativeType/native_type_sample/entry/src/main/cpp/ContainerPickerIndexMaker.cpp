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

#include "ContainerPickerIndexMaker.h"

#include <memory>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== 配置常量 =====
constexpr int32_t K_ON_CHANGE_EVENT_ID = 1000;
constexpr int32_t K_ON_SCROLL_STOP_EVENT_ID = 1001;
constexpr float K_PICKER_WIDTH_RATIO = 0.7f;
constexpr float K_TEXT_WIDTH_RATIO = 0.9f;
constexpr float K_CONTAINER_MARGIN = 20.0f;
constexpr uint32_t K_TEXT_COLOR = 0xFF182431;
constexpr float K_TEXT_FONT_SIZE = 16.0f;
constexpr int32_t K_DATA_COUNT = 10;
} // namespace

// ---------- 数据结构 ----------
struct PickerSelectedIndexState {
    std::vector<std::string> dataArray;
    int32_t selectedIndex = 0;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    ArkUI_NodeHandle pickerNode = nullptr;
    ArkUI_NodeHandle selectedIndexTextNode = nullptr;
};

static std::shared_ptr<PickerSelectedIndexState> g_state;

// ---------- 初始化数据 ----------
static void InitializeData()
{
    if (!g_state) {
        return;
    }
    g_state->dataArray.clear();
    for (int i = 1; i <= K_DATA_COUNT; i++) {
        g_state->dataArray.push_back(std::to_string(i));
    }
}

// ---------- 创建文本节点 ----------
static ArkUI_NodeHandle CreateTextNode(ArkUI_NativeNodeAPI_1 *api, const std::string &text)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = text.c_str()};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue colorValue = {.u32 = K_TEXT_COLOR};
    ArkUI_AttributeItem colorItem = {&colorValue, sizeof(colorValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_FONT_COLOR, &colorItem);
    ArkUI_NumberValue fontSizeValue = {.f32 = K_TEXT_FONT_SIZE};
    ArkUI_AttributeItem fontSizeItem = {&fontSizeValue, sizeof(fontSizeValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_NumberValue widthValue = {.f32 = K_TEXT_WIDTH_RATIO};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_TEXT_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, sizeof(alignValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_TEXT_ALIGN, &alignItem);
    return textNode;
}

// ---------- 更新选中索引文本 ----------
static void UpdateSelectedIndexText()
{
    if (!g_state || !g_state->api || !g_state->selectedIndexTextNode) {
        return;
    }
    std::string text = "selectedIndex: " + std::to_string(g_state->selectedIndex);
    ArkUI_AttributeItem contentItem = {.string = text.c_str()};
    g_state->api->setAttribute(g_state->selectedIndexTextNode, NODE_TEXT_CONTENT, &contentItem);
}

// ---------- 更新Picker选中项 ----------
static void UpdatePickerSelectedIndex()
{
    if (!g_state || !g_state->api || !g_state->pickerNode) {
        return;
    }
    ArkUI_NumberValue selectedValue = {.i32 = g_state->selectedIndex};
    ArkUI_AttributeItem selectedItem = {&selectedValue, sizeof(selectedValue) / sizeof(ArkUI_NumberValue)};
    g_state->api->setAttribute(g_state->pickerNode, NODE_PICKER_OPTION_SELECTED_INDEX, &selectedItem);
}

// ---------- 创建Picker选项 ----------
static ArkUI_NodeHandle CreatePickerOption(ArkUI_NativeNodeAPI_1 *api, const std::string &text)
{
    ArkUI_NodeHandle textNode = CreateTextNode(api, text);
    return textNode;
}

// ---------- 事件处理函数 ----------
static void OnChangeEvent(ArkUI_NodeEvent *event)
{
    if (!g_state || !event) {
        return;
    }
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent && componentEvent->data) {
        int32_t selectedValue = componentEvent->data[0].i32;
        g_state->selectedIndex = selectedValue;
        UpdateSelectedIndexText();
    }
}

static void OnScrollStopEvent(ArkUI_NodeEvent *event)
{
    if (!g_state || !event) {
        return;
    }
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent && componentEvent->data) {
        int32_t selectedValue = componentEvent->data[0].i32;
        g_state->selectedIndex = selectedValue;
        UpdateSelectedIndexText();
    }
}

// ---------- 全局事件接收器 ----------
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == K_ON_CHANGE_EVENT_ID) {
        OnChangeEvent(event);
    } else if (eventId == K_ON_SCROLL_STOP_EVENT_ID) {
        OnScrollStopEvent(event);
    }
}

// ---------- 创建Picker组件 ----------
static ArkUI_NodeHandle CreatePicker(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle picker = api->createNode(ARKUI_NODE_PICKER);
    if (picker == nullptr) {
        return nullptr;
    }
    if (g_state) {
        g_state->pickerNode = picker;
    }
    ArkUI_NumberValue widthValue = {.f32 = K_PICKER_WIDTH_RATIO};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_WIDTH_PERCENT, &widthItem);
    UpdatePickerSelectedIndex();
    api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_CHANGE, K_ON_CHANGE_EVENT_ID, nullptr);
    api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_SCROLL_STOP, K_ON_SCROLL_STOP_EVENT_ID, nullptr);
    if (g_state) {
        for (const auto &item : g_state->dataArray) {
            ArkUI_NodeHandle optionNode = CreatePickerOption(api, item);
            if (optionNode != nullptr) {
                api->addChild(picker, optionNode);
            }
        }
    }
    return picker;
}

// ---------- 添加Picker部分 ----------
static void AddPickerSection(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle rootColumn)
{
    ArkUI_NodeHandle pickerRow = api->createNode(ARKUI_NODE_ROW);
    if (pickerRow != nullptr) {
        ArkUI_NumberValue rowWidthValue = {.f32 = 1.0f};
        ArkUI_AttributeItem rowWidthItem = {&rowWidthValue, sizeof(rowWidthValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(pickerRow, NODE_WIDTH_PERCENT, &rowWidthItem);
        ArkUI_NumberValue rowAlignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem rowAlignItem = {&rowAlignValue, sizeof(rowAlignValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(pickerRow, NODE_ROW_JUSTIFY_CONTENT, &rowAlignItem);
        ArkUI_NodeHandle picker = CreatePicker(api);
        if (picker != nullptr) {
            api->addChild(pickerRow, picker);
        }
        api->addChild(rootColumn, pickerRow);
    }
}

// ---------- 添加文本显示部分 ----------
static void AddTextDisplaySection(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle rootColumn)
{
    ArkUI_NodeHandle textColumn = api->createNode(ARKUI_NODE_COLUMN);
    if (textColumn != nullptr) {
        ArkUI_NumberValue colWidthValue = {.f32 = 1.0f};
        ArkUI_AttributeItem colWidthItem = {&colWidthValue, sizeof(colWidthValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(textColumn, NODE_WIDTH_PERCENT, &colWidthItem);
        ArkUI_NumberValue colAlignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
        ArkUI_AttributeItem colAlignItem = {&colAlignValue, sizeof(colAlignValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(textColumn, NODE_COLUMN_JUSTIFY_CONTENT, &colAlignItem);
        g_state->selectedIndexTextNode = CreateTextNode(api, "selectedIndex: 0");
        if (g_state->selectedIndexTextNode != nullptr) {
            api->addChild(textColumn, g_state->selectedIndexTextNode);
        }
        api->addChild(rootColumn, textColumn);
    }
}

// ---------- 创建根列 ----------
static ArkUI_NodeHandle CreateRootColumn(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle rootColumn = api->createNode(ARKUI_NODE_COLUMN);
    if (rootColumn == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue rootWidthValue = {.f32 = 1.0f};
    ArkUI_AttributeItem rootWidthItem = {&rootWidthValue, sizeof(rootWidthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootColumn, NODE_WIDTH_PERCENT, &rootWidthItem);
    ArkUI_NumberValue rootHeightValue = {.f32 = 1.0f};
    ArkUI_AttributeItem rootHeightItem = {&rootHeightValue, sizeof(rootHeightValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootColumn, NODE_HEIGHT_PERCENT, &rootHeightItem);
    ArkUI_NumberValue marginValue = {.f32 = K_CONTAINER_MARGIN};
    ArkUI_AttributeItem marginItem = {&marginValue, sizeof(marginValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootColumn, NODE_PADDING, &marginItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, sizeof(alignValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rootColumn, NODE_COLUMN_JUSTIFY_CONTENT, &alignItem);
    AddPickerSection(api, rootColumn);
    AddTextDisplaySection(api, rootColumn);
    api->registerNodeEventReceiver(&OnEventReceive);
    return rootColumn;
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerIndexMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }
    g_state = std::make_shared<PickerSelectedIndexState>();
    g_state->api = api;
    g_state->selectedIndex = 0;
    InitializeData();
    return CreateRootColumn(api);
}