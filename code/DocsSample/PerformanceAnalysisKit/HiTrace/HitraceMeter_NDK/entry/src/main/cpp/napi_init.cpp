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

// [Start hitracemeter_ndk_native_code]
#include <cstdio>
#include <cstring>

#include "hilog/log.h"
#include "hitrace/trace.h"
#include "napi/native_api.h"

#undef LOG_TAG
#define LOG_TAG "traceTest"

static napi_value Add(napi_env env, napi_callback_info info)
{
    // 第一个异步跟踪任务开始
    HiTrace_Output_Level level = HITRACE_LEVEL_COMMERCIAL;
    constexpr int64_t taskIdOne = 1001;
    OH_HiTrace_StartAsyncTraceEx(level, "myTestAsyncTrace", taskIdOne, "categoryTest", "key=value");
    // 开始计数任务
    int64_t traceCount = 0;
    traceCount++;
    OH_HiTrace_CountTraceEx(level, "myTestCountTrace", traceCount);
    // 业务流程
    OH_LOG_INFO(LogType::LOG_APP, "myTraceTest running, taskId: 1001");
    // 第二个异步跟踪任务开始，同时第一个跟踪的同名任务还没结束，出现了并行执行，对应接口的taskId需要不同
    constexpr int64_t taskIdTwo = 1002;
    OH_HiTrace_StartAsyncTraceEx(level, "myTestAsyncTrace", taskIdTwo, "categoryTest", "key=value");
    // 开始计数任务
    traceCount++;
    OH_HiTrace_CountTraceEx(level, "myTestCountTrace", traceCount);
    // 业务流程
    OH_LOG_INFO(LogType::LOG_APP, "myTraceTest running, taskId: 1002");

    // 结束taskId为1001的异步跟踪任务
    OH_HiTrace_FinishAsyncTraceEx(level, "myTestAsyncTrace", taskIdOne);
    // 结束taskId为1002的异步跟踪任务
    OH_HiTrace_FinishAsyncTraceEx(level, "myTestAsyncTrace", taskIdTwo);

    // 开始同步跟踪任务
    OH_HiTrace_StartTraceEx(level, "myTestSyncTrace", "key=value");
    // 业务流程
    OH_LOG_INFO(LogType::LOG_APP, "myTraceTest running, synchronizing trace");
    // 结束同步跟踪任务
    OH_HiTrace_FinishTraceEx(level);

    // 若通过HiTraceMeter性能打点接口传递的参数的生成过程比较复杂，此时可以通过isTraceEnabled判断当前是否开启应用trace捕获，
    // 在未开启应用trace捕获时，避免该部分性能损耗
    constexpr int64_t taskIdThree = 1003;
    constexpr int loopTime = 10;
    if (OH_HiTrace_IsTraceEnabled()) {
        char customArgs[128] = "key0=value0";
        for (int index = 1; index < loopTime; index++) {
            char buffer[16];
            snprintf(buffer, sizeof(buffer), ",key%d=value%d", index, index);
            strncat(customArgs, buffer, sizeof(customArgs) - strlen(customArgs) - 1);
        }
        OH_HiTrace_StartAsyncTraceEx(level, "myTestAsyncTrace", taskIdThree, "categoryTest", customArgs);
        OH_LOG_INFO(LogType::LOG_APP, "myTraceTest running, taskId: 1003");
        OH_HiTrace_FinishAsyncTraceEx(level, "myTestAsyncTrace", taskIdThree);
    } else {
        OH_LOG_INFO(LogType::LOG_APP, "myTraceTest running, trace is not enabled");
    }

    size_t requireArgc = 2;
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
// [End hitracemeter_ndk_native_code]