/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

#include "hilog/log.h"
#include "napi/native_api.h"
#include "ohaudio/native_audiocapturer.h"
#include "ohaudio/native_audiorenderer.h"
#include "ohaudio/native_audiostreambuilder.h"
#include <sstream>
#include <vector>
// [Start print_session_info]
#include "ohaudio/native_audio_debugging_manager.h"
// [StartExclude print_session_info]

// [Start csessionactive_process]
#include <cstdint>
// [Start cimport_h]
#include "ohaudio/native_audio_session_manager.h"
// [StartExclude csessionactive_process]
// [End cimport_h]

class Var {
public:
    const int globalResmgr = 0xFF00;
    std::vector<OH_AudioStreamBuilder *> rendererBuilders;
    std::vector<OH_AudioStreamBuilder *> capturerBuilders;
    std::vector<OH_AudioRenderer *> renderer;
    std::vector<OH_AudioCapturer *> capturer;
    std::vector<bool> isStart;
};

const char *SESSION_TAG = "AudioSession";
Var *g_audioSessionVariable = new Var();
// [Start cint_deacticatedcallback]
// [EndExclude csessionactive_process]
int32_t MyAudioSessionDeactivatedCallback(OH_AudioSession_DeactivatedEvent event)
{
    switch (event.reason) {
        case DEACTIVATED_LOWER_PRIORITY:
          // 应用焦点被抢占。
            return 0;
        case DEACTIVATED_TIMEOUT:
          // 超时。
            return 0;
    }
}

// [Start cget_sessionmanager]
// [Start clistencallback_process]
// [EndExclude print_session_info]
OH_AudioSessionManager *audioSessionManager;
// [StartExclude cget_sessionmanager]
// [StartExclude csessionactive_process]
// [End cint_deacticatedcallback]
// [StartExclude print_session_info]

void AudioSessionStateChangedCallback(OH_AudioSession_StateChangedEvent event)
{
    switch (event.stateChangeHint) {
        case AUDIO_SESSION_STATE_CHANGE_HINT_PAUSE:
          // 此分支表示系统已将音频流暂停（临时失去焦点），为保持状态一致，应用需切换至音频暂停状态。
          // 临时失去焦点：其他音频流释放音频焦点后，本音频流会收到resume事件，可继续播放。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_RESUME:
          // 此分支表示系统解除对AudioSession焦点的暂停操作。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_STOP:
          // 此分支表示系统已将音频流停止（永久失去焦点），为保持状态一致，应用需切换至音频暂停状态。
          // 永久失去焦点：后续不会再收到任何音频焦点事件，若想恢复播放，需要用户主动触发。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_TIME_OUT_STOP:
          // 此分支表示由于长时间没有音频流播放，为防止系统资源被长时间无效占用，系统已将AudioSession停止（永久失去焦点），
          // 为保持状态一致，应用需切换至音频暂停状态。
          // 永久失去焦点：后续不会再收到任何音频焦点事件，若想恢复播放，需要用户主动触发。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_DUCK:
          // 此分支表示系统已将音频音量降低（默认降到正常音量的20%）。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_UNDUCK:
          // 此分支表示系统已将音频音量恢复正常。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_MUTE_SUGGESTION:
          // 此分支表示其他应用开始播放非混音音频，系统可自行决定是否静音。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_UNMUTE_SUGGESTION:
          // 此分支表示其他应用的非混音音频播放结束，系统可自行决定是否取消静音。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_MUTE:
          // 此分支表示系统已将音频静音。
            break;
        case AUDIO_SESSION_STATE_CHANGE_HINT_UNMUTE:
          // 此分支表示系统已将音频解除静音。
            break;
        default:
            break;
    }
}
// [StartExclude clistencallback_process]

void AudioSessionCapturerOnReadData(OH_AudioCapturer *capturer, void *userData, void *buffer, int32_t bufferLen)
{
    // 此处仅用于保持录音流运行，业务侧可按需处理录音数据。
}

OH_AudioStream_Result CreateAndStartSessionCapturer(OH_AudioCapturer **capturer)
{
    OH_AudioStreamBuilder *builder = nullptr;
    OH_AudioStream_Result result = OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER);
    if (result != AUDIOSTREAM_SUCCESS || builder == nullptr) {
        return result;
    }

    const int samplingRate = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, samplingRate);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);
    OH_AudioStreamBuilder_SetCapturerReadDataCallback(builder, AudioSessionCapturerOnReadData, nullptr);

    result = OH_AudioStreamBuilder_GenerateCapturer(builder, capturer);
    OH_AudioStreamBuilder_Destroy(builder);
    if (result != AUDIOSTREAM_SUCCESS || capturer == nullptr || *capturer == nullptr) {
        return result;
    }

    return OH_AudioCapturer_Start(*capturer);
}

