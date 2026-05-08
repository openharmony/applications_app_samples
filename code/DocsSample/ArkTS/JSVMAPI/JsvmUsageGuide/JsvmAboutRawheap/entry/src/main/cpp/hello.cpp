/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include <iostream>
#include <fstream>
#include <thread>
#include <chrono>
#include <unistd.h>
#include <sys/types.h>
#include "napi/native_api.h"
#include "hilog/log.h"
#include "ark_runtime/jsvm.h"

#define LOG_DOMAIN 0x3200
#define LOG_TAG "APP"

static int g_aa = 0;

static bool g_heapThresholdCalled = false;
static uint64_t g_triggeredThreshold = 0;
static void* g_callbackUserData = nullptr;
static bool g_snapshotGenerated = false;

static constexpr int SLEEP_TIME_MS = 100;
static constexpr uint64_t THRESHOLD_SIZE = 1024 * 1024;
static constexpr int TEST_DATA_VALUE = 0x12345678;

bool SnapshotStreamCallback(const char* data, int size, void* streamData)
{
    std::FILE* file = reinterpret_cast<std::FILE*>(streamData);
    if (file) {
        size_t written = std::fwrite(data, 1, size, file);
        return written == static_cast<size_t>(size);
    }
    return true;
}

void OnHeapThresholdReached(JSVM_VM vm, uint64_t threshold, void* data)
{
    OH_LOG_INFO(LOG_APP, "== Heap threshold reached ==");
    OH_LOG_INFO(LOG_APP, "Threshold: %{public}lu bytes", threshold);
    OH_LOG_INFO(LOG_APP, "User data: %{public}d", *static_cast<int*>(data));

    g_heapThresholdCalled = true;
    g_triggeredThreshold = threshold;
    g_callbackUserData = data;

    if (!g_snapshotGenerated) {
        g_snapshotGenerated = true;
        pid_t pid = fork();
        if (pid < 0) {
            OH_LOG_ERROR(LOG_APP, "fork failed");
        } else if (pid == 0) {
            std::FILE* file = std::fopen(
                "/data/storage/el2/base/temp/threshold.rawheap", "wb");
            OH_JSVM_TakeRawHeapSnapshot(vm, SnapshotStreamCallback, file);
            std::fflush(file);
            fclose(file);
            _exit(0);
        }
    }
}

static void ResetTestState()
{
    g_heapThresholdCalled = false;
    g_triggeredThreshold = 0;
    g_callbackUserData = nullptr;
    g_snapshotGenerated = false;
}

static void TestSetHeapThresholdCallback(JSVM_VM vm, uint64_t threshold, int* testData)
{
    JSVM_Status addStatus = OH_JSVM_SetHeapThresholdCallback(
        vm, threshold, OnHeapThresholdReached, testData);
    if (addStatus == JSVM_OK) {
        OH_LOG_INFO(LOG_APP, "Set heap threshold callback success");
    }

    JSVM_Status addRepeatStatus = OH_JSVM_SetHeapThresholdCallback(
        vm, threshold, OnHeapThresholdReached, testData);
    if (addRepeatStatus == JSVM_INVALID_ARG) {
        OH_LOG_INFO(LOG_APP, "Set repeated callback failed (expected)");
    }

    JSVM_Status addInvalidStatus = OH_JSVM_SetHeapThresholdCallback(
        vm, 0, OnHeapThresholdReached, testData);
    if (addInvalidStatus == JSVM_INVALID_ARG) {
        OH_LOG_INFO(LOG_APP, "Set callback with 0 threshold failed (expected)");
    }
}

static void TestClearHeapThresholdCallback(JSVM_VM vm, uint64_t threshold, int* testData)
{
    JSVM_Status removeStatus = OH_JSVM_ClearHeapThresholdCallback(
        vm, threshold, OnHeapThresholdReached, testData);
    if (removeStatus == JSVM_OK) {
        OH_LOG_INFO(LOG_APP, "Clear heap threshold callback success");
    }

    JSVM_Status removeRepeatStatus = OH_JSVM_ClearHeapThresholdCallback(
        vm, threshold, OnHeapThresholdReached, testData);
    if (removeRepeatStatus == JSVM_INVALID_ARG) {
        OH_LOG_INFO(LOG_APP, "Clear repeated callback failed (expected)");
    }

    JSVM_Status removeMismatchStatus = OH_JSVM_ClearHeapThresholdCallback(
        vm, 999999, OnHeapThresholdReached, testData);
    if (removeMismatchStatus == JSVM_INVALID_ARG) {
        OH_LOG_INFO(LOG_APP, "Clear mismatch threshold callback failed (expected)");
    }
}

static void RunAllocScript(JSVM_Env env)
{
    const char* allocJs = R"JS(
        var holder = [];
        for (let i = 0; i < 10000; i++) {
            holder.push(new Uint8Array(1024));
        }
    )JS";

    JSVM_Value jsSrc;
    JSVM_Value result1;
    JSVM_Script script;
    OH_JSVM_CreateStringUtf8(env, allocJs, JSVM_AUTO_LENGTH, &jsSrc);
    OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script);
    OH_JSVM_RunScript(env, script, &result1);
}

static bool CheckTestResult(uint64_t threshold, int* testData)
{
    bool testSuccess = (g_heapThresholdCalled &&
                        g_triggeredThreshold == threshold &&
                        g_callbackUserData == testData &&
                        g_snapshotGenerated);
    if (testSuccess) {
        OH_LOG_INFO(LOG_APP, "Heap management test: SUCCESS");
    } else {
        OH_LOG_ERROR(LOG_APP, "Heap management test: FAILED");
    }
    return testSuccess;
}

