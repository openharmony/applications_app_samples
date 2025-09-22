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
#include <arkui/native_node.h>
#include <cstddef>
#include <cstdint>
#include <hilog/log.h>

namespace NativeNode::Manager {

constexpr uint32_t MATRIX_ARRAY_SIZE = 16;
NodeManager& NodeManager::GetInstance()
{
    static NodeManager instance;
    return instance;
}

ArkUI_NativeNodeAPI_1* NodeManager::GetNodeApi()
{
    static ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    return nodeApi;
}

void NodeManager::SetXComponent(OH_NativeXComponent* xComponent)
{
    xComponent_ = xComponent;
}

struct AttributeScope {
    ArkUI_NodeType nodeType;
    ArkUI_NodeAttributeType begin;
    ArkUI_NodeAttributeType end;
};

AttributeScope attributeArray[] = {
    { ARKUI_NODE_TIME_PICKER, NODE_TIME_PICKER_SELECTED, NODE_TIME_PICKER_ENABLE_CASCADE },
    { ARKUI_NODE_TEXT_PICKER, NODE_TEXT_PICKER_OPTION_RANGE },
    { ARKUI_NODE_CALENDAR_PICKER, NODE_CALENDAR_PICKER_HINT_RADIUS, NODE_CALENDAR_PICKER_MARK_TODAY },
    { ARKUI_NODE_IMAGE_ANIMATOR, NODE_IMAGE_ANIMATOR_IMAGES, NODE_IMAGE_ANIMATOR_ITERATION },
    { ARKUI_NODE_IMAGE, NODE_IMAGE_SRC, NODE_IMAGE_ORIENTATION },
    { ARKUI_NODE_SLIDER, NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR, NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR },
};

uint32_t g_colors[] = {0xFFFEBB62, 0xffFFA0A4};
float g_stops[] = {0, 1.0};
static ArkUI_ColorStop linerGrand[] = {{g_colors, g_stops, 2}};

static ArkUI_NumberValue timePickerValue1[] = { { .i32 = 1 } };
static ArkUI_NumberValue textPickerValue1[] = { { .i32 = ARKUI_TEXTPICKER_RANGETYPE_SINGLE } };
static ArkUI_NumberValue textPickerValue2[] = { { .i32 = 0 } };
static ArkUI_NumberValue textPickerValue3[] = { { .f32 = 10.0 } };
static ArkUI_NumberValue hdrBrightness[] = { { .f32 = 1.0 } };
static ArkUI_NumberValue orientation[] = { { .i32 = ARKUI_ORIENTATION_DOWN } };
static ArkUI_NumberValue copyOption[] = { { .i32 = ARKUI_COPY_OPTIONS_IN_APP } };
static ArkUI_NumberValue imageMatrix[MATRIX_ARRAY_SIZE] = { { .f32 = 5.0f }, { .f32 = 0.0f }, { .f32 = 0.0f },
    { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 1.0f }, { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 0.0f },
    { .f32 = 0.0f }, { .f32 = 1.0f }, { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 400.0f },
    { .f32 = 0.0f }, { .f32 = 1.0f } };
static ArkUI_NumberValue dynamicRangeMode[] = { { .i32 = 1 } };
static ArkUI_NumberValue enableAnalyzer[] = { { .i32 = 1 } };
static ArkUI_NumberValue matchDirection[] = { { .i32 = 1 } };
static ArkUI_NumberValue sourceSize[] = { { .i32 = -100 }, { .i32 = 100 } };
static ArkUI_NumberValue calendarPickerValue1[] = { { .f32 = 10.0f } };
static ArkUI_NumberValue calendarPickerValue2[] = { { .u32 = 2025 }, { .u32 = 1 }, { .u32 = 1 } };
static ArkUI_NumberValue calendarPickerValue3[] = { { .i32 = ARKUI_CALENDAR_ALIGNMENT_START }, { .f32 = 10.0f },
    { .f32 = 10.0f } };
static ArkUI_NumberValue calendarPickerValue4[] = { { .u32 = 0xFFFF0000 }, { .f32 = 10.0f },
    { .i32 = ARKUI_FONT_WEIGHT_NORMAL } };

static std::map<int32_t, ArkUI_AttributeItem> attributeValueMap = {
    // ARKUI_NODE_TIME_PICKER
    { NODE_TIME_PICKER_SELECTED, { timePickerValue1, 1, "11-59", nullptr } },
    { NODE_TIME_PICKER_USE_MILITARY_TIME, { timePickerValue1, 1, "11-59", nullptr } },
    { NODE_TIME_PICKER_DISAPPEAR_TEXT_STYLE, { timePickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TIME_PICKER_TEXT_STYLE, { timePickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TIME_PICKER_SELECTED_TEXT_STYLE, { timePickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TIME_PICKER_START, { timePickerValue1, 1, "00:00:00", nullptr } },
    { NODE_TIME_PICKER_END, { timePickerValue1, 1, "23:59:59", nullptr } },
    { NODE_TIME_PICKER_ENABLE_CASCADE, { timePickerValue1, 1, nullptr, nullptr } },
    // ARKUI_NODE_TEXT_PICKER
    { NODE_TEXT_PICKER_OPTION_RANGE, { textPickerValue1, 1, "1;2;3", nullptr } },
    { NODE_TEXT_PICKER_OPTION_SELECTED, { textPickerValue2, 1, nullptr, nullptr } },
    { NODE_TEXT_PICKER_OPTION_VALUE, { textPickerValue1, 1, "1;2;3", nullptr } },
    { NODE_TEXT_PICKER_DISAPPEAR_TEXT_STYLE, { textPickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TEXT_PICKER_TEXT_STYLE, { textPickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TEXT_PICKER_SELECTED_TEXT_STYLE, { textPickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr } },
    { NODE_TEXT_PICKER_SELECTED_INDEX, { textPickerValue2, 1, nullptr, nullptr } },
    { NODE_TEXT_PICKER_CAN_LOOP, { textPickerValue2, 1, nullptr, nullptr } },
    { NODE_TEXT_PICKER_DEFAULT_PICKER_ITEM_HEIGHT, { textPickerValue3, 1, nullptr, nullptr } },
    { NODE_TEXT_PICKER_ENABLE_HAPTIC_FEEDBACK, { textPickerValue1, 1, nullptr, nullptr } },
    // ARKUI_NODE_CALENDAR_PICKER
    { NODE_CALENDAR_PICKER_HINT_RADIUS, { calendarPickerValue1, 1, nullptr, nullptr } },
    { NODE_CALENDAR_PICKER_SELECTED_DATE, { calendarPickerValue2, 3, nullptr, nullptr } },
    { NODE_CALENDAR_PICKER_EDGE_ALIGNMENT, { calendarPickerValue3, 3, nullptr, nullptr } },
    { NODE_CALENDAR_PICKER_TEXT_STYLE, { calendarPickerValue4, 3, nullptr, nullptr } },
    { NODE_CALENDAR_PICKER_START, { timePickerValue1, 1, "2025-1-1", nullptr } },
    { NODE_CALENDAR_PICKER_END, { timePickerValue1, 1, "2025-1-1", nullptr } },
    // ARKUI_NODE_IMAGE_ANIMATOR
    { NODE_IMAGE_ANIMATOR_IMAGES, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_STATE, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_DURATION, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_REVERSE, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_FIXED_SIZE, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_FILL_MODE, { timePickerValue1, 1, nullptr, nullptr } },
    { NODE_IMAGE_ANIMATOR_ITERATION, { timePickerValue1, 1, nullptr, nullptr } },
    // ARKUI_NODE_IMAGE attributes type and value map
    { NODE_IMAGE_HDR_BRIGHTNESS, { hdrBrightness, 1, nullptr, nullptr } },
    { NODE_IMAGE_ORIENTATION, { orientation, 1, nullptr, nullptr } },
    { NODE_IMAGE_IMAGE_MATRIX, { imageMatrix, MATRIX_ARRAY_SIZE, nullptr, nullptr } },
    { NODE_IMAGE_COPY_OPTION, { copyOption, 1, nullptr, nullptr } },
    { NODE_IMAGE_DYNAMIC_RANGE_MODE, { dynamicRangeMode, 1, nullptr, nullptr } },
    { NODE_IMAGE_ENABLE_ANALYZER, { enableAnalyzer, 1, nullptr, nullptr } },
    { NODE_IMAGE_MATCH_TEXT_DIRECTION, { matchDirection, 1, nullptr, nullptr } },
    { NODE_IMAGE_SOURCE_SIZE, { sourceSize, 2, nullptr, nullptr } },
    // ARKUI_NODE_SLIDER
    { NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
    { NODE_SLIDER_TRACK_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
    { NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
};

int32_t NodeManager::AddNativeNode(ArkUI_NodeHandle newNode, int32_t nodeType)
{
    if (newNode == nullptr) {
        return -1;
    }

    std::lock_guard<std::mutex> lock(mutex_);
    int32_t id = nodeId_++;
    nativeNodeMap_[id] = { newNode, nodeType };
    return id;
}

NodeRecord NodeManager::GetNativeNode(int32_t id)
{
    std::lock_guard<std::mutex> lock(mutex_);
    auto it = nativeNodeMap_.find(id);
    if (it != nativeNodeMap_.end()) {
        return it->second;
    }
    return { nullptr, -1 };
}

void NodeManager::RemoveNativeNode(int32_t id)
{
    std::lock_guard<std::mutex> lock(mutex_);
    auto it = nativeNodeMap_.find(id);
    if (it != nativeNodeMap_.end()) {
        nativeNodeMap_.erase(it);
    }
}

int32_t NodeManager::CreateNativeNode(int32_t nodeType)
{
    if (!xComponent_) {
        return -1;
    }
    ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
    if (nodeApi == nullptr) {
        return -1;
    }
    bool isValid = false;
    for (int i = 0; i < sizeof(attributeArray) / sizeof(AttributeScope); i++) {
        if (attributeArray[i].nodeType == nodeType) {
            isValid = true;
            break;
        }
    }
    if (!isValid) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----CreateNativeNode, isValid is false");
        return -1;
    }

    ArkUI_NodeHandle newNode = nodeApi->createNode((ArkUI_NodeType)nodeType);
    if (nodeType == ARKUI_NODE_IMAGE) {
        ArkUI_AttributeItem srcItem = {};
        srcItem.string = "resource://base/media/startIcon2.png";
        nodeApi->setAttribute(newNode, NODE_IMAGE_SRC, &srcItem); // create image node and set src attribute
        ArkUI_NumberValue valueWidth[] = { { .f32 = 200 } };
        ArkUI_AttributeItem itemWidth = { valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_WIDTH, &itemWidth);
        ArkUI_NumberValue valueHeight[] = { { .f32 = 400 } };
        ArkUI_AttributeItem itemHeight = { valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_HEIGHT, &itemHeight);
    }

    int32_t newNodeId = AddNativeNode(newNode, nodeType);
    BindEventByType(newNode, nodeType, BIND_EVENT);
    OH_NativeXComponent_AttachNativeRootNode(xComponent_, newNode);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----CreateNativeNode, nodeType:%{public}d, nodeId：%{public}d",
        nodeType, newNodeId);
    return newNodeId;
}

void NodeManager::RemoveOldNode(int32_t nodeId)
{
    if (!xComponent_) {
        return;
    }
    ArkUI_NodeHandle oldNode = GetNativeNode(nodeId).nodeHandle;
    int32_t nodeType = GetNativeNode(nodeId).nodeType;
    OH_NativeXComponent_DetachNativeRootNode(xComponent_, oldNode);
    BindEventByType(oldNode, nodeType, UNBIND_EVENT);
    RemoveNativeNode(nodeId);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----RemoveOldNode, nodeId：%{public}d", nodeId);
}

bool NodeManager::IsValidAttributeType(int32_t nodeType, int32_t attributeType)
{
    bool isValid = false;
    for (int i = 0; i < sizeof(attributeArray) / sizeof(AttributeScope); i++) {
        if (attributeArray[i].nodeType == nodeType) {
            if (attributeArray[i].begin <= attributeType && attributeType <= attributeArray[i].end) {
                isValid = true;
            }
            break;
        }
    }
    if (!isValid) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----IsValidAttributeType, isValid is false");
    }
    return isValid;
}

int32_t NodeManager::SetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType, int32_t value)
{
    int32_t ret = 0;
    if (!IsValidAttributeType(nodeType, attributeType)) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle node = GetNativeNode(nodeId).nodeHandle;
    if (nodeApi == nullptr || node == nullptr) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }

    ArkUI_NumberValue itemValue[] = { { .i32 = value } };
    ArkUI_AttributeItem attributeItem = { itemValue, sizeof(itemValue) / sizeof(ArkUI_NumberValue) };
    // when set NODE_IMAGE_ENABLE_ANALYZER, need set NODE_IMAGE_DRAGGABLE to 0, can only be pasted
    if (attributeType == NODE_IMAGE_ENABLE_ANALYZER) {
        ArkUI_NumberValue valueEnable[] = { { .i32 = 0 } };
        ArkUI_AttributeItem itemValue = { valueEnable, sizeof(valueEnable) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_IMAGE_DRAGGABLE, &itemValue);
    }
    // set NODE_IMAGE_COPY_OPTION, attribute value is ARKUI_COPY_OPTIONS_LOCAL_DEVICE
    if (attributeType == NODE_IMAGE_COPY_OPTION) {
        int32_t copyValue = ArkUI_CopyOptions::ARKUI_COPY_OPTIONS_LOCAL_DEVICE;
        ArkUI_NumberValue value[] = { { .i32 = copyValue } };
        ArkUI_AttributeItem valueCopyItem = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_IMAGE_COPY_OPTION, &valueCopyItem);
    }
    if (attributeValueMap.count(attributeType)) {
        attributeItem = attributeValueMap[attributeType];
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
                     "----- SetNativeNodeAttribute default SetNativeNodeAttribute, type:%{public}d, ret:%{public}d",
                     attributeType, ret);
        ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &(attributeValueMap[attributeType]));
    } else {
    // set other attribute type
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    }
    if (attributeType == NODE_IMAGE_ORIENTATION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE orientation SetNativeNodeAttribute, type:%{public}d, ret:%{public}d, item_value:%{public}d",
            attributeType, ret, attributeItem.value[0].i32);
    } else if (attributeType == NODE_IMAGE_ENABLE_ANALYZER) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE enable analyzer SetNativeNodeAttribute, type:%{public}d, ret:%{public}d, item_value:%{public}d",
            attributeType, ret, attributeItem.value[0].i32);
    } else if (attributeType == NODE_IMAGE_MATCH_TEXT_DIRECTION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE match direction SetNativeNodeAttribute, type:%{public}d, ret:%{public}d, item_value:%{public}d",
            attributeType, ret, attributeItem.value[0].i32);
    } else if (attributeType == NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR ||
                    attributeType == NODE_SLIDER_TRACK_LINEAR_GRADIENT_COLOR ||
                    attributeType == NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_SLIDER SetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE default SetNativeNodeAttribute, type:%{public}d, ret:%{public}d, item_value:%{public}d",
            attributeType, ret, attributeItem.value[0].i32);
    }
    return ret;
}
// When the user inputs multiple values, attribute setting
int32_t NodeManager::SetNativeNodeAttribute(
    int32_t nodeId, int32_t nodeType, int32_t attributeType, const std::vector<float>& value)
{
    int32_t ret = -1;
    if (!IsValidAttributeType(nodeType, attributeType)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "NODE_IMAGE IsValidAttributeType");
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle node = GetNativeNode(nodeId).nodeHandle;
    if (nodeApi == nullptr || node == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "NODE_IMAGE nodeApi or node is nullptr");
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // The following attributes do not support input with more than 2 parameters
    if (value.size() <= 0 || (value.size() >= 2 && (attributeType == NODE_IMAGE_COPY_OPTION ||
        attributeType == NODE_IMAGE_ENABLE_ANALYZER || attributeType == NODE_IMAGE_ORIENTATION))) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // The following NODE_IMAGE_SOURCE_SIZE attributes do not support input with more than 3 parameters
    if (value.size() >= 3 && attributeType == NODE_IMAGE_SOURCE_SIZE) { // 3 means three elements
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }

    // set attribute type is NODE_IMAGE_IMAGE_MATRIX, must set NODE_IMAGE_OBJECT_FIT to ARKUI_OBJECT_FIT_NONE_MATRIX
    if (attributeType == NODE_IMAGE_IMAGE_MATRIX) {
        if (value.size() < MATRIX_ARRAY_SIZE) {
            return ARKUI_ERROR_CODE_PARAM_INVALID;
        }
        int32_t objectFitValue = ArkUI_ObjectFit::ARKUI_OBJECT_FIT_NONE_MATRIX;
        ArkUI_NumberValue valueObject[] = { { .i32 = objectFitValue } };
        ArkUI_AttributeItem valueItem = { valueObject, sizeof(valueObject) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_IMAGE_OBJECT_FIT, &valueItem);
        ArkUI_NumberValue valueMatrix[100] = {};
        for (int i = 0; i < value.size(); ++i) {
            valueMatrix[i].f32 = value[i];
        }
        ArkUI_AttributeItem valueItemMatrix = { valueMatrix, sizeof(valueMatrix) / sizeof(ArkUI_NumberValue) };
        ret = nodeApi->setAttribute(node, NODE_IMAGE_IMAGE_MATRIX, &valueItemMatrix);
    }
    // set attribute type is NODE_IMAGE_SOURCE_SIZE
    if (attributeType == NODE_IMAGE_SOURCE_SIZE) {
        ArkUI_NumberValue valueSourceSize[] = { { .i32 = static_cast<int32_t>(value[0]) },
            { .i32 = static_cast<int32_t>(value[1]) } };
        ArkUI_AttributeItem valueItemSourceSize = { valueSourceSize,
            sizeof(valueSourceSize) / sizeof(ArkUI_NumberValue) };
        ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &valueItemSourceSize);
    }
    return ret;
}

