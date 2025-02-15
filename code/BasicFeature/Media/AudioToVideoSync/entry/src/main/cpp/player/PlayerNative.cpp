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

#include "PlayerNative.h"

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0xFF00
#define LOG_TAG "player"

struct CallbackContext {
    napi_env env = nullptr;
    napi_ref callbackRef = nullptr;
};

void Callback(void *asyncContext)
{
    uv_loop_s *loop = nullptr;
    CallbackContext *context = (CallbackContext *)asyncContext;
    napi_get_uv_event_loop(context->env, &loop);
    uv_work_t *work = new uv_work_t;
    work->data = context;
    uv_queue_work(
        loop, work, [](uv_work_t *work) {},
        [](uv_work_t *work, int status) {
            CallbackContext *context = (CallbackContext *)work->data;
            napi_handle_scope scope = nullptr;
            // manage napi_value lifeCycle，avoid memory leaks.
            napi_open_handle_scope(context->env, &scope);
            napi_value callback = nullptr;
            napi_get_reference_value(context->env, context->callbackRef, &callback);
            // callBack to UI side.
            napi_call_function(context->env, nullptr, callback, 0, nullptr, nullptr);
            napi_close_handle_scope(context->env, scope);
            delete context;
            delete work;
        });
}

napi_value PlayerNative::RatePlay(napi_env env, napi_callback_info info)
{
    double speed;
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_double(env, args[0], &speed);
    Player::GetInstance().SetSpeed(static_cast<float>(speed));
    return nullptr;
}

napi_value PlayerNative::Play(napi_env env, napi_callback_info info)
{
    SampleInfo sampleInfo;
    size_t argc = 4;  // 4 共四个参数
    napi_value args[4] = {nullptr};  // 4 共四个参数
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    napi_get_value_int32(env, args[0], &sampleInfo.inputFd);
    napi_get_value_int64(env, args[1], &sampleInfo.inputFileOffset);
    napi_get_value_int64(env, args[2], &sampleInfo.inputFileSize); // 2 第2个参数

    auto asyncContext = new CallbackContext();
    asyncContext->env = env;
    napi_create_reference(env, args[3], 1, &asyncContext->callbackRef); // 3 第三个参数

    sampleInfo.playDoneCallback = &Callback;
    sampleInfo.playDoneCallbackData = asyncContext;
    Player::GetInstance().Init(sampleInfo);
    Player::GetInstance().Start();
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {
        {"playNative", nullptr, PlayerNative::Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"ratePlay", nullptr, PlayerNative::RatePlay, nullptr},
    };

    NativeXComponentSample::PluginManager::GetInstance()->Export(env, exports);
    napi_define_properties(env, exports, sizeof(classProp) / sizeof(classProp[0]), classProp);
    return exports;
}
EXTERN_C_END

static napi_module PlayerModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "player",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterPlayerModule(void) { napi_module_register(&PlayerModule); }