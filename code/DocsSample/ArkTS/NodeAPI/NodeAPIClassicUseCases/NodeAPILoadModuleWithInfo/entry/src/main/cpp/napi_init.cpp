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
// [Start napi_load_module_with_info_entry_napi_init]
static constexpr int INT_ARG_2 = 2; // 入参索引
static constexpr int INT_ARG_3 = 3; // 入参索引

static napi_value loadModule(napi_env env, napi_callback_info info)
{
    napi_value result;
    // 1. 使用napi_load_module_with_info加载libentry.so
    napi_status status = napi_load_module_with_info(env, "libentry.so", "com.example.application/entry", &result);

    napi_value addFn;
    // 2. 使用napi_get_named_property获取add函数
    napi_get_named_property(env, result, "add", &addFn);

    napi_value a;
    napi_value b;
    napi_create_int32(env, INT_ARG_2, &a);
    napi_create_int32(env, INT_ARG_3, &b);
    napi_value args[2] = {a, b};
    // 3. 使用napi_call_function调用函数add
    napi_value returnValue;
    napi_call_function(env, result, addFn, INT_ARG_2, args, &returnValue);
    return result;
}
// [End napi_load_module_with_info_entry_napi_init]
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"loadModule", nullptr, loadModule, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
