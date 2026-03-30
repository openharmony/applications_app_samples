/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <string>
#include <thread>
#include <fstream>
#include "napi/native_api.h"
#include "hilog/log.h"

#include "ohaudio/native_audiocapturer.h"
#include "ohaudio/native_audiorenderer.h"
#include "ohaudio/native_audiostreambuilder.h"
#include "ohaudio/native_audiostream_base.h"
#include "ohaudio/native_audio_manager.h"
#include "ohaudio/native_audio_common.h"
#include "ohaudio/native_audio_routing_manager.h"
#include "ohaudio/native_audio_session_manager.h"

#include <cmath>
#include <cstring>
#include <queue>

#include "NapiUtils.h"

const  static size_t ARGC_MAX = 6;
const static  int32_t SUCCESS = 0;
const static int32_t ERROR = 1;

static OH_AudioRenderer *g_audioRendererVoIP;
static OH_AudioCapturer *g_audioCapturerVoIP;
static OH_AudioSessionManager *g_audioSessionManager;
static std::queue<std::vector<uint8_t>> g_voip_capturer_buffers;
static std::mutex g_voip_capturer_buffer_mutex;

static bool g_isPlayMute = false;
static bool g_isRecordMute = false;

const static int32_t AUDIO_SAMPLINGRATE_VOIP = 16000;
const static int32_t AUDIO_CHANNELCOUNT_VOIP = 2;
const static int32_t AUDIO_CALLBACK_FRAME_SIZE_MS = 20;
const static int32_t LOG_LIMIT_TIME = 10;
const static int32_t MS_TO_S = 1000;

static int32_t AudioCapturerOnReadData(
    OH_AudioCapturer *capturer,
    void *userdata,
    void *buffer,
    int32_t length)
{
    OH_LOG_DEBUG(LOG_APP, "OnReadData: length=%{public}d", length);
    
    if (buffer == nullptr || length <= 0) {
        return 0;
    }
    
    // 复制数据到播放缓冲区
    std::vector<uint8_t> audioData(length);
    if (g_isRecordMute) {
        memset(audioData.data(), 0, length);
    } else {
        memcpy(audioData.data(), buffer, length);
    }
    
    {
        std::lock_guard<std::mutex> lock(g_voip_capturer_buffer_mutex);
        
        g_voip_capturer_buffers.push(std::move(audioData));
        
        // 每10次回调记录一次状态，避免日志过多
        static int logCount = 0;
        if (++logCount % LOG_LIMIT_TIME == 0) {
            OH_LOG_DEBUG(LOG_APP, "Recording progress: %{public}d bytes, queue: %{public}zu",
                         length, g_voip_capturer_buffers.size());
        }
    }
    
    return 0;
}

int g_fcount = 0;
static void WriteSinToBuffer(void *buffer, int32_t bufferLength)
{
    memset(buffer, 0, bufferLength);
    
    int32_t cycle = AUDIO_SAMPLINGRATE_VOIP / 445;
    
    const  int channels = AUDIO_CHANNELCOUNT_VOIP;
    const  int samples = bufferLength / channels / 2;
    int16_t *bufferPtr = reinterpret_cast<int16_t *>(buffer);
    int16_t bound = INT16_MAX >> 1;
    for (int idx = 0; idx < samples; idx++) {
        int16_t tmp = bound * sinf(2.0f * static_cast<float >(M_PI) *
                                   (static_cast<float >(g_fcount++ % cycle) / cycle));
        for (size_t ch = 0; ch < AUDIO_CHANNELCOUNT_VOIP; ch++) {
            bufferPtr[channels * idx + ch] = g_isPlayMute ? 0 : tmp;
        }
    }
}

static int32_t AudioRendererPlayerOnWriteData(OH_AudioRenderer *renderer, void *userData,
                                              void *buffer, int32_t bufferLen)
{
    WriteSinToBuffer(buffer, bufferLen);
    return 0;
}

