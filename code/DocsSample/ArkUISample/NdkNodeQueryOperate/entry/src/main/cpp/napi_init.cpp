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


#include "NativeEntry.h"
// [Start ndknodequeryoperate7_start]
#include "Attribute_util.h"
#include "napi/native_api.h"
#include <arkui/native_interface.h>
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>
#include <hilog/log.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
// [StartExclude ndknodequeryoperate7_start]
using namespace NativeModule;

const unsigned int NUMBER_2 = 2;
const unsigned int NUMBER_WIDTH = 100;
const unsigned int NUMBER_HEIGHT = 100;
// [EndExclude ndknodequeryoperate7_start]
static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = NUMBER_2;
    napi_value args[NUMBER_2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    return sum;
}

static ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;

static napi_value NAPI_Global_createNativeNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    ArkUI_NodeContentHandle contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    // 创建Image组件
    auto imageNode = nodeAPI->createNode(ARKUI_NODE_IMAGE);
    AttributeUtil imageNodeAttr(imageNode, nodeAPI);
    // 设置image组件属性
    imageNodeAttr.ImageSrc("resources/base/media/startIcon.png");
    imageNodeAttr.ImageSyncLoad();
    imageNodeAttr.Width(NUMBER_WIDTH);
    imageNodeAttr.Height(NUMBER_HEIGHT);
    // 在当前即时帧触发节点属性更新
    OH_ArkUI_NativeModule_InvalidateAttributes(imageNode);
    // 挂载image组件到组件树
    OH_ArkUI_NodeContent_AddNode(contentHandle, imageNode);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"createNativeNode", nullptr, NAPI_Global_createNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr},
        // [StartExclude ndknodequeryoperate7_start]
        {"createInquireUniqueIdNode", nullptr, Manager::CreateInquireUniqueIdNode, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"createMoveToNode", nullptr, Manager::CreateMoveToNode, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"createUserIdNode", nullptr, Manager::CreateUserIdNode, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"showSubcomponentInfo", nullptr, Manager::ShowSubcomponentInfo, nullptr, nullptr, nullptr,
            napi_default, nullptr},
        {"destroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr,
            napi_default, nullptr}
        // [EndExclude ndknodequeryoperate7_start]
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
// [End ndknodequeryoperate7_start]