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
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"

#define LOG_DOMAIN 0x3200
#define LOG_TAG "APP"

static int g_aa = 0;

#define CHECK_RET(theCall)                                                                                             \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if ((cond) != JSVM_OK) {                                                                                       \
            const JSVM_ExtendedErrorInfo *info;                                                                        \
            OH_JSVM_GetLastErrorInfo(env, &info);                                                                      \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s", \
                         __FILE__, __LINE__, cond, info != nullptr ? info->errorMessage : "");                         \
            return -1;                                                                                                 \
        }                                                                                                              \
    } while (0)

#define CHECK(theCall)                                                                                                 \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if ((cond) != JSVM_OK) {                                                                                       \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d", __FILE__, __LINE__,  \
                         cond);                                                                                        \
            return -1;                                                                                                 \
        }                                                                                                              \
    } while (0)

// 用于调用theCall并检查其返回值是否为JSVM_OK。
// 如果不是，则调用OH_JSVM_GetLastErrorInfo处理错误并返回retVal。
#define JSVM_CALL_BASE(env, theCall, retVal)                                                                           \
    do {                                                                                                               \
        JSVM_Status cond = theCall;                                                                                    \
        if (cond != JSVM_OK) {                                                                                         \
            const JSVM_ExtendedErrorInfo *info;                                                                        \
            OH_JSVM_GetLastErrorInfo(env, &info);                                                                      \
            OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s", \
                         __FILE__, __LINE__, cond, info != nullptr ? info->errorMessage : "");                         \
            return retVal;                                                                                             \
        }                                                                                                              \
    } while (0)

// JSVM_CALL_BASE的简化版本，返回nullptr
#define JSVM_CALL(theCall) JSVM_CALL_BASE(env, theCall, nullptr)

// [Start oh_jsvm_add_finalizer]
static int AddFinalizer(JSVM_VM vm, JSVM_Env env)
{
    // 打开 handlescope
    JSVM_HandleScope handleScope;
    CHECK_RET(OH_JSVM_OpenHandleScope(env, &handleScope));
    // 创建 object 并设置回调
    JSVM_Value obj;
    CHECK_RET(OH_JSVM_CreateObject(env, &obj));
    CHECK_RET(OH_JSVM_AddFinalizer(
        env, obj, nullptr,
        [](JSVM_Env env, void *data, void *hint) -> void {
            // Finalizer 方法，可在该方法中清理 Native 对象
            OH_LOG_INFO(LOG_APP, "JSVM: finalizer called.");
        },
        nullptr, nullptr));
    OH_LOG_INFO(LOG_APP, "JSVM: finalizer added.");
    // 关闭 handlescope，触发 GC，GC 时 Finalizer 会被调用
    CHECK_RET(OH_JSVM_CloseHandleScope(env, handleScope));
    OH_LOG_INFO(LOG_APP, "JSVM: before call gc.");
    CHECK_RET(OH_JSVM_MemoryPressureNotification(env, JSVM_MemoryPressureLevel::JSVM_MEMORY_PRESSURE_LEVEL_CRITICAL));
    OH_LOG_INFO(LOG_APP, "JSVM: after call gc.");

    return 0;
}

static void RunDemo(JSVM_VM vm, JSVM_Env env)
{
    if (AddFinalizer(vm, env) != 0) {
        OH_LOG_INFO(LOG_APP, "Run PromiseRegisterHandler failed");
    }
}
// [End oh_jsvm_add_finalizer]

static napi_value RunTest(napi_env env, napi_callback_info info)
{
    JSVM_VM vm;
    JSVM_Env envs = nullptr;
    RunDemo(vm, envs);
    return nullptr;
}

// 模块注册信息，供arkts侧调用
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {{"runTest", nullptr, RunTest, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "addfinalizer",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