static napi_value AudioRendererPlayerInitVoIP(napi_env env, napi_callback_info info)
{
    size_t argc = ARGC_MAX;
    napi_value argv[ARGC_MAX];
    napi_value self;
    napi_value value;
    napi_status status = napi_get_cb_info(env, info, &argc, argv, &self, nullptr);
    if (status != napi_ok || argc != 1) {
        NapiUtils::SetValueInt32(env, ERROR, value);
        return value;
    }
    int32_t number = 0;
    NapiUtils::GetValueInt32(env, number, argv[0]);
    OH_AudioStream_Usage streamUsage = static_cast<OH_AudioStream_Usage>(number);
    
    OH_AudioStreamBuilder *rendererBuilder = nullptr;
    if (g_audioRendererVoIP) {
        OH_AudioRenderer_Release(g_audioRendererVoIP);
        OH_AudioStreamBuilder_Destroy(rendererBuilder);
        g_audioRendererVoIP = nullptr;
        rendererBuilder = nullptr;
    }
    
    // create builder
    OH_AudioStreamBuilder_Create(&rendererBuilder, AUDIOSTREAM_TYPE_RENDERER);
    
    // set params and callbacks
    OH_AudioStreamBuilder_SetSamplingRate(rendererBuilder, AUDIO_SAMPLINGRATE_VOIP);
    OH_AudioStreamBuilder_SetChannelCount(rendererBuilder, AUDIO_CHANNELCOUNT_VOIP);
    OH_AudioStreamBuilder_SetSampleFormat(rendererBuilder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(rendererBuilder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetRendererInfo(rendererBuilder, streamUsage);
    OH_AudioStreamBuilder_SetFrameSizeInCallback(rendererBuilder,
                                                 AUDIO_CALLBACK_FRAME_SIZE_MS * AUDIO_SAMPLINGRATE_VOIP / MS_TO_S);
    
    OH_AudioRenderer_Callbacks rendererCallbacks;
    rendererCallbacks.OH_AudioRenderer_OnWriteData = AudioRendererPlayerOnWriteData;
    rendererCallbacks.OH_AudioRenderer_OnStreamEvent = nullptr;
    rendererCallbacks.OH_AudioRenderer_OnInterruptEvent = nullptr;
    rendererCallbacks.OH_AudioRenderer_OnError = nullptr;
    OH_AudioStreamBuilder_SetRendererCallback(rendererBuilder, rendererCallbacks, nullptr);
    
    // create OH_AudioRenderer
    OH_AudioStreamBuilder_GenerateRenderer(rendererBuilder, &g_audioRendererVoIP);
    OH_AudioStreamBuilder_Destroy(rendererBuilder);
    rendererBuilder = nullptr;
    g_isPlayMute = false;
    
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

static napi_value AudioRendererPlayerStartVoIP(napi_env env, napi_callback_info info)
{
    // start
    if (g_audioRendererVoIP != nullptr) {
        OH_AudioRenderer_Start(g_audioRendererVoIP);
    }
    return nullptr;
}

static napi_value AudioRendererPlayerPauseVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioRendererVoIP != nullptr) {
        OH_AudioRenderer_Pause(g_audioRendererVoIP);
    }
    return nullptr;
}

static napi_value AudioRendererPlayerMuteVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioRendererVoIP != nullptr) {
        g_isPlayMute = true;
        OH_LOG_INFO(LOG_APP, "AudioRendererPlayerMuteVoIP Mute");
    }
    return nullptr;
}

static napi_value AudioRendererPlayerUnMuteVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioRendererVoIP != nullptr) {
        g_isPlayMute = false;
        OH_LOG_INFO(LOG_APP, "AudioRendererPlayerUnMuteVoIP UnMute");
    }
    return nullptr;
}

static napi_value AudioRendererPlayerStopVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioRendererVoIP != nullptr) {
        OH_AudioRenderer_Stop(g_audioRendererVoIP);
    }
    return nullptr;
}

static napi_value AudioRendererPlayerReleaseVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioRendererVoIP != nullptr) {
        OH_AudioRenderer_Release(g_audioRendererVoIP);
        g_audioRendererVoIP = nullptr;
    }
    return nullptr;
}

