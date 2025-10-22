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

#include <cstdint>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>
// [Start register_native_child_process_exit]
// [Start native_child_process_header]
#include <AbilityKit/native_child_process.h>
// [End native_child_process_header]
#include <hilog/log.h>

// [StartExclude register_native_child_process_exit]
int32_t g_result1 = -1;
int32_t g_result2 = -1;
// [EndExclide register_native_child_process_exit]

void OnNativeChildProcessExit(int32_t pid, int32_t signal)
{
    OH_LOG_INFO(LOG_APP, "pid: %{public}d, signal: %{public}d", pid, signal);
}

void RegisterNativeChildProcessExitCallback()
{
    Ability_NativeChildProcess_ErrCode ret =
        OH_Ability_RegisterNativeChildProcessExitCallback(OnNativeChildProcessExit);
    if (ret != NCP_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "register failed.");
    }
    // [StartExclude register_native_child_process_exit]
    g_result1 = ret;
    // [EndExclide register_native_child_process_exit]
}

void UnregisterNativeChildProcessExitCallback()
{
    Ability_NativeChildProcess_ErrCode ret =
        OH_Ability_UnregisterNativeChildProcessExitCallback(OnNativeChildProcessExit);
    if (ret != NCP_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "unregister failed.");
    }
    // [StartExclude register_native_child_process_exit]
    g_result2 = ret;
    // [EndExclide register_native_child_process_exit]
}

// [End register_native_child_process_exit]

static napi_value TestRegisterFunc(napi_env env, napi_callback_info info)
{
    RegisterNativeChildProcessExitCallback();
    napi_value napiRet;
    napi_create_int32(env, g_result1, &napiRet);
    return napiRet;
}
static napi_value TestUnregisterFunc(napi_env env, napi_callback_info info)
{
    UnregisterNativeChildProcessExitCallback();
    napi_value napiRet;
    napi_create_int32(env, g_result2, &napiRet);
    return napiRet;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"testRegisterFunc", nullptr, TestRegisterFunc, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testUnregisterFunc", nullptr, TestUnregisterFunc, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "mainprocesssample",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
