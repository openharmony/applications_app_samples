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
    {ARKUI_NODE_IMAGE_SPAN, NODE_IMAGE_SPAN_SRC, NODE_IMAGE_SPAN_BASELINE_OFFSET},
    {ARKUI_NODE_IMAGE, NODE_BACKGROUND_IMAGE, NODE_IMAGE_SYNC_LOAD},
    {ARKUI_NODE_LOADING_PROGRESS, NODE_LOADING_PROGRESS_COLOR, NODE_LOADING_PROGRESS_ENABLE_LOADING},
    {ARKUI_NODE_PROGRESS, NODE_PROGRESS_VALUE, NODE_PROGRESS_LINEAR_STYLE},
    {ARKUI_NODE_DATE_PICKER, NODE_DATE_PICKER_LUNAR, NODE_DATE_PICKER_CAN_LOOP},
    {ARKUI_NODE_TIME_PICKER, NODE_TIME_PICKER_SELECTED, NODE_TIME_PICKER_ENABLE_CASCADE},
    {ARKUI_NODE_TEXT_PICKER, NODE_TEXT_PICKER_OPTION_RANGE, NODE_TEXT_PICKER_SELECTED_BACKGROUND_STYLE},
    {ARKUI_NODE_CALENDAR_PICKER, NODE_CALENDAR_PICKER_HINT_RADIUS, NODE_CALENDAR_PICKER_MARK_TODAY},
    {ARKUI_NODE_IMAGE_ANIMATOR, NODE_IMAGE_ANIMATOR_IMAGES, NODE_IMAGE_ANIMATOR_ITERATION},
};

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
        ArkUI_NumberValue valueWidth[] = { { .f32 = 200 } };
        ArkUI_AttributeItem itemWidth = { valueWidth, sizeof(valueWidth) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_WIDTH, &itemWidth);
        ArkUI_NumberValue valueHeight[] = { { .f32 = 200 } };
        ArkUI_AttributeItem itemHeight = { valueHeight, sizeof(valueHeight) / sizeof(ArkUI_NumberValue) };
        nodeApi->setAttribute(newNode, NODE_HEIGHT, &itemHeight);
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
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
        "NodeManager", "-----SetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
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

    int32_t ret = -1;
    try {
        ret = NodeManager::GetInstance().SetNativeNodeAttribute(nodeId, nodeType, attributeType);
    } catch (const std::exception&) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager", "-----SetNativeNodeAttribute exception");
    }

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

napi_value TransTool::GetImageSpanAttribute(napi_env env, napi_callback_info info)
{
    size_t argc = 3; // 3 means three arguments are expected
    napi_value args[3] = {nullptr}; // 3 means three arguments are expected
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int32_t nodeId = -1;
    napi_get_value_int32(env, args[0], &nodeId);
    int32_t nodeType = -1;
    napi_get_value_int32(env, args[1], &nodeType);
    int32_t attributeType = -1;
    napi_get_value_int32(env, args[2], &attributeType); // 2 means the third argument
    napi_value result;
    if (nodeType < 0 || attributeType < 0) {
        napi_create_int32(env, -1, &result);
        return result;
    }
    const ArkUI_AttributeItem* item = NodeManager::GetInstance().GetNativeNodeAttribute(nodeId,
        nodeType, attributeType);
    if (item == nullptr) {
        napi_create_int32(env, -1, &result);
        return result;
    }
    std::stringstream ss;
    bool hasValue = false;
    if (item->size > 0) {
        for (size_t i = 0; i < item->size; i++) {
            if (hasValue) {
                ss << "/";
            }
            ss << static_cast<int32_t>(item->value[i].i32);
            hasValue = true;
        }
    }
    if (item->string != nullptr) {
        if (hasValue) {
            ss << "/";
        }
        ss << item->string;
        hasValue = true;
    }
    if (!hasValue) {
        ss << "-1";
    }
    std::string resultStr = ss.str();
    napi_create_string_utf8(env, resultStr.c_str(), resultStr.length(), &result);
    return result;
}
} // namespace NativeNode::Manager