static napi_value AudioCapturerInitVoIP(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "InitCapturerVoIP");
    
    // 如果已有录音，先释放
    OH_AudioStreamBuilder *capturerBuilder = nullptr;
    if (g_audioCapturerVoIP) {
        OH_AudioCapturer_Release(g_audioCapturerVoIP);
        OH_AudioStreamBuilder_Destroy(capturerBuilder);
        g_audioCapturerVoIP = nullptr;
        capturerBuilder = nullptr;
    }
    
    // 清空之前录音数据
    {
        std::lock_guard<std::mutex> lock(g_voip_capturer_buffer_mutex);
        while (!g_voip_capturer_buffers.empty()) {
            g_voip_capturer_buffers.pop();
        }
    }
    
    OH_AudioStreamBuilder_Create(&capturerBuilder, AUDIOSTREAM_TYPE_CAPTURER);
    OH_AudioStreamBuilder_SetSamplingRate(capturerBuilder, AUDIO_SAMPLINGRATE_VOIP);
    OH_AudioStreamBuilder_SetChannelCount(capturerBuilder, AUDIO_CHANNELCOUNT_VOIP);
    OH_AudioStreamBuilder_SetSampleFormat(capturerBuilder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(capturerBuilder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(capturerBuilder, AUDIOSTREAM_SOURCE_TYPE_VOICE_COMMUNICATION);

    // 设置回调
    OH_AudioCapturer_Callbacks capturerCallbacks;
    capturerCallbacks.OH_AudioCapturer_OnReadData = AudioCapturerOnReadData;
    capturerCallbacks.OH_AudioCapturer_OnStreamEvent = nullptr;
    capturerCallbacks.OH_AudioCapturer_OnInterruptEvent = nullptr;
    capturerCallbacks.OH_AudioCapturer_OnError = nullptr;

    OH_AudioStreamBuilder_SetCapturerCallback(capturerBuilder, capturerCallbacks, nullptr);

    OH_AudioStreamBuilder_GenerateCapturer(capturerBuilder, &g_audioCapturerVoIP);
    OH_AudioStreamBuilder_Destroy(capturerBuilder);
    capturerBuilder = nullptr;
    g_isRecordMute = false;

return nullptr;
}

static napi_value AudioCapturerStartVoIP(napi_env env, napi_callback_info info)
{
    // start
    if (g_audioCapturerVoIP != nullptr) {
        OH_AudioCapturer_Start(g_audioCapturerVoIP);
    }
    return nullptr;
}

static napi_value AudioCapturerPauseVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioCapturerVoIP != nullptr) {
        OH_AudioCapturer_Pause(g_audioCapturerVoIP);
    }
    return nullptr;
}

static napi_value AudioCapturerMuteVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioCapturerVoIP != nullptr) {
        g_isRecordMute = true;
        OH_LOG_INFO(LOG_APP, "AudioCapturerMuteVoIP Mute");
    }
    return nullptr;
}

static napi_value AudioCapturerUnMuteVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioCapturerVoIP != nullptr) {
        g_isRecordMute = false;
        OH_LOG_INFO(LOG_APP, "AudioCapturerUnMuteVoIP UnMute");
    }
    return nullptr;
}

static napi_value AudioCapturerStopVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioCapturerVoIP != nullptr) {
        OH_AudioCapturer_Stop(g_audioCapturerVoIP);
    }
    return nullptr;
}

static napi_value AudioCapturerReleaseVoIP(napi_env env, napi_callback_info info)
{
    if (g_audioCapturerVoIP != nullptr) {
        OH_AudioCapturer_Release(g_audioCapturerVoIP);
        g_audioCapturerVoIP = nullptr;
    }
    return nullptr;
}

void AudioSessionStateChangedCallback(OH_AudioSession_StateChangedEvent event)
{
    switch (event.stateChangeHint) {
        case AUDIO_SESSION_STATE_CHANGE_HINT_PAUSE:
            if (g_audioCapturerVoIP) {
                OH_AudioCapturer_Pause(g_audioCapturerVoIP);
                OH_AudioCapturer_Stop(g_audioCapturerVoIP);
            }
            if (g_audioRendererVoIP) {
                OH_AudioRenderer_Pause(g_audioRendererVoIP);
                OH_AudioRenderer_Stop(g_audioRendererVoIP);
            }
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_RESUME:
            if (g_audioCapturerVoIP) {
                OH_AudioCapturer_Start(g_audioCapturerVoIP);
            }
            if (g_audioRendererVoIP) {
                OH_AudioRenderer_Start(g_audioRendererVoIP);
            }
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_STOP:
            if (g_audioCapturerVoIP) {
                OH_AudioCapturer_Stop(g_audioCapturerVoIP);
            }
            if (g_audioRendererVoIP) {
                OH_AudioRenderer_Stop(g_audioRendererVoIP);
            }
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_TIME_OUT_STOP:
            // 此分支表示由于长时间没有音频流播放，为防止系统资源被长时间无效占用，系统已将AudioSession停止（永久失去焦点），为保持状态一致，应用需切换至音频暂停状态。
            // 永久失去焦点：后续不会再收到任何音频焦点事件，若想恢复播放，需要用户主动触发。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_DUCK:
            // 此分支表示系统已将音频音量降低（默认降到正常音量的20%）。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_UNDUCK:
            // 此分支表示系统已将音频音量恢复正常。
            break;
        default:
            break;
    }
}

