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

#include "ContainerPickerRegionMaker.h"

#include <functional>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
// ===== 地区数据结构定义 =====
struct RegionData {
    std::unordered_map<std::string, std::unordered_map<std::string, std::vector<std::string>>> data;
};
// ===== 配置常量 =====
constexpr float K_PICKER_WIDTH_RATIO = 0.25f;
constexpr float K_ROW_WIDTH_RATIO = 1.0f;
constexpr bool K_CAN_LOOP = false;
constexpr bool K_HAPTIC_FEEDBACK = false;
// ===== 事件ID常量 =====
constexpr int32_t K_PROVINCE_CHANGE_ID = 1000;
constexpr int32_t K_PROVINCE_SCROLL_STOP_ID = 1001;
constexpr int32_t K_CITY_CHANGE_ID = 1002;
constexpr int32_t K_CITY_SCROLL_STOP_ID = 1003;
constexpr int32_t K_COUNTY_CHANGE_ID = 1004;
constexpr int32_t K_COUNTY_SCROLL_STOP_ID = 1005;
// ===== 颜色常量 =====
constexpr uint32_t K_DIVIDER_COLOR = 0xFF0000FF;
} // namespace

// ---------- 全局状态 ----------
struct RegionPickerState {
    RegionData regionData;
    int32_t provinceIndex = 0;
    int32_t cityIndex = 0;
    int32_t countyIndex = 0;
    std::vector<std::string> provinces;
    std::vector<std::string> cities;
    std::vector<std::string> counties;
    ArkUI_NodeHandle provincePicker = nullptr;
    ArkUI_NodeHandle cityPicker = nullptr;
    ArkUI_NodeHandle countyPicker = nullptr;
    ArkUI_NativeNodeAPI_1 *api = nullptr;
};

static std::shared_ptr<RegionPickerState> g_regionState;

// ---------- 初始化地区数据 ----------
static RegionData InitRegionData()
{
    RegionData data;
    std::unordered_map<std::string, std::vector<std::string>> liaoningCities;
    liaoningCities["沈阳市"] = {"沈河区", "和平区", "浑南区"};
    liaoningCities["大连市"] = {"中山区", "金州区", "长海县"};
    data.data["辽宁省"] = liaoningCities;
    std::unordered_map<std::string, std::vector<std::string>> jilinCities;
    jilinCities["长春市"] = {"南关区", "宽城区", "朝阳区"};
    jilinCities["四平市"] = {"铁西区", "铁东区", "梨树县"};
    data.data["吉林省"] = jilinCities;
    std::unordered_map<std::string, std::vector<std::string>> heilongjiangCities;
    heilongjiangCities["哈尔滨市"] = {"道里区", "道外区", "南岗区"};
    heilongjiangCities["牡丹江市"] = {"东安区", "西安区", "爱民区"};
    data.data["黑龙江省"] = heilongjiangCities;
    return data;
}

