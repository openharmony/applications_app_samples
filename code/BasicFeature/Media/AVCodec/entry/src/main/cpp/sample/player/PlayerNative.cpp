/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "PlayerNative.h"
#include "dfx/error/av_codec_sample_error.h"

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
            // 管理 napi_value 的生命周期，防止内存泄露
            napi_open_handle_scope(context->env, &scope);
            napi_value callback = nullptr;
            napi_get_reference_value(context->env, context->callbackRef, &callback);
            // 回调至UI侧
            napi_call_function(context->env, nullptr, callback, 0, nullptr, nullptr);
            napi_close_handle_scope(context->env, scope);
            delete context;
            delete work;
    });
}

napi_value PlayerNative::SetPlaybackSpeed(napi_env env, napi_callback_info info)
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
    size_t argc = 6;                    // 参数个数，这里ArkTS往native测传递了四个参数，故此处赋值为4
    napi_value args[6] = {nullptr};     // napi_value类型数组，用于存储接收的ArkTS侧参数
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);  // 从info中获取参数信息到参数数组args[]
    
    int index = 0;
    napi_get_value_int32(env, args[index++], &sampleInfo.inputFd);
    napi_get_value_int64(env, args[index++], &sampleInfo.inputFileOffset);
    napi_get_value_int64(env, args[index++], &sampleInfo.inputFileSize);
    napi_get_value_int32(env, args[index++], &sampleInfo.codecType);
    napi_get_value_int32(env, args[index++], &sampleInfo.codecRunMode);
    
    auto asyncContext = new CallbackContext();
    asyncContext->env = env;
    napi_create_reference(env, args[index], 1, &asyncContext->callbackRef);
    
    sampleInfo.playDoneCallback = &Callback;
    sampleInfo.playDoneCallbackData = asyncContext;
    int32_t ret = Player::GetInstance().Init(sampleInfo);
    if (ret == AVCODEC_SAMPLE_ERR_OK) {
        Player::GetInstance().Start();
    }
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor classProp[] = {
        {"playNative", nullptr, PlayerNative::Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPlaybackSpeed", nullptr, PlayerNative::SetPlaybackSpeed, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterPlayerModule(void)
{
    napi_module_register(&PlayerModule);
}