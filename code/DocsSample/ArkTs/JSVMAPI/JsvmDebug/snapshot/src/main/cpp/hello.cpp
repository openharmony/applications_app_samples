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

// [Start heap_snapshot]
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"
#include <fstream>
// [StartExclude heap_snapshot]
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
// [EndExclude heap_snapshot]

using namespace std;

// 待调优的JS代码。
static string g_srcProf = R"JS(
function sleep(delay) {
    var start = (new Date()).getTime();
    while ((new Date()).getTime() - start < delay) {
        continue;
    }
}

function work3() {
    sleep(300);
}

function work2() {
    work3();
    sleep(200);
}

function work1() {
    work2();
    sleep(100);
}

work1();
)JS";

// 数据输出流回调，用户自定义，处理返回的调优数据，此处以写入文件为例。
static bool OutputStream(const char *data, int size, void *streamData)
{
    auto &os = *reinterpret_cast<ofstream *>(streamData);
    if (data) {
        os.write(data, size);
    } else {
        os.close();
    }
    return true;
}

static JSVM_CpuProfiler ProfilingBegin(JSVM_VM vm)
{
    // 文件输出流，保存调优数据，/data/storage/el2/base/files为沙箱路径。以包名为com.example.helloworld为例。
    // 实际文件会保存到/data/app/el2/100/base/com.example.helloworld/files/heap-snapshot-begin.heapsnapshot。
    ofstream heapSnapshot("/data/storage/el2/base/files/heap-snapshot-begin.heapsnapshot",
                          ios::out | ios::binary | ios::trunc);
    // 执行JS前获取一次Heap Snapshot数据。
    OH_JSVM_TakeHeapSnapshot(vm, OutputStream, &heapSnapshot);
    JSVM_CpuProfiler cpuProfiler;
    // 开启CPU Profiler。
    OH_JSVM_StartCpuProfiler(vm, &cpuProfiler);
    return cpuProfiler;
}

// 关闭调优数据采集工具
static void ProfilingEnd(JSVM_VM vm, JSVM_CpuProfiler cpuProfiler)
{
    // 文件输出流，保存调优数据，/data/storage/el2/base/files为沙箱路径。以包名为com.example.helloworld为例。
    // 实际文件会保存到/data/app/el2/100/base/com.example.helloworld/files/cpu-profile.cpuprofile。
    ofstream cpuProfile("/data/storage/el2/base/files/cpu-profile.cpuprofile",
                        ios::out | ios::binary | ios::trunc);
    // 关闭CPU Profiler，获取数据。
    OH_JSVM_StopCpuProfiler(vm, cpuProfiler, OutputStream, &cpuProfile);
    ofstream heapSnapshot("/data/storage/el2/base/files/heap-snapshot-end.heapsnapshot",
                              ios::out | ios::binary | ios::trunc);
    // 执行JS后再获取一次Heap Snapshot数据，与执行前数据作对比，以分析内存问题或者进行内存调优。
    OH_JSVM_TakeHeapSnapshot(vm, OutputStream, &heapSnapshot);
}

static JSVM_Value RunScriptWithStatistics(JSVM_Env env, JSVM_CallbackInfo info)
{
    JSVM_VM vm;
    OH_JSVM_GetVM(env, &vm);

    // 开始调优。
    auto cpuProfiler = ProfilingBegin(vm);

    JSVM_HandleScope handleScope;
    OH_JSVM_OpenHandleScope(env, &handleScope);

    JSVM_Value jsSrc;
    OH_JSVM_CreateStringUtf8(env, g_srcProf.c_str(), g_srcProf.size(), &jsSrc);

    JSVM_Script script;
    OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script);

    JSVM_Value result;
    // 执行JS代码。
    OH_JSVM_RunScript(env, script, &result);

    OH_JSVM_CloseHandleScope(env, handleScope);

    // 结束调优。
    ProfilingEnd(vm, cpuProfiler);
    return nullptr;
}
static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = RunScriptWithStatistics},
};
static JSVM_CallbackStruct *method = param;
// runScriptWithStatistics方法别名，供JS调用
static JSVM_PropertyDescriptor descriptor[] = {
    {"runScriptWithStatistics", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

const char *SRC_CALL_NATIVE = R"JS(runScriptWithStatistics();)JS";

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
// [End heap_snapshot]

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
    .nm_modname = "snapshot",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
