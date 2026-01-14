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
// [Start napi_thread_safety_cpp]
// [Start napi_call_threadsafe_function_cpp]
#include "napi/native_api.h"
#include "hilog/log.h"
#include <future>
// [StartExclude napi_call_threadsafe_function_cpp]

static constexpr int INT_ARG_2 = 2; // 入参索引
static constexpr int INT_BUF_32 = 32; // 入参索引

struct CallbackData {
    napi_threadsafe_function tsfn;
    napi_async_work work;
};

// 在工作线程中调用ExecuteWork并执行线程安全函数
static void ExecuteWork(napi_env env, void *data)
{
    CallbackData *callbackData = reinterpret_cast<CallbackData *>(data);
    std::promise<std::string> promise;
    auto future = promise.get_future();
    napi_call_threadsafe_function(callbackData->tsfn, &promise, napi_tsfn_nonblocking);
    try {
        auto result = future.get();
        OH_LOG_INFO(LOG_APP, "XXX, Result from JS %{public}s", result.c_str());
    } catch (const std::exception &e) {
        OH_LOG_INFO(LOG_APP, "XXX, Result from JS %{public}s", e.what());
    }
}

static napi_value ResolvedCallback(napi_env env, napi_callback_info info)
{
    void *data = nullptr;
    size_t argc = 1;
    napi_value argv[1];
    if (napi_get_cb_info(env, info, &argc, argv, nullptr, &data) != napi_ok) {
        return nullptr;
    }
    size_t result = 0;
    char buf[32] = {0};
    napi_get_value_string_utf8(env, argv[0], buf, INT_BUF_32, &result);
    reinterpret_cast<std::promise<std::string> *>(data)->set_value(std::string(buf));
    return nullptr;
}

static napi_value RejectedCallback(napi_env env, napi_callback_info info)
{
    void *data = nullptr;
    if (napi_get_cb_info(env, info, nullptr, nullptr, nullptr, &data) != napi_ok) {
        return nullptr;
    }
    reinterpret_cast<std::promise<std::string> *>(data)->set_exception(
        std::make_exception_ptr(std::runtime_error("Error in jsCallback")));
    return nullptr;
}

static void CallJs(napi_env env, napi_value jsCb, void *context, void *data)
{
    if (env == nullptr) {
        return;
    }
    napi_value undefined = nullptr;
    napi_value promise = nullptr;
    napi_get_undefined(env, &undefined);
    napi_call_function(env, undefined, jsCb, 0, nullptr, &promise);
    napi_value thenFunc = nullptr;
    if (napi_get_named_property(env, promise, "then", &thenFunc) != napi_ok) {
        return;
    }
    napi_value resolvedCallback;
    napi_value rejectedCallback;
    napi_create_function(env, "resolvedCallback", NAPI_AUTO_LENGTH, ResolvedCallback, data, &resolvedCallback);
    napi_create_function(env, "rejectedCallback", NAPI_AUTO_LENGTH, RejectedCallback, data, &rejectedCallback);
    napi_value argv[2] = {resolvedCallback, rejectedCallback};
    napi_call_function(env, promise, thenFunc, INT_ARG_2, argv, nullptr);
}

// 任务执行完成后，进行资源清理回收
static void WorkComplete(napi_env env, napi_status status, void *data)
{
    CallbackData *callbackData = reinterpret_cast<CallbackData *>(data);
    napi_release_threadsafe_function(callbackData->tsfn, napi_tsfn_release);
    napi_delete_async_work(env, callbackData->work);
    callbackData->tsfn = nullptr;
    callbackData->work = nullptr;
}

