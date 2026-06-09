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

#include "ContainerPickerTypesMaker.h"

#include <functional>
#include <memory>
#include <string>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== 配置常量 =====
constexpr float K_PICKER_WIDTH = 200.0f;
constexpr float K_COLUMN_MARGIN = 20.0f;
constexpr float K_TAB_BAR_WIDTH = 140.0f;
constexpr float K_TAB_BAR_HEIGHT = 230.0f;
constexpr float K_TAB_CONTENT_HEIGHT = 230.0f;
constexpr float K_DIVIDER_WIDTH = 1.0f;
constexpr int32_t K_ANIMATION_DURATION = 400;
// ===== 资源路径常量 =====
constexpr const char *K_IMAGE_PATHS[] = {"resources/base/media/640.jpg", "resources/base/media/background.png",
                                         "resources/base/media/startIcon.png"};
constexpr const char *K_SYMBOL_PATHS[] = {"resources/base/media/640.jpg",        "resources/base/media/background.png",
                                          "resources/base/media/startIcon.png",  "resources/base/media/640.jpg",
                                          "resources/base/media/background.png", "resources/base/media/startIcon.png"};
// ===== 文本数据 =====
constexpr const char *K_TEXT_ITEMS[] = {"text1", "text2", "text3", "text4", "text5", "text6"};
constexpr int32_t K_ITEM_COUNT = 6;
// ===== 事件ID常量 =====
constexpr int32_t K_TAB_CHANGE_EVENT_ID = 1000;
constexpr int32_t K_TEXT_PICKER_CHANGE_ID = 1001;
constexpr int32_t K_TEXT_PICKER_SCROLL_STOP_ID = 1002;
constexpr int32_t K_IMAGE_PICKER_CHANGE_ID = 1003;
constexpr int32_t K_IMAGE_PICKER_SCROLL_STOP_ID = 1004;
constexpr int32_t K_HYBRID_PICKER_CHANGE_ID = 1005;
constexpr int32_t K_HYBRID_PICKER_SCROLL_STOP_ID = 1006;
} // namespace

// ---------- 全局状态 ----------
struct PickerTypesState {
    int32_t curTabIndex = 0;
    ArkUI_NodeHandle textPicker = nullptr;
    ArkUI_NodeHandle imagePicker = nullptr;
    ArkUI_NodeHandle hybridPicker = nullptr;
    ArkUI_NodeHandle tabs = nullptr;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
};

static std::shared_ptr<PickerTypesState> g_pickerTypesState;

// ---------- 创建文本选项 ----------
static ArkUI_NodeHandle CreateTextOption(ArkUI_NativeNodeAPI_1 *api, const char *text)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = text};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue alignmentValue = {.i32 = ARKUI_TEXT_CONTENT_ALIGN_CENTER};
    ArkUI_AttributeItem alignmentItem = {&alignmentValue, sizeof(alignmentValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_TEXT_CONTENT_ALIGN, &alignmentItem);
    return textNode;
}

