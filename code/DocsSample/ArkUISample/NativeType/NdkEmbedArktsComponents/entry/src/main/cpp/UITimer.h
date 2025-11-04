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
// [Start ui_timer]
// UITimer.h
// 定时器模块。

#ifndef MYAPPLICATION_UITIMER_H
#define MYAPPLICATION_UITIMER_H

#include <hilog/log.h>
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <node_api.h>
#include <node_api_types.h>
#include <string>
#include <thread>
#include <uv.h>

namespace NativeModule {

struct UIData {
    void *userData = nullptr;
    int32_t count = 0;
    int32_t totalCount = 0;
    void (*func)(void *userData, int32_t count) = nullptr;
};

napi_threadsafe_function threadSafeFunction = nullptr;

void CreateNativeTimer(napi_env env, void *userData, int32_t totalCount, void (*func)(void *userData, int32_t count))
{
    napi_value name;
    std::string str = "UICallback";
    napi_create_string_utf8(env, str.c_str(), str.size(), &name);
    // UI主线程回调函数。
    napi_create_threadsafe_function(
        env, nullptr, nullptr, name, 0, 1, nullptr, nullptr, nullptr,
        [](napi_env env, napi_value value, void *context, void *data) {
            auto userdata = reinterpret_cast<UIData *>(data);
            userdata->func(userdata->userData, userdata->count);
            delete userdata;
        },
        &threadSafeFunction);
    // 启动定时器，模拟数据变化。
    std::thread timerThread([data = userData, totalCount, func]() {
        uv_loop_t *loop = uv_loop_new();
        uv_timer_t *timer = new uv_timer_t();
        uv_timer_init(loop, timer);
        timer->data = new UIData{data, 0, totalCount, func};
        uint64_t timeout = 4000;
        uint64_t repeat = 4000;
        uv_timer_start(
            timer,
            [](uv_timer_t *handle) {
                OH_LOG_INFO(LOG_APP, "on timeout");
                napi_acquire_threadsafe_function(threadSafeFunction);
                auto *customData = reinterpret_cast<UIData *>(handle->data);
                // 创建回调数据。
                auto *callbackData =
                    new UIData{customData->userData, customData->count, customData->totalCount, customData->func};
                napi_call_threadsafe_function(threadSafeFunction, callbackData, napi_tsfn_blocking);
                customData->count++;
                if (customData->count > customData->totalCount) {
                    uv_timer_stop(handle);
                    delete handle;
                    delete customData;
                }
            },
            timeout, repeat);
        uv_run(loop, UV_RUN_DEFAULT);
        uv_loop_delete(loop);
    });
    timerThread.detach();
}
} // namespace NativeModule

#endif // MYAPPLICATION_UITIMER_H
// [End ui_timer]