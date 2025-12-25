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

#include "ContainerPickerTimeMaker.h"

#include <algorithm>
#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include <vector>

namespace {
// ===== 时间选择器配置常量 =====
constexpr float PICKER_WIDTH_PERCENT = 0.2f;
constexpr float PICKER_HEIGHT_RATIO = 0.4f;
constexpr bool INITIAL_LOOP_STATE = true;
constexpr bool INITIAL_SHOW_SECOND_STATE = false;
constexpr bool INITIAL_USE_MILITARY_STATE = false;
constexpr bool INITIAL_ZERO_PREFIX_STATE = false;
constexpr uint32_t INDICATOR_BACKGROUND_COLOR = 0xD3D3D3D3;
constexpr float PICKER_CORNER_RADIUS = 24.0f;
// ===== 时间相关常量 =====
constexpr int32_t HOURS_IN_12_HOUR_FORMAT = 12;
constexpr int32_t HOURS_IN_24_HOUR_FORMAT = 24;
constexpr int32_t MINUTES_IN_HOUR = 60;
constexpr int32_t SECONDS_IN_MINUTE = 60;
constexpr int32_t FIRST_HOUR_IN_12_HOUR_FORMAT = 12;
constexpr int32_t LAST_HOUR_IN_12_HOUR_FORMAT = 11;
constexpr int32_t AM_PM_SWITCH_HOUR = 12;
constexpr int32_t SINGLE_DIGIT_THRESHOLD = 10;
constexpr int32_t LOG_DISPLAY_ITEM_COUNT = 5;
constexpr int32_t AM_INDEX = 0;
constexpr int32_t PM_INDEX = 1;
// ===== 事件ID =====
constexpr int32_t EVENT_HOUR_CHANGE = 2001;
constexpr int32_t EVENT_HOUR_SCROLL_STOP = 2002;
constexpr int32_t EVENT_MINUTE_CHANGE = 2003;
constexpr int32_t EVENT_MINUTE_SCROLL_STOP = 2004;
constexpr int32_t EVENT_SECOND_CHANGE = 2005;
constexpr int32_t EVENT_SECOND_SCROLL_STOP = 2006;
constexpr int32_t EVENT_AMPM_CHANGE = 2007;
constexpr int32_t EVENT_AMPM_SCROLL_STOP = 2008;
// ===== 切换按钮事件ID =====
constexpr int32_t EVENT_TOGGLE_LOOP = 2101;
constexpr int32_t EVENT_TOGGLE_SECOND = 2102;
constexpr int32_t EVENT_TOGGLE_MILITARY = 2103;
constexpr int32_t EVENT_TOGGLE_DIGITS = 2104;
} // namespace

// ---------- 全局状态管理 ----------
struct TimePickerState {
    // 时间选择器组件
    std::shared_ptr<ContainerPickerTimeMaker> hourPicker;
    std::shared_ptr<ContainerPickerTimeMaker> minutePicker;
    std::shared_ptr<ContainerPickerTimeMaker> secondPicker;
    std::shared_ptr<ContainerPickerTimeMaker> amPmPicker;
    // 当前选中索引
    int32_t hourIndex = 0;
    int32_t minuteIndex = 0;
    int32_t secondIndex = 0;
    int32_t amPmIndex = AM_INDEX;
    // 配置选项
    bool showSecond = INITIAL_SHOW_SECOND_STATE;
    bool useMilitary = INITIAL_USE_MILITARY_STATE;
    bool zeroPrefix = INITIAL_ZERO_PREFIX_STATE;
    bool canLoop = INITIAL_LOOP_STATE;
    // 数据数组
    std::vector<std::string> amPmArray;
    std::vector<std::string> hourArray;
    std::vector<std::string> minuteArray;
    std::vector<std::string> secondArray;
    // UI节点句柄
    ArkUI_NodeHandle statusLabel = nullptr;
    ArkUI_NodeHandle toggleLoop = nullptr;
    ArkUI_NodeHandle toggleSecond = nullptr;
    ArkUI_NodeHandle toggleMilitary = nullptr;
    ArkUI_NodeHandle toggleDigits = nullptr;
    ArkUI_NodeHandle pickersRow = nullptr;
    ArkUI_NodeHandle controlPanel = nullptr;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
};

static std::shared_ptr<TimePickerState> g_timePickerState;

