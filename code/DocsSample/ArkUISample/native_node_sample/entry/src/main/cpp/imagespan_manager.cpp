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
#include "imagespan_manager.h"

#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <cstddef>
#include <cstdint>
#include <hilog/log.h>
#include <iomanip>
#include <napi/native_api.h>
#include <sstream>

namespace NativeNode::ImageSpan {

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

struct AttributeScope {
    ArkUI_NodeType nodeType;
    ArkUI_NodeAttributeType begin;
    ArkUI_NodeAttributeType end;
};

AttributeScope g_attributeArray[] = {
    {ARKUI_NODE_IMAGE_SPAN, NODE_IMAGE_SPAN_SRC, NODE_IMAGE_SPAN_BASELINE_OFFSET, NODE_IMAGE_SPAN_SUPPORT_SVG2},
    {ARKUI_NODE_IMAGE, NODE_BACKGROUND_IMAGE, NODE_IMAGE_ORIENTATION},
    {ARKUI_NODE_LOADING_PROGRESS, NODE_LOADING_PROGRESS_COLOR, NODE_LOADING_PROGRESS_ENABLE_LOADING},
    {ARKUI_NODE_PROGRESS, NODE_PROGRESS_VALUE, NODE_PROGRESS_LINEAR_STYLE},
    {ARKUI_NODE_DATE_PICKER, NODE_DATE_PICKER_LUNAR, NODE_DATE_PICKER_CAN_LOOP},
    {ARKUI_NODE_TIME_PICKER, NODE_TIME_PICKER_SELECTED, NODE_TIME_PICKER_ENABLE_CASCADE},
    {ARKUI_NODE_TEXT_PICKER, NODE_TEXT_PICKER_OPTION_RANGE, NODE_TEXT_PICKER_SELECTED_BACKGROUND_STYLE},
    {ARKUI_NODE_CALENDAR_PICKER, NODE_CALENDAR_PICKER_HINT_RADIUS, NODE_CALENDAR_PICKER_MARK_TODAY},
    {ARKUI_NODE_IMAGE_ANIMATOR, NODE_IMAGE_ANIMATOR_IMAGES, NODE_IMAGE_ANIMATOR_ITERATION},
};

static ArkUI_NumberValue hdrBrightness[] = { { .f32 = 1.0 } };
static ArkUI_NumberValue orientation[] = { { .i32 = ARKUI_ORIENTATION_RIGHT } };
static ArkUI_NumberValue copyOption[] = { { .i32 = ARKUI_COPY_OPTIONS_IN_APP } };
static ArkUI_NumberValue imageMatrix[MATRIX_ARRAY_SIZE] = { { .f32 = 5.0f }, { .f32 = 0.0f }, { .f32 = 0.0f },
    { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 1.0f }, { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 0.0f },
    { .f32 = 0.0f }, { .f32 = 1.0f }, { .f32 = 0.0f }, { .f32 = 0.0f }, { .f32 = 50.0f },
    { .f32 = 0.0f }, { .f32 = 1.0f } };
static ArkUI_NumberValue dynamicRangeMode[] = { { .i32 = 1 } };
static ArkUI_NumberValue enableAnalyzer[] = { { .i32 = 1 } };
static ArkUI_NumberValue matchDirection[] = { { .i32 = 1 } };
static ArkUI_NumberValue sourceSize[] = { { .i32 = 80 }, { .i32 = 90 } }; // 80, 90 means image width height
static ArkUI_NumberValue commonValue1[] = {{.i32 = 1}};
static ArkUI_NumberValue commonValue2[] = {{.f32 = 10.0f}};
static ArkUI_NumberValue textPickerValue1[] = {{.i32 = ARKUI_TEXTPICKER_RANGETYPE_SINGLE}};
static ArkUI_NumberValue textPickerValue2[] = {{.i32 = 0}};
static ArkUI_NumberValue textPickerValue3[] = {{.f32 = 1.0f}};
static ArkUI_NumberValue calendarPickerValue1[] = { { .f32 = 10.0f } };
static ArkUI_NumberValue calendarPickerValue2[] = { { .u32 = 2025 }, { .u32 = 1 }, { .u32 = 1 } };
static ArkUI_NumberValue calendarPickerValue3[] = { { .i32 = ARKUI_CALENDAR_ALIGNMENT_START }, { .f32 = 10.0f },
    { .f32 = 10.0f } };
static ArkUI_NumberValue calendarPickerValue4[] = { { .u32 = 0xFFFF0000 }, { .f32 = 10.0f },
    { .i32 = ARKUI_FONT_WEIGHT_NORMAL } };
static ArkUI_NumberValue calendarPickerValue5[] = {{.u32 = 0xFF1122FF}};

static ArkUI_NumberValue imageAnimatorValue2[] = {{.i32 = 500}};
static ArkUI_NumberValue imageAnimatorValue3[] = {{.i32 = 5}};

// ARKUI_NODE_IMAGE_SPAN
static ArkUI_NumberValue imageSpanValue2[] = {{.i32 = ARKUI_IMAGE_SPAN_ALIGNMENT_BASELINE}};
// ARKUI_NODE_IMAGE
const char START_ICON_PATH[] = "resource://base/media/startIcon.png";
const char BACKGROUND_PATH[] = "resource://base/media/background.png";
static ArkUI_NumberValue imageValue2[] = {{.f32 = 100.0f}, {.f32 = 100.0f}};
static ArkUI_NumberValue imageValue3[] = {{.f32 = 100.0f}};
static ArkUI_NumberValue imageValue4[] = {{.f32 = 0.0f}, {.f32 = 0.0f}};
static ArkUI_NumberValue imageValue5[] = {{.f32 = 5.0f}, {.f32 = 5.0f}, {.f32 = 5.0f}, {.f32 = 5.0f}};
static ArkUI_NumberValue imageValue6[] = {{.i32 = ARKUI_OBJECT_FIT_CONTAIN}};
static ArkUI_NumberValue imageValue7[] = {{.i32 = ARKUI_IMAGE_INTERPOLATION_NONE}};
static ArkUI_NumberValue imageValue8[20] = {{.f32 = 0.0f}};
static ArkUI_NumberValue imageValue9[] = {{.i32 = ARKUI_IMAGE_RENDER_MODE_ORIGINAL}};
static ArkUI_NumberValue imageValue10[] = {{.u32 = 0X0000FFFF}};

// ARKUI_NODE_LOADING_PROGRESS
static ArkUI_NumberValue loadProcessValue1[] = {{.u32 = 0XFFFF0000}};
static ArkUI_NumberValue processValue1[] = {{.i32 = ARKUI_PROGRESS_TYPE_LINEAR}};
// ARKUI_NODE_IMAGE_ANIMATOR
static ArkUI_NumberValue imageAnimatorValue1[] = {{.f32 = 200.0f}};

static std::map<int32_t, ArkUI_AttributeItem> attributeValueMap = {
    // ARKUI_NODE_IMAGE_SPAN
    {NODE_IMAGE_SPAN_SRC, {commonValue1, 1, START_ICON_PATH, nullptr}},
    {NODE_IMAGE_SPAN_VERTICAL_ALIGNMENT, {imageSpanValue2, 1, nullptr, nullptr}},
    {NODE_IMAGE_SPAN_ALT, {commonValue1, 1, BACKGROUND_PATH, nullptr}},
    {NODE_IMAGE_SPAN_BASELINE_OFFSET, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_SPAN_SUPPORT_SVG2, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_IMAGE
    {NODE_BACKGROUND_IMAGE, {commonValue1, 1, BACKGROUND_PATH, nullptr}},
    {NODE_BACKGROUND_IMAGE_SIZE, {imageValue2, 2, nullptr, nullptr}},
    {NODE_BACKGROUND_IMAGE_SIZE_WITH_STYLE, {imageValue3, 1, nullptr, nullptr}},
    {NODE_BACKGROUND_IMAGE_POSITION, {imageValue4, 2, nullptr, nullptr}},
    {NODE_BACKGROUND_IMAGE_RESIZABLE_WITH_SLICE, {imageValue5, 4, nullptr, nullptr}},
    {NODE_IMAGE_SRC, {commonValue1, 1, START_ICON_PATH, nullptr}},
    {NODE_IMAGE_OBJECT_FIT, {imageValue6, 1, nullptr, nullptr}},
    {NODE_IMAGE_INTERPOLATION, {imageValue7, 1, nullptr, nullptr}},
    {NODE_IMAGE_OBJECT_REPEAT, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_COLOR_FILTER, {imageValue8, 20, nullptr, nullptr}},
    {NODE_IMAGE_AUTO_RESIZE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_ALT, {commonValue1, 1, START_ICON_PATH, nullptr}},
    {NODE_IMAGE_DRAGGABLE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_RENDER_MODE, {imageValue9, 1, nullptr, nullptr}},
    {NODE_IMAGE_FIT_ORIGINAL_SIZE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_FILL_COLOR, {imageValue10, 1, nullptr, nullptr}},
    {NODE_IMAGE_RESIZABLE, {imageValue5, 4, nullptr, nullptr}},
    {NODE_IMAGE_SYNC_LOAD, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_HDR_BRIGHTNESS, {hdrBrightness, 1, nullptr, nullptr}},
    {NODE_IMAGE_ORIENTATION, {orientation, 1, nullptr, nullptr}},
    {NODE_IMAGE_IMAGE_MATRIX, {imageMatrix, MATRIX_ARRAY_SIZE, nullptr, nullptr}},
    {NODE_IMAGE_COPY_OPTION, {copyOption, 1, nullptr, nullptr}},
    {NODE_IMAGE_DYNAMIC_RANGE_MODE, {dynamicRangeMode, 1, nullptr, nullptr}},
    {NODE_IMAGE_ENABLE_ANALYZER, {enableAnalyzer, 1, nullptr, nullptr}},
    {NODE_IMAGE_MATCH_TEXT_DIRECTION, {matchDirection, 1, nullptr, nullptr}},
    {NODE_IMAGE_SOURCE_SIZE, {sourceSize, 2, nullptr, nullptr}},
    // ARKUI_NODE_LOADING_PROGRESS
    {NODE_LOADING_PROGRESS_COLOR, {loadProcessValue1, 1, nullptr, nullptr}},
    {NODE_LOADING_PROGRESS_ENABLE_LOADING, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_PROGRESS
    {NODE_PROGRESS_VALUE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_PROGRESS_TOTAL, {commonValue1, 1, nullptr, nullptr}},
    {NODE_PROGRESS_COLOR, {loadProcessValue1, 1, nullptr, nullptr}},
    {NODE_PROGRESS_TYPE, {processValue1, 1, nullptr, nullptr}},
    {NODE_PROGRESS_LINEAR_STYLE, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_DATE_PICKER
    {NODE_DATE_PICKER_LUNAR, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_DATE_PICKER_START, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_DATE_PICKER_END, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_DATE_PICKER_SELECTED, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_DATE_PICKER_DISAPPEAR_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_DATE_PICKER_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_DATE_PICKER_SELECTED_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_DATE_PICKER_MODE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_DATE_PICKER_ENABLE_HAPTIC_FEEDBACK, {commonValue1, 1, nullptr, nullptr}},
    {NODE_DATE_PICKER_CAN_LOOP, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_TIME_PICKER
    {NODE_TIME_PICKER_SELECTED, {commonValue1, 1, "11-59", nullptr}},
    {NODE_TIME_PICKER_USE_MILITARY_TIME, {commonValue1, 1, "11-59", nullptr}},
    {NODE_TIME_PICKER_DISAPPEAR_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TIME_PICKER_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TIME_PICKER_SELECTED_TEXT_STYLE, {commonValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TIME_PICKER_START, {commonValue1, 1, "00:00:00", nullptr}},
    {NODE_TIME_PICKER_END, {commonValue1, 1, "23:59:59", nullptr}},
    {NODE_TIME_PICKER_ENABLE_CASCADE, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_TEXT_PICKER
    {NODE_TEXT_PICKER_OPTION_RANGE, {textPickerValue1, 1, "1;2;3", nullptr}},
    {NODE_TEXT_PICKER_OPTION_SELECTED, {textPickerValue2, 1, nullptr, nullptr}},
    {NODE_TEXT_PICKER_OPTION_VALUE, {textPickerValue1, 1, "1;2;3", nullptr}},
    {NODE_TEXT_PICKER_DISAPPEAR_TEXT_STYLE, {textPickerValue1, 1,
        "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TEXT_PICKER_TEXT_STYLE, {textPickerValue1, 1, "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TEXT_PICKER_SELECTED_TEXT_STYLE, {textPickerValue1, 1,
        "#ff182431;14;normal;Arial;normal", nullptr}},
    {NODE_TEXT_PICKER_SELECTED_INDEX, {textPickerValue2, 1, nullptr, nullptr}},
    {NODE_TEXT_PICKER_CAN_LOOP, {commonValue1, 1, nullptr, nullptr}},
    {NODE_TEXT_PICKER_DEFAULT_PICKER_ITEM_HEIGHT, {textPickerValue3, 1, nullptr, nullptr}},
    {NODE_TEXT_PICKER_ENABLE_HAPTIC_FEEDBACK, {textPickerValue2, 1, nullptr, nullptr}},
    {NODE_TEXT_PICKER_SELECTED_BACKGROUND_STYLE, {calendarPickerValue5, 1, nullptr, nullptr}},
    // ARKUI_NODE_CALENDAR_PICKER
    {NODE_CALENDAR_PICKER_HINT_RADIUS, {calendarPickerValue1, 1, nullptr, nullptr}},
    {NODE_CALENDAR_PICKER_SELECTED_DATE, {calendarPickerValue2, 3, nullptr, nullptr}},
    {NODE_CALENDAR_PICKER_EDGE_ALIGNMENT, {calendarPickerValue3, 3, nullptr, nullptr}},
    {NODE_CALENDAR_PICKER_TEXT_STYLE, {calendarPickerValue4, 3, nullptr, nullptr}},
    {NODE_CALENDAR_PICKER_START, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_CALENDAR_PICKER_END, {commonValue1, 1, "2025-1-1", nullptr}},
    {NODE_CALENDAR_PICKER_DISABLED_DATE_RANGE, {commonValue1, 1, "2025-01-01,2025-01-02", nullptr}},
    {NODE_CALENDAR_PICKER_MARK_TODAY, {commonValue1, 1, nullptr, nullptr}},
    // ARKUI_NODE_IMAGE_ANIMATOR
    {NODE_IMAGE_ANIMATOR_IMAGES, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_STATE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_DURATION, {imageAnimatorValue2, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_REVERSE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_FIXED_SIZE, {imageAnimatorValue3, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_FILL_MODE, {commonValue1, 1, nullptr, nullptr}},
    {NODE_IMAGE_ANIMATOR_ITERATION, {commonValue1, 1, nullptr, nullptr}},
};

static ArkUI_ImageAnimatorFrameInfo* imageAnimatorFrame = nullptr;
static ArkUI_ImageAnimatorFrameInfo* GetImageAnimator()
{
    if (imageAnimatorFrame == nullptr) {
        imageAnimatorFrame = OH_ArkUI_ImageAnimatorFrameInfo_CreateFromString("resource://base/media/startIcon.png");
        if (imageAnimatorFrame != nullptr) {
            OH_ArkUI_ImageAnimatorFrameInfo_SetWidth(imageAnimatorFrame, imageAnimatorValue1[0].f32);
            OH_ArkUI_ImageAnimatorFrameInfo_SetHeight(imageAnimatorFrame, imageAnimatorValue1[0].f32);
        } else {
            OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager", "-----GetImageAnimator, frame is null");
        }
    }
    return imageAnimatorFrame;
}

static void DisposeImageAnimator()
{
    OH_ArkUI_ImageAnimatorFrameInfo_Dispose(imageAnimatorFrame);
    imageAnimatorFrame = nullptr;
}

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
        GetNodeApi()->disposeNode(it->second.nodeHandle);
        nativeNodeMap_.erase(it);
    }
}

ArkUI_NodeHandle NodeManager::GetMainPageSroll()
{
    if (mainPageScroll_ == nullptr) {
        ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
        mainPageScroll_ = nodeApi->createNode(ARKUI_NODE_SCROLL);
    }
    return mainPageScroll_;
}

int32_t NodeManager::CreateNativeNode(int32_t nodeType)
{
    ArkUI_NativeNodeAPI_1* nodeApi = GetNodeApi();
    if (nodeApi == nullptr) {
        return -1;
    }
    bool isValid = false;
    for (int i = 0; i < sizeof(g_attributeArray) / sizeof(AttributeScope); i++) {
        if (g_attributeArray[i].nodeType == nodeType) {
            isValid = true;
            break;
        }
    }
    if (!isValid) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager", "-----CreateNativeNode, isValid is false");
        return -1;
    }

    ArkUI_NodeHandle newNode = nodeApi->createNode((ArkUI_NodeType)nodeType);
    if (nodeType == ARKUI_NODE_IMAGE || nodeType == ARKUI_NODE_IMAGE_SPAN) {
        ArkUI_AttributeItem srcItem = {};
        srcItem.string = "resource://base/media/startIcon2.png";
        nodeApi->setAttribute(newNode, NODE_IMAGE_SRC, &srcItem);
        ArkUI_NumberValue valueWidth[] = { { .f32 = 200 } };
        ArkUI_AttributeItem itemWidth = { valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_WIDTH, &itemWidth);
        ArkUI_NumberValue valueHeight[] = { { .f32 = 200 } };
        ArkUI_AttributeItem itemHeight = { valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_HEIGHT, &itemHeight);
        ArkUI_NumberValue hdrBrightness[] = {{.f32 = 0.1}}; // 0.1 means hdr brightness value
        ArkUI_AttributeItem valueItem = {hdrBrightness, sizeof(hdrBrightness) / sizeof(ArkUI_NumberValue)};
        nodeApi->setAttribute(newNode, NODE_IMAGE_HDR_BRIGHTNESS, &valueItem);
        ArkUI_NumberValue dynamicMode[] = {{.i32 = 2}}; // 2 means dynamic range mode
        ArkUI_AttributeItem valueItemRangeMode = {dynamicMode, sizeof(dynamicMode) / sizeof(ArkUI_NumberValue)};
        nodeApi->setAttribute(newNode, NODE_IMAGE_DYNAMIC_RANGE_MODE, &valueItemRangeMode);
    }

    int32_t newNodeId = AddNativeNode(newNode, nodeType);
    BindEventByType(newNode, nodeType, BIND_EVENT);
    nodeApi->addChild(mainPageScroll_, newNode);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
        "NodeManager", "-----CreateNativeNode, nodeType:%{public}d, nodeId:%{public}d", nodeType, newNodeId);
    return newNodeId;
}

void NodeManager::RemoveOldNode(int32_t nodeId)
{
    ArkUI_NodeHandle oldNode = GetNativeNode(nodeId).nodeHandle;
    int32_t nodeType = GetNativeNode(nodeId).nodeType;
    GetNodeApi()->removeChild(mainPageScroll_, oldNode);
    BindEventByType(oldNode, nodeType, UNBIND_EVENT);
    if (nodeId == ARKUI_NODE_IMAGE_ANIMATOR) {
        DisposeImageAnimator();
    }
    RemoveNativeNode(nodeId);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NodeManager", "-----RemoveOldNode, nodeId:%{public}d", nodeId);
}

bool NodeManager::IsValidAttributeType(int32_t nodeType, int32_t attributeType)
{
    bool isValid = false;
    for (int i = 0; i < sizeof(g_attributeArray) / sizeof(AttributeScope); i++) {
        if (g_attributeArray[i].nodeType == nodeType) {
            if (g_attributeArray[i].begin <= attributeType && attributeType <= g_attributeArray[i].end) {
                isValid = true;
            }
            break;
        }
    }
    if (!isValid) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager", "--IsValidAttributeType, isValid is false");
    }
    return isValid;
}

int32_t NodeManager::SetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType)
{
    int32_t ret = 0;
    if (!IsValidAttributeType(nodeType, attributeType)) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    ArkUI_NodeHandle node = GetNativeNode(nodeId).nodeHandle;
    if (nodeApi == nullptr || node == nullptr) {
        return ARKUI_ERROR_CODE_PARAM_INVALID;
    }

    ArkUI_AttributeItem attributeItem = {};
    if (attributeValueMap.count(attributeType)) {
        attributeItem = attributeValueMap[attributeType];
        if (attributeType == NODE_IMAGE_ANIMATOR_IMAGES) {
            if (GetImageAnimator() == nullptr) {
                return -1;
            }
            ArkUI_ImageAnimatorFrameInfo* frame = GetImageAnimator();
            attributeItem.object = (void*)(&frame);
        }
    }
    if (attributeType == NODE_IMAGE_IMAGE_MATRIX) {
        int32_t objectFitValue = ArkUI_ObjectFit::ARKUI_OBJECT_FIT_NONE_MATRIX;
        ArkUI_NumberValue valueObject[] = { { .i32 = objectFitValue } };
        ArkUI_AttributeItem valueItem = { valueObject, sizeof(valueObject) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_IMAGE_OBJECT_FIT, &valueItem);
    }
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
        "NodeManager", "-----SetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
    return ret;
}

int32_t NodeManager::SetNativeNodeAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType, int32_t value)
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

    ArkUI_NumberValue itemValue[] = { { .i32 = value } };
    ArkUI_AttributeItem attributeItem = { itemValue, sizeof(itemValue) / sizeof(ArkUI_NumberValue) };
    // set NODE_IMAGE_COPY_OPTION, attribute value is ARKUI_COPY_OPTIONS_LOCAL_DEVICE
    if (attributeType == NODE_IMAGE_COPY_OPTION) {
        int32_t copyValue = ArkUI_CopyOptions::ARKUI_COPY_OPTIONS_LOCAL_DEVICE;
        ArkUI_NumberValue value[] = { { .i32 = copyValue } };
        ArkUI_AttributeItem valueCopyItem = { value, sizeof(value) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(node, NODE_IMAGE_COPY_OPTION, &valueCopyItem);
    }
    // set other attribute type
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    if (ret != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "NODE_IMAGE SetAttribute failed");
        return -1;
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
    // set attribute type is NODE_IMAGE_HDR_BRIGHTNESS
    if (attributeType == NODE_IMAGE_HDR_BRIGHTNESS) {
        ArkUI_NumberValue valueHdrBrightness[] = { {.f32 = value[0]} };
        ArkUI_AttributeItem valueItemHdr = { valueHdrBrightness,
            sizeof(valueHdrBrightness) / sizeof(ArkUI_NumberValue) };
        ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &valueItemHdr);
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
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager",
        "NODE_IMAGE ResetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
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
    if (attributeItem == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager",
            "----- GetNativeNodeAttribute is failed , type:%{public}d", attributeType);
        return nullptr;
    }
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager",
        "----- GetAttribute, type:%{public}d, size:%{public}d, value:%{public}d, str:%{public}s", attributeType,
        attributeItem->size, attributeItem->value[0].i32, attributeItem->string);
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
        default:
            break;
    }
}

