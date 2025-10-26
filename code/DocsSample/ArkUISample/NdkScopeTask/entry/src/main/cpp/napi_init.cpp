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

#include "napi/native_api.h"

#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <hilog/log.h>

#define LOG_INFO(...) OH_LOG_Print(LOG_APP, LOG_INFO, 0xD001400, LOG_TAG, __VA_ARGS__)
#define VALUE_400 400
#define VALUE_1 1
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

namespace ConstIde {
const uint32_t NUMBER_0 = 0;
const uint32_t NUMBER_1 = 1;
const uint32_t VALUE_2 = 250;
const uint32_t VALUE_3 = 480;
const uint32_t MARGIN_NUMBER_30 = 30;
constexpr const char *K_LOG_DOMAIN = "Manager";
}
ArkUI_NativeNodeAPI_1* nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
    OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));

static void CreateAndSetID(ArkUI_NodeHandle &textContainer)
{
    // [Start runtaskinscopeone_start]
    //page1
    ArkUI_NodeHandle button = nodeAPI->createNode(ARKUI_NODE_BUTTON);
    ArkUI_AttributeItem LABEL_Item = {.string = "pageOneButton"};
    //设置id，用于在第二个页面内通过接口查找
    ArkUI_AttributeItem id = {.string = "pageOneButton"};
    nodeAPI->setAttribute(button, NODE_ID, &id);
    nodeAPI->setAttribute(button, NODE_BUTTON_LABEL, &LABEL_Item);
    nodeAPI->addChild(textContainer, button);
    // [End runtaskinscopeone_start]
}

static ArkUI_NodeHandle CreateNativeFirstNode()
{
    ArkUI_NodeHandle scroll = nodeAPI->createNode(ARKUI_NODE_SCROLL);
    ArkUI_NodeHandle Container = nodeAPI->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = VALUE_400}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = VALUE_1};
    nodeAPI->setAttribute(Container, NODE_WIDTH, &widthItem);
    CreateAndSetID(Container);
    nodeAPI->addChild(scroll, Container);
    return scroll;
}

static napi_value CreateNativeNode(napi_env env, napi_callback_info info)
{
    if ((env == nullptr) || (info == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "env or info is null");
        return nullptr;
    }
    
    size_t argc = ConstIde::NUMBER_1;
    napi_value args[ConstIde::NUMBER_1] = {nullptr};
    napi_status st = napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (st != napi_ok || argc < ConstIde::NUMBER_1) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "napi_get_cb_info failed");
        return nullptr;
    }

    ArkUI_NodeContentHandle nodeContentHandle = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[ConstIde::NUMBER_0], &nodeContentHandle);
    if (nodeContentHandle == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN,
                     "nodeContentHandle is null");
        return nullptr;
    }
    
    // 可选：保留对 nodeAPI_ 的健壮性检查（与你现有代码一致）
    if (nodeAPI == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "nodeAPI is null");
        return nullptr;
    }

    // 构建具体节点 & 挂载
    ArkUI_NodeHandle page = CreateNativeFirstNode();
    if (page == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, ConstIde::K_LOG_DOMAIN, "makeNodeFn return null");
        return nullptr;
    }

    OH_ArkUI_NodeContent_AddNode(nodeContentHandle, page);
    return nullptr;
}


static napi_value ModifyPageOneButton(napi_env env, napi_callback_info info)
{
    // [Start runtaskinscopetwo_start]
    //page2
    //pageOneButton由前置页面创建，通过OH_ArkUI_NodeUtils_GetAttachedNodeHandleById在第二个页面获取。
    ArkUI_NodeHandle pageOneButton = nullptr;
    auto errorCode = OH_ArkUI_NodeUtils_GetAttachedNodeHandleById("pageOneButton", &pageOneButton);
    if (errorCode != ARKUI_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "test Failed to get pageOneButton handle, error code: %{public}d", errorCode);
        return nullptr;
    }
    auto uiContext = OH_ArkUI_GetContextByNode(pageOneButton);
    if (uiContext == nullptr) {
        OH_LOG_ERROR(LOG_APP, "test Failed to get UI context for pageOneButton");
        return nullptr;
    }
    OH_ArkUI_RunTaskInScope(uiContext, pageOneButton, [](void *userData) {
        auto *nodeAPI = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
            OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
        auto pageOneButton = (ArkUI_NodeHandle)userData;
        ArkUI_NumberValue value[] = {VALUE_3};
        ArkUI_AttributeItem LABEL_Item = {.string = "success"};
        value[0].f32 = VALUE_2;
        ArkUI_AttributeItem button_Item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        nodeAPI->setAttribute(pageOneButton, NODE_BUTTON_LABEL, &LABEL_Item);
        nodeAPI->setAttribute(pageOneButton, NODE_WIDTH, &button_Item);
    });
    // [End runtaskinscopetwo_start]
}
    
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createNativeNode", nullptr, CreateNativeNode, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"modifyPageOneButton", nullptr, ModifyPageOneButton, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
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