// ---------- 辅助函数 ----------
static std::string FormatTime(int32_t number, bool zeroPrefix)
{
    if (zeroPrefix && number < SINGLE_DIGIT_THRESHOLD) {
        return "0" + std::to_string(number);
    }
    return std::to_string(number);
}

static void RegenerateHourArray()
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->hourArray.clear();
    if (g_timePickerState->useMilitary) {
        // 24小时制: 00-23
        for (int i = 0; i < HOURS_IN_24_HOUR_FORMAT; i++) {
            g_timePickerState->hourArray.push_back(FormatTime(i, g_timePickerState->zeroPrefix));
        }
    } else {
        // 12小时制: 12, 01-11
        if (g_timePickerState->zeroPrefix) {
            g_timePickerState->hourArray.push_back(std::to_string(FIRST_HOUR_IN_12_HOUR_FORMAT));
            for (int i = 1; i <= LAST_HOUR_IN_12_HOUR_FORMAT; i++) {
                g_timePickerState->hourArray.push_back(FormatTime(i, true));
            }
        } else {
            g_timePickerState->hourArray.push_back(std::to_string(FIRST_HOUR_IN_12_HOUR_FORMAT));
            for (int i = 1; i <= LAST_HOUR_IN_12_HOUR_FORMAT; i++) {
                g_timePickerState->hourArray.push_back(std::to_string(i));
            }
        }
    }
}

static void RegenerateMinuteSecondArray()
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->minuteArray.clear();
    g_timePickerState->secondArray.clear();
    for (int i = 0; i < MINUTES_IN_HOUR; i++) {
        std::string formatted = FormatTime(i, g_timePickerState->zeroPrefix);
        g_timePickerState->minuteArray.push_back(formatted);
        g_timePickerState->secondArray.push_back(formatted);
    }
}

static void LogMinuteSecondArray()
{
    if (!g_timePickerState) {
        return;
    }
    std::cout << "Regenerated minute/second array (" << (g_timePickerState->zeroPrefix ? "2-digit" : "1-digit")
              << "): ";
    for (int i = 0; i < LOG_DISPLAY_ITEM_COUNT && i < static_cast<int>(g_timePickerState->minuteArray.size()); i++) {
        std::cout << g_timePickerState->minuteArray[i] << " ";
    }
    if (g_timePickerState->minuteArray.size() > LOG_DISPLAY_ITEM_COUNT) {
        std::cout << "... ";
    }
    std::cout << std::endl;
}

static ArkUI_NodeHandle CreateTextOption(const std::string &text)
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return nullptr;
    }
    ArkUI_NodeHandle textNode = g_timePickerState->api->createNode(ARKUI_NODE_TEXT);
    if (!textNode) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = text.c_str()};
    g_timePickerState->api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    return textNode;
}

static void RemoveAllChildren(ArkUI_NodeHandle parent)
{
    if (!parent || !g_timePickerState || !g_timePickerState->api) {
        return;
    }
    auto api = g_timePickerState->api;
    uint32_t childCount = api->getTotalChildCount(parent);
    for (int32_t i = childCount - 1; i >= 0; i--) {
        ArkUI_NodeHandle child = api->getChildAt(parent, i);
        if (child) {
            api->removeChild(parent, child);
            api->disposeNode(child);
        }
    }
}

static void UpdatePickerOptions(ArkUI_NodeHandle pickerHandle, const std::vector<std::string> &newOptions)
{
    if (!pickerHandle || !g_timePickerState || !g_timePickerState->api) {
        return;
    }
    auto api = g_timePickerState->api;
    RemoveAllChildren(pickerHandle);
    for (const auto &option : newOptions) {
        ArkUI_NodeHandle textNode = CreateTextOption(option);
        if (textNode) {
            api->addChild(pickerHandle, textNode);
        }
    }
}