int32_t NodeManager::ResetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType)
{
    int32_t ret = -1;
    if (!IsValidAttributeType(nodeType, attributeType)) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle node = GetNativeNode(nodeId).nodeHandle;
    if (nodeApi == nullptr || node == nullptr) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    // call reset interface with attribute type
    ret = nodeApi->resetAttribute(node, (ArkUI_NodeAttributeType)attributeType);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
        "NODE_IMAGE ResetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
    const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, (ArkUI_NodeAttributeType)attributeType);
    if (attributeType == NODE_IMAGE_ORIENTATION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE orientation GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d", attributeType,
            attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_IMAGE_MATRIX) {
        for (int i = 0; i < MATRIX_ARRAY_SIZE; ++i) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
                "NODE_IMAGE imageMatrix GetAttribute, type:%{public}d, size:%{public}d, value:%{public}f",
                attributeType, attributeItem->size, attributeItem->value[i].f32);
        }
    } else if (attributeType == NODE_IMAGE_ENABLE_ANALYZER) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE enable analyzer GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_MATCH_TEXT_DIRECTION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE match direction GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_SOURCE_SIZE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE sourceSize GetAttribute, type:%{public}d, size:%{public}d, value_0:%{public}d, "
            "value_1:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32, attributeItem->value[1].i32);
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE hdr brightness GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d", attributeType,
            attributeItem->size, attributeItem->value[0].i32);
    }
    return ret;
}

