/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */

#include "ContainerPickerMaker.h"

#include <arkui/native_node.h>
#include <arkui/native_type.h>

namespace {
constexpr int32_t MONTH_COUNT = 12;
constexpr int32_t INITIAL_SELECTED_INDEX = 2;
constexpr float PICKER_WIDTH_RATIO = 0.5f;
constexpr float PICKER_HEIGHT_RATIO = 0.5f;
constexpr float OPTION_WIDTH_RATIO = 0.3f;
constexpr int32_t CHANGE_EVENT_ID = 2;
constexpr int32_t SCROLL_STOP_EVENT_ID = 3;
constexpr uint32_t BACKGROUND_COLOR = 0xD3D3D3D3;
constexpr float CORNER_RADIUS = 10.0f;
} // namespace

ArkUI_NodeHandle ContainerPickerMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *api = GetNativeNodeAPI();
    if (api == nullptr) {
        return nullptr;
    }
    ArkUI_NodeHandle container = CreateFullScreenContainer(api);
    ArkUI_NodeHandle picker = CreateContainerPicker(api);
    if (picker != nullptr && container != nullptr) {
        api->addChild(container, picker);
    }
    return container;
}

ArkUI_NativeNodeAPI_1 *ContainerPickerMaker::GetNativeNodeAPI()
{
    ArkUI_NativeNodeAPI_1 *api = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, api);
    return api;
}

ArkUI_NodeHandle ContainerPickerMaker::CreateFullScreenContainer(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle container = api->createNode(ARKUI_NODE_COLUMN);
    if (container == nullptr) {
        return nullptr;
    }
    SetAttributeFloat32(api, container, NODE_WIDTH_PERCENT, 1.0f);
    SetAttributeFloat32(api, container, NODE_HEIGHT_PERCENT, 1.0f);
    return container;
}

ArkUI_NodeHandle ContainerPickerMaker::CreateContainerPicker(ArkUI_NativeNodeAPI_1 *api)
{
    ArkUI_NodeHandle picker = api->createNode(ARKUI_NODE_PICKER);
    if (picker == nullptr) {
        return nullptr;
    }
    // 设置尺寸
    ArkUI_NumberValue widthValue = {.f32 = PICKER_WIDTH_RATIO};
    ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_WIDTH_PERCENT, &widthItem);
    ArkUI_NumberValue heightValue = {.f32 = PICKER_HEIGHT_RATIO};
    ArkUI_AttributeItem heightItem = {&heightValue, sizeof(heightValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_HEIGHT_PERCENT, &heightItem);
    // 配置各个组件
    SetupPickerOptions(api, picker);
    ConfigurePickerProperties(api, picker);
    SetupPickerEvents(api, picker);
    SetupPickerIndicator(api, picker);
    return picker;
}

void ContainerPickerMaker::SetupPickerOptions(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker)
{
    const char *monthNames[MONTH_COUNT] = {"一月", "二月", "三月", "四月", "五月",   "六月",
                                           "七月", "八月", "九月", "十月", "十一月", "十二月"};
    for (int i = 0; i < MONTH_COUNT; ++i) {
        ArkUI_NodeHandle textNode = api->createNode(ARKUI_NODE_TEXT);
        if (textNode == nullptr) {
            continue;
        }
        // 设置文本内容
        ArkUI_AttributeItem contentItem = {.string = monthNames[i]};
        api->setAttribute(textNode, NODE_TEXT_CONTENT, &contentItem);
        // 设置宽度
        ArkUI_NumberValue widthValue = {.f32 = OPTION_WIDTH_RATIO};
        ArkUI_AttributeItem widthItem = {&widthValue, sizeof(widthValue) / sizeof(ArkUI_NumberValue)};
        api->setAttribute(textNode, NODE_WIDTH_PERCENT, &widthItem);
        // 添加到picker
        api->addChild(picker, textNode);
    }
}

void ContainerPickerMaker::ConfigurePickerProperties(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker)
{
    // 设置选中项
    ArkUI_NumberValue selectedIndexValue = {.i32 = INITIAL_SELECTED_INDEX};
    ArkUI_AttributeItem selectedIndexItem = {&selectedIndexValue,
                                             sizeof(selectedIndexValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_OPTION_SELECTED_INDEX, &selectedIndexItem);
    // 设置循环滚动
    ArkUI_NumberValue canLoopValue = {.i32 = true};
    ArkUI_AttributeItem canLoopItem = {&canLoopValue, sizeof(canLoopValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_CAN_LOOP, &canLoopItem);
    // 设置触感反馈
    ArkUI_NumberValue enableHapticFeedbackValue = {.i32 = true};
    ArkUI_AttributeItem enableHapticFeedbackItem = {&enableHapticFeedbackValue,
                                                    sizeof(enableHapticFeedbackValue) / sizeof(ArkUI_NumberValue)};
    api->setAttribute(picker, NODE_PICKER_ENABLE_HAPTIC_FEEDBACK, &enableHapticFeedbackItem);
}

void ContainerPickerMaker::SetupPickerEvents(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker)
{
    api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_CHANGE, CHANGE_EVENT_ID, nullptr);
    api->registerNodeEvent(picker, NODE_PICKER_EVENT_ON_SCROLL_STOP, SCROLL_STOP_EVENT_ID, nullptr);
    api->registerNodeEventReceiver(OnPickerEventCallback);
}

void ContainerPickerMaker::SetupPickerIndicator(ArkUI_NativeNodeAPI_1 *api, ArkUI_NodeHandle picker)
{
    ArkUI_PickerIndicatorStyle *indicatorStyle =
        OH_ArkUI_PickerIndicatorStyle_Create(ARKUI_PICKER_INDICATOR_BACKGROUND);
    ArkUI_PickerIndicatorBackground background = {.backgroundColor = BACKGROUND_COLOR,
                                                  .topLeftRadius = CORNER_RADIUS,
                                                  .topRightRadius = CORNER_RADIUS,
                                                  .bottomLeftRadius = CORNER_RADIUS,
                                                  .bottomRightRadius = CORNER_RADIUS};
    OH_ArkUI_PickerIndicatorStyle_ConfigureBackground(indicatorStyle, &background);
    ArkUI_AttributeItem selectionIndicatorItem = {.object = indicatorStyle};
    api->setAttribute(picker, NODE_PICKER_SELECTION_INDICATOR, &selectionIndicatorItem);
}

void ContainerPickerMaker::OnPickerEventCallback(ArkUI_NodeEvent *event)
{
    if (event == nullptr) {
        return;
    }
    int32_t eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
    auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
    if (componentEvent == nullptr || componentEvent->data == nullptr) {
        return;
    }
    int32_t selectedIndex = componentEvent->data[0].i32;
    if (eventId == CHANGE_EVENT_ID) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "containerPicker", "NODE_PICKER_EVENT_ON_CHANGE :%{public}d",
                     selectedIndex);
    } else if (eventId == SCROLL_STOP_EVENT_ID) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, "containerPicker", "NODE_PICKER_EVENT_ON_SCROLL_STOP :%{public}d",
                     selectedIndex);
    }
}