static napi_value StartThread(napi_env env, napi_callback_info info)
{
    CallbackData *callbackData = new CallbackData();
    size_t argc = 1;
    napi_value jsCb = nullptr;
    napi_get_cb_info(env, info, &argc, &jsCb, nullptr, nullptr);

    // 创建一个线程安全函数
    napi_value resourceName = nullptr;
    napi_create_string_utf8(env, "Thread-safe Function Demo", NAPI_AUTO_LENGTH, &resourceName);
    napi_create_threadsafe_function(env, jsCb, nullptr, resourceName, 0, 1, callbackData, nullptr, callbackData, CallJs,
                                    &callbackData->tsfn);

    // 创建一个异步任务
    // ExecuteWork会执行在一个由libuv创建的非JS线程上
    // 此处使用napi_create_async_work是为了模拟在非JS线程场景使用napi_call_threadsafe_function接口向JS线程提交任务
    napi_create_async_work(env, nullptr, resourceName, ExecuteWork, WorkComplete, callbackData, &callbackData->work);

    // 将异步任务加入到异步队列中
    napi_queue_async_work(env, callbackData->work);
    return nullptr;
}
// [End napi_thread_safety_cpp]
// [EndExclude napi_call_threadsafe_function_cpp]

struct TsfnContext {
    napi_ref callbackRef;
};

struct ThreadData {
    std::string inputStr;
    napi_threadsafe_function tsfn;
};

// C++子线程
void NativeThread(void* arg)
{
    auto* data = static_cast<ThreadData*>(arg);
    OH_LOG_INFO(LOG_APP, "[C++ SubThread] Received from Worker: %{public}s\n", data->inputStr.c_str());
    std::string str = "Hello from C++!";
    std::string msg = "Echo of " + str;
    char* cstr = strdup(msg.c_str());
    napi_call_threadsafe_function(data->tsfn, cstr, napi_tsfn_nonblocking);
    napi_release_threadsafe_function(data->tsfn, napi_tsfn_release);
    delete data;
}

// 在 JS 线程中实际执行的回调
void CallJsCallback(napi_env env, napi_value jsCallback, void* context, void* data)
{
    if (data == nullptr) {
        return;
    }
    char* message = static_cast<char*>(data);
    napi_value jsStr;
    napi_create_string_utf8(env, message, NAPI_AUTO_LENGTH, &jsStr);
    napi_value global;
    napi_get_global(env, &global);
    napi_value result;
    napi_call_function(env, global, jsCallback, 1, &jsStr, &result);
    free(message);
}

// tsfn销毁时的清理回调
void TsfnFinalizeCallback(napi_env env, void* finalizeData, void* finalizeHint)
{
    TsfnContext* ctx = static_cast<TsfnContext*>(finalizeData);
    if (ctx && ctx->callbackRef) {
        napi_delete_reference(env, ctx->callbackRef);
        delete ctx;
    }
}

// ArkTS 调用的入口函数
napi_value StartWithCallback(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    size_t length = 0;
    napi_status status = napi_get_value_string_utf8(env, args[0], nullptr, 0, &length);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "napi_get_value_string_utf8 failed");
        return nullptr;
    }
    char* inputStr = new char[length + 1];
    std::fill(inputStr, inputStr + (length + 1), 0);
    status = napi_get_value_string_utf8(env, args[0], inputStr, length + 1, &length);
    if (status != napi_ok) {
        if (inputStr) {
            delete[] inputStr;
        }
        OH_LOG_ERROR(LOG_APP, "napi_get_value_string_utf8 failed");
        return nullptr;
    }
    std::string inputString(inputStr, length);
    delete[] inputStr;
    TsfnContext* ctx = new TsfnContext();
    napi_create_reference(env, args[1], 1, &ctx->callbackRef);
    napi_value resourceName;
    napi_create_string_utf8(env, "TSFN_WorkerToCpp", NAPI_AUTO_LENGTH, &resourceName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[1], nullptr, resourceName,
                                    0, 1, ctx, TsfnFinalizeCallback, nullptr, CallJsCallback, &tsfn);
    auto* threadData = new ThreadData{std::move(inputString), tsfn};
    std::thread nativethread(NativeThread, threadData);
    nativethread.detach();
    return nullptr;
}
// [End napi_call_threadsafe_function_cpp]


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"startThread", nullptr, StartThread, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startWithCallback", nullptr, StartWithCallback, nullptr, nullptr, nullptr, napi_default, nullptr}
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
    .nm_modname = "entry1",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }