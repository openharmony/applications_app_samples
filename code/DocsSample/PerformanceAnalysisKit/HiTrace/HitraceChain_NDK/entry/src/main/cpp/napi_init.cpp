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

// [Start hitracechain_ndk_native_code]
#include <thread>

#include "hilog/log.h"
#include "hitrace/trace.h"
#include "napi/native_api.h"

#undef LOG_TAG
#define LOG_TAG "testTag"

void Print2(HiTraceId id)
{
    // 为当前线程设置HiTraceId
    OH_HiTrace_SetId(&id);
    // 生成分支标识spanId
    id = OH_HiTrace_CreateSpan();
    // 为当前线程设置带spanId的HiTraceId
    OH_HiTrace_SetId(&id);
    OH_LOG_INFO(LogType::LOG_APP, "Print2");
    // 结束当前线程分布式跟踪，功能同OH_HiTrace_EndChain()
    OH_HiTrace_ClearId();
    OH_LOG_INFO(LogType::LOG_APP, "Print2, HiTraceChain end");
}

void Print1(HiTraceId id)
{
    // 为当前线程设置HiTraceId
    OH_HiTrace_SetId(&id);
    // 生成分支标识spanId
    id = OH_HiTrace_CreateSpan();
    // 为当前线程设置带spanId的HiTraceId
    OH_HiTrace_SetId(&id);
    OH_LOG_INFO(LogType::LOG_APP, "Print1");
    std::thread(Print2, OH_HiTrace_GetId()).detach();
    // 结束当前线程分布式跟踪
    OH_HiTrace_EndChain();
    OH_LOG_INFO(LogType::LOG_APP, "Print1, HiTraceChain end");
}

static napi_value Add(napi_env env, napi_callback_info info)
{
    // 任务开始，开启分布式跟踪
    HiTraceId hiTraceId = OH_HiTrace_BeginChain("testTag: hiTraceChain begin", HiTrace_Flag::HITRACE_FLAG_DEFAULT);
    // 判断生成的hiTraceId是否有效，有效则输出一行hilog日志
    if (OH_HiTrace_IsIdValid(&hiTraceId)) {
        OH_LOG_INFO(LogType::LOG_APP, "HiTraceId is valid");
    }
    // 使能HITRACE_FLAG_INCLUDE_ASYNC标志位，表示会在系统支持的异步机制里自动传递HiTraceId
    OH_HiTrace_EnableFlag(&hiTraceId, HiTrace_Flag::HITRACE_FLAG_INCLUDE_ASYNC);
    // 判断hitraceId的HITRACE_FLAG_INCLUDE_ASYNC标志位是否已经使能，使能则把hiTraceId设置到当前线程TLS中
    if (OH_HiTrace_IsFlagEnabled(&hiTraceId, HiTrace_Flag::HITRACE_FLAG_INCLUDE_ASYNC)) {
        OH_HiTrace_SetId(&hiTraceId);
        OH_LOG_INFO(LogType::LOG_APP, "HITRACE_FLAG_INCLUDE_ASYNC is enabled");
    }
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_valuetype valuetype0;
    napi_typeof(env, args[0], &valuetype0);

    napi_valuetype valuetype1;
    napi_typeof(env, args[1], &valuetype1);

    double value0;
    napi_get_value_double(env, args[0], &value0);

    double value1;
    napi_get_value_double(env, args[1], &value1);

    napi_value sum;
    napi_create_double(env, value0 + value1, &sum);

    // 创建线程执行打印任务，传递当前线程的HiTraceId
    std::thread(Print1, OH_HiTrace_GetId()).detach();
    // 任务结束，结束分布式跟踪
    OH_HiTrace_EndChain();
    OH_LOG_INFO(LogType::LOG_APP, "Add, HiTraceChain end");

    return sum;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr }
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End hitracechain_ndk_native_code]