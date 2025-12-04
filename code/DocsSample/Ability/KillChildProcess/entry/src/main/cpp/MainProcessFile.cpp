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
// [Start kill_child_process_main]
// [Start kill_child_process_header]
#include <AbilityKit/native_child_process.h>
// [End kill_child_process_header]
// [StartExclude kill_child_process_main]
int32_t g_result = -1;
// [EndExclude kill_child_process_main]
void KillChildProcess(int32_t pid)
{
    Ability_NativeChildProcess_ErrCode ret = OH_Ability_KillChildProcess(pid);
    if (ret != NCP_NO_ERROR) {
        // 子进程未成功杀死的异常处理
    }
    // [StartExclude kill_child_process_main]
    g_result = ret;
    // [EndExclude kill_child_process_main]
}
// [End kill_child_process_main]
static napi_value TestKillChildProcessFunc(napi_env env, napi_callback_info info)
{
    KillChildProcess(-1);
    napi_value napiRet;
    napi_create_int32(env, g_result, &napiRet);
    return napiRet;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"testKillChildProcessFunc", nullptr, TestKillChildProcessFunc,
            nullptr, nullptr, nullptr, napi_default, nullptr}};
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
