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
#include "manager.h"
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <AbilityKit/ability_base/want.h>
#include <hilog/log.h>

namespace NativeNode::Manager {
constexpr int32_t ACCESSIBILITY_VALUE_MIN = 0;
constexpr int32_t ACCESSIBILITY_VALUE_MAX = 100;
constexpr int32_t ACCESSIBILITY_VALUE_CURRENT = 50;
constexpr const char* ACCESSIBILITY_VALUE_TEXT = "Value";
constexpr int32_t ACCESSIBILITY_RANGE_MIN = 0;
constexpr int32_t ACCESSIBILITY_RANGE_MAX = 10;
constexpr int32_t ACCESSIBILITY_RANGE_CURRENT = 5;
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;
constexpr float COL_WIDTH_PX = 300.0f;
constexpr float TEXT_WIDTH_PX = 300.0f;
constexpr float TEXT_HEIGHT_PX = 100.0f;
constexpr float BORDER_WIDTH_PX = 1.0f;
constexpr int WANT_STR_BUF_LEN = 10;
constexpr int WANT_STR_COPY_LEN = 5;
constexpr int WANT_URI_BUF_LEN = 10;
constexpr int WANT_URI_COPY_LEN = 5;
constexpr int EMBEDDED_COMPONENT_WIDTH = 480;
constexpr float BUTTON_WIDTH_PX = 200.0f;
constexpr float BUTTON_HEIGHT_PX = 50.0f;
constexpr float BUTTON_MARGIN_PX = 5.0f;
constexpr int EVENT_ID = 11111;
constexpr const char* SAMPLE_TEXT = "Hello Accessibility Sample";

void NodeManager::CreateAccessibilitySelectedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "1. 通过 OH_ArkUI_AccessibilityState_SetSelected 设置无障碍状态:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "Hello Accessibility Sample(non-selected)");
    ArkUI_NodeHandle text3 = BuildTextNode(nodeApi, "Hello Accessibility Sample(selected)");
    this->CreateAccessibilityState();
    this->SetAccessibilityDisabled(false);
    bool disabled = this->IsAccessibilityDisabled();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilityDisabled: disabled=%{public}d",
        disabled);
    this->SetAccessibilitySelected(true);
    bool selected = this->IsAccessibilitySelected();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilitySelected: selected=%{public}d",
        selected);
    ArkUI_AttributeItem accessibilityItem = { .object = this->accessibilityState_ };
    nodeApi->setAttribute(text3, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    this->SetAccessibilitySelected(false);
    accessibilityItem = { .object = this->accessibilityState_ };
    nodeApi->setAttribute(text2, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    nodeApi->addChild(column, text2);
    nodeApi->addChild(column, text3);
    nodeApi->addChild(parent, column);
}

void NodeManager::CreateAccessibilityCheckedSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "2. 通过 OH_ArkUI_AccessibilityState_SetCheckedState 设置无障碍状态:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle checkbox = nodeApi->createNode(ARKUI_NODE_CHECKBOX);
    ArkUI_NodeHandle checkbox2 = nodeApi->createNode(ARKUI_NODE_CHECKBOX);
    this->CreateAccessibilityState();
    this->SetAccessibilityDisabled(false);
    bool disabled = this->IsAccessibilityDisabled();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilityDisabled: disabled=%{public}d",
        disabled);
    this->SetAccessibilityCheckedState(ARKUI_ACCESSIBILITY_UNCHECKED);
    int32_t checkedState = this->GetAccessibilityCheckedState();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityCheckedState: state=%{public}d",
        checkedState);
    ArkUI_AttributeItem accessibilityItem = { .object = this->accessibilityState_ };
    nodeApi->setAttribute(parent, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    this->SetAccessibilityCheckedState(ARKUI_ACCESSIBILITY_CHECKED);
    accessibilityItem = { .object = this->accessibilityState_ };
    nodeApi->setAttribute(checkbox2, NODE_ACCESSIBILITY_STATE, &accessibilityItem);
    nodeApi->addChild(column, checkbox);
    nodeApi->addChild(column, checkbox2);
    nodeApi->addChild(parent, column);
}