const ArkUI_AttributeItem* NodeManager::GetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType)
{
    if (!IsValidAttributeType(nodeType, attributeType)) {
        return nullptr;
    }
    ArkUI_NativeNodeAPI_1* nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1*>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle node = GetNativeNode(nodeId).nodeHandle;
    if (nodeApi == nullptr || node == nullptr) {
        return nullptr;
    }
    // call get attribute interface with attribute type
    const ArkUI_AttributeItem* attributeItem = nodeApi->getAttribute(node, (ArkUI_NodeAttributeType)attributeType);
    if (attributeType == NODE_IMAGE_ORIENTATION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE orientation GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d", attributeType,
            attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_IMAGE_MATRIX) {
        for (int i = 0; i < MATRIX_ARRAY_SIZE; ++i) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
                "NODE_IMAGE imageMatrix GetAttribute, type:%{public}d, size:%{public}d, value:%{public}f",
                attributeType, attributeItem->size, attributeItem->value[i].f32);
        }
    } else if (attributeType == NODE_IMAGE_HDR_BRIGHTNESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE hdr brightness GetAttribute, type:%{public}d, size:%{public}d, value:%{public}f", attributeType,
            attributeItem->size, attributeItem->value[0].f32);
    } else if (attributeType == NODE_IMAGE_DYNAMIC_RANGE_MODE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE dynamic rangeMode GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_ENABLE_ANALYZER) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE enable analyzer GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_MATCH_TEXT_DIRECTION) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE match direction GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32);
    } else if (attributeType == NODE_IMAGE_SOURCE_SIZE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
            "NODE_IMAGE sourceSize GetAttribute, type:%{public}d, size:%{public}d, value_0:%{public}d, "
            "value_1:%{public}d",
            attributeType, attributeItem->size, attributeItem->value[0].i32, attributeItem->value[1].i32);
    } else {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode",
                     "NODE_IMAGE hdr brightness GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d",
                     attributeType, attributeItem->size, attributeItem->value[0].i32);
    }
    return attributeItem;
}