// ---------- 创建图片选项 ----------
static ArkUI_NodeHandle CreateImageOption(ArkUI_NativeNodeAPI_1 *api, const char *imagePath)
{
    ArkUI_NodeHandle imageNode = api->createNode(ARKUI_NODE_IMAGE);
    if (imageNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem srcItem = {.string = imagePath};
    api->setAttribute(imageNode, NODE_IMAGE_SRC, &srcItem);
    return imageNode;
}

// ---------- 创建图文组合选项 ----------
static ArkUI_NodeHandle CreateHybridOption(ArkUI_NativeNodeAPI_1 *api, const char *symbolPath, const char *text)
{
    ArkUI_NodeHandle rowNode = api->createNode(ARKUI_NODE_ROW);
    if (rowNode == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, sizeof(alignValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(rowNode, NODE_ROW_JUSTIFY_CONTENT, &alignItem);
    ArkUI_NodeHandle symbolNode = api->createNode(ARKUI_NODE_IMAGE);
    if (symbolNode != nullptr) {
        ArkUI_AttributeItem symbolSrcItem = {.string = symbolPath};
        api->setAttribute(symbolNode, NODE_IMAGE_SRC, &symbolSrcItem);
        ArkUI_NumberValue heightValue = {.f32 = 20.0f};
        ArkUI_AttributeItem heightItem = {&heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(symbolNode, NODE_HEIGHT, &heightItem);
        ArkUI_NumberValue widthValue = {.f32 = 20.0f};
        ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(symbolNode, NODE_WIDTH, &widthItem);
        ArkUI_NumberValue marginValue = {.f32 = 5.0f};
        ArkUI_AttributeItem marginItem = {&marginValue, sizeof(marginValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(symbolNode, NODE_MARGIN, &marginItem);
        api->addChild(rowNode, symbolNode);
    }
    ArkUI_NodeHandle textNode = CreateTextOption(api, text);
    if (textNode != nullptr) {
        ArkUI_NumberValue marginValue = {.f32 = 5.0f};
        ArkUI_AttributeItem marginItem = {&marginValue, sizeof(marginValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(textNode, NODE_MARGIN, &marginItem);
        api->addChild(rowNode, textNode);
    }
    return rowNode;
}

// ---------- Picker事件回调函数 ----------
static void OnPickerChange(ArkUI_NodeEvent *event, const char *pickerType)
{
    if (!event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    printf("%s Picker item changed: index = %d\n", pickerType, selectedIndex);
}

static void OnPickerScrollStop(ArkUI_NodeEvent *event, const char *pickerType)
{
    if (!event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    printf("%s Picker scroll stopped: index = %d\n", pickerType, selectedIndex);
}

static void OnTextPickerChange(ArkUI_NodeEvent *event) { OnPickerChange(event, "文本"); }

static void OnTextPickerScrollStop(ArkUI_NodeEvent *event) { OnPickerScrollStop(event, "文本"); }

static void OnImagePickerChange(ArkUI_NodeEvent *event) { OnPickerChange(event, "图片"); }

static void OnImagePickerScrollStop(ArkUI_NodeEvent *event) { OnPickerScrollStop(event, "图片"); }

static void OnHybridPickerChange(ArkUI_NodeEvent *event) { OnPickerChange(event, "图文组合"); }

static void OnHybridPickerScrollStop(ArkUI_NodeEvent *event) { OnPickerScrollStop(event, "图文组合"); }

// ---------- 创建Picker ----------
static ArkUI_NodeHandle CreatePicker(ArkUI_NativeNodeAPI_1 *api, const std::vector<ArkUI_NodeHandle> &options,
                                     int32_t changeEventId, int32_t scrollStopEventId)
{
    ArkUI_NodeHandle picker = api->createNode(ARKUI_NODE_PICKER);
    if (picker == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue widthValue = {.f32 = K_PICKER_WIDTH};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue canLoopValue = {.i32 = 1};
    ArkUI_AttributeItem canLoopItem = {&canLoopValue, sizeof(canLoopValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_CAN_LOOP, &canLoopItem);
    ArkUI_NumberValue hapticValue = {.i32 = 0};
    ArkUI_AttributeItem hapticItem = {&hapticValue, sizeof(hapticValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_ENABLE_HAPTIC_FEEDBACK, &hapticItem);
    ArkUI_PickerIndicatorStyle *indicatorStyle = OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_DIVIDER);
    if (indicatorStyle != nullptr) {
        ArkUI_PickerIndicatorDivider divider = {
            .strokeWidth = 2.0f, .dividerColor = 0xFF0000FF, .startMargin = 20.0f, .endMargin = 20.0f};
        OH_ArkUI_PickerIndicatorStyle_ConfigureDivider(indicatorStyle, &divider);
        ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
        api->setAttribute(picker, NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
    }
    for (const auto &option : options) {
        if (option != nullptr) {
            api->addChild(picker, option);
        }
    }
    if (changeEventId > 0) {
        api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_CHANGE, changeEventId, nullptr);
    }
    if (scrollStopEventId > 0) {
        api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_SCROLL_STOP, scrollStopEventId, nullptr);
    }
    return picker;
}

// ---------- 创建文本Picker ----------
static ArkUI_NodeHandle CreateTextPicker(ArkUI_NativeNodeAPI_1 *api)
{
    std::vector<ArkUI_NodeHandle> options;
    options.reserve(K_ITEM_COUNT);
    for (int i = 0; i < K_ITEM_COUNT; i++) {
        ArkUI_NodeHandle textOption = CreateTextOption(api, K_TEXT_ITEMS[i]);
        options.push_back(textOption);
    }
    return CreatePicker(api, options, K_TEXT_PICKER_CHANGE_ID, K_TEXT_PICKER_SCROLL_STOP_ID);
}

// ---------- 创建图片Picker ----------
static ArkUI_NodeHandle CreateImagePicker(ArkUI_NativeNodeAPI_1 *api)
{
    std::vector<ArkUI_NodeHandle> options;
    options.reserve(K_ITEM_COUNT);
    for (int i = 0; i < K_ITEM_COUNT; i++) {
        ArkUI_NodeHandle imageOption = CreateImageOption(api, K_IMAGE_PATHS[i]);
        options.push_back(imageOption);
    }
    return CreatePicker(api, options, K_IMAGE_PICKER_CHANGE_ID, K_IMAGE_PICKER_SCROLL_STOP_ID);
}

// ---------- 创建图文组合Picker ----------
static ArkUI_NodeHandle CreateHybridPicker(ArkUI_NativeNodeAPI_1 *api)
{
    std::vector<ArkUI_NodeHandle> options;
    options.reserve(K_ITEM_COUNT);
    for (int i = 0; i < K_ITEM_COUNT; i++) {
        ArkUI_NodeHandle hybridOption = CreateHybridOption(api, K_SYMBOL_PATHS[i], K_TEXT_ITEMS[i]);
        options.push_back(hybridOption);
    }
    return CreatePicker(api, options, K_HYBRID_PICKER_CHANGE_ID, K_HYBRID_PICKER_SCROLL_STOP_ID);
}

// ---------- 创建Column容器 ----------
static ArkUI_NodeHandle CreateColumnContainer(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker)
{
    ArkUI_NodeHandle column = api->createNode(ARKUI_NODE_COLUMN);
    if (column == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue marginValue = {.f32 = K_COLUMN_MARGIN};
    ArkUI_AttributeItem marginItem = {&marginValue, sizeof(marginValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(column, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, sizeof(alignValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(column, NODE_COLUMN_JUSTIFY_CONTENT, &alignItem);
    if (picker != nullptr) {
        api->addChild(column, picker);
    }
    return column;
}

// ---------- Tab切换事件回调 ----------
static void OnTabChange(ArkUI_NodeEvent *event)
{
    if (!g_pickerTypesState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_pickerTypesState->curTabIndex = selectedIndex;
    printf("Tab changed to index: %d\n", selectedIndex);
}

// ---------- 全局事件接收器 ----------
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    switch (eventId) {
        case K_TAB_CHANGE_EVENT_ID:
            OnTabChange(event);
            break;
        case K_TEXT_PICKER_CHANGE_ID:
            OnTextPickerChange(event);
            break;
        case K_TEXT_PICKER_SCROLL_STOP_ID:
            OnTextPickerScrollStop(event);
            break;
        case K_IMAGE_PICKER_CHANGE_ID:
            OnImagePickerChange(event);
            break;
        case K_IMAGE_PICKER_SCROLL_STOP_ID:
            OnImagePickerScrollStop(event);
            break;
        case K_HYBRID_PICKER_CHANGE_ID:
            OnHybridPickerChange(event);
            break;
        case K_HYBRID_PICKER_SCROLL_STOP_ID:
            OnHybridPickerScrollStop(event);
            break;
        default:
            break;
        }
}

// ---------- 创建Tabs界面 ----------
static ArkUI_NodeHandle CreatePickerTypesUI(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    g_pickerTypesState = std::make_shared<PickerTypesState>();
    g_pickerTypesState->api = api;
    ArkUI_NodeHandle rootContainer = api->createNode(ARKUI_NODE_COLUMN);
    if (!rootContainer) {
        return nullptr;
    }
    ArkUI_NumberValue rootWidthValue = {.f32 = 1.0f};
    ArkUI_AttributeItem rootWidthItem = {&rootWidthValue, 1};
    api->setAttribute(rootContainer, NODE_WIDTH_PERCENT, &rootWidthItem);
    ArkUI_NumberValue rootHeightValue = {.f32 = 1.0f};
    ArkUI_AttributeItem rootHeightItem = {&rootHeightValue, 1};
    api->setAttribute(rootContainer, NODE_HEIGHT_PERCENT, &rootHeightItem);
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem justifyItem = {&justifyValue, 1};
    api->setAttribute(rootContainer, NODE_COLUMN_JUSTIFY_CONTENT, &justifyItem);
    g_pickerTypesState->textPicker = CreateTextPicker(api);
    g_pickerTypesState->imagePicker = CreateImagePicker(api);
    g_pickerTypesState->hybridPicker = CreateHybridPicker(api);
    ArkUI_NodeHandle textColumn = CreateColumnContainer(api, g_pickerTypesState->textPicker);
    ArkUI_NodeHandle imageColumn = CreateColumnContainer(api, g_pickerTypesState->imagePicker);
    ArkUI_NodeHandle hybridColumn = CreateColumnContainer(api, g_pickerTypesState->hybridPicker);
    if (textColumn)
        api->addChild(rootContainer, textColumn);
    if (imageColumn)
        api->addChild(rootContainer, imageColumn);
    if (hybridColumn)
        api->addChild(rootContainer, hybridColumn);
    return rootContainer;
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerTypesMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }
    ArkUI_NodeHandle pickerTypesUI = CreatePickerTypesUI(api);
    if (pickerTypesUI) {
        api->registerNodeEventReceiver(&OnEventReceive);
    }
    return pickerTypesUI;
}