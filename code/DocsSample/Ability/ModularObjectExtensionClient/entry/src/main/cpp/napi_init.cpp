/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi/native_api.h"
#include <AbilityKit/ability_runtime/ability_runtime_common.h>
#include <AbilityKit/ability_runtime/modular_object_extension_manager.h>
#include <AbilityKit/ability_runtime/connect_options.h>

#include "calculator_proxy.h"
#include "log_helper.h"

// [Start modular_object_extension_connect]
// [Start modular_object_extension_disconnect]
// [Start modular_object_extension_test_add]
static OHIPCRemoteProxy *g_remoteProxy = NULL;
// [StartExclude modular_object_extension_test_add]
static int64_t g_connectionId = -1;

// [StartExclude modular_object_extension_disconnect]
static void OnConnectCallback(OH_AbilityRuntime_ConnectOptions *connectOptions, AbilityBase_Element *element,
                              OHIPCRemoteProxy *proxy)
{
    OH_LOG_INFO(LOG_APP, "OnConnectCallback");
    g_remoteProxy = proxy;
}
// [EndExclude modular_object_extension_disconnect]

static void OnDisconnectCallback(OH_AbilityRuntime_ConnectOptions *connectOptions, AbilityBase_Element *element)
{
    OH_LOG_INFO(LOG_APP, "OnDisconnectCallback");
    g_remoteProxy = NULL;
}

// [StartExclude modular_object_extension_disconnect]
static void OnFailedCallback(OH_AbilityRuntime_ConnectOptions *connectOptions, AbilityRuntime_ErrorCode code)
{
    OH_LOG_ERROR(LOG_APP, "OnFailedCallback, code: %{public}d", code);
}

static napi_value TestConnect(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TestConnect");
    // 创建Want
    AbilityBase_Element element = {.bundleName = "com.samples.modularobjectextensionservice",
                                   .moduleName = "entry",
                                   .abilityName = "SampleModularObjectExtAbility"};
    AbilityBase_Want *want = OH_AbilityBase_CreateWant(element);
    if (want == NULL) {
        OH_LOG_ERROR(LOG_APP, "CreateWant failed");
        return nullptr;
    }

    // 创建ConnectOptions并注册回调
    OH_AbilityRuntime_ConnectOptions *options = OH_AbilityRuntime_CreateConnectOptions();
    OH_AbilityRuntime_ConnectOptions_SetOnConnectCallback(options, OnConnectCallback);
    OH_AbilityRuntime_ConnectOptions_SetOnDisconnectCallback(options, OnDisconnectCallback);
    OH_AbilityRuntime_ConnectOptions_SetOnFailedCallback(options, OnFailedCallback);

    // 发起连接
    int64_t connectionId = -1;
    AbilityRuntime_ErrorCode err = OH_AbilityRuntime_ConnectModularObjectExtensionAbility(want, options, &connectionId);
    if (err != ABILITY_RUNTIME_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "ConnectModularObjectExtensionAbility err:%{public}d", err);
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "ConnectModularObjectExtensionAbility id:%{public}ld", connectionId);
    // 保存连接ID,用于后续断开连接操作
    g_connectionId = connectionId;
    OH_AbilityBase_DestroyWant(want);
    return nullptr;
}
// [EndExclude modular_object_extension_disconnect]
// [End modular_object_extension_connect]

static napi_value TestDisconnect(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TestDisconnect");
    if (g_connectionId == -1) {
        OH_LOG_ERROR(LOG_APP, "Not connected");
        return nullptr;
    }
    AbilityRuntime_ErrorCode err =
        OH_AbilityRuntime_DisconnectModularObjectExtensionAbility(g_connectionId);
    if (err != ABILITY_RUNTIME_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "DisconnectModularObjectExtensionAbility err:%{public}d", err);
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "DisconnectModularObjectExtensionAbility success");
    g_connectionId = -1;
    g_remoteProxy = NULL;
    return nullptr;
}
// [EndExclude modular_object_extension_test_add]
// [End modular_object_extension_disconnect]

// [Start modular_object_extension_test_add]
static napi_value TestAdd(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "TestAdd");
    if (g_remoteProxy == NULL) {
        OH_LOG_ERROR(LOG_APP, "Remote proxy is null, not connected");
        return nullptr;
    }
    CalculatorProxy proxy(g_remoteProxy);
    int32_t result = 0;
    ErrCode err = proxy.Add(10, 20, result);
    if (err != OH_IPC_SUCCESS) {
        OH_LOG_ERROR(LOG_APP, "CalculatorProxy::Add err:%{public}d", err);
        return nullptr;
    }
    OH_LOG_INFO(LOG_APP, "CalculatorProxy::Add(10, 20) result:%{public}d", result);
    return nullptr;
}
// [End modular_object_extension_test_add]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"testConnect", nullptr, TestConnect, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testDisconnect", nullptr, TestDisconnect, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"testAdd", nullptr, TestAdd, nullptr, nullptr, nullptr, napi_default, nullptr}
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
