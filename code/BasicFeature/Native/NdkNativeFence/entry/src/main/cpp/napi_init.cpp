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
#include <native_fence/native_fence.h>

#include <chrono>
#include <cstring>
#include <cerrno>
#include <fcntl.h>
#include <iostream>
#include <linux/sync_file.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/signalfd.h>
#include <thread>
#include <unistd.h>
#include "common/log_common.h"

constexpr int INVALID_FD = -1;
constexpr uint32_t TIMEOUT_MS = 5000;

static napi_value Add(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};

    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);

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

static napi_value SyncFenceWait(napi_env env, napi_callback_info info)
{
    bool result = OH_NativeFence_Wait(INVALID_FD, TIMEOUT_MS);
    DRAWING_LOGI("get result %{public}d", result);
    bool isValid = OH_NativeFence_IsValid(INVALID_FD);
    DRAWING_LOGI("input fenceFd is:  %{public}d", isValid);

    std::atomic<bool> signaled(false);
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGINT); // Monitor SIGINT signal (Ctrl C)
    sigaddset(&mask, SIGTERM); // Monitor SIGTERM signal (kill command)
    sigprocmask(SIG_BLOCK, &mask, NULL);
    int sfd = signalfd(-1, &mask, 0);
    DRAWING_LOGI("input fenceFd is:  %{public}d", sfd);
    if (sfd == -1) {
        perror("signalfd failed");
        exit(1);
    }
    isValid = OH_NativeFence_IsValid(sfd);
    DRAWING_LOGI("input fenceFd is:  %{public}d", isValid);
    std::thread waitThread([&]() {
        bool result2 = false;
        auto startTime = std::chrono::steady_clock::now();
        result2 = OH_NativeFence_Wait(sfd, TIMEOUT_MS);
        auto endTime = std::chrono::steady_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();
        DRAWING_LOGI("get result2 %{public}d,   cost_time: %{public}d", result2, duration);
        signaled.store(true);
    });
    std::this_thread::sleep_for(std::chrono::seconds(3)); // 3 means main thread sleep 3 seconds.
    pid_t target_pid = getpid();
    int ret = kill(target_pid, SIGINT);
    if (ret < 0) {
        DRAWING_LOGI("kill failed: %{public}d", strerror(errno));
    }
    // Waiting for waitThread to complete
    waitThread.join();
    // checks the signaled variable to ensure that OH_NativeFence_Wait has returned
    DRAWING_LOGI("get signaled.load() %{public}d", signaled.load());
    OH_NativeFence_Close(sfd);
}

static napi_value SyncFenceWaitForever(napi_env env, napi_callback_info info)
{
    bool result = OH_NativeFence_WaitForever(INVALID_FD);
    DRAWING_LOGI("get result %{public}d", result);

    std::atomic<bool> signaled(false);
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, SIGINT); // Monitor SIGINT signal (Ctrl C)
    sigaddset(&mask, SIGTERM); // Monitor SIGTERM signal (kill command)
    sigprocmask(SIG_BLOCK, &mask, NULL);
    int sfd = signalfd(-1, &mask, 0);
    if (sfd == -1) {
        perror("signalfd failed");
        exit(1);
    }
    std::thread waitThread([&]() {
        bool result2 = false;
        auto startTime = std::chrono::steady_clock::now();
        result2 = OH_NativeFence_WaitForever(sfd);
        auto endTime = std::chrono::steady_clock::now();
        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();
        DRAWING_LOGI("get result2 %{public}d,   cost_time: %{public}d", result2, duration);
        signaled.store(true);
    });
    std::this_thread::sleep_for(std::chrono::seconds(3)); // 3 means main thread sleep 3 seconds.
    pid_t target_pid = getpid();
    int ret = kill(target_pid, SIGINT);
    if (ret < 0) {
        DRAWING_LOGI("kill failed: %{public}d", strerror(errno));
    }
    // Waiting for waitThread to complete
    waitThread.join();
    // checks the signaled variable to ensure that OH_NativeFence_Wait has returned
    DRAWING_LOGI("get signaled.load() %{public}d", signaled.load());
    OH_NativeFence_Close(sfd);
}

// EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "add", nullptr, Add, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "syncFence_wait", nullptr, SyncFenceWait, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "syncFence_waitForever", nullptr, SyncFenceWaitForever, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
// EXTERN_C_END

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