napi_value AudioSessionActive(napi_env env, napi_callback_info info)
{
    // 创建音频会话管理器。
    // [EndExclude cget_sessionmanager]
    // [EndExclude csessionactive_process]
    OH_AudioCommon_Result resultManager = OH_AudioManager_GetAudioSessionManager(&audioSessionManager);
    // [StartExclude csessionactive_process]
    // [EndExclude clistencallback_process]
    OH_AudioCommon_Result result = OH_AudioSessionManager_RegisterStateChangeCallback(audioSessionManager,
                                                                                      AudioSessionStateChangedCallback);
    // [StartExclude clistencallback_process]
    if (resultManager == 0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                     " OH_AudioManager_GetAudioSessionManager success! ");
    }
    // [End cget_sessionmanager]
    // [Start cset_audioscene]
    // [Start cenable_muteSuggestion]
    // [EndExclude clistencallback_process]
    // AUDIO_SESSION_SCENE_MEDIA 仅为示例，实际使用时请根据具体情况进行修改。
    OH_AudioSessionManager_SetScene(audioSessionManager, AUDIO_SESSION_SCENE_MEDIA);
    // [StartExclude cset_audioscene]
    // 启用混音播放下静音建议。
    OH_AudioSessionManager_EnableMuteSuggestionWhenMixWithOthers(audioSessionManager, true);
    // [EndExclude cset_audioscene]
    // [Start cactive_sessionmanager]
    // [StartExclude cenable_muteSuggestion]
    // CONCURRENCY_MIX_WITH_OTHERS 是示例，实际使用时请根据情况修改。
    // [EndExclude cenable_muteSuggestion]
    // [EndExclude csessionactive_process]
    OH_AudioSession_Strategy strategy = {CONCURRENCY_MIX_WITH_OTHERS};
    
    // 设置音频并发模式并激活音频会话。
    OH_AudioSessionManager_ActivateAudioSession(audioSessionManager, &strategy);
    // [StartExclude clistencallback_process]
    // [End cset_audioscene]
    // [End cenable_muteSuggestion]
    // [End cactive_sessionmanager]
    // 查询音频会话是否已激活。
    // [Start ccheck_isactivated]
    bool isActivated = OH_AudioSessionManager_IsAudioSessionActivated(audioSessionManager);
    // [End ccheck_isactivated]
    if (isActivated) {
        OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                     " AudioSessionManager is activated! ");
    }
    // 监听音频会话停用事件。
    // [Start cregist_deacticatedcallback]
    OH_AudioCommon_Result resultRegister = OH_AudioSessionManager_RegisterSessionDeactivatedCallback(
        audioSessionManager, MyAudioSessionDeactivatedCallback);
    // [End cregist_deacticatedcallback]
    // [StartExclude csessionactive_process]
    std::stringstream ss;
    ss << "创建音频会话管理器成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value AudioSessionDeactive(napi_env env, napi_callback_info info)
{
    // [Start cdeactive_audiosession]
    OH_AudioCommon_Result result;
    // [StartExclude cdeactive_audiosession]
    // [EndExclude csessionactive_process]
    // 取消监听音频会话停用事件。
    result = OH_AudioSessionManager_UnregisterStateChangeCallback(audioSessionManager,
                                                                  AudioSessionStateChangedCallback);
    // [StartExclude csessionactive_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                 " OH_AudioSessionManager_UnregisterStateChangeCallback return: %{public}d! ", result);
    // [EndExclude csessionactive_process]
    // 停用音频会话。
    // [EndExclude cdeactive_audiosession]
    // [EndExclude clistencallback_process]
    result = OH_AudioSessionManager_DeactivateAudioSession(audioSessionManager);
    // [StartExclude clistencallback_process]
    // [End cdeactive_audiosession]
    // [End csessionactive_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                 " OH_AudioSessionManager_DeactivateAudioSession return: %{public}d! ", result);
    // [EndExclude clistencallback_process]
    // [Start cunregist_deacticatedcallback]
    OH_AudioCommon_Result resultUnregister = OH_AudioSessionManager_UnregisterSessionDeactivatedCallback(
        audioSessionManager, MyAudioSessionDeactivatedCallback);
    // [End cunregist_deacticatedcallback]
    // [End clistencallback_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                 " OH_AudioSessionManager_UnregisterSessionDeactivatedCallback return: %{public}d ! ", result);
    std::stringstream ss;
    ss << "取消监听音频会话停用事件成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value SetAudioSessionBehavior(napi_env env, napi_callback_info info)
{
    // 创建音频会话管理器。
    OH_AudioCommon_Result resultManager = OH_AudioManager_GetAudioSessionManager(&audioSessionManager);
    
    OH_AudioCommon_Result result = OH_AudioSessionManager_RegisterStateChangeCallback(audioSessionManager,
        AudioSessionStateChangedCallback);
    if (resultManager == 0) {
        OH_LOG_Print(LOG_APP, LOG_INFO, g_audioSessionVariable->globalResmgr, SESSION_TAG,
                     " OH_AudioManager_GetAudioSessionManager success! ");
    }
    // [Start cset_session_behavior]
    // AUDIO_SESSION_SCENE_MEDIA 仅为示例，实际使用时请根据具体情况进行修改。
    OH_AudioSessionManager_SetScene(audioSessionManager, AUDIO_SESSION_SCENE_MEDIA);
    
    // 本接口应在激活音频会话前调用。
    // 若音频会话在激活状态时调用此接口后，必须重新激活音频会话使其生效。
    uint32_t behavior = OH_AudioSession_BehaviorFlags::MUTE_WHEN_INTERRUPTED;
    OH_AudioSessionManager_SetBehavior(audioSessionManager, behavior);
    
    OH_AudioSession_Strategy strategy = {CONCURRENCY_PAUSE_OTHERS};
    
    // 设置音频并发模式并激活音频会话。
    OH_AudioSessionManager_ActivateAudioSession(audioSessionManager, &strategy);
    // [End cset_session_behavior]
    
    OH_AudioCommon_Result resultRegister = OH_AudioSessionManager_RegisterSessionDeactivatedCallback(
        audioSessionManager, MyAudioSessionDeactivatedCallback);
    napi_value retVal;
    napi_create_int32(env, 0, &retVal);
    return retVal;
}

napi_value SetAudioSessionCapturerMuteHint(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    OH_AudioCommon_Result managerResult = OH_AudioManager_GetAudioSessionManager(&audioSessionManager);
    if (managerResult != AUDIOCOMMON_RESULT_SUCCESS || audioSessionManager == nullptr) {
        ss << "获取音频会话管理器失败，错误码: " << managerResult;
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    OH_AudioSessionManager_SetScene(audioSessionManager, AUDIO_SESSION_SCENE_MEDIA);
    OH_AudioSession_Strategy strategy = {CONCURRENCY_MIX_WITH_OTHERS};
    OH_AudioCommon_Result activeResult = OH_AudioSessionManager_ActivateAudioSession(audioSessionManager, &strategy);
    if (activeResult != AUDIOCOMMON_RESULT_SUCCESS) {
        ss << "激活音频会话失败，错误码: " << activeResult;
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    OH_AudioCapturer *capturer = nullptr;
    OH_AudioStream_Result startResult = CreateAndStartSessionCapturer(&capturer);
    if (startResult != AUDIOSTREAM_SUCCESS || capturer == nullptr) {
        if (capturer != nullptr) {
            OH_AudioCapturer_Release(capturer);
        }
        ss << "启动会话录音流失败，错误码: " << startResult;
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
        return retVal;
    }

    // [Start cset_capturer_mute_hint]
    bool mute = true;
    OH_AudioCommon_Result setResult = OH_AudioSessionManager_SetCaptureMuteHint(audioSessionManager, mute);
    if (setResult != AUDIOCOMMON_RESULT_SUCCESS) {
        // 根据返回值处理异常，如AUDIOCOMMON_RESULT_ERROR_ILLEGAL_STATE。
    }

    mute = false;
    OH_AudioCommon_Result unsetResult = OH_AudioSessionManager_SetCaptureMuteHint(audioSessionManager, mute);
    // [End cset_capturer_mute_hint]

    OH_AudioCapturer_Stop(capturer);
    OH_AudioCapturer_Release(capturer);

    ss << "上报会话级录音流静音提示完成（接口不实际触发静音）\n";
    ss << "SetCaptureMuteHint(true) 返回值: " << setResult << "\n";
    ss << "SetCaptureMuteHint(false) 返回值: " << unsetResult;

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value printAudioSessionInfo(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    int32_t fd = -1;
    napi_get_value_int32(env, args[0], &fd);
    
    // [EndExclude print_session_info]
    // 创建音频会话管理器。
    OH_AudioManager_GetAudioSessionManager(&audioSessionManager);
    // 设置音频并发模式。
    OH_AudioSession_Strategy strategy = {CONCURRENCY_MIX_WITH_OTHERS};
    // 激活音频会话。
    OH_AudioSessionManager_ActivateAudioSession(audioSessionManager, &strategy);
    
    // 创建音频调试管理器。
    OH_AudioDebuggingManager *audioDebuggingManager;
    OH_AudioManager_GetAudioDebuggingManager(&audioDebuggingManager);
    
    // 输出到hilog日志。
    OH_AudioDebuggingManager_PrintSessionInfo(audioDebuggingManager, audioSessionManager, -1);
    
    // fd 文件描述符，实际使用时请根据具体情况获取
    // 输出到文件
    OH_AudioDebuggingManager_PrintSessionInfo(audioDebuggingManager, audioSessionManager, fd);
    // [End print_session_info]
    
    napi_value retVal;
    napi_create_int32(env, 0, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AudioSessionActive", nullptr, AudioSessionActive, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AudioSessionDeactive", nullptr, AudioSessionDeactive, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SetAudioSessionBehavior", nullptr, SetAudioSessionBehavior, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SetAudioSessionCapturerMuteHint", nullptr, SetAudioSessionCapturerMuteHint, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"printAudioSessionInfo", nullptr, printAudioSessionInfo, nullptr, nullptr, nullptr, napi_default, nullptr},
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
