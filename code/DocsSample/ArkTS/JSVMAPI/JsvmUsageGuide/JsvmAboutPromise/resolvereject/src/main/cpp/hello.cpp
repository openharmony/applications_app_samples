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

// [Start oh_jsvm_resolvedeferred_and_rejectdeferred]
#include "napi/native_api.h"
#include "ark_runtime/jsvm.h"
#include "hilog/log.h"
// [StartExclude oh_jsvm_resolvedeferred_and_rejectdeferred]
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
// [EndExclude oh_jsvm_resolvedeferred_and_rejectdeferred]

// OH_JSVM_CreatePromise、OH_JSVM_ResolveDeferred、OH_JSVM_RejectDeferred的样例方法
static JSVM_Value CreatePromise(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_Deferred defer = nullptr;
    JSVM_Value promise = nullptr;
    JSVM_Status status = OH_JSVM_CreatePromise(env, &defer, &promise);
    bool isPromise = false;
    JSVM_Value returnIsPromise = nullptr;
    OH_JSVM_IsPromise(env, promise, &isPromise);
    if (status != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "JSVM CreatePromise fail");
    } else {
        OH_LOG_INFO(LOG_APP, "JSVM CreatePromise success:%{public}d", isPromise);
    }
    // 将布尔值转为可以返回的JSVM_Value
    OH_JSVM_GetBoolean(env, isPromise, &returnIsPromise);
    return returnIsPromise;
}

static JSVM_Value ResolveRejectDeferred(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 获得并解析参数
    size_t argc = 3;
    JSVM_Value args[3] = {nullptr};
    OH_JSVM_GetCbInfo(env, info, &argc, args, nullptr, nullptr);
    // 第一个参数为向resolve传入的信息，第二个参数为向reject传入的信息，第三个参数为Promise的状态
    bool status = false;
    constexpr size_t PROMISE_STATUS_ARG_INDEX = 2;
    OH_JSVM_GetValueBool(env, args[PROMISE_STATUS_ARG_INDEX], &status);
    // 创建Promise对象
    JSVM_Deferred deferred = nullptr;
    JSVM_Value promise = nullptr;
    JSVM_Status createStatus = OH_JSVM_CreatePromise(env, &deferred, &promise);
    if (createStatus != JSVM_OK) {
        OH_JSVM_ThrowError(env, nullptr, "Create promise failed");
        return nullptr;
    }
    // 根据第三个参数设置resolve或reject
    if (status) {
        OH_JSVM_ResolveDeferred(env, deferred, args[0]);
        OH_LOG_INFO(LOG_APP, "OH_JSVM_ResolveDeferred resolve");
    } else {
        OH_JSVM_RejectDeferred(env, deferred, args[1]);
        OH_LOG_INFO(LOG_APP, "OH_JSVM_RejectDeferred reject");
    }
    JSVM_Value result = nullptr;
    OH_JSVM_GetBoolean(env, true, &result);
    return result;
}
// CreatePromise,ResolveRejectDeferred注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = CreatePromise},
    {.data = nullptr, .callback = ResolveRejectDeferred},
};
static JSVM_CallbackStruct *method = param;
// CreatePromise,ResolveRejectDeferred方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"createPromise", nullptr, method, nullptr, nullptr, nullptr, JSVM_DEFAULT},
    {"resolveRejectDeferred", nullptr, method+1, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

// 样例测试js
const char *SRC_CALL_NATIVE_CREATE_PROMISE = R"JS(createPromise())JS";
const char *SRC_CALL_NATIVE_RESOLVE_REJECT_DEFERRED1 = R"JS(resolveRejectDeferred('success', 'fail', true))JS";
const char *SRC_CALL_NATIVE_RESOLVE_REJECT_DEFERRED2 = R"JS(resolveRejectDeferred('success', 'fail', false))JS";
// [End oh_jsvm_resolvedeferred_and_rejectdeferred]

static int32_t TestJSVM()
{
    JSVM_InitOptions initOptions = {0};
    JSVM_VM vm;
    JSVM_Env env = nullptr;
    JSVM_VMScope vmScope;
    JSVM_EnvScope envScope;
    JSVM_HandleScope handleScope;
    JSVM_Value result;
    // 初始化JavaScript引擎实例
    if (g_aa == 0) {
        g_aa++;
        CHECK(OH_JSVM_Init(&initOptions));
    }
    // 创建JSVM环境
    CHECK(OH_JSVM_CreateVM(nullptr, &vm));
    CHECK(OH_JSVM_CreateEnv(vm, sizeof(descriptor) / sizeof(descriptor[0]), descriptor, &env));
    CHECK(OH_JSVM_OpenVMScope(vm, &vmScope));
    CHECK_RET(OH_JSVM_OpenEnvScope(env, &envScope));
    CHECK_RET(OH_JSVM_OpenHandleScope(env, &handleScope));

    // 通过script调用测试函数
    JSVM_Script script;
    JSVM_Value jsSrc;
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE_CREATE_PROMISE, JSVM_AUTO_LENGTH, &jsSrc));
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE_RESOLVE_REJECT_DEFERRED1, JSVM_AUTO_LENGTH, &jsSrc));
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE_RESOLVE_REJECT_DEFERRED2, JSVM_AUTO_LENGTH, &jsSrc));
    CHECK_RET(OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script));
    CHECK_RET(OH_JSVM_RunScript(env, script, &result));

    // 销毁JSVM环境
    CHECK_RET(OH_JSVM_CloseHandleScope(env, handleScope));
    CHECK_RET(OH_JSVM_CloseEnvScope(env, envScope));
    CHECK(OH_JSVM_CloseVMScope(vm, vmScope));
    CHECK(OH_JSVM_DestroyEnv(env));
    CHECK(OH_JSVM_DestroyVM(vm));
    return 0;
}

static napi_value RunTest(napi_env env, napi_callback_info info)
{
    TestJSVM();
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
    .nm_modname = "resolvereject",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