static void OnEventReceive(ArkUI_NodeEvent* event)
{
    int32_t eventTypeId = OH_ArkUI_NodeEvent_GetTargetId(event);
    OH_LOG_Print(LOG_APP, LOG_INFO,
        LOG_PRINT_DOMAIN, "NodeManager", "-----OnEventReceive, eventTypeId:%{public}d", eventTypeId);
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
                OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
                    "NodeManager", "-----BIND_EVENT fail, errorcode:%{public}d", ret);
                break;
            }
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NodeManager", "-----BIND_EVENT success");
    } else {
        for (int32_t index = begin; index <= end; index++) {
            nodeApi->unregisterNodeEvent(newNode, (ArkUI_NodeEventType)index);
        }
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NodeManager", "-----UNBIND_EVENT finish");
    }
}

napi_value TransTool::CreateImageSpanPage(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateImageSpanPage BEGIN");
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateImageSpanPage env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateImageSpanPage napi_get_cb_info failed");
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &nodeContentHandle);

    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "OH_ArkUI_GetBasicNodeAPI after");
    ArkUI_NativeNodeAPI_1* nodeApi = NodeManager::GetNodeApi();
    if (nodeApi != nullptr) {
        if (nodeApi->createNode != nullptr && nodeApi->addChild != nullptr) {
            ArkUI_NodeHandle pageNode = NodeManager::GetInstance().GetMainPageSroll();
            OH_ArkUI_NodeContent_AddNode(nodeContentHandle, pageNode);
        }
    }
    return nullptr;
}

