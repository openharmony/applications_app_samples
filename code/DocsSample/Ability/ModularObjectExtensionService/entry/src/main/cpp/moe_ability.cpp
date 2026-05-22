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

// [Start modular_object_extension_moe_ability]
// [StartExclude modular_object_extension_moe_ability]
#include <AbilityKit/ability_runtime/ability_runtime_common.h>
#include <AbilityKit/ability_runtime/modular_object_extension_ability.h>
#include <map>
// [EndExclude modular_object_extension_moe_ability]

#include "calculator_stub.h"
// [StartExclude modular_object_extension_moe_ability]
#include "log_helper.h"
// [EndExclude modular_object_extension_moe_ability]

static std::map<OH_AbilityRuntime_ModObjExtensionInstanceHandle, OH_AbilityRuntime_ModObjExtensionContextHandle>
    g_contextMap;
static std::map<OH_AbilityRuntime_ModObjExtensionInstanceHandle, CalculatorStub *> g_stubMap;

static void OnCreate(OH_AbilityRuntime_ModObjExtensionInstanceHandle instance, AbilityBase_Want *want)
{
    OH_LOG_INFO(LOG_APP, "OnCreate");
    // 获取context并保存
    OH_AbilityRuntime_ModObjExtensionContextHandle context = NULL;
    AbilityRuntime_ErrorCode err = OH_AbilityRuntime_ModObjExtensionAbility_GetContextFromInstance(instance, &context);
    if (context != NULL) {
        g_contextMap[instance] = context;
    }
}

static OHIPCRemoteStub *OnConnect(OH_AbilityRuntime_ModObjExtensionInstanceHandle instance, AbilityBase_Want *want)
{
    OH_LOG_INFO(LOG_APP, "OnConnect");
    // 创建Stub并返回
    OH_AbilityRuntime_ModObjExtensionContextHandle context = g_contextMap.at(instance);
    if (context == nullptr) {
        return nullptr;
    }
    CalculatorStub *stub = new CalculatorStub(context);
    g_stubMap[instance] = stub;
    return stub->GetRemoteStub();
}

static void OnDisconnect(OH_AbilityRuntime_ModObjExtensionInstanceHandle instance)
{
    OH_LOG_INFO(LOG_APP, "OnDisconnect");
    // 断连时清理Stub
    CalculatorStub *stub = g_stubMap.at(instance);
    if (stub != nullptr) {
        delete stub;
        g_stubMap.erase(instance);
    }
}

static void OnDestroy(OH_AbilityRuntime_ModObjExtensionInstanceHandle instance)
{
    OH_LOG_INFO(LOG_APP, "OnDestroy");
    // 销毁时清理context
    g_contextMap.erase(instance);
}

EXTERN_C_START
void OH_AbilityRuntime_OnNativeExtensionCreate(AbilityRuntime_ExtensionInstanceHandle handle, const char *abilityName)
{
    // 获取实例
    OH_AbilityRuntime_ModObjExtensionInstanceHandle instance = NULL;
    AbilityRuntime_ErrorCode err = OH_AbilityRuntime_ModObjExtensionAbility_GetInstanceFromBase(handle, &instance);
    if (err != ABILITY_RUNTIME_ERROR_CODE_NO_ERROR) {
        OH_LOG_ERROR(LOG_APP, "GetInstanceFromBase err:%{public}d", err);
        return;
    }
    // 注册回调函数
    OH_AbilityRuntime_ModObjExtensionAbility_RegisterOnCreateFunc(instance, OnCreate);
    OH_AbilityRuntime_ModObjExtensionAbility_RegisterOnConnectFunc(instance, OnConnect);
    OH_AbilityRuntime_ModObjExtensionAbility_RegisterOnDisconnectFunc(instance, OnDisconnect);
    OH_AbilityRuntime_ModObjExtensionAbility_RegisterOnDestroyFunc(instance, OnDestroy);
}
EXTERN_C_END
// [End modular_object_extension_moe_ability]