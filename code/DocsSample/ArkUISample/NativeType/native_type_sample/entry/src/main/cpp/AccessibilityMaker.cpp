/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <AbilityKit/ability_base/want.h>
#include <hilog/log.h>
#include "AccessibilityMaker.h"

constexpr int32_t ACCESSIBILITY_VALUE_MIN = 0;
constexpr int32_t ACCESSIBILITY_VALUE_MAX = 100;
constexpr int32_t ACCESSIBILITY_VALUE_CURRENT = 50;
constexpr int32_t ACCESSIBILITY_RANGE_MIN = 0;
constexpr int32_t ACCESSIBILITY_RANGE_MAX = 10;
constexpr int32_t ACCESSIBILITY_RANGE_CURRENT = 5;
constexpr int EVENT_ID = 11111;
constexpr float COL_WIDTH_PX = 300.0f;
constexpr float TEXT_WIDTH_PX = 300.0f;
constexpr float TEXT_HEIGHT_PX = 100.0f;
constexpr float BORDER_WIDTH_PX = 1.0f;
constexpr float BUTTON_WIDTH_PX = 200.0f;
constexpr float BUTTON_HEIGHT_PX = 50.0f;
constexpr float BUTTON_MARGIN_PX = 5.0f;
constexpr const char* SAMPLE_TEXT = "Hello Accessibility Sample";
constexpr const char* ACCESSIBILITY_VALUE_TEXT = "Value";
static ArkUI_AccessibilityState* accessibilityState_;
static ArkUI_AccessibilityValue* accessibilityValue_;

void AccessibilityMaker::CreateAccessibilitySelectedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "1. 通过 OH_ArkUI_AccessibilityState_SetSelected 设置无障碍状态:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "Hello Accessibility Sample(non-selected)");
    ArkUI_NodeHandle text3 = BuildTextNode(nodeApi, "Hello Accessibility Sample(selected)");
    CreateAccessibilityState();
    SetAccessibilityDisabled(false);
    bool disabled = IsAccessibilityDisabled();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilityDisabled: disabled=%{public}d",
        disabled);
    SetAccessibilitySelected(true);
    bool selected = IsAccessibilitySelected();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilitySelected: selected=%{public}d",
        selected);
    ArkUI_AttributeItem accessibilityItem = { .object = accessibilityState_ };
    nodeApi->setAttribute(text3, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    SetAccessibilitySelected(false);
    accessibilityItem = { .object = accessibilityState_ };
    nodeApi->setAttribute(text2, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    nodeApi->addChild(column, text2);
    nodeApi->addChild(column, text3);
    nodeApi->addChild(parent, column);
}

void AccessibilityMaker::CreateAccessibilityCheckedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "2. 通过 OH_ArkUI_AccessibilityState_SetCheckedState 设置无障碍状态:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle checkbox = nodeApi->createNode(ARKUI_NODE_CHECKBOX);
    ArkUI_NodeHandle checkbox2 = nodeApi->createNode(ARKUI_NODE_CHECKBOX);
    CreateAccessibilityState();
    SetAccessibilityDisabled(false);
    bool disabled = IsAccessibilityDisabled();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilityDisabled: disabled=%{public}d",
        disabled);
    SetAccessibilityCheckedState(ARKUI_ACCESSIBILITY_UNCHECKED);
    int32_t checkedState = GetAccessibilityCheckedState();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityCheckedState: state=%{public}d",
        checkedState);
    ArkUI_AttributeItem accessibilityItem = { .object = accessibilityState_ };
    nodeApi->setAttribute(parent, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    SetAccessibilityCheckedState(ARKUI_ACCESSIBILITY_CHECKED);
    accessibilityItem = { .object = accessibilityState_ };
    nodeApi->setAttribute(checkbox2, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    nodeApi->addChild(column, checkbox);
    nodeApi->addChild(column, checkbox2);
    nodeApi->addChild(parent, column);
}

void AccessibilityMaker::CreateAccessibilityValueSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "3. 通过 NODE_ACCESSIBILITY_VALUE 设置无障碍信息属性:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    CreateAccessibilityValue();
    SetAccessibilityValueMin(ACCESSIBILITY_VALUE_MIN);
    int32_t valueMin = GetAccessibilityValueMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMin: min=%{public}d", valueMin);
    SetAccessibilityValueMax(ACCESSIBILITY_VALUE_MAX);
    int32_t valueMax = GetAccessibilityValueMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMax: max=%{public}d", valueMax);
    SetAccessibilityValueCurrent(ACCESSIBILITY_VALUE_CURRENT);
    int32_t valueCurrent = GetAccessibilityValueCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueCurrent: current=%{public}d",
        valueCurrent);
    SetAccessibilityValueText(ACCESSIBILITY_VALUE_TEXT);
    const char* valueText = GetAccessibilityValueText();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueText: text=%{public}s",
        valueText);
    SetAccessibilityRangeMin(ACCESSIBILITY_RANGE_MIN);
    int32_t rangeMin = GetAccessibilityRangeMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMin: min=%{public}d", rangeMin);
    SetAccessibilityRangeMax(ACCESSIBILITY_RANGE_MAX);
    int32_t rangeMax = GetAccessibilityValueMax();
    rangeMax = GetAccessibilityRangeMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMax: max=%{public}d", rangeMax);
    SetAccessibilityRangeCurrent(ACCESSIBILITY_RANGE_CURRENT);
    int32_t rangeCurrent = GetAccessibilityRangeCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeCurrent: current=%{public}d",
        rangeCurrent);
    ArkUI_AttributeItem accessibilityValueItem = { .object = accessibilityValue_ };
    nodeApi->setAttribute(text2, NODE_ACCESSIBILITY_VALUE, &accessibilityValueItem);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateAccessibilityNodeIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi, "4. 通过 NODE_ID 获取无障碍节点ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    SetNodeId(nodeApi, text2, "test node id");
    const char* nodeId = GetNodeId(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetNodeId: id=%{public}s", nodeId);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateAccessibilityGroupSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "5. 通过 NODE_ACCESSIBILITY_GROUP 设置无障碍分组:");
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "column子节点1");
    ArkUI_NodeHandle text3 = BuildTextNode(nodeApi, "column子节点2");
    SetAccessibilityGroup(nodeApi, column, true);
    bool isGroup = GetAccessibilityGroup(nodeApi, column);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityGroup: isGroup=%{public}d", isGroup);
    nodeApi->addChild(column, text2);
    nodeApi->addChild(column, text3);
    nodeApi->addChild(parent, text1);
    nodeApi->addChild(parent, column);
}

void AccessibilityMaker::CreateAccessibilityModeSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "6. 通过 NODE_ACCESSIBILITY_MODE 设置无障碍辅助服务模式(ACCESSIBILITY_MODE):");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "Hello Accessibility Sample(DISABLED, 不可被无障碍辅助服务所识别)");
    SetAccessibilityMode(nodeApi, text2, ARKUI_ACCESSIBILITY_MODE_DISABLED);
    ArkUI_AccessibilityMode mode = GetAccessibilityMode(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityMode: mode=%{public}d", mode);
    nodeApi->addChild(parent, text2);
}


void AccessibilityMaker::CreateAccessibilityTextSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "7. 通过 NODE_ACCESSIBILITY_TEXT 设置无障碍文本:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    SetAccessibilityText(nodeApi, text2, "This is a text");
    const char* accessibilityText = GetAccessibilityText(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityText: text=%{public}s",
        accessibilityText);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateAccessibilityDescriptionSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "8. 通过 NODE_ACCESSIBILITY_DESCRIPTION 设置无障碍描述:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    SetAccessibilityDescription(nodeApi, text2, "This is accessibility description");
    const char* description = GetAccessibilityDescription(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityDescription: description=%{public}s",
        description);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateAccessibilityIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "9. 通过 NODE_ACCESSIBILITY_ID 获取无障碍ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    int accessibilityId = GetAccessibilityId(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityId: id=%{public}d", accessibilityId);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateAccessibilityActionsSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi, "10. 设置无障碍支持操作事件:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle button = nodeApi->createNode(ARKUI_NODE_BUTTON);
    ArkUI_NumberValue button_widthValue[] = {BUTTON_WIDTH_PX};
    ArkUI_AttributeItem button_widthItem = {button_widthValue, 1};
    ArkUI_NumberValue button_heightValue1[] = {BUTTON_HEIGHT_PX};
    ArkUI_AttributeItem button_heightItem = {button_heightValue1, 1};
    ArkUI_NumberValue marginValue[] = {BUTTON_MARGIN_PX};
    ArkUI_AttributeItem marginItem = {marginValue, 1};
    nodeApi->setAttribute(button, NODE_WIDTH, &button_widthItem);
    nodeApi->setAttribute(button, NODE_HEIGHT, &button_heightItem);
    nodeApi->setAttribute(button, NODE_MARGIN, &marginItem);
    SetAccessibilityActions(nodeApi, button);
    nodeApi->registerNodeEvent(button, NODE_ON_CLICK, 0, nullptr);
    nodeApi->registerNodeEvent(button, NODE_ON_ACCESSIBILITY_ACTIONS, EVENT_ID, nullptr);
    nodeApi->registerNodeEventReceiver([](ArkUI_NodeEvent *event) {
        auto eventId = OH_ArkUI_NodeEvent_GetTargetId(event);
        if (eventId == EVENT_ID) {
            auto componentEvent = OH_ArkUI_NodeEvent_GetNodeComponentEvent(event);
            auto actionType = componentEvent->data[0].u32;
            switch (actionType) {
                case ARKUI_ACCESSIBILITY_ACTION_CLICK:
                    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "ARKUI_ACCESSIBILITY_ACTION_CLICK");
                    break;
                default:
                    break;
            }
        }
    });
    nodeApi->addChild(parent, button);
}

