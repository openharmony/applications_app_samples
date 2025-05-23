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

// [Start jsvm_wasm]
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"
#include <vector>
// [StartExclude jsvm_wasm]
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

#define CHECK(cond)                                                                                                    \
    if (!(cond)) {                                                                                                     \
        OH_LOG_ERROR(LOG_APP, "jsvm fail file: %{public}s line: %{public}d ret = %{public}d", __FILE__, __LINE__,      \
                     cond);                                                                                            \
        return -1;                                                                                                     \
    }

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
// [EndExclude jsvm_wasm]

#ifndef CHECK_STATUS
#define CHECK_STATUS(cond)                           \
    do {                                             \
        if (!(cond)) {                               \
            OH_LOG_ERROR(LOG_APP, "CHECK FAILED");   \
        }                                            \
    } while (0)
#endif

// 判断一个 JSVM_Value 是否是 wasm module
static bool IsWasmModuleObject(JSVM_Env env, JSVM_Value value)
{
    bool result;
    JSVM_Status status = OH_JSVM_IsWasmModuleObject(env, value, &result);
    CHECK_STATUS(status == JSVM_OK);
    return result;
}

// 由 C 字符串创建 JSVM string
static JSVM_Value CreateString(JSVM_Env env, const char *str)
{
    JSVM_Value jsvmStr;
    JSVM_Status status = OH_JSVM_CreateStringUtf8(env, str, JSVM_AUTO_LENGTH, &jsvmStr);
    CHECK_STATUS(status == JSVM_OK);
    return jsvmStr;
}

// 由 C int32_t 创建 JSVM number
static JSVM_Value CreateInt32(JSVM_Env env, int32_t val)
{
    JSVM_Value jsvmInt32;
    JSVM_Status status = OH_JSVM_CreateInt32(env, val, &jsvmInt32);
    CHECK_STATUS(status == JSVM_OK);
    return jsvmInt32;
}

// 对 wasm module 进行实例化
static JSVM_Value InstantiateWasmModule(JSVM_Env env, JSVM_Value wasmModule)
{
    JSVM_Status status = JSVM_OK;
    JSVM_Value globalThis;
    status = OH_JSVM_GetGlobal(env, &globalThis);
    CHECK_STATUS(status == JSVM_OK);

    JSVM_Value webAssembly;
    status = OH_JSVM_GetProperty(env, globalThis, CreateString(env, "WebAssembly"), &webAssembly);
    CHECK_STATUS(status == JSVM_OK);

    JSVM_Value webAssemblyInstance;
    status = OH_JSVM_GetProperty(env, webAssembly, CreateString(env, "Instance"), &webAssemblyInstance);
    CHECK_STATUS(status == JSVM_OK);

    JSVM_Value instance;
    JSVM_Value argv[] = {wasmModule};
    status = OH_JSVM_NewInstance(env, webAssemblyInstance, 1, argv, &instance);
    CHECK_STATUS(status == JSVM_OK);
    return instance;
}

// 获取 wasm 字节码 (add 模块)
static std::vector<uint8_t> GetAddWasmBuffer()
{
    // 以下 wasmBuffer 对应的 wasm 字节码文本格式如下所示，只包含了一个函数 add
    // (module
    //   (func $add (param $lhs i32) (param $rhs i32) (result i32)
    //     local.get $lhs
    //     local.get $rhs
    //     i32.add
    //   )
    //   (export "add" (func $add))
    // )
    std::vector<uint8_t> wasmBuffer = {0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x07, 0x01,
                                       0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f, 0x03, 0x02, 0x01, 0x00, 0x07,
                                       0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00, 0x0a, 0x09, 0x01,
                                       0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b};
    return wasmBuffer;
}

// 验证 wasm instance 功能 (add 模块)
static void VerifyAddWasmInstance(JSVM_Env env, JSVM_Value wasmInstance)
{
    JSVM_Status status = JSVM_OK;
    // 从 wasm instance 获取 exports.add 函数
    JSVM_Value exports;
    status = OH_JSVM_GetProperty(env, wasmInstance, CreateString(env, "exports"), &exports);
    CHECK_STATUS(status == JSVM_OK);

    JSVM_Value add;
    status = OH_JSVM_GetProperty(env, exports, CreateString(env, "add"), &add);
    CHECK_STATUS(status == JSVM_OK);

    // 执行 exports.add(1, 2)，期望得到结果 3
    JSVM_Value undefined;
    OH_JSVM_GetUndefined(env, &undefined);
    JSVM_Value one = CreateInt32(env, 1);
    JSVM_Value two = CreateInt32(env, 2);
    JSVM_Value argv[] = {one, two};
    JSVM_Value result;
    const int argumentCount = 2;
    status = OH_JSVM_CallFunction(env, undefined, add, argumentCount, argv, &result);
    CHECK_STATUS(status == JSVM_OK);
    int32_t resultInt32;
    OH_JSVM_GetValueInt32(env, result, &resultInt32);
    CHECK_STATUS(resultInt32 == 3);
}