napi_value TransTool::CreateImageSpanNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeType;
    napi_get_value_int32(env, args[0], &nodeType);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "TransTool", "-----CreateImageSpanNode, input nodeType:%{public}d", nodeType);
    if (nodeType < 0) {
        napi_value result;
        napi_create_int32(env, -1, &result);
        return result;
    }

    int32_t newNodeId = NodeManager::GetInstance().CreateNativeNode(nodeType);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "TransTool", "-----CreateImageSpanNode, newNodeId:%{public}d", newNodeId);
    if (newNodeId != -1) {
        napi_value result;
        napi_create_int32(env, newNodeId, &result);
        return result;
    }
    return nullptr;
}

napi_value TransTool::RemoveImageSpanNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    if (nodeId < 0) {
        return nullptr;
    }

    NodeManager::GetInstance().RemoveOldNode(nodeId);
    return nullptr;
}

static std::vector<float> ParseFloatValues(const std::string& value)
{
    std::vector<float> floatValues;
    std::stringstream ss(value);
    std::string item;
    while (std::getline(ss, item, '/')) {
        if (!item.empty()) {
            try {
                float floatValue = std::stof(item);
                floatValues.push_back(floatValue);
            } catch (const std::exception&) {
                continue;
            }
        }
    }
    return floatValues;
}

