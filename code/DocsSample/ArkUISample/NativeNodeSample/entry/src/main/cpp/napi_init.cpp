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
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <hilog/log.h>
#include <napi/native_api.h>
#include <vector>
#include <sstream>
#include <algorithm>
#include <iomanip>

static OH_NativeXComponent* GetXComponent(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        return nullptr;
    }
    napi_value exportInstance = nullptr;
    if (napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        return nullptr;
    }
    OH_NativeXComponent* xComp = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&xComp)) != napi_ok) {
        return nullptr;
    }
    return xComp;
}

static napi_value CreateNativeNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeType;
    napi_get_value_int32(env, args[0], &nodeType);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----CreateNativeNode, input nodeType:%{public}d", nodeType);
    if (nodeType < 0) {
        napi_value result;
        napi_create_int32(env, -1, &result);
        return result;
    }

    int32_t newNodeId = NativeNode::Manager::NodeManager::GetInstance().CreateNativeNode(nodeType);
    OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "NativeNode", "-----CreateNativeNode, newNodeId:%{public}d", newNodeId);
    if (newNodeId != -1) {
        napi_value result;
        napi_create_int32(env, newNodeId, &result);
        return result;
    }
    return nullptr;
}

static napi_value RemoveOldNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t nodeId;
    napi_get_value_int32(env, args[0], &nodeId);
    if (nodeId < 0) {
        return nullptr;
    }

    NativeNode::Manager::NodeManager::GetInstance().RemoveOldNode(nodeId);
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
    size_t slashCount = std::count(value.begin(), value.end(), '/');
    if (slashCount > 0) {
        std::vector<float> floatValues = ParseFloatValues(value);
        if (!floatValues.empty()) {
            return NativeNode::Manager::NodeManager::GetInstance().SetNativeNodeAttribute(
                nodeId, nodeType, attributeType, floatValues);
        }
        return -1;
    }

    try {
        int32_t intValue = std::stoi(value);
        return NativeNode::Manager::NodeManager::GetInstance().SetNativeNodeAttribute(
            nodeId, nodeType, attributeType, intValue);
    } catch (const std::exception&) {
        return -1;
    }
}

static napi_value SetNativeNodeAttribute(napi_env env, napi_callback_info info)
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

static napi_value ResetNativeNodeAttribute(napi_env env, napi_callback_info info)
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

    int32_t ret = NativeNode::Manager::NodeManager::GetInstance().ResetNativeNodeAttribute(nodeId,
        nodeType, attributeType);
    napi_value result;
    napi_create_int32(env, ret, &result);
    return result;
}

static napi_value GetNativeNodeAttribute(napi_env env, napi_callback_info info)
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
    const ArkUI_AttributeItem* item = NativeNode::Manager::NodeManager::GetInstance().GetNativeNodeAttribute(nodeId,
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
            if (attributeType != NODE_IMAGE_IMAGE_MATRIX) {
                ss << static_cast<int32_t>(item->value[i].i32);
            } else {
                ss << std::fixed << std::setprecision(6) << item->value[i].f32; // 6 means six decimal places
            }
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

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "createNativeNode", nullptr, CreateNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "removeOldNode", nullptr, RemoveOldNode, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "setNativeNodeAttribute", nullptr, SetNativeNodeAttribute, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "resetNativeNodeAttribute", nullptr, ResetNativeNodeAttribute,
            nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getNativeNodeAttribute", nullptr, GetNativeNodeAttribute, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    auto xComponent = GetXComponent(env, exports);
    if (xComponent) {
        NativeNode::Manager::NodeManager::GetInstance().SetXComponent(xComponent);
    }
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
