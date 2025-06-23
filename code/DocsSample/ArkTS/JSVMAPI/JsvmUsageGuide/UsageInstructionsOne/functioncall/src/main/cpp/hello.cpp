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

// [Start jsvm_function_call]
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"

#define LOG_DOMAIN 0x3200
#define LOG_TAG "APP"

#define CHECK_RET(cond)                                                                                                \
    if ((cond)) {                                                                                                      \
        const JSVM_ExtendedErrorInfo *info;                                                                            \
        OH_JSVM_GetLastErrorInfo(env, &info);                                                                          \
        OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s",     \
                     __FILE__, __LINE__, cond, info != nullptr ? info->errorMessage : "");                             \
        return -1;                                                                                                     \
    }

#define CHECK(cond)                                                                                                    \
    if (!(cond)) {                                                                                                     \
        OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d", __FILE__, __LINE__,      \
                     cond);                                                                                            \
        return -1;                                                                                                     \
    }

JSVM_Value NativeCreateFunctionTest(JSVM_Env env, JSVM_CallbackInfo info)
{
    void *data;
    size_t argc = 1;
    JSVM_Value argv[1] = {nullptr};
    JSVM_Value thisArg;
    // 获取callback 参数信息
    JSVM_Status ret = OH_JSVM_GetCbInfo(env, info, &argc, &argv[0], &thisArg, &data);
    if (ret != JSVM_OK) {
        const JSVM_ExtendedErrorInfo *info;
        OH_JSVM_GetLastErrorInfo(env, &info);
        OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d message = %{public}s",
                     __FILE__, __LINE__, ret, info != nullptr ? info->errorMessage : "");
        return nullptr;
    }
    const int maxMessageLength = 256;
    char message[256];
    OH_JSVM_GetValueStringLatin1(env, argv[0], message, maxMessageLength, nullptr);
    if (data == nullptr) {
        OH_LOG_ERROR(LOG_APP, "jsvm: %{public}s; callback data null", message);
    } else {
        OH_LOG_INFO(LOG_APP, "jsvm: %{public}s; %{public}s", message, (char *)data);
    }
    return nullptr;
}

static int32_t TEST_FUNC()
{
    JSVM_InitOptions initOptions{};
    JSVM_VM vm;
    JSVM_Env env = nullptr;
    JSVM_VMScope vmScope;
    JSVM_EnvScope envScope;
    JSVM_HandleScope handleScope;
    JSVM_Value result;
    static bool isVMInit = false;
    if (!isVMInit) {
        isVMInit = true;
        // 单个进程只用初始化一次
        OH_JSVM_Init(&initOptions);
    }
    CHECK_RET(OH_JSVM_CreateVM(nullptr, &vm));
    CHECK_RET(OH_JSVM_CreateEnv(vm, 0, nullptr, &env));
    CHECK_RET(OH_JSVM_OpenVMScope(vm, &vmScope));
    CHECK_RET(OH_JSVM_OpenEnvScope(env, &envScope));
    CHECK_RET(OH_JSVM_OpenHandleScope(env, &handleScope));

    // 创建并检查函数
    char hello[] = "Hello World!";
    JSVM_CallbackStruct cb = {NativeCreateFunctionTest, (void *)hello};
    JSVM_Value func;
    CHECK_RET(OH_JSVM_CreateFunction(env, "", JSVM_AUTO_LENGTH, &cb, &func));
    bool isFunction = false;
    CHECK_RET(OH_JSVM_IsFunction(env, func, &isFunction));
    CHECK(isFunction);

    // 将函数设置到全局对象中
    JSVM_Value global;
    CHECK_RET(OH_JSVM_GetGlobal(env, &global));
    JSVM_Value key;
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, "NativeFunc", JSVM_AUTO_LENGTH, &key));
    CHECK_RET(OH_JSVM_SetProperty(env, global, key, func));

    // 通过call 接口调用函数
    JSVM_Value argv[1] = {nullptr};
    OH_JSVM_CreateStringUtf8(env, "jsvm api call function", JSVM_AUTO_LENGTH, &argv[0]);
    CHECK_RET(OH_JSVM_CallFunction(env, global, func, 1, argv, &result));

    // 通过script调用函数
    JSVM_Script script;
    JSVM_Value jsSrc;
    const char *srcCallNative = R"JS(NativeFunc('js source call function');)JS";
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, srcCallNative, JSVM_AUTO_LENGTH, &jsSrc));
    CHECK_RET(OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script));
    CHECK_RET(OH_JSVM_RunScript(env, script, &result));

    CHECK_RET(OH_JSVM_CloseHandleScope(env, handleScope));
    CHECK_RET(OH_JSVM_CloseEnvScope(env, envScope));
    CHECK_RET(OH_JSVM_CloseVMScope(vm, vmScope));
    CHECK_RET(OH_JSVM_DestroyEnv(env));
    CHECK_RET(OH_JSVM_DestroyVM(vm));
    return 0;
}
// [End jsvm_function_call]

static napi_value RunTest(napi_env env, napi_callback_info info)
{
    TEST_FUNC();
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
    .nm_modname = "functioncall",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