void AccessibilityMaker::CreateAccessibilityRoleSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "11. 通过 NODE_ACCESSIBILITY_ROLE 设置无障碍组件类型:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    SetAccessibilityRole(nodeApi, text2, ARKUI_NODE_TEXT);
    uint32_t role = GetAccessibilityRole(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRole: role=%{public}u", role);
    nodeApi->addChild(parent, text2);
}

void AccessibilityMaker::CreateUniqueIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "12. 通过 NODE_UNIQUE_ID 获取唯一ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    GetUniqueId(nodeApi, text2);
    nodeApi->addChild(parent, text2);
}

ArkUI_NodeHandle AccessibilityMaker::CreateNativeNode()
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return nullptr;
    }
    // 创建一个Column容器组件
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    // 创建Text组件
    ArkUI_NodeHandle text = BuildTextNode(nodeApi, SAMPLE_TEXT);

    auto scrollNode = nodeApi->createNode(ARKUI_NODE_SCROLL);
    nodeApi->addChild(scrollNode, column);

    CreateAccessibilitySelectedSection(nodeApi, column);
    CreateAccessibilityCheckedSection(nodeApi, column);
    CreateAccessibilityValueSection(nodeApi, column);
    CreateAccessibilityNodeIdSection(nodeApi, column);
    CreateAccessibilityGroupSection(nodeApi, column);
    CreateAccessibilityModeSection(nodeApi, column);
    CreateAccessibilityTextSection(nodeApi, column);
    CreateAccessibilityDescriptionSection(nodeApi, column);
    CreateAccessibilityIdSection(nodeApi, column);
    CreateAccessibilityActionsSection(nodeApi, column);
    CreateAccessibilityRoleSection(nodeApi, column);
    CreateUniqueIdSection(nodeApi, column);

    // Column作为XComponent子组件
    return scrollNode;
}

ArkUI_NodeHandle AccessibilityMaker::BuildTextNodeWithoutAccessibilityFocus(ArkUI_NativeNodeAPI_1* nodeApi,
    const char* content)
{
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = TEXT_WIDTH_PX}};
    ArkUI_AttributeItem textWidthItem = { textWidth, sizeof(textWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = TEXT_HEIGHT_PX}};
    ArkUI_AttributeItem textHeightItem = { textHeight, sizeof(textHeight) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_AttributeItem valueItem = {.string = content};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT, &valueItem);
    SetAccessibilityMode(nodeApi, text, ARKUI_ACCESSIBILITY_MODE_DISABLED);
    return text;
}
ArkUI_NodeHandle AccessibilityMaker::BuildTextNode(ArkUI_NativeNodeAPI_1* nodeApi, const char* content)
{
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = TEXT_WIDTH_PX}};
    ArkUI_AttributeItem textWidthItem = { textWidth, sizeof(textWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = TEXT_HEIGHT_PX}};
    ArkUI_AttributeItem textHeightItem = { textHeight, sizeof(textHeight) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_AttributeItem valueItem = {.string = content};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT, &valueItem);
    return text;
}

ArkUI_NodeHandle AccessibilityMaker::BuildColumnNode(ArkUI_NativeNodeAPI_1* nodeApi)
{
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = COL_WIDTH_PX}};
    ArkUI_AttributeItem widthItem = { colWidth, sizeof(colWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    return column;
}

AccessibilityMaker::~AccessibilityMaker()
{
    DisposeAccessibilityState();
    DisposeAccessibilityValue();
}

void AccessibilityMaker::CreateAccessibilityState()
{
    if (!accessibilityState_) {
        accessibilityState_ = OH_ArkUI_AccessibilityState_Create();
    }
}

void AccessibilityMaker::SetAccessibilityDisabled(bool isDisabled)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetDisabled(accessibilityState_, isDisabled);
    }
}

bool AccessibilityMaker::IsAccessibilityDisabled()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_IsDisabled(accessibilityState_);
    }
    return false;
}

void AccessibilityMaker::SetAccessibilitySelected(bool isSelected)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetSelected(accessibilityState_, isSelected);
    }
}

bool AccessibilityMaker::IsAccessibilitySelected()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_IsSelected(accessibilityState_);
    }
    return false;
}

void AccessibilityMaker::SetAccessibilityCheckedState(int32_t checkedState)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetCheckedState(accessibilityState_, checkedState);
    }
}

int32_t AccessibilityMaker::GetAccessibilityCheckedState()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_GetCheckedState(accessibilityState_);
    }
    return 0;
}

