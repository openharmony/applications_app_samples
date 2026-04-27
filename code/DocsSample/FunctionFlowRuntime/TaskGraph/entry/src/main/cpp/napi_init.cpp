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
#include "napi/native_api.h"
#include "parallel.h"
#include "parallel_cpp.h"

int CheckDepExecType(bool apiType)
{
    return apiType ? DependenceCExec() : DependenceCppExec();
}

int CheckFibExecType(bool apiType)
{
    return apiType ? FibCExec() : FibCppExec();
}

static napi_value ParallelDepExec(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool apiType;
    napi_get_value_bool(env, args[0], &apiType);

    int result = CheckDepExecType(apiType);

    napi_value exec;
    napi_create_double(env, result, &exec);

    return exec;
}

static napi_value ParallelFibExec(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    bool apiType;
    napi_get_value_bool(env, args[0], &apiType);

    int result = CheckFibExecType(apiType);

    napi_value exec;
    napi_create_double(env, result, &exec);

    return exec;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "parallel_dependence_exec", nullptr, ParallelDepExec, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "parallel_fib_exec", nullptr, ParallelFibExec, nullptr, nullptr, nullptr, napi_default, nullptr },
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
