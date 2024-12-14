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

#include <pthread.h>
#include "napi/native_api.h"
#include <napi/common.h>
#include <pthread.h>
#include <future>

static constexpr int INT_ARG_2 = 2; // 入参索引
static constexpr int INT_ARG_12 = 12; // 入参索引
static constexpr int INT_ARG_15 = 15; // 入参索引

static void *CreateArkRuntimeFunc(void *arg)
{
    // 1. 创建基础运行环境
    napi_env env;
    napi_status ret = napi_create_ark_runtime(&env);
    if (ret != napi_ok) {
        return nullptr;
    }

    // 2. 加载自定义模块
    napi_value objUtils;
    ret = napi_load_module_with_info(env, "entry/src/main/ets/pages/ObjectUtils", "com.example.myapplication/entry",
                                     &objUtils);
    if (ret != napi_ok) {
        return nullptr;
    }

    // 3. 使用ArkTS中的logger
    napi_value logger;
    ret = napi_get_named_property(env, objUtils, "Logger", &logger);
    if (ret != napi_ok) {
        return nullptr;
    }
    ret = napi_call_function(env, objUtils, logger, 0, nullptr, nullptr);

    // 4. 销毁ArkTS环境
    ret = napi_destroy_ark_runtime(&env);

    return nullptr;
}

static napi_value CreateArkRuntime(napi_env env, napi_callback_info info)
{
    pthread_t tid;
    pthread_create(&tid, nullptr, CreateArkRuntimeFunc, nullptr);
    pthread_join(tid, nullptr);
    return nullptr;
}

static napi_value ResolvedCallback(napi_env env, napi_callback_info info)
{
    napi_stop_event_loop(env);
    return nullptr;
}

static napi_value RejectedCallback(napi_env env, napi_callback_info info)
{
    napi_stop_event_loop(env);
    return nullptr;
}

static void *RunEventLoopFunc(void *arg)
{
    // 1. 创建ArkTS实例
    napi_env env;
    napi_status ret = napi_create_ark_runtime(&env);
    if (ret != napi_ok) {
        return nullptr;
    }

    // 2. 加载自定义的模块
    napi_value objectUtils;
    // 'com.example.myapplication' 为当前应用的bundleName
    ret = napi_load_module_with_info(env, "ets/pages/ObjectUtils", "com.example.myapplication/entry", &objectUtils);
    if (ret != napi_ok) {
        return nullptr;
    }

    // 3. 调用异步SetTimeout接口
    napi_value setTimeout = nullptr;
    napi_value promise = nullptr;

    napi_get_named_property(env, objectUtils, "SetTimeout", &setTimeout);
    napi_call_function(env, objectUtils, setTimeout, 0, nullptr, &promise);

    napi_value theFunc = nullptr;
    if (napi_get_named_property(env, promise, "then", &theFunc) != napi_ok) {
        return nullptr;
    }

    napi_value resolvedCallback = nullptr;
    napi_value rejectedCallback = nullptr;
    napi_create_function(env, "resolvedCallback", NAPI_AUTO_LENGTH, ResolvedCallback, nullptr, &resolvedCallback);
    napi_create_function(env, "rejectedCallback", NAPI_AUTO_LENGTH, RejectedCallback, nullptr, &rejectedCallback);
    napi_value argv[2] = {resolvedCallback, rejectedCallback};
    napi_call_function(env, promise, theFunc, INT_ARG_2, argv, nullptr);

    auto flag = reinterpret_cast<bool *>(arg);
    if (*flag == true) {
        napi_run_event_loop(env, napi_event_mode_default);
    } else {
        // 非阻塞式的处理任务，有可能队列中还没有任务就已经返回了
        napi_run_event_loop(env, napi_event_mode_nowait);
    }
    return nullptr;
}

static napi_value RunEventLoop(napi_env env, napi_callback_info info)
{
    pthread_t tid;
    size_t argc = 1;
    napi_value argv[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    bool flag = false;
    napi_get_value_bool(env, argv[0], &flag);
    // 创建异步线程
    pthread_create(&tid, nullptr, RunEventLoopFunc, &flag);
    pthread_join(tid, nullptr);

    return nullptr;
}

struct CallbackData {
    napi_threadsafe_function tsfn;
    napi_async_work work;
};
// ArkTS线程的回调实现
static void CallJs(napi_env env, napi_value jsCb, void *context, void *data)
{
    if (env == nullptr) {
        return;
    }
    napi_value resultNumber = nullptr;
    napi_value undefined = nullptr;
    napi_get_undefined(env, &undefined);
    napi_value number1 = nullptr;
    napi_create_int32(env, INT_ARG_12, &number1);
    napi_value number2 = nullptr;
    napi_create_int32(env, INT_ARG_15, &number2);
    napi_value argv[2] = {number1, number2};
    napi_call_function(env, undefined, jsCb, INT_ARG_2, argv, &resultNumber);
    int32_t res = 0;
    napi_get_value_int32(env, resultNumber, &res);
}

// 异步线程中调用该接口向ArkTS线程投递指定优先级和入队方式的任务
static void ExecuteWork(napi_env env, void *data)
{
    CallbackData *callbackData = reinterpret_cast<CallbackData *>(data);
    // 执行任务为napi_priority_idle优先级，入队方式为队列尾部入队
    napi_call_threadsafe_function_with_priority(callbackData->tsfn, nullptr, napi_priority_idle, true);
    napi_call_threadsafe_function_with_priority(callbackData->tsfn, nullptr, napi_priority_low, true);
    napi_call_threadsafe_function_with_priority(callbackData->tsfn, nullptr, napi_priority_high, true);
    napi_call_threadsafe_function_with_priority(callbackData->tsfn, nullptr, napi_priority_immediate, true);
    // 执行任务为napi_priority_high优先级，入队方式为队列头部入队
    napi_call_threadsafe_function_with_priority(callbackData->tsfn, nullptr, napi_priority_high, false);
}

static void WorkComplete(napi_env env, napi_status status, void *data)
{
    CallbackData *callbackData = reinterpret_cast<CallbackData *>(data);
    napi_release_threadsafe_function(callbackData->tsfn, napi_tsfn_release);
    napi_delete_async_work(env, callbackData->work);
    callbackData->work = nullptr;
    callbackData->tsfn = nullptr;
}

static napi_value CallThreadSafeWithPriority(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value jsCb = nullptr;
    CallbackData *callbackData = nullptr;
    napi_get_cb_info(env, info, &argc, &jsCb, nullptr, reinterpret_cast<void **>(&callbackData));
    napi_value resourceName = nullptr;
    napi_create_string_utf8(env, "Thread-safe Function Demo", NAPI_AUTO_LENGTH, &resourceName);
    napi_create_threadsafe_function(env, jsCb, nullptr, resourceName, 0, 1, callbackData, nullptr, callbackData, CallJs,
                                    &callbackData->tsfn);
    napi_create_async_work(env, nullptr, resourceName, ExecuteWork, WorkComplete, callbackData, &callbackData->work);
    napi_queue_async_work(env, callbackData->work);
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    CallbackData *callbackData = new CallbackData();
    napi_property_descriptor desc[] = {
        {"createArkRuntime", nullptr, CreateArkRuntime, nullptr, nullptr, nullptr, napi_static, nullptr},
        {"runEventLoop", nullptr, RunEventLoop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"callThreadSafeWithPriority", nullptr, CallThreadSafeWithPriority, nullptr, nullptr, nullptr,
            napi_default, callbackData}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterQueueWorkModule() { napi_module_register(&nativeModule); }