void AccessibilityMaker::DisposeAccessibilityState()
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_Dispose(accessibilityState_);
        accessibilityState_ = nullptr;
    }
}

void AccessibilityMaker::CreateAccessibilityValue()
{
    if (!accessibilityValue_) {
        accessibilityValue_ = OH_ArkUI_AccessibilityValue_Create();
    }
}

void AccessibilityMaker::DisposeAccessibilityValue()
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_Dispose(accessibilityValue_);
        accessibilityValue_ = nullptr;
    }
}

void AccessibilityMaker::SetAccessibilityValueMin(int32_t min)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetMin(accessibilityValue_, min);
    }
}

int32_t AccessibilityMaker::GetAccessibilityValueMin()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetMin(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetAccessibilityValueMax(int32_t max)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetMax(accessibilityValue_, max);
    }
}

int32_t AccessibilityMaker::GetAccessibilityValueMax()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetMax(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetAccessibilityValueCurrent(int32_t current)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetCurrent(accessibilityValue_, current);
    }
}

int32_t AccessibilityMaker::GetAccessibilityValueCurrent()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetCurrent(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetAccessibilityValueText(const char* text)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetText(accessibilityValue_, text);
    }
}

const char* AccessibilityMaker::GetAccessibilityValueText()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetText(accessibilityValue_);
    }
    return nullptr;
}

void AccessibilityMaker::SetAccessibilityRangeMin(int32_t rangeMin)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeMin(accessibilityValue_, rangeMin);
    }
}

int32_t AccessibilityMaker::GetAccessibilityRangeMin()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeMin(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetAccessibilityRangeMax(int32_t rangeMax)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeMax(accessibilityValue_, rangeMax);
    }
}

int32_t AccessibilityMaker::GetAccessibilityRangeMax()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeMax(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetAccessibilityRangeCurrent(int32_t rangeCurrent)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeCurrent(accessibilityValue_, rangeCurrent);
    }
}

int32_t AccessibilityMaker::GetAccessibilityRangeCurrent()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeCurrent(accessibilityValue_);
    }
    return 0;
}

void AccessibilityMaker::SetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* id)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem idItem = {.string = id};
        nodeApi->setAttribute(node, NODE_ID, &idItem);
    }
}

const char* AccessibilityMaker::GetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, NODE_ID);
        if (attributeItem) {
            return attributeItem->string;
        }
    }
    return nullptr;
}

void AccessibilityMaker::SetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, bool isGroup)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{.i32 = isGroup}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_GROUP, &item);
    }
}

bool AccessibilityMaker::GetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_GROUP);
        if (attributeItem) {
            return attributeItem->value[0].i32;
        }
    }
    return false;
}

void AccessibilityMaker::SetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
    ArkUI_AccessibilityMode mode)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{.i32 = mode}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_MODE, &item);
    }
}

ArkUI_AccessibilityMode AccessibilityMaker::GetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_MODE);
        if (attr && attr->size > 0) {
            return static_cast<ArkUI_AccessibilityMode>(attr->value[0].i32);
        }
    }
    return ARKUI_ACCESSIBILITY_MODE_AUTO;
}

void AccessibilityMaker::SetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
    const char* description)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem item = {.string = description};
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_DESCRIPTION, &item);
    }
}

const char* AccessibilityMaker::GetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_DESCRIPTION);
        if (attr) {
            return attr->string;
        }
    }
    return nullptr;
}

int AccessibilityMaker::GetAccessibilityId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ID);
        if (attr && attr->size > 0) {
            return attr->value[0].i32;
        }
    }
    return -1;
}

void AccessibilityMaker::SetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* text)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem item = {.string = text};
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_TEXT, &item);
    }
}

const char* AccessibilityMaker::GetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_TEXT);
        if (attr) {
            return attr->string;
        }
    }
    return nullptr;
}

void AccessibilityMaker::SetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{ .u32 = ARKUI_ACCESSIBILITY_ACTION_CLICK}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_ACTIONS, &item);
    }
}

uint32_t AccessibilityMaker::GetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ACTIONS);
        if (attr && attr->size > 0) {
            return attr->value[0].u32;
        }
    }
    return 0U;
}

void AccessibilityMaker::SetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
    const uint32_t role)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{ .u32 = role}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_ROLE, &item);
    }
}

uint32_t AccessibilityMaker::GetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ROLE);
        if (attr && attr->size > 0) {
            return attr->value[0].u32;
        }
    }
    return 0U;
}

void AccessibilityMaker::GetUniqueId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem *attributeItem = nodeApi->getAttribute(node, NODE_UNIQUE_ID);
        // 组件id作为targetid来区分不同组件的事件。
        auto id = attributeItem->value[0].i32;
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetUniqueId: id=%{public}d", id);
    }
}