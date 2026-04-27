/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include "QueryNavigation.h"
#include "napi/native_api.h"
#include "arkui/native_node_napi.h"
#include <hilog/log.h>
#include "arkui/native_node.h"

using namespace NativeModule;

static napi_value CreateContentNode(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (argc < 1) {
        napi_throw_error(env, nullptr, "参数数量错误");
        return nullptr;
    }
    ArkUI_NodeContentHandle contentHandle = contentHandle;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &contentHandle);
    CreateQueryRootNode(env, contentHandle);
    napi_value result;
    napi_get_undefined(env, &result);
    
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "NAPI", "创建节点成功");
    
    return result;
}

static napi_value InitAnimationModule(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"createContentNode", nullptr, CreateContentNode, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    
    return exports;
}

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = InitAnimationModule,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
