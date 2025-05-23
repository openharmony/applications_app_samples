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
// [Start oh_jsvm_pump_message_loop_and_perform_microtask_checkpoint]
#include <chrono>
#include <cstring>
// [StartExclude oh_jsvm_pump_message_loop_and_perform_microtask_checkpoint]
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
// [EndExclude oh_jsvm_pump_message_loop_and_perform_microtask_checkpoint]

// 待执行的js代码
static const char *STR_TASK = R"JS(
    // wasm 字节码 (以add 模块为例)
    // 以下 wasmBuffer 对应的 wasm 字节码文本格式如下所示，只包含了一个函数 add
    // (module
    //   (func $add (param $lhs i32) (param $rhs i32) (result i32)
    //     local.get $lhs
    //     local.get $rhs
    //     i32.add
    //   )
    //   (export "add" (func $add))
    // )
    var wasmBytes = new Uint8Array([0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x07, 0x01,
                                       0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f, 0x03, 0x02, 0x01, 0x00, 0x07,
                                       0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00, 0x0a, 0x09, 0x01,
                                       0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b]);

    var p = WebAssembly.instantiate(wasmBytes, {});
    p.then((result) => {
        consoleinfo("Called with instance " + result);
    });
    p.finally(() => {
       consoleinfo("Called Finally");
    });
)JS";

// 保证js代码中的打印信息可以正常输出
static JSVM_Value ConsoleInfo(JSVM_Env env, JSVM_CallbackInfo info)
{
    size_t argc = 1;
    JSVM_Value args[1];
    #define MAX_LOG_LENGTH 255
    char log[MAX_LOG_LENGTH + 1] = "";
    size_t logLength = 0;
    JSVM_CALL(OH_JSVM_GetCbInfo(env, info, &argc, args, NULL, NULL));

    OH_JSVM_GetValueStringUtf8(env, args[0], log, MAX_LOG_LENGTH, &logLength);
    log[MAX_LOG_LENGTH] = 0;
    OH_LOG_INFO(LOG_APP, "JSVM API TEST: %{public}s", log);
    return nullptr;
}

// 注册consoleinfo的方法
JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = ConsoleInfo},
};
JSVM_PropertyDescriptor descriptor[] = {
    {"consoleinfo", NULL, &param[0], NULL, NULL, NULL, JSVM_DEFAULT},
};

static int32_t TestJSVM()
{
    JSVM_InitOptions init_options;
    memset(&init_options, 0, sizeof(init_options));
    if (g_aa == 0) {
        OH_JSVM_Init(&init_options);
        g_aa++;
    }
    // 创建JavaScript虚拟机实例,打开虚拟机作用域
    JSVM_VM vm;
    JSVM_CreateVMOptions options;
    memset(&options, 0, sizeof(options));
    CHECK(OH_JSVM_CreateVM(&options, &vm));
    JSVM_VMScope vm_scope;
    CHECK(OH_JSVM_OpenVMScope(vm, &vm_scope));

    JSVM_Env env;
    CHECK(OH_JSVM_CreateEnv(vm, sizeof(descriptor) / sizeof(descriptor[0]), descriptor, &env));
    JSVM_EnvScope envScope;
    CHECK_RET(OH_JSVM_OpenEnvScope(env, &envScope));
    JSVM_HandleScope handlescope;
    CHECK_RET(OH_JSVM_OpenHandleScope(env, &handlescope));
    JSVM_Value sourcecodevalue;
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, STR_TASK, strlen(STR_TASK), &sourcecodevalue));
    JSVM_Script script;
    CHECK_RET(OH_JSVM_CompileScript(env, sourcecodevalue, nullptr, 0, true, nullptr, &script));
    JSVM_Value result;
    CHECK_RET(OH_JSVM_RunScript(env, script, &result));
    bool rst = false;
    auto start = std::chrono::system_clock::now();
    while (true) {
        // 如果任务队列中没有任务启动，则rst设置为false
        CHECK_RET(OH_JSVM_PumpMessageLoop(vm, &rst));
        CHECK_RET(OH_JSVM_PerformMicrotaskCheckpoint(vm));
        // 定时退出
        auto now = std::chrono::system_clock::now();
        auto cost = std::chrono::duration_cast<std::chrono::milliseconds>(now - start).count();
        const int timeoutMs = 100;
        if (cost > timeoutMs) {
            break;
        }
    }

    // 关闭并销毁环境和虚拟机
    CHECK_RET(OH_JSVM_CloseHandleScope(env, handlescope));
    CHECK_RET(OH_JSVM_CloseEnvScope(env, envScope));
    CHECK(OH_JSVM_DestroyEnv(env));
    CHECK(OH_JSVM_CloseVMScope(vm, vm_scope));
    CHECK(OH_JSVM_DestroyVM(vm));
    return 0;
}
// [End oh_jsvm_pump_message_loop_and_perform_microtask_checkpoint]

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
    .nm_modname = "pumpmessageloop",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }