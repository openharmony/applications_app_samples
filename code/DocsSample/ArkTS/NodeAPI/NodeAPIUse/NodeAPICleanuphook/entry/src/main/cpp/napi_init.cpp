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

// [Start napi_remove_add_env_cleanup_hook]
#include <hilog/log.h>
#include <string>
#include "napi/native_api.h"
#include "uv.h"

// 定义内存结构，包含指向数据的指针和数据的大小
typedef struct {
    char *data;
    size_t size;
} Memory;

// 外部缓冲区清理回调函数，用于释放分配的内存
void ExternalFinalize(napi_env env, void *finalizeData, void *finalizeHint)
{
    Memory *wrapper = (Memory *)finalizeHint;
    // [StartExclude napi_remove_add_env_cleanup_hook]
    if (wrapper == nullptr) {
        //处理内存分配失败的情况
        return;
    }
    // [EndExclude napi_remove_add_env_cleanup_hook]
    free(wrapper->data);
    free(wrapper);
    OH_LOG_INFO(LOG_APP, "Node-API napi_add_env_cleanup_hook ExternalFinalize");
}

// 在环境关闭时执行一些清理操作，如清理全局变量或其他需要在环境关闭时处理的资源
static void Cleanup(void *arg)
{
    // 执行清理操作
    OH_LOG_INFO(LOG_APP, "Node-API napi_add_env_cleanup_hook cleanuped: %{public}d", *(int *)(arg));
}

// 创建外部缓冲区并注册环境清理钩子函数
static napi_value NapiEnvCleanUpHook(napi_env env, napi_callback_info info)
{
    // 分配内存并复制字符串数据到内存中
    std::string str("Hello from Node-API!");
    Memory *wrapper = (Memory *)malloc(sizeof(Memory));
    if (wrapper == nullptr) {
        OH_LOG_ERROR(LOG_APP, "malloc for wrapper failed");
        return nullptr;
    }
    wrapper->data = static_cast<char *>(malloc(str.size() + 1));
    if (wrapper->data == nullptr) {
        free(wrapper);
        OH_LOG_ERROR(LOG_APP, "malloc for wrapper->data failed");
        return nullptr;
    }
    std::copy_n(str.c_str(), str.size() + 1, wrapper->data);
    wrapper->size = str.size();
    // 创建外部缓冲区对象，并指定清理回调函数
    // 注意：wrapper->data 的内存释放依赖于 ExternalFinalize 回调，只有 buffer 被正确持有并最终被 GC 回收时，ExternalFinalize 才会被调用，否则会导致内存泄漏。
    napi_value buffer = nullptr;
    napi_status status = napi_create_external_buffer(env, wrapper->size, (void *)wrapper->data,
                                                     ExternalFinalize, wrapper, &buffer);
    if (status != napi_ok) {
        // 创建失败时需主动释放内存，避免泄漏
        free(wrapper->data);
        free(wrapper);
        OH_LOG_ERROR(LOG_APP, "napi_create_external_buffer failed.");
        return nullptr;
    }
    // 静态变量作为钩子函数参数
    static int hookArg = 42;
    static int hookParameter = 1;
    // 注册环境清理钩子函数
    status = napi_add_env_cleanup_hook(env, Cleanup, &hookArg);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Test Node-API napi_add_env_cleanup_hook failed.");
        return nullptr;
    }
    // 注册环境清理钩子函数，此处不移除环境清理钩子，为了在ArkTS环境被销毁时，这个钩子函数被调用，用来模拟执行一些清理操作，例如释放资源、关闭文件等。
    status = napi_add_env_cleanup_hook(env, Cleanup, &hookParameter);
    if (status != napi_ok) {
        OH_LOG_ERROR(LOG_APP, "Test Node-API napi_add_env_cleanup_hook failed.");
        return nullptr;
    }
    // 立即移除环境清理钩子函数，确保不会在后续环境清理时被调用
    // 不需要此钩子函数时可以将其移除。如果希望钩子在环境退出时执行，不需要移除。
    napi_remove_env_cleanup_hook(env, Cleanup, &hookArg);
    napi_remove_env_cleanup_hook(env, Cleanup, &hookParameter);
    // 返回创建的外部缓冲区对象
    return buffer;
}
// [End napi_remove_add_env_cleanup_hook]

