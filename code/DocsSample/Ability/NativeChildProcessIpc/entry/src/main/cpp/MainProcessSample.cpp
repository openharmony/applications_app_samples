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

// [Start main_processIpc_launch_native_child]
// [Start main_handle_child_start_callback]
#include <IPCKit/ipc_kit.h>
#include "AbilityKit/native_child_process.h"
// [StartExclude main_handle_child_start_callback]
// [StartExclude main_processIpc_launch_native_child]
#include "IpcProxy.h"
#include <cstdint>
#include <hilog/log.h>
#include <future>
#include <thread>
#include <mutex>
#include <deque>
#include "napi/native_api.h"
#include "ChildProcess.h"
#include "loghelper.h"

static ChildProcess g_childProcess;
static IpcProxy *g_ipcProxyPnt = nullptr;
static std::vector<IpcProxy *> g_ipcProxyPntObjects;
static std::promise<int> *g_promiseStartProcess = nullptr;
int32_t g_result = -1;

extern "C" {
OHIPCRemoteStub *NativeChildProcess_OnConnect()
{
    OH_LOG_INFO(LOG_APP, "Child process - OnConnect");
    return g_childProcess.GetIpcStub();
}

void NativeChildProcessMainProc()
{
    OH_LOG_INFO(LOG_APP, "Child process - MainProc started");
    g_childProcess.MainProc();
    OH_LOG_INFO(LOG_APP, "Child process - MainProc end");
}

} // extern "C"

class ArkTsThread {
    std::thread thread_;
    napi_env env;
    napi_ref on_message_func;
    std::condition_variable cond;
    std::mutex lock;
    std::deque<std::function<void()>> jobs;
    bool stopFlag = false;

public:
    ArkTsThread();
    ~ArkTsThread();
    void CallFunc();
};

ArkTsThread::ArkTsThread()
{
    auto waiter = std::promise<bool>();
    this->thread_ = std::thread([&]() {
        napi_create_ark_runtime(&this->env);
        auto env = this->env;

        napi_value worker_utils;
        napi_load_module_with_info(env, "entry/src/main/ets/pages/worker", "com.example.capichildprocesstest/entry",
                                   &worker_utils);
        napi_value on_message_func;
        auto ret = napi_get_named_property(env, worker_utils, "onMessage", &on_message_func);
        napi_create_reference(env, on_message_func, 1, &this->on_message_func);
        waiter.set_value(true);

        while (!stopFlag) {
            auto l = std::unique_lock<std::mutex>(this->lock);
            cond.wait(l, [this] { return stopFlag; });
            for (const auto job : this->jobs) {
                job();
            }
            this->jobs.clear();
        }
        napi_destroy_ark_runtime(&this->env);
    });
    waiter.get_future().wait();
}

ArkTsThread::~ArkTsThread()
{
    {
        auto l = std::unique_lock<std::mutex>(this->lock);
        stopFlag = true;
    }
    cond.notify_all();
    if (this->thread_.joinable()) {
        this->thread_.join();
    }
}

void ArkTsThread::CallFunc()
{
    auto l = std::unique_lock<std::mutex>(this->lock);
    this->jobs.push_back([this]() {
        napi_value on_message_func;
        napi_get_reference_value(this->env, this->on_message_func, &on_message_func);
        napi_value ret;
        napi_call_function(this->env, nullptr, on_message_func, 0, nullptr, &ret);
    });
    this->cond.notify_all();
}

namespace {
    ArkTsThread *g_thread;
}
// [EndExclude main_processIpc_launch_native_child]
// [EndExclude main_handle_child_start_callback]
static void OnNativeChildProcessStarted(int errCode, OHIPCRemoteProxy *remoteProxy)
{
    if (errCode != NCP_NO_ERROR) {
        // 子进程未能正常启动时的异常处理
        // ...
        return;
    }

    // 保存remoteProxy对象，后续基于IPC Kit提供的API同子进程间进行IPC通信
    // 耗时操作建议转移到独立线程去处理，避免长时间阻塞回调线程
    // IPC对象使用完毕后，需要调用OH_IPCRemoteProxy_Destroy方法释放
    // [StartExclude main_handle_child_start_callback]
    // [StartExclude main_processIpc_launch_native_child]
    OH_LOG_INFO(LOG_APP, "Main process - OnNativeChildProcessStarted %{public}d", errCode);
    g_ipcProxyPnt = new (std::nothrow) IpcProxy(remoteProxy);
    if (g_ipcProxyPnt == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Main process - Alloc ipc proxy object failed!");
        OH_IPCRemoteProxy_Destroy(remoteProxy);
    } else {
        g_ipcProxyPntObjects.push_back(g_ipcProxyPnt);
    }

    if (g_promiseStartProcess != nullptr) {
        g_promiseStartProcess->set_value(errCode);
    }
    // [EndExclude main_processIpc_launch_native_child]
    // [EndExclude main_handle_child_start_callback]
}
// [End main_handle_child_start_callback]

void CreateNativeChildProcess()
{
    // 第一个参数"libchildprocesssample.so"为实现了子进程必要导出方法的动态库文件名称
    int32_t ret = OH_Ability_CreateNativeChildProcess("libchildprocesssample.so", OnNativeChildProcessStarted);
    if (ret != NCP_NO_ERROR) {
        // 子进程未能正常启动时的异常处理
        // ...
    }
    g_result = ret;
}
// [End main_processIpc_launch_native_child]

static napi_value TestChildProcess(napi_env env, napi_callback_info info)
{
    CreateNativeChildProcess();
    napi_value napiRet;
    napi_create_int32(env, g_result, &napiRet);
    return napiRet;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"testChildProcess", nullptr, TestChildProcess, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "mainprocesssample",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
