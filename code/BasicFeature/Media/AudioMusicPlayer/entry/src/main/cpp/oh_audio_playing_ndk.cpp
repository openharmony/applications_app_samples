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

#include "napi/native_api.h"
#include "oh_audio_playing.h"
#include <cstdint>

#include <hilog/log.h>

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "playingNDK"

struct PlayStatusCallbackContext {
    napi_env env = nullptr;
    napi_ref callbackRef = nullptr;
    int32_t playStatus = 1;
    uv_loop_s *loop = nullptr;
};

void PlayStateCallback(void *asyncContext, PlayStatus playStatus) {
    PlayStatusCallbackContext *context = (PlayStatusCallbackContext *)asyncContext;
    
    if (context == nullptr || context->loop == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Invalid context or loop in PlayStateCallback");
        return;
    }
    
    uv_work_t *work = new uv_work_t;
    context->playStatus = playStatus;
    work->data = context;

    uv_queue_work(
        context->loop, work, [](uv_work_t *work) {},
        [](uv_work_t *work, int status) {
            PlayStatusCallbackContext *context = (PlayStatusCallbackContext *)work->data;
            
            if (context == nullptr) {
                OH_LOG_ERROR(LOG_APP, "Context is null in uv_work callback");
                delete work;
                return;
            }
            
            napi_handle_scope scope = nullptr;
            napi_open_handle_scope(context->env, &scope);
            napi_value callback = nullptr;
            napi_value ms;
            napi_create_int32(context->env, context->playStatus, &ms);
            napi_value args[1] = {ms};
            napi_get_reference_value(context->env, context->callbackRef, &callback);
            napi_call_function(context->env, nullptr, callback, 1, args, nullptr);
            napi_close_handle_scope(context->env, scope);
            delete work;
        });
}


// Initialize player
static napi_value InitPlayerNDK(napi_env env, napi_callback_info info) {
    OHAudioPlayer::GetInstance().InitPlayer();
    return nullptr;
}

// Load song information
static napi_value LoadSongInfoNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 4;
    napi_value argValues[4] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    
    char fileName[256] = {0};
    size_t fileNameLength = 0;
    napi_get_value_string_utf8(env, argValues[0], fileName, sizeof(fileName), &fileNameLength);
    
    uint32_t songFd = -1;
    napi_get_value_uint32(env, argValues[1], &songFd);
    uint32_t songFileSize = 0;
    napi_get_value_uint32(env, argValues[2], &songFileSize);
    uint32_t songFileOffset = 0;
    napi_get_value_uint32(env, argValues[3], &songFileOffset);
    
    OHAudioPlayer::GetInstance().LoadSongInfo(fileName, songFd, songFileSize, songFileOffset);
    return nullptr;
}

// Start to play song
static napi_value PlaySongNDK(napi_env env, napi_callback_info info) {
    OHAudioPlayer::GetInstance().PlaySong();
    return nullptr;
}

// Pause to play song
static napi_value PauseSongNDK(napi_env env, napi_callback_info info) {
    OHAudioPlayer::GetInstance().PauseSong();
    return nullptr;
}

// Stop to play song
static napi_value StopSongNDK(napi_env env, napi_callback_info info) {
    OHAudioPlayer::GetInstance().StopSong();
    return nullptr;
}

static napi_value GetProgressNDK(napi_env env, napi_callback_info info) {
    int32_t currentProgress = OHAudioPlayer::GetInstance().GetProgress();
    napi_value napiProgress = nullptr;
    napi_create_int32(env, currentProgress, &napiProgress);
    return napiProgress;
}

static napi_value GetSongDurationNDK(napi_env env, napi_callback_info info) {
    int32_t songDuration = OHAudioPlayer::GetInstance().GetSongDuration();
    napi_value napiDuration = nullptr;
    napi_create_int32(env, songDuration, &napiDuration);
    return napiDuration;
}

static napi_value GetRemainingTimeNDK(napi_env env, napi_callback_info info) {
    uint32_t remainingMs = OHAudioPlayer::GetInstance().GetRemainingTime();
    napi_value napiRemainingMs = nullptr;
    napi_create_uint32(env, remainingMs, &napiRemainingMs);
    return napiRemainingMs;
}

// Seek to play song
static napi_value SeekPlaySongNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 1;
    napi_value argValues[1] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    uint32_t timeStamp = 0;
    napi_get_value_uint32(env, argValues[0], &timeStamp);
    OHAudioPlayer::GetInstance().SeekPlaySong(timeStamp);
    return nullptr;
}

