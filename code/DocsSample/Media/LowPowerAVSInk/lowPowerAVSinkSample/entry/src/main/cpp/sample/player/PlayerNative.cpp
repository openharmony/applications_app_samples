/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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
#include <cstdint>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0xFF00
#define LOG_TAG "playerNative"

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
            delete work;
    });
}

napi_value PlayerNative::Play(napi_env env, napi_callback_info info)
{
    SampleInfo sampleInfo;
    size_t argc = 5;                    // 参数个数，这里ArkTS往native测传递了两个参数，故此处赋值为4
    napi_value args[5] = {nullptr};     // napi_value类型数组，用于存储接收的ArkTS侧参数
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);  // 从info中获取参数信息到参数数组args[]
    
    int32_t two = 2;
    int32_t three = 3;
    napi_get_value_int32(env, args[0], &sampleInfo.inputFd);
    napi_get_value_int64(env, args[1], &sampleInfo.inputFileOffset);
    napi_get_value_int64(env, args[two], &sampleInfo.inputFileSize);
    
    AVCODEC_SAMPLE_LOGI("inputFilePath %{public}s",sampleInfo.inputFilePath.c_str());
    AVCODEC_SAMPLE_LOGI("inputFilePath %{public}ld",sampleInfo.inputFileSize);
    
    auto asyncContext = new CallbackContext();
    asyncContext->env = env;
    napi_create_reference(env, args[three], 1, &asyncContext->callbackRef);
    
    sampleInfo.playDoneCallback = &Callback;
    sampleInfo.playDoneCallbackData = asyncContext;
    auto asyncContextB = new CallbackContext();
    asyncContextB->env = env;
    napi_create_reference(env, args[4], 1, &asyncContextB->callbackRef);
    sampleInfo.audioCallback = &Callback;
    sampleInfo.audioCallbackData = asyncContextB;
    int32_t ret = Player::GetInstance().Init(sampleInfo);
    return nullptr;
}

napi_value PlayerNative::Stop(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGD("NativeStop");
    Player::GetInstance().Stop();
    AVCODEC_SAMPLE_LOGD("NativeStop1");
    return nullptr;
}

napi_value PlayerNative::Release(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGD("NativeRelease in");
    Player::GetInstance().StartRelease();
    AVCODEC_SAMPLE_LOGD("NativeRelease out");
    return nullptr;
}

napi_value PlayerNative::Reset(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGD("resetNative in");
    Player::GetInstance().Reset();
    AVCODEC_SAMPLE_LOGD("resetNative out");
    return nullptr;
}

napi_value PlayerNative::Pause(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGD("PauseNative in");
    Player::GetInstance().Pause();
    AVCODEC_SAMPLE_LOGD("PauseNative out");
    return nullptr;
}

napi_value PlayerNative::Resume(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGD("ResumeNative in");
    Player::GetInstance().Resume();
    AVCODEC_SAMPLE_LOGD("ResumeNative out");
    return nullptr;
}

napi_value PlayerNative::Speed(napi_env env, napi_callback_info info)
{
    size_t argc = 1;                    
    napi_value args[1] = {nullptr};
    double speed = 1.0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_double(env, args[0], &speed);
    AVCODEC_SAMPLE_LOGD("ResumeNative in");
    Player::GetInstance().SetSpeed(speed);
    AVCODEC_SAMPLE_LOGD("ResumeNative out");
    return nullptr;
}

napi_value PlayerNative::SetSurface(napi_env env, napi_callback_info info)
{
    size_t argc = 1;                    
    napi_value args[1] = {nullptr};
    char surfaceId[30] = "";
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_string_utf8(env, args[0], surfaceId, 30, 0);
    char* endptr;
    int64_t value = std::strtoll(surfaceId, &endptr, 10);
    AVCODEC_SAMPLE_LOGD("SetSurface In %{public}ld %{public}s", value, surfaceId);
    Player::GetInstance().SetSurface(value);
    AVCODEC_SAMPLE_LOGD("SetSurface out");
    return nullptr;
}