static JSVM_Value HeapMgmtTest(JSVM_Env env, JSVM_CallbackInfo info)
{
    ResetTestState();

    JSVM_VM vm;
    OH_JSVM_GetVM(env, &vm);
    int testData = TEST_DATA_VALUE;
    uint64_t threshold = THRESHOLD_SIZE;

    std::FILE* file = std::fopen(
        "/data/storage/el2/base/temp/take.rawheap", "wb");
    JSVM_Status snapshotStatus = OH_JSVM_TakeRawHeapSnapshot(
        vm, SnapshotStreamCallback, file);
    if (snapshotStatus == JSVM_INVALID_ARG) {
        OH_LOG_ERROR(LOG_APP, "Take raw heap snapshot failed (invalid arg)");
    }

    TestSetHeapThresholdCallback(vm, threshold, &testData);
    RunAllocScript(env);

    OH_JSVM_MemoryPressureNotification(env, JSVM_MEMORY_PRESSURE_LEVEL_CRITICAL);
    std::this_thread::sleep_for(std::chrono::milliseconds(SLEEP_TIME_MS));

    TestClearHeapThresholdCallback(vm, threshold, &testData);

    bool testSuccess = CheckTestResult(threshold, &testData);

    JSVM_Value result;
    OH_JSVM_GetBoolean(env, testSuccess, &result);
    return result;
}

static JSVM_CallbackStruct param[] = {
    {.data = nullptr, .callback = HeapMgmtTest},
};

static JSVM_CallbackStruct* method = param;

static JSVM_PropertyDescriptor descriptor[] = {
    {"heapMgmtTest", nullptr, method++, nullptr, nullptr, nullptr, JSVM_DEFAULT},
};

const char* SRC_CALL_NATIVE = R"JS(heapMgmtTest();)JS";

static int32_t InitJSVM(JSVM_VM* vm, JSVM_Env* env)
{
    if (g_aa == 0) {
        g_aa++;
        JSVM_InitOptions initOptions = {0};
        if (OH_JSVM_Init(&initOptions) != JSVM_OK) {
            OH_LOG_ERROR(LOG_APP, "OH_JSVM_Init failed");
            return -1;
        }
    }

    if (OH_JSVM_CreateVM(nullptr, vm) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_CreateVM failed");
        return -1;
    }

    size_t descriptorCount = sizeof(descriptor) / sizeof(descriptor[0]);
    if (OH_JSVM_CreateEnv(*vm, descriptorCount, descriptor, env) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_CreateEnv failed");
        OH_JSVM_DestroyVM(*vm);
        return -1;
    }
    return 0;
}

static int32_t OpenScopes(JSVM_VM vm, JSVM_Env env,
                          JSVM_VMScope* vmScope,
                          JSVM_EnvScope* envScope,
                          JSVM_HandleScope* handleScope)
{
    if (OH_JSVM_OpenVMScope(vm, vmScope) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_OpenVMScope failed");
        return -1;
    }

    if (OH_JSVM_OpenEnvScope(env, envScope) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_OpenEnvScope failed");
        OH_JSVM_CloseVMScope(vm, *vmScope);
        return -1;
    }

    if (OH_JSVM_OpenHandleScope(env, handleScope) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_OpenHandleScope failed");
        OH_JSVM_CloseEnvScope(env, *envScope);
        OH_JSVM_CloseVMScope(vm, *vmScope);
        return -1;
    }
    return 0;
}

static int32_t CompileAndRunScript(JSVM_Env env)
{
    JSVM_Value jsSrc;
    if (OH_JSVM_CreateStringUtf8(env, SRC_CALL_NATIVE, JSVM_AUTO_LENGTH, &jsSrc)
        != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_CreateStringUtf8 failed");
        return -1;
    }

    JSVM_Script script;
    if (OH_JSVM_CompileScript(env, jsSrc, nullptr, 0, true, nullptr, &script)
        != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_CompileScript failed");
        return -1;
    }

    JSVM_Value result;
    if (OH_JSVM_RunScript(env, script, &result) != JSVM_OK) {
        OH_LOG_ERROR(LOG_APP, "OH_JSVM_RunScript failed");
        return -1;
    }
    return 0;
}

static void CloseScopes(JSVM_VM vm, JSVM_Env env,
                        JSVM_VMScope vmScope,
                        JSVM_EnvScope envScope,
                        JSVM_HandleScope handleScope)
{
    OH_JSVM_CloseHandleScope(env, handleScope);
    OH_JSVM_CloseEnvScope(env, envScope);
    OH_JSVM_CloseVMScope(vm, vmScope);
}

static int32_t TestJSVM()
{
    JSVM_VM vm;
    JSVM_Env env = nullptr;

    if (InitJSVM(&vm, &env) != 0) {
        return -1;
    }

    JSVM_VMScope vmScope;
    JSVM_EnvScope envScope;
    JSVM_HandleScope handleScope;
    if (OpenScopes(vm, env, &vmScope, &envScope, &handleScope) != 0) {
        OH_JSVM_DestroyEnv(env);
        OH_JSVM_DestroyVM(vm);
        return -1;
    }

    int32_t result = CompileAndRunScript(env);

    CloseScopes(vm, env, vmScope, envScope, handleScope);
    OH_JSVM_DestroyEnv(env);
    OH_JSVM_DestroyVM(vm);
    return result;
}

static napi_value RunTest(napi_env env, napi_callback_info info)
{
    TestJSVM();
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"runTest", nullptr, RunTest, nullptr, nullptr, nullptr, napi_default, nullptr}
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
    .nm_priv = static_cast<void*>(0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}