void NodeManager::BindEventByType(ArkUI_NodeHandle newNode, int32_t nodeType, EventOperation operation)
{
    switch (nodeType) {
        case ARKUI_NODE_IMAGE:
            BindEventFunc(newNode, NODE_IMAGE_ON_COMPLETE, NODE_IMAGE_ON_DOWNLOAD_PROGRESS, operation);
            break;
        case ARKUI_NODE_DATE_PICKER:
            BindEventFunc(
                newNode, NODE_DATE_PICKER_EVENT_ON_DATE_CHANGE, NODE_DATE_PICKER_EVENT_ON_DATE_CHANGE, operation);
            break;
        case ARKUI_NODE_TIME_PICKER:
            BindEventFunc(newNode, NODE_TIME_PICKER_EVENT_ON_CHANGE, NODE_TIME_PICKER_EVENT_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_TEXT_PICKER:
            BindEventFunc(newNode, NODE_TEXT_PICKER_EVENT_ON_CHANGE, NODE_TEXT_PICKER_EVENT_ON_SCROLL_STOP, operation);
            break;
        case ARKUI_NODE_CALENDAR_PICKER:
            BindEventFunc(
                newNode, NODE_CALENDAR_PICKER_EVENT_ON_CHANGE, NODE_CALENDAR_PICKER_EVENT_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_IMAGE_ANIMATOR:
            BindEventFunc(newNode, NODE_IMAGE_ANIMATOR_EVENT_ON_START, NODE_IMAGE_ANIMATOR_EVENT_ON_FINISH, operation);
            break;
        case ARKUI_NODE_SLIDER:
            BindEventFunc(newNode, NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR, NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR,
                operation);
            break;
        default:
            break;
    }
}

static void OnEventReceive(ArkUI_NodeEvent* event)
{
    int32_t eventTypeId = OH_ArkUI_NodeEvent_GetTargetId(event);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----OnEventReceive, eventTypeId:%{public}d", eventTypeId);
}

void NodeManager::BindEventFunc(ArkUI_NodeHandle newNode, int32_t begin, int32_t end, EventOperation operation)
{
    ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
    if (nodeApi == nullptr) {
        return;
    }
    if (operation == BIND_EVENT) {
        // 注册事件
        nodeApi->registerNodeEventReceiver(&OnEventReceive);
        int32_t ret = -1;
        for (int32_t index = begin; index <= end; index++) {
            ret = nodeApi->registerNodeEvent(newNode, (ArkUI_NodeEventType)index, index, nullptr);
            if (ret != ARKUI_ERROR_CODE_NO_ERROR) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----BIND_EVENT fail, errorcode:%{public}d", ret);
                break;
            }
        }
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----BIND_EVENT success");
    } else {
        for (int32_t index = begin; index <= end; index++) {
            nodeApi->unregisterNodeEvent(newNode, (ArkUI_NodeEventType)index);
        }
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----UNBIND_EVENT finish");
    }
}
} // namespace NativeNode::Manager