void NodeManager::CreateAccessibilityValueSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "3. 通过 NODE_ACCESSIBILITY_VALUE 设置无障碍信息属性:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->CreateAccessibilityValue();
    this->SetAccessibilityValueMin(ACCESSIBILITY_VALUE_MIN);
    int32_t valueMin = this->GetAccessibilityValueMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMin: min=%{public}d", valueMin);
    this->SetAccessibilityValueMax(ACCESSIBILITY_VALUE_MAX);
    int32_t valueMax = this->GetAccessibilityValueMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMax: max=%{public}d", valueMax);
    this->SetAccessibilityValueCurrent(ACCESSIBILITY_VALUE_CURRENT);
    int32_t valueCurrent = this->GetAccessibilityValueCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueCurrent: current=%{public}d",
        valueCurrent);
    this->SetAccessibilityValueText(ACCESSIBILITY_VALUE_TEXT);
    const char* valueText = this->GetAccessibilityValueText();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueText: text=%{public}s",
        valueText);
    this->SetAccessibilityRangeMin(ACCESSIBILITY_RANGE_MIN);
    int32_t rangeMin = this->GetAccessibilityRangeMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMin: min=%{public}d", rangeMin);
    this->SetAccessibilityRangeMax(ACCESSIBILITY_RANGE_MAX);
    int32_t rangeMax = this->GetAccessibilityValueMax();
    rangeMax = this->GetAccessibilityRangeMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMax: max=%{public}d", rangeMax);
    this->SetAccessibilityRangeCurrent(ACCESSIBILITY_RANGE_CURRENT);
    int32_t rangeCurrent = this->GetAccessibilityRangeCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeCurrent: current=%{public}d",
        rangeCurrent);
    ArkUI_AttributeItem accessibilityValueItem = { .object = this->accessibilityValue_ };
    nodeApi->setAttribute(text2, NODE_ACCESSIBILITY_VALUE, &accessibilityValueItem);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateAccessibilityNodeIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi, "4. 通过 NODE_ID 获取无障碍节点ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->SetNodeId(nodeApi, text2, "test node id");
    const char* nodeId = this->GetNodeId(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetNodeId: id=%{public}s", nodeId);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateAccessibilityGroupSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "5. 通过 NODE_ACCESSIBILITY_GROUP 设置无障碍分组:");
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "column子节点1");
    ArkUI_NodeHandle text3 = BuildTextNode(nodeApi, "column子节点2");
    this->SetAccessibilityGroup(nodeApi, column, true);
    bool isGroup = this->GetAccessibilityGroup(nodeApi, column);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityGroup: isGroup=%{public}d", isGroup);
    nodeApi->addChild(column, text2);
    nodeApi->addChild(column, text3);
    nodeApi->addChild(parent, text1);
    nodeApi->addChild(parent, column);
}

void NodeManager::CreateAccessibilityModeSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "6. 通过 NODE_ACCESSIBILITY_MODE 设置无障碍辅助服务模式(ACCESSIBILITY_MODE):");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "Hello Accessibility Sample(DISABLED, 不可被无障碍辅助服务所识别)");
    this->SetAccessibilityMode(nodeApi, text2, ARKUI_ACCESSIBILITY_MODE_DISABLED);
    ArkUI_AccessibilityMode mode = this->GetAccessibilityMode(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityMode: mode=%{public}d", mode);
    nodeApi->addChild(parent, text2);
}


void NodeManager::CreateAccessibilityTextSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "7. 通过 NODE_ACCESSIBILITY_TEXT 设置无障碍文本:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->SetAccessibilityText(nodeApi, text2, "This is a text");
    const char* accessibilityText = this->GetAccessibilityText(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityText: text=%{public}s",
        accessibilityText);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateAccessibilityDescriptionSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "8. 通过 NODE_ACCESSIBILITY_DESCRIPTION 设置无障碍描述:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->SetAccessibilityDescription(nodeApi, text2, "This is accessibility description");
    const char* description = this->GetAccessibilityDescription(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityDescription: description=%{public}s",
        description);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateAccessibilityIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "9. 通过 NODE_ACCESSIBILITY_ID 获取无障碍ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    int accessibilityId = this->GetAccessibilityId(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityId: id=%{public}d", accessibilityId);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateAccessibilityActionsSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
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
    this->SetAccessibilityActions(nodeApi, button);
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

void NodeManager::CreateAccessibilityRoleSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "11. 通过 NODE_ACCESSIBILITY_ROLE 设置无障碍组件类型:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->SetAccessibilityRole(nodeApi, text2, ARKUI_NODE_TEXT);
    uint32_t role = this->GetAccessibilityRole(nodeApi, text2);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRole: role=%{public}u", role);
    nodeApi->addChild(parent, text2);
}