// ---------- 创建Picker选项 ----------
static ArkUI_NodeHandle CreatePickerOption(ArkUI_NativeNodeAPI_1 *api, const std::string &text)
{
    ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
    if (textNode == nullptr) {
        return nullptr;
    }
    ArkUI_AttributeItem contentItem = {.string = text.c_str()};
    api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
    ArkUI_NumberValue alignmentValue = {.i32 = ARKUI_TEXT_CONTENT_ALIGN_CENTER};
    ArkUI_AttributeItem alignmentItem = {&alignmentValue, sizeof(alignmentValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(textNode, NODE_TEXT_CONTENT_ALIGN, &alignmentItem);
    return textNode;
}

// ---------- 创建Picker ----------
static ArkUI_NodeHandle CreatePicker(ArkUI_NativeNodeAPI_1 *api, const std::vector<std::string> &options,
                                     uint32_t selectedIndex, int32_t changeEventId, int32_t scrollStopEventId)
{
    ArkUI_NodeHandle picker = api->createNode(ARKUI_NODE_PICKER);
    if (picker == nullptr) {
        return nullptr;
    }
    ArkUI_NumberValue widthValue = {.f32 = K_PICKER_WIDTH_RATIO};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue selectedValue = {.u32 = selectedIndex};
    ArkUI_AttributeItem selectedItem = {&selectedValue, sizeof(selectedValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_OPTION_SELECTED_INDEX, &selectedItem);
    ArkUI_NumberValue canLoopValue = {.i32 = K_CAN_LOOP ? 1 : 0};
    ArkUI_AttributeItem canLoopItem = {&canLoopValue, sizeof(canLoopValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_CAN_LOOP, &canLoopItem);
    ArkUI_NumberValue hapticValue = {.i32 = K_HAPTIC_FEEDBACK ? 1 : 0};
    ArkUI_AttributeItem hapticItem = {&hapticValue, sizeof(hapticValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_ENABLE_HAPTIC_FEEDBACK, &hapticItem);
    ArkUI_PickerIndicatorStyle *indicatorStyle = OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_DIVIDER);
    if (indicatorStyle != nullptr) {
        ArkUI_PickerIndicatorDivider divider = {
            .strokeWidth = 2.0f, .dividerColor = K_DIVIDER_COLOR, .startMargin = 20.0f, .endMargin = 20.0f};
        OH_ArkUI_PickerIndicatorStyle_ConfigureDivider(indicatorStyle, &divider);
        ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
        api->setAttribute(picker, NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
    }
    for (const auto &option : options) {
        ArkUI_NodeHandle textNode = CreatePickerOption(api, option);
        if (textNode != nullptr) {
            api->addChild(picker, textNode);
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

// ---------- 刷新县区数据 ----------
static void RefreshCounties()
{
    if (!g_regionState || !g_regionState->api) {
        return;
    }
    if (g_regionState->provinceIndex < 0 ||
        g_regionState->provinceIndex >= static_cast<int32_t>(g_regionState->provinces.size()) ||
        g_regionState->cityIndex < 0 ||
        g_regionState->cityIndex >= static_cast<int32_t>(g_regionState->cities.size())) {
        g_regionState->counties.clear();
        return;
    }
    std::string currentProvince = g_regionState->provinces[g_regionState->provinceIndex];
    std::string currentCity = g_regionState->cities[g_regionState->cityIndex];
    auto provinceIt = g_regionState->regionData.data.find(currentProvince);
    if (provinceIt == g_regionState->regionData.data.end()) {
        g_regionState->counties.clear();
        return;
    }
    auto cityIt = provinceIt->second.find(currentCity);
    if (cityIt == provinceIt->second.end()) {
        g_regionState->counties.clear();
        return;
    }
    g_regionState->counties = cityIt->second;
    g_regionState->countyIndex = 0;
    if (g_regionState->countyPicker && g_regionState->api) {
        ArkUI_NodeHandle child = g_regionState->api->getFirstChild(g_regionState->countyPicker);
        while (child != nullptr) {
            ArkUI_NodeHandle next = g_regionState->api->getNextSibling(child);
            g_regionState->api->removeChild(g_regionState->countyPicker, child);
            child = next;
        }
        for (const auto &county : g_regionState->counties) {
            ArkUI_NodeHandle textNode = CreatePickerOption(g_regionState->api, county);
            if (textNode != nullptr) {
                g_regionState->api->addChild(g_regionState->countyPicker, textNode);
            }
        }
        ArkUI_NumberValue selectedValue = {.u32 = 0};
        ArkUI_AttributeItem selectedItem = {&selectedValue, sizeof(selectedValue) / sizeof(ArkUI_NumberValue)};
        g_regionState->api->setAttribute(g_regionState->countyPicker, NODE_PICKER_OPTION_SELECTED_INDEX, &selectedItem);
    }
}

// ---------- 刷新城市数据 ----------
static void RefreshCities()
{
    if (!g_regionState || !g_regionState->api) {
        return;
    }
    if (g_regionState->provinceIndex < 0 ||
        g_regionState->provinceIndex >= static_cast<int32_t>(g_regionState->provinces.size())) {
        return;
    }
    std::string currentProvince = g_regionState->provinces[g_regionState->provinceIndex];
    auto provinceIt = g_regionState->regionData.data.find(currentProvince);
    if (provinceIt == g_regionState->regionData.data.end()) {
        g_regionState->cities.clear();
        return;
    }
    g_regionState->cities.clear();
    for (const auto &cityPair : provinceIt->second) {
        g_regionState->cities.push_back(cityPair.first);
    }
    g_regionState->cityIndex = 0;
    if (g_regionState->cityPicker && g_regionState->api) {
        ArkUI_NodeHandle child = g_regionState->api->getFirstChild(g_regionState->cityPicker);
        while (child != nullptr) {
            ArkUI_NodeHandle next = g_regionState->api->getNextSibling(child);
            g_regionState->api->removeChild(g_regionState->cityPicker, child);
            child = next;
        }
        for (const auto &city : g_regionState->cities) {
            ArkUI_NodeHandle textNode = CreatePickerOption(g_regionState->api, city);
            if (textNode != nullptr) {
                g_regionState->api->addChild(g_regionState->cityPicker, textNode);
            }
        }
        ArkUI_NumberValue selectedValue = {.u32 = 0};
        ArkUI_AttributeItem selectedItem = {&selectedValue, sizeof(selectedValue) / sizeof(ArkUI_NumberValue)};
        g_regionState->api->setAttribute(g_regionState->cityPicker, NODE_PICKER_OPTION_SELECTED_INDEX, &selectedItem);
    }
    RefreshCounties();
}

// ---------- 事件回调函数 ----------
static void OnProvinceChange(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->provinceIndex = selectedIndex;
    RefreshCities();
}

static void OnProvinceScrollStop(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->provinceIndex = selectedIndex;
}

static void OnCityChange(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->cityIndex = selectedIndex;
    RefreshCounties();
}

static void OnCityScrollStop(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->cityIndex = selectedIndex;
}

static void OnCountyChange(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->countyIndex = selectedIndex;
}

static void OnCountyScrollStop(ArkUI_NodeEvent *event)
{
    if (!g_regionState || !event) {
        return;
    }
    ArkUI_NodeComponentEvent *componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    g_regionState->countyIndex = selectedIndex;
}

// ---------- 全局事件接收器 ----------
static void OnEventReceive(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    switch (eventId) {
        case K_PROVINCE_CHANGE_ID:
            OnProvinceChange(event);
            break;
        case K_PROVINCE_SCROLL_STOP_ID:
            OnProvinceScrollStop(event);
            break;
        case K_CITY_CHANGE_ID:
            OnCityChange(event);
            break;
        case K_CITY_SCROLL_STOP_ID:
            OnCityScrollStop(event);
            break;
        case K_COUNTY_CHANGE_ID:
            OnCountyChange(event);
            break;
        case K_COUNTY_SCROLL_STOP_ID:
            OnCountyScrollStop(event);
            break;
        default:
            break;
    }
}

// ---------- 创建地区选择器 ----------
static ArkUI_NodeHandle CreateRegionPicker(ArkUI_NativeNodeAPI_1 *api)
{
    if (!api) {
        return nullptr;
    }
    g_regionState = std::make_shared<RegionPickerState>();
    g_regionState->api = api;
    g_regionState->regionData = InitRegionData();
    for (const auto &provincePair : g_regionState->regionData.data) {
        g_regionState->provinces.push_back(provincePair.first);
    }
    RefreshCities();
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
    ArkUI_NodeHandle rowContainer = api->createNode(ARKUI_NODE_ROW);
    if (!rowContainer) {
        api->disposeNode(rootContainer);
        return nullptr;
    }
    ArkUI_NumberValue rowWidthValue = {.f32 = K_ROW_WIDTH_RATIO};
    ArkUI_AttributeItem rowWidthItem = {&rowWidthValue, 1};
    api->setAttribute(rowContainer, NODE_WIDTH_PERCENT, &rowWidthItem);
    ArkUI_NumberValue justifyValue = {.i32 = ARKUI_FLEX_ALIGNMENT_CENTER};
    ArkUI_AttributeItem justifyItem = {&justifyValue, 1};
    api->setAttribute(rowContainer, NODE_ROW_JUSTIFY_CONTENT, &justifyItem);
    g_regionState->provincePicker =
        CreatePicker(api, g_regionState->provinces, 0, K_PROVINCE_CHANGE_ID, K_PROVINCE_SCROLL_STOP_ID);
    g_regionState->cityPicker = CreatePicker(api, g_regionState->cities, 0, K_CITY_CHANGE_ID, K_CITY_SCROLL_STOP_ID);
    g_regionState->countyPicker =
        CreatePicker(api, g_regionState->counties, 0, K_COUNTY_CHANGE_ID, K_COUNTY_SCROLL_STOP_ID);
    if (g_regionState->provincePicker) {
        api->addChild(rowContainer, g_regionState->provincePicker);
    }
    if (g_regionState->cityPicker) {
        api->addChild(rowContainer, g_regionState->cityPicker);
    }
    if (g_regionState->countyPicker) {
        api->addChild(rowContainer, g_regionState->countyPicker);
    }
    api->addChild(rootContainer, rowContainer);
    return rootContainer;
}

// ---------- 主创建函数 ----------
ArkUI_NodeHandle ContainerPickerRegionMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    if (api == nullptr) {
        return nullptr;
    }
    ArkUI_NodeHandle regionPicker = CreateRegionPicker(api);
    if (regionPicker) {
        api->registerNodeEventReceiver(&OnEventReceive);
    }
    return regionPicker;
}