// [Start napi_add_remove_async_cleanup_hook]
typedef struct {
    napi_env env;
    void *testData;
    uv_async_s asyncUv;
    napi_async_cleanup_hook_handle cleanupHandle;
} AsyncContent;

// 删除异步工作对象并注销钩子函数
static void FinalizeWork(uv_handle_s *handle)
{
    AsyncContent *asyncData = reinterpret_cast<AsyncContent *>(handle->data);
    // 不再需要异步清理钩子函数的情况下，尝试将其从环境中移除
    napi_status result = napi_remove_async_cleanup_hook(asyncData->cleanupHandle);
    if (result != napi_ok) {
        napi_throw_error(asyncData->env, nullptr, "Test Node-API napi_remove_async_cleanup_hook failed");
    }
    // 释放AsyncContent
    free(asyncData);
}

// 异步执行环境清理工作
static void AsyncWork(uv_async_s *async)
{
    // 执行一些清理工作,比如释放动态分配的内存
    AsyncContent *asyncData = reinterpret_cast<AsyncContent *>(async->data);
    if (asyncData != nullptr && asyncData->testData != nullptr) {
        free(asyncData->testData);
        asyncData->testData = nullptr;
    }
    // 关闭libuv句柄，并触发FinalizeWork回调清理
    uv_close((uv_handle_s *)async, FinalizeWork);
}

// 异步清理钩子函数，创建异步工作对象并执行
static void AsyncCleanup(napi_async_cleanup_hook_handle handle, void *info)
{
    AsyncContent *data = reinterpret_cast<AsyncContent *>(info);
    // 获取libUv循环实例并初始化一个异步句柄，以便后续执行异步工作
    uv_loop_s *uvLoop;
    napi_get_uv_event_loop(data->env, &uvLoop);
    uv_async_init(uvLoop, &data->asyncUv, AsyncWork);

    data->asyncUv.data = data;
    data->cleanupHandle = handle;
    // 发送异步信号触发AsyncWork函数执行清理工作
    uv_async_send(&data->asyncUv);
}

static napi_value NapiAsyncCleanUpHook(napi_env env, napi_callback_info info)
{
    // 分配AsyncContent内存
    AsyncContent *data = reinterpret_cast<AsyncContent *>(malloc(sizeof(AsyncContent)));
    // StartExclude napi_add_remove_async_cleanup_hook]
    if (data == nullptr) {
        napi_throw_error(env, nullptr, "Test Node-API malloc AsyncContent failed");
        return nullptr;
    }
    // [EndExclude napi_add_remove_async_cleanup_hook]
    data->env = env;
    data->cleanupHandle = nullptr;
    // 分配内存并复制字符串数据
    const char *testDataStr = "TestNapiAsyncCleanUpHook";
    data->testData = strdup(testDataStr);
    if (data->testData == nullptr) {
        free(data);
        napi_throw_error(env, nullptr, "Test Node-API data->testData is nullptr");
        return nullptr;
    }
    // 添加异步清理钩子函数
    napi_status status = napi_add_async_cleanup_hook(env, AsyncCleanup, data, &data->cleanupHandle);
    if (status != napi_ok) {
        free(data->testData);
        free(data);
        napi_throw_error(env, nullptr, "Test Node-API napi_add_async_cleanup_hook failed");
        return nullptr;
    }
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}
// [End napi_add_remove_async_cleanup_hook]

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"napiEnvCleanUpHook", nullptr, NapiEnvCleanUpHook, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"napiAsyncCleanUpHook", nullptr, NapiAsyncCleanUpHook, nullptr, nullptr, nullptr, napi_default, nullptr}};
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
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }