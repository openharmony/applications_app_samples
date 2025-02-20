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

#include <hilog/log.h>
#include <string>
#include <malloc.h>
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
    if (wrapper == nullptr) {
        //处理内存分配失败的情况
        return;
    }
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
        //处理内存分配失败的情况
        return nullptr;
    }
    wrapper->data = static_cast<char *>(malloc(str.size()));
    strcpy(wrapper->data, str.c_str());
    wrapper->size = str.size();
    // 创建外部缓冲区对象，并指定清理回调函数
    napi_value buffer = nullptr;
    napi_create_external_buffer(env, wrapper->size, (void *)wrapper->data, ExternalFinalize, wrapper, &buffer);
    // 静态变量作为钩子函数参数
    static int hookArg = 42;
    static int hookParameter = 1;
    // 注册环境清理钩子函数
    napi_status status = napi_add_env_cleanup_hook(env, Cleanup, &hookArg);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Test Node-API napi_add_env_cleanup_hook failed.");
        return nullptr;
    }
    // 注册环境清理钩子函数，此处不移除环境清理钩子，为了在Java环境被销毁时，这个钩子函数被调用，用来模拟执行一些清理操作，例如释放资源、关闭文件等。
    status = napi_add_env_cleanup_hook(env, Cleanup, &hookParameter);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Test Node-API napi_add_env_cleanup_hook failed.");
        return nullptr;
    }
    // 立即移除环境清理钩子函数，确保不会在后续环境清理时被调用
    // 通常，当为其添加此钩子的资源无论如何都被拆除时调用这个接口
    napi_remove_env_cleanup_hook(env, Cleanup, &hookArg);
    // 返回创建的外部缓冲区对象
    return buffer;
}

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
    if (asyncData->testData != nullptr) {
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
    if (data == nullptr) {
        //处理内存分配失败的情况
        return nullptr;
    }
    data->env = env;
    data->cleanupHandle = nullptr;
    // 分配内存并复制字符串数据
    const char *testDataStr = "TestNapiAsyncCleanUpHook";
    data->testData = strdup(testDataStr);
    if (data->testData == nullptr) {
        napi_throw_error(env, nullptr, "Test Node-API data->testData is nullptr");
    }
    // 添加异步清理钩子函数
    napi_status status = napi_add_async_cleanup_hook(env, AsyncCleanup, data, &data->cleanupHandle);
    if (status != napi_ok) {
        napi_throw_error(env, nullptr, "Test Node-API napi_add_async_cleanup_hook failed");
    }
    napi_value result = nullptr;
    napi_get_boolean(env, true, &result);
    return result;
}

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