static void ConvertHourIndexForTimeFormat()
{
    if (!g_timePickerState) {
        return;
    }
    if (g_timePickerState->useMilitary) {
        // 12小时制转24小时制
        if (g_timePickerState->amPmIndex == PM_INDEX) {
            int32_t oldHourIndex = g_timePickerState->hourIndex;
            g_timePickerState->hourIndex += AM_PM_SWITCH_HOUR;
            if (g_timePickerState->hourIndex >= HOURS_IN_24_HOUR_FORMAT) {
                g_timePickerState->hourIndex = 0;
            }
        }
    } else {
        // 24小时制转12小时制
        int32_t oldHourIndex = g_timePickerState->hourIndex;
        if (oldHourIndex >= AM_PM_SWITCH_HOUR) {
            g_timePickerState->amPmIndex = PM_INDEX;
            g_timePickerState->hourIndex = oldHourIndex - AM_PM_SWITCH_HOUR;
        } else {
            g_timePickerState->amPmIndex = AM_INDEX;
            g_timePickerState->hourIndex = (oldHourIndex == 0) ? 0 : oldHourIndex;
        }
    }
}

static void AdjustIndicesToValidRange()
{
    if (!g_timePickerState) {
        return;
    }
    if (g_timePickerState->hourIndex >= static_cast<int32_t>(g_timePickerState->hourArray.size())) {
        g_timePickerState->hourIndex = 0;
    }
    if (g_timePickerState->minuteIndex >= static_cast<int32_t>(g_timePickerState->minuteArray.size())) {
        g_timePickerState->minuteIndex = 0;
    }
    if (g_timePickerState->secondIndex >= static_cast<int32_t>(g_timePickerState->secondArray.size())) {
        g_timePickerState->secondIndex = 0;
    }
}

static void SetPickerIndicatorStyle(ArkUI_NodeHandle pickerHandle)
{
    if (!pickerHandle || !g_timePickerState || !g_timePickerState->api) {
        return;
    }
    auto api = g_timePickerState->api;
    ArkUI_PickerIndicatorStyle *indicatorStyle =
        OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_BACKGROUND);
    if (indicatorStyle != nullptr) {
        ArkUI_PickerIndicatorBackground background = {.backgroundColor = INDICATOR_BACKGROUND_COLOR,
                                                      .topLeftRadius = PICKER_CORNER_RADIUS,
                                                      .topRightRadius = PICKER_CORNER_RADIUS,
                                                      .bottomLeftRadius = PICKER_CORNER_RADIUS,
                                                      .bottomRightRadius = PICKER_CORNER_RADIUS};
        OH_ArkUI_PickerIndicatorStyle_ConfigureBackground(indicatorStyle, &background);
        ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
        api->setAttribute(pickerHandle, NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
    }
}

static bool CreateTimePicker(std::shared_ptr<ContainerPickerTimeMaker> &picker, const std::vector<std::string> &data,
                             int32_t selectedIndex, int32_t changeEventId, int32_t scrollStopEventId)
{
    if (!g_timePickerState || !g_timePickerState->pickersRow) {
        return false;
    }
    picker = std::make_shared<ContainerPickerTimeMaker>();
    if (!picker || !picker->GetHandle()) {
        return false;
    }
    ArkUI_NodeHandle pickerHandle = picker->GetHandle();
    auto api = g_timePickerState->api;
    picker->SetPickerWidthPercent(PICKER_WIDTH_PERCENT);
    picker->SetPickerHeightPercent(PICKER_HEIGHT_RATIO);
    picker->SetSelectedIndex(static_cast<uint32_t>(selectedIndex));
    picker->SetCanLoop(g_timePickerState->canLoop);
    picker->SetHapticFeedback(true);
    SetPickerIndicatorStyle(pickerHandle);
    UpdatePickerOptions(pickerHandle, data);
    if (pickerHandle) {
        api->registerNodeEvent(pickerHandle, NODE_PICKER_EVENT_ON_CHANGE, changeEventId, nullptr);
        api->registerNodeEvent(pickerHandle, NODE_PICKER_EVENT_ON_SCROLL_STOP, scrollStopEventId, nullptr);
    }
    api->addChild(g_timePickerState->pickersRow, pickerHandle);
    return true;
}

static void ClearExistingPickers()
{
    if (!g_timePickerState) {
        return;
    }
    if (g_timePickerState->pickersRow && g_timePickerState->api) {
        RemoveAllChildren(g_timePickerState->pickersRow);
    }
    g_timePickerState->hourPicker.reset();
    g_timePickerState->minutePicker.reset();
    g_timePickerState->secondPicker.reset();
    g_timePickerState->amPmPicker.reset();
}