void NodeManager::CreateUniqueIdSection(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle parent)
{
    ArkUI_NodeHandle text1 = BuildTextNodeWithoutAccessibilityFocus(nodeApi,
        "12. 通过 NODE_UNIQUE_ID 获取唯一ID:");
    nodeApi->addChild(parent, text1);
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, SAMPLE_TEXT);
    this->GetUniqueId(nodeApi, text2);
    nodeApi->addChild(parent, text2);
}

ArkUI_NodeHandle NodeManager::BuildEmbeddedComponentSection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi)
{
    // 创建嵌入式组件选项
    self->CreateEmbeddedComponentOption();
    // 设置错误回调
    self->SetEmbeddedComponentOnError();
    // 设置终止回调
    self->SetEmbeddedComponentOnTerminated();
    // 创建嵌入式组件节点
    ArkUI_NodeHandle embeddedNode = nodeApi->createNode(ARKUI_NODE_EMBEDDED_COMPONENT);
    // 设置嵌入式组件的want
    self->SetEmbeddedComponentWant(nodeApi, embeddedNode);
    // 将嵌入式组件选项设置给嵌入式组件
    ArkUI_AttributeItem embeddedComponentOptionItem = { .object = self->embeddedComponentOption_ };
    nodeApi->setAttribute(embeddedNode, NODE_EMBEDDED_COMPONENT_OPTION, &embeddedComponentOptionItem);
    ArkUI_NumberValue value[] = { EMBEDDED_COMPONENT_WIDTH };
    ArkUI_AttributeItem embeddedWidthItem = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(embeddedNode, NODE_WIDTH, &embeddedWidthItem);
    nodeApi->setAttribute(embeddedNode, NODE_HEIGHT, &embeddedWidthItem);
    return embeddedNode;
}

NodeManager &NodeManager::GetInstance()
{
    static NodeManager instance;
    return instance;
}

void NodeManager::SetXComponent(OH_NativeXComponent *xComponent) { xComponent_ = xComponent; }

void NodeManager::CreateNativeNode()
{
    if (!xComponent_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    // 创建一个Column容器组件
    ArkUI_NodeHandle column = BuildColumnNode(nodeApi);
    // 创建Text组件
    ArkUI_NodeHandle text = BuildTextNode(nodeApi, SAMPLE_TEXT);

    auto scrollNode = nodeApi->createNode(ARKUI_NODE_SCROLL);
    nodeApi->addChild(scrollNode, column);

    CreateAccessibilitySelectedSection(nodeApi, column);
    CreateAccessibilityCheckedSection(nodeApi, column);
    ArkUI_NodeHandle embeddedNode = BuildEmbeddedComponentSection(this, nodeApi);
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
    ArkUI_NodeHandle text2 = BuildTextNode(nodeApi, "嵌入式组件:");
    nodeApi->addChild(column, text2);
    nodeApi->addChild(column, embeddedNode);

    // 将嵌入式组件添加到列容器
    nodeApi->addChild(column, embeddedNode);
    // Column作为XComponent子组件
    OH_NativeXComponent_AttachNativeRootNode(xComponent_, scrollNode);
}

ArkUI_NodeHandle NodeManager::BuildTextNodeWithoutAccessibilityFocus(ArkUI_NativeNodeAPI_1* nodeApi,
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
    this->SetAccessibilityMode(nodeApi, text, ARKUI_ACCESSIBILITY_MODE_DISABLED);
    return text;
}
ArkUI_NodeHandle NodeManager::BuildTextNode(ArkUI_NativeNodeAPI_1* nodeApi, const char* content)
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

ArkUI_NodeHandle NodeManager::BuildColumnNode(ArkUI_NativeNodeAPI_1* nodeApi)
{
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = COL_WIDTH_PX}};
    ArkUI_AttributeItem widthItem = { colWidth, sizeof(colWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    return column;
}

NodeManager::~NodeManager()
{
    DisposeAccessibilityState();
    DisposeAccessibilityValue();
    DisposeEmbeddedComponentOption();
}

void NodeManager::CreateAccessibilityState()
{
    if (!accessibilityState_) {
        accessibilityState_ = OH_ArkUI_AccessibilityState_Create();
    }
}

void NodeManager::SetAccessibilityDisabled(bool isDisabled)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetDisabled(accessibilityState_, isDisabled);
    }
}

bool NodeManager::IsAccessibilityDisabled()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_IsDisabled(accessibilityState_);
    }
    return false;
}

void NodeManager::SetAccessibilitySelected(bool isSelected)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetSelected(accessibilityState_, isSelected);
    }
}

bool NodeManager::IsAccessibilitySelected()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_IsSelected(accessibilityState_);
    }
    return false;
}

