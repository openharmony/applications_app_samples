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

// [Start csessionactive_process]
#include <cstdint>
// [Start cimport_h]
#include "ohaudio/native_audio_session_manager.h"
// [StartExclude csessionactive_process]
// [End cimport_h]
#include "utils.h"

const char *SESSION_TAG = "AudioSession";
Var *AudioSessionVariable = new Var();
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
OH_AudioSessionManager *audioSessionManager;
// [StartExclude cget_sessionmanager]
// [StartExclude csessionactive_process]
// [End cint_deacticatedcallback]

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
        default:
            break;
    }
}
// [StartExclude clistencallback_process]

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
        OH_LOG_Print(LOG_APP, LOG_INFO, AudioSessionVariable->GLOBAL_RESMGR, SESSION_TAG,
                     " OH_AudioManager_GetAudioSessionManager success! ");
    }
    // [End cget_sessionmanager]
    // [Start cset_audioscene]
    // [EndExclude clistencallback_process]
    // AUDIO_SESSION_SCENE_MEDIA 仅为示例，实际使用时请根据具体情况进行修改。
    OH_AudioSessionManager_SetScene(audioSessionManager, AUDIO_SESSION_SCENE_MEDIA);
    // [Start cactive_sessionmanager]
    // CONCURRENCY_MIX_WITH_OTHERS 是示例，实际使用时请根据情况修改
    // [EndExclude csessionactive_process]
    OH_AudioSession_Strategy strategy = {CONCURRENCY_MIX_WITH_OTHERS};
    
    // 设置音频并发模式并激活音频会话。
    OH_AudioSessionManager_ActivateAudioSession(audioSessionManager, &strategy);
    // [StartExclude clistencallback_process]
    // [End cset_audioscene]
    // [End cactive_sessionmanager]
    // 查询音频会话是否已激活。
    // [Start ccheck_isactivated]
    bool isActivated = OH_AudioSessionManager_IsAudioSessionActivated(audioSessionManager);
    // [End ccheck_isactivated]
    if (isActivated) {
        OH_LOG_Print(LOG_APP, LOG_INFO, AudioSessionVariable->GLOBAL_RESMGR, SESSION_TAG,
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
    OH_AudioCommon_Result result;
    // [EndExclude csessionactive_process]
    // 取消监听音频会话停用事件。
    result = OH_AudioSessionManager_UnregisterStateChangeCallback(audioSessionManager,
                                                                  AudioSessionStateChangedCallback);
    // [StartExclude csessionactive_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, AudioSessionVariable->GLOBAL_RESMGR, SESSION_TAG,
                 " OH_AudioSessionManager_UnregisterStateChangeCallback return: %{public}d! ", result);
    // [EndExclude csessionactive_process]
    // 停用音频会话。
    // [EndExclude clistencallback_process]
    result = OH_AudioSessionManager_DeactivateAudioSession(audioSessionManager);
    // [StartExclude clistencallback_process]
    // [End csessionactive_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, AudioSessionVariable->GLOBAL_RESMGR, SESSION_TAG,
                 " OH_AudioSessionManager_DeactivateAudioSession return: %{public}d! ", result);
    // [EndExclude clistencallback_process]
    // [Start cunregist_deacticatedcallback]
    OH_AudioCommon_Result resultUnregister = OH_AudioSessionManager_UnregisterSessionDeactivatedCallback(
        audioSessionManager, MyAudioSessionDeactivatedCallback);
    // [End cunregist_deacticatedcallback]
    // [End clistencallback_process]
    OH_LOG_Print(LOG_APP, LOG_INFO, AudioSessionVariable->GLOBAL_RESMGR, SESSION_TAG,
                 " OH_AudioSessionManager_UnregisterSessionDeactivatedCallback return: %{public}d ! ", result);
    std::stringstream ss;
    ss << "取消监听音频会话停用事件成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AudioSessionActive", nullptr, AudioSessionActive, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AudioSessionDeactive", nullptr, AudioSessionDeactive, nullptr, nullptr, nullptr, napi_default, nullptr},
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