static void PrepareTimeData()
{
    if (!g_timePickerState) {
        return;
    }
    RegenerateHourArray();
    RegenerateMinuteSecondArray();
    ConvertHourIndexForTimeFormat();
    AdjustIndicesToValidRange();
    g_timePickerState->amPmArray = {"AM", "PM"};
}

static void CreateAmPmPickerIfNeeded()
{
    if (!g_timePickerState || g_timePickerState->useMilitary) {
        return;
    }
    CreateTimePicker(g_timePickerState->amPmPicker, g_timePickerState->amPmArray, g_timePickerState->amPmIndex,
                     EVENT_AMPM_CHANGE, EVENT_AMPM_SCROLL_STOP);
}

static void CreateHourPicker()
{
    if (!g_timePickerState) {
        return;
    }
    CreateTimePicker(g_timePickerState->hourPicker, g_timePickerState->hourArray, g_timePickerState->hourIndex,
                     EVENT_HOUR_CHANGE, EVENT_HOUR_SCROLL_STOP);
}

static void CreateMinutePicker()
{
    if (!g_timePickerState) {
        return;
    }
    CreateTimePicker(g_timePickerState->minutePicker, g_timePickerState->minuteArray, g_timePickerState->minuteIndex,
                     EVENT_MINUTE_CHANGE, EVENT_MINUTE_SCROLL_STOP);
}

static void CreateSecondPickerIfNeeded()
{
    if (!g_timePickerState || !g_timePickerState->showSecond) {
        return;
    }
    CreateTimePicker(g_timePickerState->secondPicker, g_timePickerState->secondArray, g_timePickerState->secondIndex,
                     EVENT_SECOND_CHANGE, EVENT_SECOND_SCROLL_STOP);
}

static void CreateAllPickers()
{
    CreateAmPmPickerIfNeeded();
    CreateHourPicker();
    CreateMinutePicker();
    CreateSecondPickerIfNeeded();
}

// ---------- 重新创建时间选择器布局 ----------
static void RecreateTimePickerLayout()
{
    if (!g_timePickerState || !g_timePickerState->api || !g_timePickerState->pickersRow) {
        return;
    }
    ClearExistingPickers();
    PrepareTimeData();
    CreateAllPickers();
}