// Watch play status
static napi_value OnPlayStatusNDK(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    if (OHAudioPlayer::GetInstance().PlayStatusCallbackContext != nullptr) {
        auto oldContext = (PlayStatusCallbackContext *)OHAudioPlayer::GetInstance().PlayStatusCallbackContext;
        if (oldContext->callbackRef != nullptr) {
            napi_delete_reference(env, oldContext->callbackRef);
        }
        delete oldContext;
        OH_LOG_INFO(LOG_APP, "Cleaned old PlayStatusCallbackContext");
    }
    
    auto asyncContext = new PlayStatusCallbackContext();
    asyncContext->env = env;
    napi_create_reference(env, args[0], 1, &asyncContext->callbackRef);
    napi_get_uv_event_loop(env, &asyncContext->loop);
    OHAudioPlayer::GetInstance().PlayStatusCallback = &PlayStateCallback;
    OHAudioPlayer::GetInstance().PlayStatusCallbackContext = asyncContext;
    return nullptr;
}

// Set playing speed
static napi_value SetPlayingSpeedNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 1;
    napi_value argValues[1] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    double speed = 1;
    napi_get_value_double(env, argValues[0], &speed);
    OHAudioPlayer::GetInstance().SetPlayingSpeed(speed);
    return nullptr;
}

// Get playing volume
static napi_value GetPlayingVolumeNDK(napi_env env, napi_callback_info info) {
    double currentVolume = OHAudioPlayer::GetInstance().GetPlayingVolume();
    napi_value napiVolume = nullptr;
    napi_create_double(env, currentVolume, &napiVolume);
    return napiVolume;
}

// Set playing volume
static napi_value SetPlayingVolumeNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 1;
    napi_value argValues[1] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    double volume = 1.0;
    napi_get_value_double(env, argValues[0], &volume);
    OHAudioPlayer::GetInstance().SetPlayingVolume(volume);
    return nullptr;
}

// Set silent mode to player
static napi_value SetSilentModeNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 1;
    napi_value argValues[1] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    bool isSilentMode = false;
    napi_get_value_bool(env, argValues[0], &isSilentMode);
    OHAudioPlayer::GetInstance().SetSilentMode(isSilentMode);
    return nullptr;
}

// Set effect mode to player
static napi_value SetEffectModeNDK(napi_env env, napi_callback_info info) {
    size_t argCount = 1;
    napi_value argValues[1] = {nullptr};
    napi_get_cb_info(env, info, &argCount, argValues, nullptr, nullptr);
    bool isEffectOn = false;
    napi_get_value_bool(env, argValues[0], &isEffectOn);
    OHAudioPlayer::GetInstance().SetEffectMode(isEffectOn);
    return nullptr;
}

// Release player
static napi_value ReleasePlayerNDK(napi_env env, napi_callback_info info) {
    if (OHAudioPlayer::GetInstance().PlayStatusCallbackContext != nullptr) {
        auto context = (PlayStatusCallbackContext *)OHAudioPlayer::GetInstance().PlayStatusCallbackContext;
        if (context->callbackRef != nullptr) {
            napi_delete_reference(env, context->callbackRef);
        }
        delete context;
        OHAudioPlayer::GetInstance().PlayStatusCallbackContext = nullptr;
        OHAudioPlayer::GetInstance().PlayStatusCallback = nullptr;
        OH_LOG_INFO(LOG_APP, "Cleaned PlayStatusCallbackContext in ReleasePlayer");
    }
    
    OHAudioPlayer::GetInstance().ReleasePlayer();
    return nullptr;
}

static napi_value NAPI_Global_setEffectMode(napi_env env, napi_callback_info info) {
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"initPlayer", nullptr, InitPlayerNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"loadSongInfo", nullptr, LoadSongInfoNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"playSong", nullptr, PlaySongNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pauseSong", nullptr, PauseSongNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stopSong", nullptr, StopSongNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"seekPlaySong", nullptr, SeekPlaySongNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"onPlayStatus", nullptr, OnPlayStatusNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPlayingSpeed", nullptr, SetPlayingSpeedNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPlayingVolume", nullptr, GetPlayingVolumeNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setPlayingVolume", nullptr, SetPlayingVolumeNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSilentMode", nullptr, SetSilentModeNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setEffectMode", nullptr, SetEffectModeNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getProgress", nullptr, GetProgressNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSongDuration", nullptr, GetSongDurationNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getRemainingTime", nullptr, GetRemainingTimeNDK, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releasePlayer", nullptr, ReleasePlayerNDK, nullptr, nullptr, nullptr, napi_default, nullptr }};
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
