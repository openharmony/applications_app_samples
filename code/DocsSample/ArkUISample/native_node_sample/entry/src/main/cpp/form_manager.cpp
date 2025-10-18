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
#include "form_manager.h"

#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <cstddef>
#include <cstdint>
#include <hilog/log.h>
#include <napi/native_api.h>
#include <sstream>

namespace NativeNode::Form {

constexpr uint32_t MATRIX_ARRAY_SIZE = 16;
napi_ref g_callbackRef = nullptr;
napi_env g_env = nullptr;
uint32_t g_colors[] = {0xFFFEBB62, 0xffFFA0A4};
float g_stops[] = {0, 1.0};
static ArkUI_ColorStop linerGrand[] = {{g_colors, g_stops, 2}};

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
    {ARKUI_NODE_TOGGLE, NODE_TOGGLE_SELECTED_COLOR, NODE_TOGGLE_UNSELECTED_COLOR},
    {ARKUI_NODE_BUTTON, NODE_BUTTON_LABEL, NODE_BUTTON_MAX_FONT_SCALE},
    {ARKUI_NODE_CHECKBOX, NODE_CHECKBOX_SELECT, NODE_CHECKBOX_GROUP},
    {ARKUI_NODE_SLIDER, NODE_SLIDER_BLOCK_COLOR, NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR},
    {ARKUI_NODE_RADIO, NODE_RADIO_CHECKED, NODE_RADIO_GROUP},
    {ARKUI_NODE_CHECKBOX_GROUP, NODE_CHECKBOX_GROUP_NAME, NODE_CHECKBOX_GROUP_SHAPE},
};

static ArkUI_NumberValue togglePickerValue[] = {{.u32 = 0XFFFF0000}};

static ArkUI_NumberValue buttonPickerValue[] = {{.f32 = 10.0f}};
static ArkUI_NumberValue buttonPickerValue1[] = {{.i32 = ARKUI_BUTTON_TYPE_NORMAL}};
static ArkUI_NumberValue buttonPickerValue2[] = {{.f32 = 1.0f}};

static ArkUI_NumberValue checkboxPickerValue[] = {{.i32 = true}};
static ArkUI_NumberValue checkboxPickerValue1[] = {{.u32 = 0xFFFF0000}};
static ArkUI_NumberValue checkboxPickerValue2[] = {{.i32 = ArkUI_CHECKBOX_SHAPE_CIRCLE}};

static ArkUI_NumberValue sliderPickerValue[] = {{.u32 = 0xFFFF0000}};
static ArkUI_NumberValue sliderPickerValue1[] = {{.i32 = 1}};
static ArkUI_NumberValue sliderPickerValue2[] = {
    {.i32 = ARKUI_SLIDER_BLOCK_STYLE_IMAGE},
    {.i32 = ARKUI_CLIP_TYPE_PATH},
    {.f32 = 20},
    {.f32 = 20},
    {.f32 = 20}
};
static ArkUI_NumberValue sliderPickerValue3[] = {{.f32 = 0}};
static ArkUI_NumberValue sliderPickerValue4[] = {{.f32 = 100}};
static ArkUI_NumberValue sliderPickerValue5[] = {{.i32 = ARKUI_SLIDER_STYLE_OUT_SET}};
static ArkUI_NumberValue sliderPickerValue6[] = {{.i32 = true}};
static ArkUI_NumberValue sliderPickerValue7[] = {{.u32 = 0xFFFFFF00}};
static ArkUI_NumberValue sliderPickerValue8[] = {{.i32 = ARKUI_SLIDER_DIRECTION_VERTICAL}};
static ArkUI_NumberValue sliderPickerValue9[] = {{.f32 = 10.0}};

static ArkUI_NumberValue radioPickerValue[] = {{.i32 = true}};
static ArkUI_NumberValue radioPickerValue1[] = {{.u32 = 0xFFFF0000}, {.u32 = 0xFFFF0000}, {.u32 = 0xFFFF0000}};

static ArkUI_NumberValue checkbocGroupPickerValue[] = {{.i32 = 2}};
static ArkUI_NumberValue checkbocGroupPickerValue1[] = {{.i32 = 1}};
static ArkUI_NumberValue checkbocGroupPickerValue2[] = {{.u32 = 0xFFFF0000}, {.u32 = 0xFFFF0000}, {.u32 = 0xFFFF0000}};

static ArkUI_AlignmentRuleOption* CreatrObjects()
{
    ArkUI_NativeNodeAPI_1* nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    auto text = nodeAPI->createNode(ARKUI_NODE_TEXT);
    ArkUI_AttributeItem textItemId = { .string = "text" };
    nodeAPI->setAttribute(text, NODE_ID, &textItemId);
    auto alignmentRule = OH_ArkUI_AlignmentRuleOption_Create();
    OH_ArkUI_AlignmentRuleOption_SetEnd(alignmentRule, "text", ARKUI_HORIZONTAL_ALIGNMENT_END);
    OH_ArkUI_AlignmentRuleOption_SetCenterHorizontal(alignmentRule, "text", ARKUI_HORIZONTAL_ALIGNMENT_END);
    return alignmentRule;
}

static std::map<int32_t, ArkUI_AttributeItem> attributeValueMap = {
    // ARKUI_NODE_TOGGLE
    {NODE_TOGGLE_SELECTED_COLOR, {togglePickerValue, 1, nullptr, nullptr}},
    {NODE_TOGGLE_SWITCH_POINT_COLOR, {togglePickerValue, 1, nullptr, nullptr}},
    {NODE_TOGGLE_VALUE, {togglePickerValue, 1, nullptr, nullptr}},
    {NODE_TOGGLE_UNSELECTED_COLOR, {togglePickerValue, 1, nullptr, nullptr}},

    // ARKUI_NODE_BUTTON
    {NODE_BUTTON_LABEL, {buttonPickerValue, 1, "BUTTON", nullptr}},
    {NODE_BUTTON_TYPE, {buttonPickerValue1, 1, "BUTTON", nullptr}},
    {NODE_BUTTON_MIN_FONT_SCALE, {buttonPickerValue2, 1, "BUTTON", nullptr}},
    {NODE_BUTTON_MAX_FONT_SCALE, {buttonPickerValue, 1, "BUTTON", nullptr}},

    // ARKUI_NODE_CHECKBOX
    {NODE_CHECKBOX_SELECT, {checkboxPickerValue, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_SELECT_COLOR, {checkboxPickerValue1, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_UNSELECT_COLOR, {checkboxPickerValue1, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_MARK, {checkboxPickerValue1, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_SHAPE, {checkboxPickerValue2, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_NAME, {checkboxPickerValue, 1, "CHECKBOX", nullptr}},
    {NODE_CHECKBOX_GROUP, {checkboxPickerValue, 1, "CHECKBOX", nullptr}},

    // ARKUI_NODE_SLIDER
    {NODE_SLIDER_BLOCK_COLOR, {sliderPickerValue, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_TRACK_COLOR, {sliderPickerValue, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_SELECTED_COLOR, {sliderPickerValue7, 1, "SLIDER", nullptr}},
    { NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
    { NODE_SLIDER_TRACK_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
    { NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR, {nullptr, 0, nullptr, linerGrand} },
    {NODE_SLIDER_SHOW_STEPS, {sliderPickerValue6, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_BLOCK_STYLE, {sliderPickerValue2, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_VALUE, {sliderPickerValue9, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_MIN_VALUE, {sliderPickerValue3, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_MAX_VALUE, {sliderPickerValue4, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_DIRECTION, {sliderPickerValue8, 1, nullptr, nullptr}},
    {NODE_SLIDER_STEP, {sliderPickerValue9, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_STYLE, {sliderPickerValue5, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_REVERSE, {sliderPickerValue6, 1, nullptr, nullptr}},
    {NODE_SLIDER_TRACK_THICKNESS, {sliderPickerValue4, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_ENABLE_HAPTIC_FEEDBACK, {sliderPickerValue1, 1, "SLIDER", nullptr}},
    {NODE_SLIDER_PREFIX, {sliderPickerValue, 1, "SLIDER", CreatrObjects()}},
    {NODE_SLIDER_SUFFIX, {sliderPickerValue, 1, "SLIDER", CreatrObjects()}},

    // ARKUI_NODE_RADIO
    {NODE_RADIO_CHECKED, {radioPickerValue, 1, "SLIDER", nullptr}},
    {NODE_RADIO_STYLE, {radioPickerValue1, 1, "SLIDER", nullptr}},
    {NODE_RADIO_VALUE, {radioPickerValue, 1, "SLIDER", nullptr}},
    {NODE_RADIO_GROUP, {radioPickerValue, 1, "SLIDER", nullptr}},

    // ARKUI_NODE_CHECKBOX_GROUP
    {NODE_CHECKBOX_GROUP_NAME, {checkbocGroupPickerValue, 1, "SLIDER", nullptr}},
    {NODE_CHECKBOX_GROUP_SELECT_ALL, {checkbocGroupPickerValue1, 1, "SLIDER", nullptr}},
    {NODE_CHECKBOX_GROUP_SELECTED_COLOR, {checkbocGroupPickerValue2, 1, "SLIDER", nullptr}},
    {NODE_CHECKBOX_GROUP_UNSELECTED_COLOR, {checkbocGroupPickerValue2, 1, "SLIDER", nullptr}},
    {NODE_CHECKBOX_GROUP_MARK, {checkbocGroupPickerValue, 1, "SLIDER", nullptr}},
    {NODE_CHECKBOX_GROUP_SHAPE, {checkbocGroupPickerValue1, 1, "SLIDER", nullptr}},
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
    }
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----SetNativeNodeAttribute, type:%{public}d, ret:%{public}d",
        attributeType, ret);
    return ret;
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
    ret = nodeApi->setAttribute(node, (ArkUI_NodeAttributeType)attributeType, &attributeItem);
    OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN,
        "NodeManager", "-----SetNativeNodeAttribute, type:%{public}d, ret:%{public}d, item_value:%{public}d",
        attributeType, ret, attributeItem.value[0].i32);
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
        "ResetNativeNodeAttribute, type:%{public}d, ret:%{public}d", attributeType, ret);
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

static std::string GetNodeTypeName(int32_t eventTypeId)
{
    if (eventTypeId >= NODE_EVENT_ON_APPEAR && eventTypeId <= NODE_ON_ACCESSIBILITY_ACTIONS) {
        return "ARKUI_NODE_BUTTON";
    }

    switch (eventTypeId) {
        case NODE_TOGGLE_ON_CHANGE:
            return "ARKUI_NODE_TOGGLE";
        case NODE_CHECKBOX_EVENT_ON_CHANGE:
            return "ARKUI_NODE_CHECKBOX";
        case NODE_SLIDER_EVENT_ON_CHANGE:
            return "ARKUI_NODE_SLIDER";
        case NODE_RADIO_EVENT_ON_CHANGE:
            return "ARKUI_NODE_RADIO";
        case NODE_CHECKBOX_GROUP_EVENT_ON_CHANGE:
            return "ARKUI_NODE_CHECKBOX_GROUP";
        default:
            return "";
    }
}

void NodeManager::BindEventByType(ArkUI_NodeHandle newNode, int32_t nodeType, EventOperation operation)
{
    switch (nodeType) {
        case ARKUI_NODE_TOGGLE:
            BindEventFunc(newNode, NODE_TOGGLE_ON_CHANGE, NODE_TOGGLE_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_BUTTON:
            BindEventFunc(newNode, NODE_EVENT_ON_APPEAR, NODE_ON_ACCESSIBILITY_ACTIONS, operation);
            break;
        case ARKUI_NODE_CHECKBOX:
            BindEventFunc(newNode, NODE_CHECKBOX_EVENT_ON_CHANGE, NODE_CHECKBOX_EVENT_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_SLIDER:
            BindEventFunc(newNode, NODE_SLIDER_EVENT_ON_CHANGE, NODE_SLIDER_EVENT_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_RADIO:
             BindEventFunc(newNode, NODE_RADIO_EVENT_ON_CHANGE, NODE_RADIO_EVENT_ON_CHANGE, operation);
            break;
        case ARKUI_NODE_CHECKBOX_GROUP:
             BindEventFunc(newNode, NODE_CHECKBOX_GROUP_EVENT_ON_CHANGE, NODE_CHECKBOX_GROUP_EVENT_ON_CHANGE,
                           operation);
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

    if (g_callbackRef != nullptr && g_env != nullptr) {
        std::string result = GetNodeTypeName(eventTypeId);
        napi_value undefined = nullptr;
        napi_get_undefined(g_env, &undefined);
        napi_value callback = nullptr;
        napi_get_reference_value(g_env, g_callbackRef, &callback);
        napi_value argv[1];
        napi_create_string_utf8(g_env, result.c_str(), result.length(), &argv[0]);
        napi_call_function(g_env, undefined, callback, 1, argv, nullptr);
    }
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
static bool IsSliderLinerColor(int32_t nodeType, int32_t attributeType)
{
    if (nodeType == ARKUI_NODE_SLIDER &&
        (attributeType == NODE_SLIDER_BLOCK_LINEAR_GRADIENT_COLOR ||
         attributeType == NODE_SLIDER_TRACK_LINEAR_GRADIENT_COLOR ||
         attributeType == NODE_SLIDER_SELECTED_LINEAR_GRADIENT_COLOR)) {
        return true;
    } else {
        return false;
    }
}

static bool GetSliderLinerColor(ArkUI_AttributeItem* item, std::stringstream &ss)
{
    bool hasValue = false;
    auto colorStop = static_cast<ArkUI_ColorStop *>(item->object);
    if (colorStop) {
        for (int i = 0; i < colorStop->size; ++i) {
            ss << " color: " << std::hex << colorStop->colors[i] << " stop: " << colorStop->stops[i];
            hasValue = true;
        }
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NodeManager", "-----GetSliderLinerColor  finish");
    return hasValue;
}

static bool GetArrayValue(int32_t nodeType, int32_t attributeType, const ArkUI_AttributeItem* item,
                          std::stringstream &ss)
{
    bool hasValue = false;
    if (IsSliderLinerColor(nodeType, attributeType)) {
        hasValue = GetSliderLinerColor( (ArkUI_AttributeItem*) item, ss);
    } else {
        for (size_t i = 0; i < ((ArkUI_AttributeItem*)item)->size; i++) {
            if (hasValue) {
                ss << "/";
            }
            ss << static_cast<int32_t>(item->value[i].i32);
            hasValue = true;
        }
    }
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NodeManager", "-----GetArrayValue  finish");
    return hasValue;
}

napi_value TransTool::CreateFormPage(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateFormPage BEGIN");
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateFormPage env or info is null");
        return nullptr;
    }
    size_t argCnt = 1;
    napi_value args[1] = {nullptr};
    if (napi_get_cb_info(env, info, &argCnt, args, nullptr, nullptr) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "TransTool", "CreateFormPage napi_get_cb_info failed");
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

napi_value TransTool::CreateFormNode(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeType;
    napi_get_value_int32(env, args[0], &nodeType);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "TransTool", "-----CreateFormNode, input nodeType:%{public}d", nodeType);
    if (nodeType < 0) {
        napi_value result;
        napi_create_int32(env, -1, &result);
        return result;
    }

    if (g_callbackRef != nullptr) {
        napi_delete_reference(g_env, g_callbackRef);
        g_callbackRef = nullptr;
        g_env = nullptr;
    }
    napi_create_reference(env, args[1], 1, &g_callbackRef);
    g_env = env;

    int32_t newNodeId = NodeManager::GetInstance().CreateNativeNode(nodeType);
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "TransTool", "-----CreateFormNode, newNodeId:%{public}d", newNodeId);
    if (newNodeId != -1) {
        napi_value result;
        napi_create_int32(env, newNodeId, &result);
        return result;
    }
    return nullptr;
}

napi_value TransTool::RemoveFormNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    if (nodeId < 0) {
        return nullptr;
    }

    if (g_callbackRef != nullptr) {
        napi_delete_reference(g_env, g_callbackRef);
        g_callbackRef = nullptr;
        g_env = nullptr;
    }

    NodeManager::GetInstance().RemoveOldNode(nodeId);
    return nullptr;
}

napi_value TransTool::SetFormAttribute(napi_env env, napi_callback_info info)
{
    size_t argc = 4; // 4 means four arguments are expected
    napi_value args[4] = {nullptr}; // 4 means four arguments size
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    int32_t nodeType;
    napi_get_value_int32(env, args[1], &nodeType);
    int32_t attributeType;
    const int index2 = 2;
    napi_get_value_int32(env, args[index2], &attributeType);
    napi_valuetype valueType;
    const int index3 = 3;
    napi_typeof(env, args[index3], &valueType);

    int32_t ret = -1;
    if (valueType != napi_string) {
        napi_value result;
        napi_create_int32(env, ret, &result);
        return result;
    }

    size_t valueLen;
    napi_get_value_string_utf8(env, args[index3], nullptr, 0, &valueLen);

    std::string value(valueLen + 1, '\0');
    napi_get_value_string_utf8(env, args[index3], &value[0], valueLen + 1, nullptr);

    try {
        int32_t intValue = std::stoi(value);
        if (intValue < 0) {
            ret = NodeManager::GetInstance().SetNativeNodeAttribute(nodeId, nodeType, attributeType);
        } else {
            ret = NodeManager::GetInstance().SetNativeNodeAttribute(nodeId, nodeType, attributeType, intValue);
        }
    } catch (const std::exception&) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "NodeManager", "-----SetNativeNodeAttribute exception");
    }

    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

napi_value TransTool::ResetFormAttribute(napi_env env, napi_callback_info info)
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

napi_value TransTool::GetFormAttribute(napi_env env, napi_callback_info info)
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
        hasValue = GetArrayValue(nodeType, attributeType, item, ss);
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