static ArkUI_NodeHandle CreateToggleButton(const char *label, bool initialState, int32_t eventId)
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return nullptr;
    }
    auto api = g_timePickerState->api;
    ArkUI_NodeHandle row = api->createNode(ARKUI_NODE_ROW);
    if (!row) {
        return nullptr;
    }
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_SPACE_BETWEEN};
    ArkUI_AttributeItem justifyItem = {&justifyValue, 1};
    api->setAttribute(row, NODE_ROW_JUSTIFY_CONTENT, &justifyItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    api->setAttribute(row, NODE_ROW_ALIGN_ITEMS, &alignItem);
    ArkUI_NumberValue widthValue = {.f32 = 200.0f};
    ArkUI_AttributeItem widthItem = {&widthValue, 1};
    api->setAttribute(row, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue marginValue = {.f32 = 5.0f};
    ArkUI_AttributeItem marginItem = {&marginValue, 1};
    api->setAttribute(row, NODE_MARGIN, &marginItem);
    ArkUI_NodeHandle toggle = api->createNode(ARKUI_NODE_TOGGLE);
    if (!toggle) {
        api->disposeNode(row);
        return nullptr;
    }
    ArkUI_NumberValue stateValue = {.i32 = initialState ? 1 : 0};
    ArkUI_AttributeItem stateItem = {&stateValue, 1};
    api->setAttribute(toggle, NODE_TOGGLE_VALUE, &stateItem);
    api->registerNodeEvent(toggle, NODE_ON_CLICK, eventId, nullptr);
    ArkUI_NodeHandle text = api->createNode(ARKUI_NODE_TEXT);
    if (text) {
        ArkUI_AttributeItem textItem = {.string = label};
        api->setAttribute(text, NODE_TEXT_CONTENT, &textItem);
        ArkUI_NumberValue fontSizeValue = {.f32 = 20.0f};
        ArkUI_AttributeItem fontSizeItem = {&fontSizeValue, 1};
        api->setAttribute(text, NODE_FONT_SIZE, &fontSizeItem);
    }
    api->addChild(row, toggle);
    if (text) {
        api->addChild(row, text);
    }
    return row;
}

static void UpdateToggleState(ArkUI_NodeHandle toggleRow, bool isOn)
{
    if (!toggleRow || !g_timePickerState || !g_timePickerState->api) {
        return;
    }
    auto api = g_timePickerState->api;
    ArkUI_NodeHandle toggle = api->getFirstChild(toggleRow);
    if (toggle) {
        ArkUI_NumberValue stateValue = {.i32 = isOn ? 1 : 0};
        ArkUI_AttributeItem stateItem = {&stateValue, 1};
        api->setAttribute(toggle, NODE_TOGGLE_VALUE, &stateItem);
    }
}

static void UpdateStatusLabel()
{
    if (!g_timePickerState || !g_timePickerState->statusLabel || !g_timePickerState->api) {
        return;
    }
    std::string currentTime = "selected time: ";
    if (!g_timePickerState->useMilitary && !g_timePickerState->amPmArray.empty()) {
        currentTime += g_timePickerState->amPmArray[g_timePickerState->amPmIndex] + " ";
    }
    if (!g_timePickerState->hourArray.empty() &&
        g_timePickerState->hourIndex < static_cast<int32_t>(g_timePickerState->hourArray.size())) {
        currentTime += g_timePickerState->hourArray[g_timePickerState->hourIndex] + ":";
    } else {
        currentTime += "00:";
    }
    if (!g_timePickerState->minuteArray.empty() &&
        g_timePickerState->minuteIndex < static_cast<int32_t>(g_timePickerState->minuteArray.size())) {
        currentTime += g_timePickerState->minuteArray[g_timePickerState->minuteIndex];
    } else {
        currentTime += "00";
    }
    if (g_timePickerState->showSecond && !g_timePickerState->secondArray.empty() &&
        g_timePickerState->secondIndex < static_cast<int32_t>(g_timePickerState->secondArray.size())) {
        currentTime += ":" + g_timePickerState->secondArray[g_timePickerState->secondIndex];
    }
    ArkUI_AttributeItem contentItem = {.string = currentTime.c_str()};
    g_timePickerState->api->setAttribute(g_timePickerState->statusLabel, NODE_TEXT_CONTENT, &contentItem);
}

static void OnHourChange(int32_t selectedIndex)
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->hourIndex = selectedIndex;
    UpdateStatusLabel();
}

static void OnMinuteChange(int32_t selectedIndex)
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->minuteIndex = selectedIndex;
    UpdateStatusLabel();
}

static void OnSecondChange(int32_t selectedIndex)
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->secondIndex = selectedIndex;
    UpdateStatusLabel();
}

static void OnAmPmChange(int32_t selectedIndex)
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->amPmIndex = selectedIndex;
    UpdateStatusLabel();
}

static void UpdatePickerLoopState(std::shared_ptr<ContainerPickerTimeMaker> picker, bool canLoop)
{
    if (picker && picker->GetHandle()) {
        picker->SetCanLoop(canLoop);
    }
}

static void OnToggleLoop()
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return;
    }
    g_timePickerState->canLoop = !g_timePickerState->canLoop;
    UpdatePickerLoopState(g_timePickerState->hourPicker, g_timePickerState->canLoop);
    UpdatePickerLoopState(g_timePickerState->minutePicker, g_timePickerState->canLoop);
    UpdatePickerLoopState(g_timePickerState->secondPicker, g_timePickerState->canLoop);
    UpdatePickerLoopState(g_timePickerState->amPmPicker, g_timePickerState->canLoop);
    if (g_timePickerState->toggleLoop) {
        UpdateToggleState(g_timePickerState->toggleLoop, g_timePickerState->canLoop);
    }
}

static void OnToggleSecond()
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return;
    }
    g_timePickerState->showSecond = !g_timePickerState->showSecond;
    RecreateTimePickerLayout();
    if (g_timePickerState->toggleSecond) {
        UpdateToggleState(g_timePickerState->toggleSecond, g_timePickerState->showSecond);
    }
    UpdateStatusLabel();
}

static void OnToggleMilitary()
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return;
    }
    g_timePickerState->useMilitary = !g_timePickerState->useMilitary;
    RecreateTimePickerLayout();
    if (g_timePickerState->toggleMilitary) {
        UpdateToggleState(g_timePickerState->toggleMilitary, g_timePickerState->useMilitary);
    }
    UpdateStatusLabel();
}