void NodeManager::SetAccessibilityCheckedState(int32_t checkedState)
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_SetCheckedState(accessibilityState_, checkedState);
    }
}

int32_t NodeManager::GetAccessibilityCheckedState()
{
    if (accessibilityState_) {
        return OH_ArkUI_AccessibilityState_GetCheckedState(accessibilityState_);
    }
    return 0;
}

void NodeManager::DisposeAccessibilityState()
{
    if (accessibilityState_) {
        OH_ArkUI_AccessibilityState_Dispose(accessibilityState_);
        accessibilityState_ = nullptr;
    }
}

void NodeManager::CreateAccessibilityValue()
{
    if (!accessibilityValue_) {
        accessibilityValue_ = OH_ArkUI_AccessibilityValue_Create();
    }
}

void NodeManager::DisposeAccessibilityValue()
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_Dispose(accessibilityValue_);
        accessibilityValue_ = nullptr;
    }
}

void NodeManager::SetAccessibilityValueMin(int32_t min)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetMin(accessibilityValue_, min);
    }
}

int32_t NodeManager::GetAccessibilityValueMin()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetMin(accessibilityValue_);
    }
    return 0;
}

void NodeManager::SetAccessibilityValueMax(int32_t max)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetMax(accessibilityValue_, max);
    }
}

int32_t NodeManager::GetAccessibilityValueMax()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetMax(accessibilityValue_);
    }
    return 0;
}

void NodeManager::SetAccessibilityValueCurrent(int32_t current)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetCurrent(accessibilityValue_, current);
    }
}

int32_t NodeManager::GetAccessibilityValueCurrent()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetCurrent(accessibilityValue_);
    }
    return 0;
}

void NodeManager::SetAccessibilityValueText(const char* text)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetText(accessibilityValue_, text);
    }
}

const char* NodeManager::GetAccessibilityValueText()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetText(accessibilityValue_);
    }
    return nullptr;
}

void NodeManager::SetAccessibilityRangeMin(int32_t rangeMin)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeMin(accessibilityValue_, rangeMin);
    }
}

int32_t NodeManager::GetAccessibilityRangeMin()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeMin(accessibilityValue_);
    }
    return 0;
}

void NodeManager::SetAccessibilityRangeMax(int32_t rangeMax)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeMax(accessibilityValue_, rangeMax);
    }
}

int32_t NodeManager::GetAccessibilityRangeMax()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeMax(accessibilityValue_);
    }
    return 0;
}

void NodeManager::SetAccessibilityRangeCurrent(int32_t rangeCurrent)
{
    if (accessibilityValue_) {
        OH_ArkUI_AccessibilityValue_SetRangeCurrent(accessibilityValue_, rangeCurrent);
    }
}

int32_t NodeManager::GetAccessibilityRangeCurrent()
{
    if (accessibilityValue_) {
        return OH_ArkUI_AccessibilityValue_GetRangeCurrent(accessibilityValue_);
    }
    return 0;
}

void NodeManager::OnErrorCallback(int32_t code, const char* name, const char* msg)
{
    // 用户自定义的错误处理逻辑
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnErrorCallback:\
        code=%{public}d, name=%{public}s, message=%{public}s", code, name, msg);
}

void NodeManager::OnTerminatedCallback(int32_t code, AbilityBase_Want* want)
{
    // 用户自定义的终止处理逻辑
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: code=%{public}d", code);
    if (want == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: want is nullptr");
        return;
    }

    AbilityBase_Element element;
    auto error = OH_AbilityBase_GetWantElement(want, &element);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: bundleName=%{public}s,\
        abilityName=%{public}s, moduleName=%{public}s", element.bundleName, element.abilityName, element.moduleName);
    int wantInt = 0;
    error = OH_AbilityBase_GetWantInt32Param(want, "int", &wantInt);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantInt=%{public}d", wantInt);
    bool wantBool = false;
    error = OH_AbilityBase_GetWantBoolParam(want, "bool2", &wantBool);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantBool=%{public}d",
        wantBool);
    char wantString[WANT_STR_BUF_LEN];
    error = OH_AbilityBase_GetWantCharParam(want, "string", wantString, WANT_STR_COPY_LEN);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantString=%{public}s",
        wantString);
    char wantUri[WANT_URI_BUF_LEN];
    error = OH_AbilityBase_GetWantUri(want, wantUri, WANT_URI_COPY_LEN);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantUri=%{public}s", wantUri);
    int wantFd = 0;
    error = OH_AbilityBase_GetWantFd(want, "keyFd2", &wantFd);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Manager", "OnTerminatedCallback: wantFd=%{public}d", wantFd);
}