static int32_t HandleStringAttribute(int32_t nodeId, int32_t nodeType, int32_t attributeType, const std::string& value)
{
    std::vector<float> floatValues;
    size_t slashCount = std::count(value.begin(), value.end(), '/');
    if (slashCount > 0) {
        floatValues = ParseFloatValues(value);
        if (!floatValues.empty()) {
            return NodeManager::GetInstance().SetNativeNodeAttribute(
                nodeId, nodeType, attributeType, floatValues);
        }
    }
    if (value.find('.') != std::string::npos) {
        try {
            float floatValue = std::stof(value);
            floatValues.push_back(floatValue);
            return NodeManager::GetInstance().SetNativeNodeAttribute(
                nodeId, nodeType, attributeType, floatValues);
        } catch (const std::exception&) {
            return -1;
        }
    }

    try {
        // case-insensitive contains check for "none", if it's found, call default value
        std::string lowerValue = value;
        std::transform(lowerValue.begin(), lowerValue.end(), lowerValue.begin(),
            [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
        if (lowerValue.find("none") != std::string::npos) {
            return NodeManager::GetInstance().SetNativeNodeAttribute(
                nodeId, nodeType, attributeType);
        }
        int32_t intValue = std::stoi(value);
        if (intValue < 0) {
            return NodeManager::GetInstance().SetNativeNodeAttribute(
                nodeId, nodeType, attributeType);
        }
        return NodeManager::GetInstance().SetNativeNodeAttribute(
            nodeId, nodeType, attributeType, intValue);
    } catch (const std::exception&) {
        return -1;
    }
}

napi_value TransTool::SetImageSpanAttribute(napi_env env, napi_callback_info info)
{
    size_t argc = 4; // 4 means four arguments are expected
    napi_value args[4] = {nullptr}; // 4 means four arguments size
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    int32_t nodeType;
    napi_get_value_int32(env, args[1], &nodeType);
    int32_t attributeType;
    napi_get_value_int32(env, args[2], &attributeType); // 2 means the third argument

    napi_valuetype valueType;
    napi_typeof(env, args[3], &valueType); // 3 means the fourth argument
    int32_t ret = -1;
    if (valueType != napi_string) {
        napi_value result;
        napi_create_int32(env, ret, &result);
        return result;
    }

    size_t valueLen;
    napi_get_value_string_utf8(env, args[3], nullptr, 0, &valueLen); // 3 means the fourth argument

    std::string value(valueLen + 1, '\0');
    napi_get_value_string_utf8(env, args[3], &value[0], valueLen + 1, nullptr); // 3 means the fourth argument

    ret = HandleStringAttribute(nodeId, nodeType, attributeType, value);

    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

napi_value TransTool::ResetImageSpanAttribute(napi_env env, napi_callback_info info)
{
    size_t argc = 3; // 3 means 3 arguments are expected
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    int32_t nodeType;
    napi_get_value_int32(env, args[1], &nodeType);
    int32_t attributeType;
    napi_get_value_int32(env, args[2], &attributeType); // 2 means the third argument

    int32_t ret = NodeManager::GetInstance().ResetNativeNodeAttribute(nodeId,
        nodeType, attributeType);
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

napi_value CreateNapiResult(napi_env env, int32_t value)
{
    napi_value result;
    napi_create_int32(env, value, &result);
    return result;
}

napi_value CreateNapiString(napi_env env, const std::string& str)
{
    napi_value result;
    napi_create_string_utf8(env, str.c_str(), str.length(), &result);
    return result;
}

static bool ParseGetArgs(napi_env env, napi_callback_info info,
    int32_t& nodeId, int32_t& nodeType, int32_t& attributeType)
{
    size_t argc = 3; // 3 means three arguments are expected
    napi_value args[3] = { nullptr, nullptr, nullptr }; // 3 means three arguments are expected
    napi_status status = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (status != napi_ok || argc < 3) { // 3 means three arguments are expected
        return false;
    }
    if (napi_get_value_int32(env, args[0], &nodeId) != napi_ok ||
        napi_get_value_int32(env, args[1], &nodeType) != napi_ok ||
        napi_get_value_int32(env, args[2], &attributeType) != napi_ok) { // 2 means the third argument
        return false;
    }
    return nodeType >= 0 && attributeType >= 0;
}

static std::string AttributeItemToString(const ArkUI_AttributeItem* item, int32_t attributeType)
{
    if (item == nullptr) {
        return "-1";
    }
    const bool isFloatAttribute = (attributeType == NODE_IMAGE_HDR_BRIGHTNESS ||
        attributeType == NODE_IMAGE_IMAGE_MATRIX);
    std::stringstream ss;
    bool hasValue = false;
    if (item->size > 0 && item->value != nullptr) {
        for (size_t i = 0; i < item->size; i++) {
            if (hasValue) {
                ss << "/";
            }
            if (isFloatAttribute) {
                ss << std::fixed << std::setprecision(2) << item->value[i].f32; // 2 means two decimal places
            } else {
                ss << item->value[i].i32;
            }
            hasValue = true;
        }
    }
    if (item->string != nullptr && item->string[0] != '\0') {
        if (hasValue) {
            ss << "/";
        }
        ss << item->string;
        hasValue = true;
    }
    if (!hasValue) {
        ss << "-1";
    }
    return ss.str();
}

napi_value TransTool::GetImageSpanAttribute(napi_env env, napi_callback_info info)
{
    int32_t nodeId = -1;
    int32_t nodeType = -1;
    int32_t attributeType = -1;
    if (!ParseGetArgs(env, info, nodeId, nodeType, attributeType)) {
        return CreateNapiResult(env, -1);
    }
    const ArkUI_AttributeItem* item = NodeManager::GetInstance().GetNativeNodeAttribute(
        nodeId, nodeType, attributeType);
    if (item == nullptr) {
        return CreateNapiResult(env, -1);
    }
    return CreateNapiString(env, AttributeItemToString(item, attributeType));
}
} // namespace NativeNode::Manager