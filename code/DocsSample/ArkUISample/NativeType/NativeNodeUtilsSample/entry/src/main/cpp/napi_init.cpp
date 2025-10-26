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

// entry/src/main/cpp/napi_init.cpp
#include "napi/native_api.h"
#include "NativeEntry.h"

static napi_value NAPI_Global_createNativeRoot(napi_env env, napi_callback_info info) {
    // TODO: implements the code;
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    // 绑定Native侧的创建组件和销毁组件。
    napi_property_descriptor desc[] = {
        {"createNodeTreeOnMultiThread", nullptr, NativeModule::CreateNodeTreeOnMultiThread, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"createCustomPropertyDemo", nullptr, NativeModule::CreateCustomPropertyDemo, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"createNodeAdapterDemo", nullptr, NativeModule::CreateNodeAdapterDemo, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"disposeNodeTreeOnMultiThread", nullptr, NativeModule::DisposeNodeTreeOnMultiThread, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"destroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"disposeNodeTree", nullptr, NativeModule::DisposeNodeTree, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"destroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getContext", nullptr, NativeModule::GetContext, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getNodeHandle", nullptr, NativeModule::GetNodeHandle, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getNodeHandleById", nullptr, NativeModule::GetNodeHandleById, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getNodeHandleByUniqueId", nullptr, NativeModule::GetNodeHandleByUniqueId, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"CreateDrawNode", nullptr, NativeModule::CreateDrawNode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateNativeRoot", nullptr, NativeModule::CreateNativeRoot, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"DestroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"createNativeRoot", nullptr, NAPI_Global_createNativeRoot, nullptr, nullptr, nullptr, napi_default, nullptr },
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }