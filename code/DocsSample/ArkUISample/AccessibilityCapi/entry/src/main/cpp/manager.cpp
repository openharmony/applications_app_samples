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

void NodeManager::BuildAccessibilitySection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle text)
{
    // 创建无障碍状态对象
    self->CreateAccessibilityState();
    // 设置无障碍状态为禁用
    self->SetAccessibilityDisabled(false);
    // 检查并打印无障碍禁用状态
    bool disabled = self->IsAccessibilityDisabled();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilityDisabled: disabled=%{public}d",
        disabled);
    // 设置无障碍状态为选中
    self->SetAccessibilitySelected(true);
    // 检查并打印无障碍选中状态
    bool selected = self->IsAccessibilitySelected();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "IsAccessibilitySelected: selected=%{public}d",
        selected);
    // 设置无障碍状态为已勾选
    self->SetAccessibilityCheckedState(ARKUI_ACCESSIBILITY_CHECKED);
    // 获取并打印无障碍勾选状态
    int32_t checkedState = self->GetAccessibilityCheckedState();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityCheckedState: state=%{public}d",
        checkedState);
    // 将无障碍状态设置给Text组件
    ArkUI_AttributeItem accessibilityItem = { .object = self->accessibilityState_ };
    nodeApi->setAttribute(text, NODE_ACCESSIBILITY_STATE, &accessibilityItem);

    // 创建无障碍值对象
    self->CreateAccessibilityValue();
    // 设置无障碍值的范围
    self->SetAccessibilityValueMin(ACCESSIBILITY_VALUE_MIN);
    int32_t valueMin = self->GetAccessibilityValueMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMin: min=%{public}d", valueMin);
    self->SetAccessibilityValueMax(ACCESSIBILITY_VALUE_MAX);
    int32_t valueMax = self->GetAccessibilityValueMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueMax: max=%{public}d", valueMax);
    self->SetAccessibilityValueCurrent(ACCESSIBILITY_VALUE_CURRENT);
    int32_t valueCurrent = self->GetAccessibilityValueCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueCurrent: current=%{public}d",
        valueCurrent);
    self->SetAccessibilityValueText(ACCESSIBILITY_VALUE_TEXT);
    const char* valueText = self->GetAccessibilityValueText();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityValueText: text=%{public}s",
        valueText);
    // 设置无障碍范围值
    self->SetAccessibilityRangeMin(ACCESSIBILITY_RANGE_MIN);
    int32_t rangeMin = self->GetAccessibilityRangeMin();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMin: min=%{public}d", rangeMin);
    self->SetAccessibilityRangeMax(ACCESSIBILITY_RANGE_MAX);
    int32_t rangeMax = self->GetAccessibilityValueMax();
    rangeMax = self->GetAccessibilityRangeMax();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeMax: max=%{public}d", rangeMax);
    self->SetAccessibilityRangeCurrent(ACCESSIBILITY_RANGE_CURRENT);
    int32_t rangeCurrent = self->GetAccessibilityRangeCurrent();
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRangeCurrent: current=%{public}d",
        rangeCurrent);
    // 将无障碍值设置给Text组件
    ArkUI_AttributeItem accessibilityValueItem = { .object = self->accessibilityValue_ };
    nodeApi->setAttribute(text, NODE_ACCESSIBILITY_VALUE, &accessibilityValueItem);
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

void NodeManager::BuildTextSection(NodeManager* self, ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle text)
{
    // 设置节点ID
    self->SetNodeId(nodeApi, text, "test node id");
    const char* nodeId = self->GetNodeId(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetNodeId: id=%{public}s", nodeId);
    // 设置无障碍组
    self->SetAccessibilityGroup(nodeApi, text, false);
    bool isGroup = self->GetAccessibilityGroup(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityGroup: isGroup=%{public}d", isGroup);
    // 设置无障碍模式
    self->SetAccessibilityMode(nodeApi, text, ARKUI_ACCESSIBILITY_MODE_AUTO);
    ArkUI_AccessibilityMode mode = self->GetAccessibilityMode(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityMode: mode=%{public}d", mode);
    // 设置无障碍文本
    self->SetAccessibilityText(nodeApi, text, "This is a text");
    const char* accessibilityText = self->GetAccessibilityText(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityText: text=%{public}s",
        accessibilityText);
    // 设置无障碍描述
    self->SetAccessibilityDescription(nodeApi, text, "This is accessibility description");
    const char* description = self->GetAccessibilityDescription(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityDescription: description=%{public}s",
        description);
    // 获取无障碍ID
    int accessibilityId = self->GetAccessibilityId(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityId: id=%{public}d", accessibilityId);
    // 设置无障碍操作
    self->SetAccessibilityActions(nodeApi, text);
    uint32_t actions = self->GetAccessibilityActions(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityActions: actions=%{public}u",
        actions);
    // 设置无障碍角色
    self->SetAccessibilityRole(nodeApi, text, ARKUI_NODE_TEXT);
    // 获取并打印无障碍角色
    uint32_t role = self->GetAccessibilityRole(nodeApi, text);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Manager", "GetAccessibilityRole: role=%{public}u", role);
    // 获取唯一ID
    self->GetUniqueId(nodeApi, text);
    // 设置无障碍操作回调
    self->SetOnAccessibilityActions(nodeApi, text);
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
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = COL_WIDTH_PX}};
    ArkUI_AttributeItem widthItem = { colWidth, sizeof(colWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    // 创建Text组件
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    ArkUI_NumberValue textWidth[] = {{.f32 = TEXT_WIDTH_PX}};
    ArkUI_AttributeItem textWidthItem = { textWidth, sizeof(textWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = TEXT_HEIGHT_PX}};
    ArkUI_AttributeItem textHeightItem = { textHeight, sizeof(textHeight) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = BORDER_WIDTH_PX}};
    ArkUI_AttributeItem borderWidthItem = { borderWidth, sizeof(borderWidth) / sizeof(ArkUI_NumberValue) };
    nodeApi->setAttribute(text, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_AttributeItem valueItem = {.string = "Hello World!"};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT, &valueItem);

    // 无障碍属性设置
    BuildAccessibilitySection(this, nodeApi, text);
    // 嵌入式组件初始化
    ArkUI_NodeHandle embeddedNode = BuildEmbeddedComponentSection(this, nodeApi);
    // 文本无障碍属性与事件设置
    BuildTextSection(this, nodeApi, text);

    // Text作为Column子组件
    nodeApi->addChild(column, text);
    // 将嵌入式组件添加到列容器
    nodeApi->addChild(column, embeddedNode);
    // Column作为XComponent子组件
    OH_NativeXComponent_AttachNativeRootNode(xComponent_, column);
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
        ArkUI_NumberValue value[] = {{ .u32 = ARKUI_ACCESSIBILITY_ACTION_COPY}};
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

void NodeManager::SetOnAccessibilityActions(ArkUI_NativeNodeAPI_1* nodeApi, ArkUI_NodeHandle node)
{
    if (nodeApi && node) {
        nodeApi->registerNodeEvent(node, NODE_ON_ACCESSIBILITY_ACTIONS, 0, node);
    }
}
}
