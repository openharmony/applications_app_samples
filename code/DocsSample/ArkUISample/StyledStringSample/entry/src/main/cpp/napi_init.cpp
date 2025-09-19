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
#include <napi/native_api.h>

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

static napi_value createNativeNode(napi_env env, napi_callback_info info)
{
    NativeNode::Manager::NodeManager::GetInstance().CreateNativeNode();
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "createNativeNode", nullptr, createNativeNode, nullptr, nullptr, nullptr, napi_default, nullptr }
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