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

// [Start use_napi_method_promise_cpp]
#include "hilog/log.h"
#include "napi/native_api.h"
#include <napi/common.h>
#include <pthread.h>

//解析Promise结果的回调
static napi_value ResolvedCallback(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int result;
    napi_get_value_int32(env, args[0], &result);
    OH_LOG_INFO(LOG_APP, "Promise resolved with result:%{public}d", result);
    return nullptr;
}

//拒绝Promise的回调
static napi_value RejectedCallback(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_value error;
    napi_coerce_to_string(env, args[0], &error);
    char errorMsg[1024];
    size_t len;
    napi_get_value_string_utf8(env, error, errorMsg, sizeof(errorMsg), &len);
    OH_LOG_ERROR(LOG_APP, "Promise rejected with error:%{public}s", errorMsg);
    return nullptr;
}

static napi_value CallArkTSAsync(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    napi_value promise = nullptr;
    napi_call_function(env, nullptr, argv[0], 0, nullptr, &promise);

    napi_value thenFunc = nullptr;
    if (napi_get_named_property(env, promise, "then", &thenFunc) != napi_ok) {
        return nullptr;
    }

    napi_value onResolve = nullptr;
    napi_value onReject = nullptr;
    napi_create_function(env, "onResolve", NAPI_AUTO_LENGTH, ResolvedCallback, nullptr, &onResolve);
    napi_create_function(env, "onReject", NAPI_AUTO_LENGTH, RejectedCallback, nullptr, &onReject);
    constexpr size_t kPromiseCallbackCount = 2;
    napi_value argv1[2] = {onResolve, onReject};
    napi_call_function(env, promise, thenFunc, kPromiseCallbackCount, argv1, nullptr);

    return nullptr;
}

// 注册模块接口
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"callArkTSAsync", nullptr, CallArkTSAsync, nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule()
{
    napi_module_register(&nativeModule);
}
// [End use_napi_method_promise_cpp]