void NodeManager::CreateEmbeddedComponentOption()
{
    if (!embeddedComponentOption_) {
        embeddedComponentOption_ = OH_ArkUI_EmbeddedComponentOption_Create();
    }
}

void NodeManager::DisposeEmbeddedComponentOption()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_Dispose(embeddedComponentOption_);
        embeddedComponentOption_ = nullptr;
    }
}

void NodeManager::SetEmbeddedComponentOnError()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_SetOnError(embeddedComponentOption_, OnErrorCallback);
    }
}

void NodeManager::SetEmbeddedComponentOnTerminated()
{
    if (embeddedComponentOption_) {
        OH_ArkUI_EmbeddedComponentOption_SetOnTerminated(embeddedComponentOption_, OnTerminatedCallback);
    }
}

void NodeManager::SetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* id)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem idItem = {.string = id};
        nodeApi->setAttribute(node, NODE_ID, &idItem);
    }
}

const char* NodeManager::GetNodeId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, NODE_ID);
        if (attributeItem) {
            return attributeItem->string;
        }
    }
    return nullptr;
}

void NodeManager::SetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, bool isGroup)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{.i32 = isGroup}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_GROUP, &item);
    }
}

bool NodeManager::GetAccessibilityGroup(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_GROUP);
        if (attributeItem) {
            return attributeItem->value[0].i32;
        }
    }
    return false;
}

void NodeManager::SetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
    ArkUI_AccessibilityMode mode)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{.i32 = mode}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_MODE, &item);
    }
}

ArkUI_AccessibilityMode NodeManager::GetAccessibilityMode(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_MODE);
        if (attr && attr->size > 0) {
            return static_cast<ArkUI_AccessibilityMode>(attr->value[0].i32);
        }
    }
    return ARKUI_ACCESSIBILITY_MODE_AUTO;
}

void NodeManager::SetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node,
    const char* description)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem item = {.string = description};
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_DESCRIPTION, &item);
    }
}

const char* NodeManager::GetAccessibilityDescription(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_DESCRIPTION);
        if (attr) {
            return attr->string;
        }
    }
    return nullptr;
}

int NodeManager::GetAccessibilityId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ID);
        if (attr && attr->size > 0) {
            return attr->value[0].i32;
        }
    }
    return -1;
}

void NodeManager::SetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const char* text)
{
    if (nodeApi && node) {
        ArkUI_AttributeItem item = {.string = text};
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_TEXT, &item);
    }
}

const char* NodeManager::GetAccessibilityText(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_TEXT);
        if (attr) {
            return attr->string;
        }
    }
    return nullptr;
}

void NodeManager::SetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{ .u32 = ARKUI_ACCESSIBILITY_ACTION_CLICK}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_ACTIONS, &item);
    }
}

uint32_t NodeManager::GetAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ACTIONS);
        if (attr && attr->size > 0) {
            return attr->value[0].u32;
        }
    }
    return 0U;
}

void NodeManager::SetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node, const uint32_t role)
{
    if (nodeApi && node) {
        ArkUI_NumberValue value[] = {{ .u32 = role}};
        ArkUI_AttributeItem item = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_ACCESSIBILITY_ROLE, &item);
    }
}

uint32_t NodeManager::GetAccessibilityRole(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem* attr = nodeApi->getAttribute(node, NODE_ACCESSIBILITY_ROLE);
        if (attr && attr->size > 0) {
            return attr->value[0].u32;
        }
    }
    return 0U;
}

void NodeManager::GetUniqueId(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        const ArkUI_AttributeItem *attributeItem = nodeApi->getAttribute(node, NODE_UNIQUE_ID);
        // 组件id作为targetid来区分不同组件的事件。
        auto id = attributeItem->value[0].i32;
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetUniqueId: id=%{public}d", id);
    }
}

void NodeManager::SetEmbeddedComponentWant(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        // 创建一个Want对象并设置相关属性
        AbilityBase_Element element = {
            .bundleName = "com.samples.accessibilityndk",
            .abilityName = "SampleEmbeddedAbility",
            .moduleName = ""
        };
        AbilityBase_Want* want = OH_AbilityBase_CreateWant(element);
        ArkUI_AttributeItem itemObjWant = {.object = want};
        nodeApi->setAttribute(node, NODE_EMBEDDED_COMPONENT_WANT, &itemObjWant);
    }
}
}