// WebAssembly demo 主函数
static JSVM_Value WasmDemo(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_Status status = JSVM_OK;
    std::vector<uint8_t> wasmBuffer = GetAddWasmBuffer();
    uint8_t *wasmBytecode = wasmBuffer.data();
    size_t wasmBytecodeLength = wasmBuffer.size();
    JSVM_Value wasmModule;
    // 根据 wasm 字节码得到 wasm module
    status = OH_JSVM_CompileWasmModule(env, wasmBytecode, wasmBytecodeLength, NULL, 0, NULL, &wasmModule);
    CHECK_STATUS(status == JSVM_OK);
    CHECK_STATUS(IsWasmModuleObject(env, wasmModule));

    // 对当前 wasm module 中定义的第一个函数 (即 add) 执行编译优化
    int32_t functionIndex = 0;
    // 注意：当前只支持 high level optimization，即传入 JSVM_WASM_OPT_BASELINE 和传入 JSVM_WASM_OPT_HIGH 效果是一样的
    status = OH_JSVM_CompileWasmFunction(env, wasmModule, functionIndex, JSVM_WASM_OPT_HIGH);
    CHECK_STATUS(status == JSVM_OK);
    // 对编译得到的 wasm module 进行实例化
    JSVM_Value wasmInstance = InstantiateWasmModule(env, wasmModule);
    // 对实例化的 wasm instance 中的函数进行功能验证
    VerifyAddWasmInstance(env, wasmInstance);

    // 创建 wasm cache
    const uint8_t *wasmCacheData = NULL;
    size_t wasmCacheLength = 0;
    status = OH_JSVM_CreateWasmCache(env, wasmModule, &wasmCacheData, &wasmCacheLength);
    CHECK_STATUS(status == JSVM_OK);
    // 期望 wasm cache 创建成功
    CHECK_STATUS(wasmCacheData != NULL);
    CHECK_STATUS(wasmCacheLength > 0);

    // 通过将 wasm cache 赋值来模拟 cache 持久化，实际使用场景可能将 wasm cache 保存到文件
    std::vector<uint8_t> cacheBuffer(wasmCacheData, wasmCacheData + wasmCacheLength);

    // cache 一旦保存完成后，需要显式释放，以免发生内存泄露
    // 注意：传入的 JSVM_CacheType 必须匹配
    status = OH_JSVM_ReleaseCache(env, wasmCacheData, JSVM_CACHE_TYPE_WASM);
    CHECK_STATUS(status == JSVM_OK);

    // 使用 wasm code 反序列化来生成 wasm module
    bool cacheRejected;
    JSVM_Value wasmModule2;
    status = OH_JSVM_CompileWasmModule(env, wasmBytecode, wasmBytecodeLength, cacheBuffer.data(), cacheBuffer.size(),
                                       &cacheRejected, &wasmModule2);

    // 传入的 wasm cache 如果是匹配的，且内部校验通过 (如版本)，则会接受 cache
    CHECK_STATUS(!cacheRejected);
    CHECK_STATUS(IsWasmModuleObject(env, wasmModule2));

    // 对反序列化得到的 wasmModule2 进行同样的操作：函数编译、实例化、验证功能，期望也都是通过的
    status = OH_JSVM_CompileWasmFunction(env, wasmModule2, functionIndex, JSVM_WASM_OPT_HIGH);
    CHECK_STATUS(status == JSVM_OK);

    JSVM_Value wasmInstance2 = InstantiateWasmModule(env, wasmModule);
    VerifyAddWasmInstance(env, wasmInstance2);

    JSVM_Value result;
    OH_JSVM_GetBoolean(env, true, &result);
    OH_LOG_INFO(LOG_APP, "JSVM resultInt: %{public}d", result);
    return result;
}

// WasmDemo 方法注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = WasmDemo}
};
static JSVM_CallbackStruct *method = param;
// 将 C++ callback WasmDemo 函数注册为 JSVM globalThis.wasmDemo 属性，供 JS 侧调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"wasmDemo", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

// 样例测试js
const char *SRC_CALL_NATIVE = R"JS(wasmDemo())JS";
// [End jsvm_wasm]

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
    CHECK_RET(OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE, JSVM_AUTO_LENGTH, &jsSrc));
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
    .nm_modname = "webassembly",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