static void OnToggleDigits()
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return;
    }
    g_timePickerState->zeroPrefix = !g_timePickerState->zeroPrefix;
    RegenerateHourArray();
    RegenerateMinuteSecondArray();
    if (g_timePickerState->hourPicker && g_timePickerState->hourPicker->GetHandle()) {
        UpdatePickerOptions(g_timePickerState->hourPicker->GetHandle(), g_timePickerState->hourArray);
    }
    if (g_timePickerState->minutePicker && g_timePickerState->minutePicker->GetHandle()) {
        UpdatePickerOptions(g_timePickerState->minutePicker->GetHandle(), g_timePickerState->minuteArray);
    }
    if (g_timePickerState->secondPicker && g_timePickerState->secondPicker->GetHandle()) {
        UpdatePickerOptions(g_timePickerState->secondPicker->GetHandle(), g_timePickerState->secondArray);
    }
    if (g_timePickerState->toggleDigits) {
        UpdateToggleState(g_timePickerState->toggleDigits, g_timePickerState->zeroPrefix);
    }
    UpdateStatusLabel();
}

static ArkUI_NodeHandle CreateRootContainer()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (!api) {
        return nullptr;
    }
    ArkUI_NodeHandle rootContainer = api->createNode(ARKUI_NODE_COLUMN);
    if (!rootContainer) {
        return nullptr;
    }
    ArkUI_NumberValue widthValue = {.f32 = 1.0f};
    ArkUI_AttributeItem widthItem = {&widthValue, 1};
    api->setAttribute(rootContainer, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue heightValue = {.f32 = 1.0f};
    ArkUI_AttributeItem heightItem = {&heightValue, 1};
    api->setAttribute(rootContainer, NODE_HEIGHT_PERCENT, &heightItem);
    ArkUI_NumberValue bgColorValue = {.u32 = 0xFFFFFFFF};
    ArkUI_AttributeItem bgColorItem = {&bgColorValue, 1};
    api->setAttribute(rootContainer, NODE_BACKGROUND_COLOR, &bgColorItem);
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem justifyItem = {&justifyValue, 1};
    api->setAttribute(rootContainer, NODE_COLUMN_JUSTIFY_CONTENT, &justifyItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_HORIZONTAL_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    api->setAttribute(rootContainer, NODE_COLUMN_ALIGN_ITEMS, &alignItem);
    return rootContainer;
}

static ArkUI_NodeHandle CreatePickersRowContainer()
{
    if (!g_timePickerState || !g_timePickerState->api) {
        return nullptr;
    }
    ArkUI_NodeHandle row = g_timePickerState->api->createNode(ARKUI_NODE_ROW);
    if (!row) {
        return nullptr;
    }
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    g_timePickerState->api->setAttribute(row, NODE_ROW_ALIGN_ITEMS, &alignItem);
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem justifyItem = {&justifyValue, 1};
    g_timePickerState->api->setAttribute(row, NODE_ROW_JUSTIFY_CONTENT, &justifyItem);
    return row;
}

static void CreateStatusLabel(ArkUI_NodeHandle rootContainer)
{
    if (!g_timePickerState || !g_timePickerState->api || !rootContainer) {
        return;
    }
    auto api = g_timePickerState->api;
    ArkUI_NodeHandle statusText = api->createNode(ARKUI_NODE_TEXT);
    if (!statusText) {
        return;
    }
    g_timePickerState->statusLabel = statusText;
    ArkUI_NumberValue marginValue = {.f32 = 5.0f};
    ArkUI_AttributeItem marginItem = {&marginValue, 1};
    api->setAttribute(statusText, NODE_MARGIN, &marginItem);
    ArkUI_NumberValue widthValue = {.f32 = 0.8f};
    ArkUI_AttributeItem widthItem = {&widthValue, 1};
    api->setAttribute(statusText, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue alignValue = {.i32 = ARKUI_TEXT_CONTENT_ALIGN_CENTER};
    ArkUI_AttributeItem alignItem = {&alignValue, 1};
    api->setAttribute(statusText, NODE_TEXT_CONTENT_ALIGN, &alignItem);
    ArkUI_NumberValue fontSizeValue = {.f32 = 20.0f};
    ArkUI_AttributeItem fontSizeItem = {&fontSizeValue, 1};
    api->setAttribute(statusText, NODE_FONT_SIZE, &fontSizeItem);
    ArkUI_NumberValue borderValue = {.f32 = 1.0f};
    ArkUI_AttributeItem borderItem = {&borderValue, 1};
    api->setAttribute(statusText, NODE_BORDER_WIDTH, &borderItem);
    ArkUI_NodeHandle statusRow = api->createNode(ARKUI_NODE_ROW);
    if (statusRow) {
        api->addChild(statusRow, statusText);
        api->addChild(rootContainer, statusRow);
    }
}

static void CreateControlPanel(ArkUI_NodeHandle rootContainer)
{
    if (!g_timePickerState || !g_timePickerState->api || !rootContainer) {
        return;
    }
    auto api = g_timePickerState->api;
    g_timePickerState->controlPanel = api->createNode(ARKUI_NODE_COLUMN);
    if (!g_timePickerState->controlPanel) {
        return;
    }
    g_timePickerState->toggleLoop = CreateToggleButton("loop", g_timePickerState->canLoop, EVENT_TOGGLE_LOOP);
    if (g_timePickerState->toggleLoop) {
        api->addChild(g_timePickerState->controlPanel, g_timePickerState->toggleLoop);
    }
    g_timePickerState->toggleSecond =
        CreateToggleButton("show second", g_timePickerState->showSecond, EVENT_TOGGLE_SECOND);
    if (g_timePickerState->toggleSecond) {
        api->addChild(g_timePickerState->controlPanel, g_timePickerState->toggleSecond);
    }
    g_timePickerState->toggleMilitary =
        CreateToggleButton("use military", g_timePickerState->useMilitary, EVENT_TOGGLE_MILITARY);
    if (g_timePickerState->toggleMilitary) {
        api->addChild(g_timePickerState->controlPanel, g_timePickerState->toggleMilitary);
    }
    g_timePickerState->toggleDigits =
        CreateToggleButton("2-digits", g_timePickerState->zeroPrefix, EVENT_TOGGLE_DIGITS);
    if (g_timePickerState->toggleDigits) {
        api->addChild(g_timePickerState->controlPanel, g_timePickerState->toggleDigits);
    }
    api->addChild(rootContainer, g_timePickerState->controlPanel);
}

static void InitializeTimePickerData()
{
    if (!g_timePickerState) {
        return;
    }
    g_timePickerState->amPmArray = {"AM", "PM"};
    RegenerateHourArray();
    RegenerateMinuteSecondArray();
    LogMinuteSecondArray();
}

static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (!event) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    if (eventId == EVENT_HOUR_CHANGE) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent) {
            OnHourChange(componentEvent->data[0].i32);
        }
    } else if (eventId == EVENT_MINUTE_CHANGE) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent) {
            OnMinuteChange(componentEvent->data[0].i32);
        }
    } else if (eventId == EVENT_SECOND_CHANGE) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent) {
            OnSecondChange(componentEvent->data[0].i32);
        }
    } else if (eventId == EVENT_AMPM_CHANGE) {
        ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
        if (componentEvent) {
            OnAmPmChange(componentEvent->data[0].i32);
        }
    } else if (eventId == EVENT_TOGGLE_LOOP) {
        OnToggleLoop();
    } else if (eventId == EVENT_TOGGLE_SECOND) {
        OnToggleSecond();
    } else if (eventId == EVENT_TOGGLE_MILITARY) {
        OnToggleMilitary();
    } else if (eventId == EVENT_TOGGLE_DIGITS) {
        OnToggleDigits();
    }
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerTimeMaker::CreateNativeNode()
{
    ArkUI_NodeHandle rootContainer = CreateRootContainer();
    if (!rootContainer) {
        return nullptr;
    }
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (!api) {
        return nullptr;
    }
    g_timePickerState = std::make_shared<TimePickerState>();
    g_timePickerState->api = api;
    InitializeTimePickerData();
    g_timePickerState->pickersRow = CreatePickersRowContainer();
    if (g_timePickerState->pickersRow) {
        api->addChild(rootContainer, g_timePickerState->pickersRow);
        RecreateTimePickerLayout();
    }
    CreateStatusLabel(rootContainer);
    UpdateStatusLabel();
    CreateControlPanel(rootContainer);
    api->registerNodeEventReceiver(&OnEventReceive);
    return rootContainer;
}