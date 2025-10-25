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

// [Start TestHidebugNdk_Function]
#include <thread>
#include "hidebug/hidebug.h"
#include "hilog/log.h"
#include "test_backtrace.h"

#undef LOG_TAG
#define LOG_TAG "testTag"

__attribute((noinline)) __attribute((optnone)) void TestNativeFrames(int i)
{
    if (i > 0) {
        TestNativeFrames(i - 1);
        return;
    }
    BacktraceCurrentThread();
}

__attribute((noinline)) __attribute((optnone)) napi_value TestBackTrace(napi_env env, napi_callback_info info)
{
    TestNativeFrames(1);
    return nullptr;
}

napi_value TestGetThreadCpuUsage(napi_env env, napi_callback_info info)
{
    HiDebug_ThreadCpuUsagePtr cpuUsage = OH_HiDebug_GetAppThreadCpuUsage();
    while (cpuUsage != nullptr) {
        OH_LOG_INFO(LogType::LOG_APP,
            "GetAppThreadCpuUsage: threadId %{public}d, cpuUsage: %{public}f", cpuUsage->threadId, cpuUsage->cpuUsage);
        cpuUsage = cpuUsage->next; // 获取下一个线程的cpu使用率对象指针。
    }
    OH_HiDebug_FreeThreadCpuUsage(&cpuUsage); // 释放内存，防止内存泄露。
    return nullptr;
}
// [End TestHidebugNdk_Function]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // [Start TestHidebugNdk_Define]
    napi_property_descriptor desc[] = {
        { "testGetThreadCpuUsage", nullptr, TestGetThreadCpuUsage, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "testBackTrace", nullptr, TestBackTrace, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    // [End TestHidebugNdk_Define]
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}