static napi_value ActivateAudioSessionVoIP(napi_env env, napi_callback_info info)
{
    napi_value value;
    
    OH_AudioCommon_Result result = OH_AudioManager_GetAudioSessionManager(&g_audioSessionManager);
    if (result != AUDIOCOMMON_RESULT_SUCCESS || g_audioSessionManager == nullptr) {
        NapiUtils::SetValueInt32(env, result, value);
        OH_LOG_INFO(LOG_APP, "GetAudioSessionManager failed");
        return value;
    }
    
    result = OH_AudioSessionManager_RegisterStateChangeCallback(g_audioSessionManager,
                                                                AudioSessionStateChangedCallback);
    if (result != AUDIOCOMMON_RESULT_SUCCESS) {
        NapiUtils::SetValueInt32(env, result, value);
        return value;
    }
    
    OH_AudioSessionManager_SetScene(g_audioSessionManager, AUDIO_SESSION_SCENE_VOICE_COMMUNICATION);
    OH_AudioSession_Strategy strategy = {CONCURRENCY_DEFAULT};
    result = OH_AudioSessionManager_ActivateAudioSession(g_audioSessionManager, &strategy);
    if (result != AUDIOCOMMON_RESULT_SUCCESS) {
        NapiUtils::SetValueInt32(env, result, value);
        return value;
    }
    
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

static napi_value DeActivateAudioSessionVoIP(napi_env env, napi_callback_info info)
{
    napi_value value;
    OH_AudioCommon_Result result;
    if (g_audioSessionManager != nullptr) {
        result = OH_AudioSessionManager_DeactivateAudioSession(g_audioSessionManager);
        if (result != AUDIOCOMMON_RESULT_SUCCESS) {
            NapiUtils::SetValueInt32(env, result, value);
            return value;
        }
        result = OH_AudioSessionManager_UnregisterStateChangeCallback(g_audioSessionManager,
                                                                      AudioSessionStateChangedCallback);
        if (result != AUDIOCOMMON_RESULT_SUCCESS) {
            NapiUtils::SetValueInt32(env, result, value);
            return value;
        }
    }
    NapiUtils::SetValueInt32(env, SUCCESS, value);
    return value;
}

EXTERN_C_START static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"activateAudioSessionVoIP", nullptr, ActivateAudioSessionVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deActivateAudioSessionVoIP", nullptr, DeActivateAudioSessionVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerInitVoIP", nullptr, AudioRendererPlayerInitVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerStartVoIP", nullptr, AudioRendererPlayerStartVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerPauseVoIP", nullptr, AudioRendererPlayerPauseVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerStopVoIP", nullptr, AudioRendererPlayerStopVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerReleaseVoIP", nullptr, AudioRendererPlayerReleaseVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerMuteVoIP", nullptr, AudioRendererPlayerMuteVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioRendererPlayerUnMuteVoIP", nullptr, AudioRendererPlayerUnMuteVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerInitVoIP", nullptr, AudioCapturerInitVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerStartVoIP", nullptr, AudioCapturerStartVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerPauseVoIP", nullptr, AudioCapturerPauseVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerStopVoIP", nullptr, AudioCapturerStopVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerReleaseVoIP", nullptr, AudioCapturerReleaseVoIP,
            nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerMuteVoIP", nullptr, AudioCapturerMuteVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"audioCapturerUnMuteVoIP", nullptr, AudioCapturerUnMuteVoIP, nullptr, nullptr, nullptr, napi_default, nullptr},
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
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}