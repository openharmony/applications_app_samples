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

// [Start oh_jsvm_get_heap_statistics]
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"
// [StartExclude oh_jsvm_get_heap_statistics]
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
// [EndExclude oh_jsvm_get_heap_statistics]

// OH_JSVM_GetHeapStatistics的样例方法
void PrintHeapStatistics(JSVM_HeapStatistics result)
{
    OH_LOG_INFO(LOG_APP, "JSVM API heap totalHeapSize: %{public}zu", result.totalHeapSize);
    OH_LOG_INFO(LOG_APP, "JSVM API heap totalHeapSizeExecutable: %{public}zu", result.totalHeapSizeExecutable);
    OH_LOG_INFO(LOG_APP, "JSVM API heap totalPhysicalSize: %{public}zu", result.totalPhysicalSize);
    OH_LOG_INFO(LOG_APP, "JSVM API heap totalAvailableSize: %{public}zu", result.totalAvailableSize);
    OH_LOG_INFO(LOG_APP, "JSVM API heap usedHeapSize: %{public}zu", result.usedHeapSize);
    OH_LOG_INFO(LOG_APP, "JSVM API heap heapSizeLimit: %{public}zu", result.heapSizeLimit);
    OH_LOG_INFO(LOG_APP, "JSVM API heap mallocedMemory: %{public}zu", result.mallocedMemory);
    OH_LOG_INFO(LOG_APP, "JSVM API heap externalMemory: %{public}zu", result.externalMemory);
    OH_LOG_INFO(LOG_APP, "JSVM API heap peakMallocedMemory: %{public}zu", result.peakMallocedMemory);
    OH_LOG_INFO(LOG_APP, "JSVM API heap numberOfNativeContexts: %{public}zu", result.numberOfNativeContexts);
    OH_LOG_INFO(LOG_APP, "JSVM API heap numberOfDetachedContexts: %{public}zu", result.numberOfDetachedContexts);
    OH_LOG_INFO(LOG_APP, "JSVM API heap totalGlobalHandlesSize: %{public}zu", result.totalGlobalHandlesSize);
    OH_LOG_INFO(LOG_APP, "JSVM API heap usedGlobalHandlesSize: %{public}zu", result.usedGlobalHandlesSize);
}

static JSVM_Value GetHeapStatistics(JSVM_Env env, JSVM_CallbackInfo info)
{
    // 获取当前虚拟机对象
    JSVM_VM testVm;
    OH_JSVM_GetVM(env, &testVm);
    // 获取虚拟机的堆统计信息
    JSVM_HeapStatistics result;
    OH_JSVM_GetHeapStatistics(testVm, &result);
    // 打印虚拟机堆统计信息
    PrintHeapStatistics(result);
    // 返回虚拟机堆统计信息中‘本机上下文数量’
    JSVM_Value nativeContextsCnt = nullptr;
    OH_JSVM_CreateInt64(env, result.numberOfNativeContexts, &nativeContextsCnt);
    return nativeContextsCnt;
}
// GetHeapStatistics注册回调
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = GetHeapStatistics},
};
static JSVM_CallbackStruct *method = param;
// GetHeapStatistics方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"getHeapStatistics", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

const char *SRC_CALL_NATIVE = R"JS(getHeapStatistics())JS";
// [End oh_jsvm_get_heap_statistics]

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
    .nm_modname = "getheapstatistics",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