napi_value PlayerNative::Seek(napi_env env, napi_callback_info info)
{
    int32_t seekTime = 0;
    int32_t mode = 0;
    bool acc = false;
    size_t seekArgc = 3;                    // 参数个数，这里ArkTS往native测传递了两个参数，故此处赋值为4
    napi_value seekArgs[3] = {nullptr};     // napi_value类型数组，用于存储接收的ArkTS侧参数
    napi_get_cb_info(env, info, &seekArgc, seekArgs, nullptr, nullptr);  // 从info中获取参数信息到参数数组args[]
    napi_get_value_int32(env, seekArgs[0], &seekTime);
    napi_get_value_int32(env, seekArgs[1], &mode);
    napi_get_value_bool(env, seekArgs[0], &acc);
    AVCODEC_SAMPLE_LOGI("Seek in");
    Player::GetInstance().Seek(seekTime, mode, acc);
    AVCODEC_SAMPLE_LOGI("Seek out");
    return nullptr;
}

napi_value PlayerNative::Prepare(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGI("Prepare in");
    napi_value result;
    int32_t ret = Player::GetInstance().Prepare();
    napi_create_int32(env, ret, &result);
    AVCODEC_SAMPLE_LOGI("Prepare out");
    return result;
}

napi_value PlayerNative::StartDecoder(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGI("StartDecoder in");
    Player::GetInstance().StartDecoder();
    AVCODEC_SAMPLE_LOGI("StartDecoder out");
    return nullptr;
}
napi_value PlayerNative::RenderFirstFrame(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGI("RenderFirstFrame in");
    Player::GetInstance().RenderFirstFrame();
    AVCODEC_SAMPLE_LOGI("RenderFirstFrame out");
    return nullptr;
}
napi_value PlayerNative::StartRender(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGI("StartRender in");
    Player::GetInstance().StartRender();
    AVCODEC_SAMPLE_LOGI("StartRender out");
    return nullptr;
}
napi_value PlayerNative::StartAudio(napi_env env, napi_callback_info info)
{
    AVCODEC_SAMPLE_LOGI("StartAudio in");
    Player::GetInstance().StartAudio();
    AVCODEC_SAMPLE_LOGI("StartAudio out");
    return nullptr;
}

napi_value PlayerNative::GetDurationTime(napi_env env, napi_callback_info info) {
    napi_value result;
    int64_t duration = Player::GetInstance().GetDurationTime();
    napi_create_int64(env, duration, &result);
    return result;
}

napi_value PlayerNative::GetProgressTime(napi_env env, napi_callback_info info) {
    napi_value result;
    int64_t progress = Player::GetInstance().GetProgressTime();
    napi_create_int64(env, progress, &result);
    return result;
}

napi_value PlayerNative::SetVolume(napi_env env, napi_callback_info info) {
    size_t argc = 1;                    
    napi_value args[1] = {nullptr};
    double volume = 0;
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_get_value_double(env, args[0], &volume);
    AVCODEC_SAMPLE_LOGD("SetVolume in");
    Player::GetInstance().SetVolume(volume);
    AVCODEC_SAMPLE_LOGD("SetVolume out");
    return nullptr;
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor classProp[] = {
        {"playNative", nullptr, PlayerNative::Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopNative", nullptr, PlayerNative::Stop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseNative", nullptr, PlayerNative::Release, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resetNative", nullptr, PlayerNative::Reset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pauseNative", nullptr, PlayerNative::Pause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"resumeNative", nullptr, PlayerNative::Resume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"speedNative", nullptr, PlayerNative::Speed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSurfaceNative", nullptr, PlayerNative::SetSurface, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"seekNative", nullptr, PlayerNative::Seek, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDurationTime", nullptr, PlayerNative::GetDurationTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getProgressTime", nullptr, PlayerNative::GetProgressTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"prepareNative", nullptr, PlayerNative::Prepare, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startDecoderNative", nullptr, PlayerNative::StartDecoder, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"renderFirstFrameNative", nullptr, PlayerNative::RenderFirstFrame, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"startRenderNative", nullptr, PlayerNative::StartRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"startAudioNative", nullptr, PlayerNative::StartAudio, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setVolumeNative", nullptr, PlayerNative::SetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
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