/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
#include <js_native_api.h>
#include <multimedia/player_framework/avplayer.h>
#include "multimedia/player_framework/avplayer_base.h"
#include "multimedia/player_framework/native_averrors.h"
#include <string>
#include <ace/xcomponent/native_interface_xcomponent.h>
#include <hilog/log.h>

#define LOG_MSG_TAG "AVPlayerNDK"

#define LOG(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
#define LOGE(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))

void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window);
void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window);

class SampleRenderer {
public:
    SampleRenderer(std::string &id) { this->id_ = id; }
    ~SampleRenderer() {}
    static SampleRenderer *GetInstance(std::string &id) {
        if (instance_.find(id) == instance_.end()) {
            SampleRenderer *instance = new SampleRenderer(id);
            instance_[id] = instance;
            return instance;
        } else {
            return instance_[id];
        }
    }
    static void Release(std::string &id)  {
        SampleRenderer *render = SampleRenderer::GetInstance(id);
        if (render != nullptr) {
            instance_.erase(instance_.find(id));
        }
    }
    void RegisterCallback(OH_NativeXComponent *nativeXComponent) {
        renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
        renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
        OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
    }

public:
    static std::unordered_map<std::string, SampleRenderer *> instance_;
    std::string id_;

private:
    OH_NativeXComponent_Callback renderCallback_;
};
std::unordered_map<std::string, SampleRenderer *> SampleRenderer::instance_;

class SampleManager {
public:
    ~SampleManager() {
        LOG("Callback ~PluginManager");
        for (auto iter = nativeXComponentMap_.begin(); iter != nativeXComponentMap_.end(); ++iter) {
            if (iter->second != nullptr) {
                delete iter->second;
                iter->second = nullptr;
            }
        }
        nativeXComponentMap_.clear();
        for (auto iter = pluginRenderMap_.begin(); iter != pluginRenderMap_.end(); ++iter) {
            if (iter->second != nullptr) {
                delete iter->second;
                iter->second = nullptr;
            }
        }
        pluginRenderMap_.clear();
    }
    static SampleManager *GetInstance() { return &SampleManager::pluginManager_; }
    void SetNativeXComponent(std::string &id, OH_NativeXComponent *nativeXComponent) {
        if (nativeXComponent == nullptr) {
            return;
        }
        surfaceId_ = &id;
        nativeXComponentMap_[id] = nativeXComponent;
    }
    void SetNativeWindow(OHNativeWindow *nativeWindow, uint64_t width, uint64_t height) {
        nativeWindow_ = nativeWindow;
        height_ = height;
        width_ = width;
    }
    void SetAVPlayer(OH_AVPlayer *player) { player_ = player; }
    void Export(napi_env env, napi_value exports) {
        LOG("Call PluginManager::Export");
        if ((env == nullptr) || (exports == nullptr)) {
            LOG("PluginManager %{public}s", "Export: env or exports is null");
            return;
        }
        napi_value exportInstance = nullptr;
        if (napi_get_named_property(env, exports, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
            LOG("PluginManager %{public}s", "Export: napi_get_named_property fail");
            return;
        }
        OH_NativeXComponent *nativeXComponent = nullptr;
        if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
            LOG("PluginManager %{public}s", "Export: napi_unwrap fail");
            return;
        }
        char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
        uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
        if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
            LOG("PluginManager Export: OH_NativeXComponent_GetXComponentId fail");
            return;
        }
        LOG("Call PluginManager::Export surfaceID=%{public}s", idStr);
        std::string id(idStr);
        auto context = SampleManager::GetInstance();
        if ((context != nullptr) && (nativeXComponent != nullptr)) {
            context->SetNativeXComponent(id, nativeXComponent);
            auto render = context->GetRender(id);
            if (render != nullptr) {
                render->RegisterCallback(nativeXComponent);
            }
        }
    }
    SampleRenderer *GetRender(std::string &id) {
        if (pluginRenderMap_.find(id) == pluginRenderMap_.end()) {
            SampleRenderer *instance = SampleRenderer::GetInstance(id);
            pluginRenderMap_[id] = instance;
            return instance;
        }
        return pluginRenderMap_[id];
    }

public:
    static SampleManager pluginManager_;
    std::unordered_map<std::string, SampleRenderer *> pluginRenderMap_;
    std::unordered_map<std::string, OH_NativeXComponent *> nativeXComponentMap_;
    std::string *surfaceId_;
    OHNativeWindow *nativeWindow_ = nullptr;
    uint64_t height_;
    uint64_t width_;
    OH_AVPlayer *player_ = nullptr;
    OH_NativeXComponent_Callback renderCallback_;
};
SampleManager SampleManager::pluginManager_;

void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window) {
    LOG("OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    uint64_t width;
    uint64_t height;
    OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    auto context = SampleManager::GetInstance();
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    if ((context != nullptr) && (nativeWindow != nullptr)) {
        context->SetNativeWindow(nativeWindow, width, height);
    }
}
void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window) {
    LOG("OnSurfaceDestroyedCB");
    if ((component == nullptr) || (window == nullptr)) {
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        return;
    }
    std::string id(idStr);
    SampleRenderer::Release(id);
}

void OHAVPlayerOnInfoCallback(OH_AVPlayer *player, AVPlayerOnInfoType type, OH_AVFormat *infoBody, void *userData) {
    int32_t ret;
    int32_t value = -1;

    int32_t state = -1;
    int32_t stateChangeReason = -1;
    AVPlayerState avState = AV_IDLE;

    float volume = 0.0;

    int32_t width = -1;
    int32_t height = -1;

    int32_t bufferType = -1;
    int32_t bufferValue = -1;

    uint8_t *bitRates;
    size_t size;

    int32_t interruptType = -1;
    int32_t interruptForce = -1;
    int32_t interruptHint = -1;
    switch (type) {
    case AV_INFO_TYPE_STATE_CHANGE:
        LOG("AVPlayerOnInfoType AV_INFO_TYPE_STATE_CHANGE");
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_STATE, &state);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_STATE_CHANGE_REASON, &stateChangeReason);
        OH_AVPlayer_GetState(player, &avState); // 获取当前播放状态
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_STATE_CHANGE  state: %{public}d ,stateChangeReason: %{public}d", 
            state, stateChangeReason);
        avState = static_cast<AVPlayerState>(state);
        switch (avState) {
        case AV_IDLE: // 成功调用reset接口后触发该状态机上报
            LOG("AVPlayerState  AV_IDLE");
            break;
        case AV_INITIALIZED: {
            LOG("AVPlayerState  AV_INITIALIZED");
            auto context = SampleManager::GetInstance();
            ret = OH_AVPlayer_SetVideoSurface(player, context->nativeWindow_);
            LOG("OH_AVPlayer_SetVideoSurface ret:%{public}d", ret);
            ret = OH_AVPlayer_Prepare(player); // 设置播放源后触发该状态上报
            if (ret != AV_ERR_OK) {
                // 处理异常
                LOG("player  %{public}s", "OH_AVPlayer_Prepare Err");
            }
        } break;
        case AV_PREPARED:
            LOG("AVPlayerState AV_PREPARED");
            ret = OH_AVPlayer_SetAudioEffectMode(player, EFFECT_NONE); // 设置音频音效模式
            LOG("OH_AVPlayer_SetAudioEffectMode ret:%{public}d", ret);
            ret = OH_AVPlayer_Play(player); // 调用播放接口开始播放
            LOG("OH_AVPlayer_Play ret:%{public}d", ret);
            break;
        case AV_PLAYING:
            LOG("AVPlayerState AV_PLAYING");
            break;
        case AV_PAUSED:
            LOG("AVPlayerState AV_PAUSED");
            break;
        case AV_STOPPED:
            LOG("AVPlayerState AV_STOPPED");
            break;
        case AV_COMPLETED:
            LOG("AVPlayerState AV_COMPLETED");
            break;
        case AV_ERROR:
            LOG("AVPlayerState AV_ERROR");
            break;
        case AV_RELEASED:
            LOG("AVPlayerState AV_RELEASED");
            break;
        default:
            break;
        }
        break;
    case AV_INFO_TYPE_SEEKDONE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SEEK_POSITION, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_SEEKDONE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_SPEEDDONE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_PLAYBACK_SPEED, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_SPEEDDONE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_BITRATEDONE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_BITRATE, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_BITRATEDONE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_EOS:
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_EOS");
        break;
    case AV_INFO_TYPE_POSITION_UPDATE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_CURRENT_POSITION, &value);
        // 以下log会频繁打印
        // LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_POSITION_UPDATE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_MESSAGE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_MESSAGE_TYPE, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_MESSAGE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_VOLUME_CHANGE:
        OH_AVFormat_GetFloatValue(infoBody, OH_PLAYER_VOLUME, &volume);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_VOLUME_CHANGE value: %{public}f", volume);
        break;
    case AV_INFO_TYPE_RESOLUTION_CHANGE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_VIDEO_WIDTH, &width);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_VIDEO_HEIGHT, &height);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_RESOLUTION_CHANGE width: %{public}d, height: %{public}d", 
            width, height);
        break;
    case AV_INFO_TYPE_BUFFERING_UPDATE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_BUFFERING_TYPE, &bufferType);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_BUFFERING_VALUE, &bufferValue);
        // 以下log会频繁打印
//        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_BUFFERING_UPDATE bufferType: %{public}d, bufferValue: %{public}d",
//            bufferType, bufferValue);
        break;
    case AV_INFO_TYPE_BITRATE_COLLECT:
        OH_AVFormat_GetBuffer(infoBody, OH_PLAYER_BITRATE_ARRAY, &bitRates, &size);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_BITRATE_COLLECT size: %{public}zu", size);
        for (size_t i = 0, cnt = size / sizeof(uint32_t); i < cnt; i++) {
            LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_BITRATE_COLLECT bitRates[%{public}zu]: %{public}u", i,
                *(static_cast<uint32_t *>(static_cast<void *>(bitRates)) + i));
        }
        break;
    case AV_INFO_TYPE_INTERRUPT_EVENT:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_TYPE, &interruptType);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_FORCE, &interruptForce);
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_HINT, &interruptHint);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_INTERRUPT_EVENT interruptType: %{public}d, "
            "interruptForce: %{public}d, interruptHint: %{public}d", interruptType, interruptForce, interruptHint);
        break;
    case AV_INFO_TYPE_DURATION_UPDATE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_DURATION, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_DURATION_UPDATE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_IS_LIVE_STREAM:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_IS_LIVE_STREAM, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_IS_LIVE_STREAM value: %{public}d", value);
        break;
    case AV_INFO_TYPE_TRACKCHANGE:
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_TRACKCHANGE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_TRACK_INFO_UPDATE:
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_TRACK_INFO_UPDATE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_SUBTITLE_UPDATE:
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_SUBTITLE_UPDATE value: %{public}d", value);
        break;
    case AV_INFO_TYPE_AUDIO_OUTPUT_DEVICE_CHANGE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_DEVICE_CHANGE_REASON, &value);
        LOG("OHAVPlayerOnInfoCallback AV_INFO_TYPE_AUDIO_OUTPUT_DEVICE_CHANGE value: %{public}d", value);
        break;
    default:
        break;
    }
}
void OHAVPlayerOnErrorCallback(OH_AVPlayer *player, int32_t errorCode, const char *errorMsg, void *userData) {
    LOG("OHAVPlayerOnErrorCallback errorCode: %{public}d ,errorMsg: %{public}s", errorCode, errorMsg);
}
static napi_value NAPI_Global_Setup(napi_env env, napi_callback_info info) {

    LOG("Call NAPI AVPlayer setup");
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    // 获取参数类型
    napi_valuetype stringType;
    if (napi_ok != napi_typeof(env, args[0], &stringType)) {
        // 处理异常
        LOG("参数异常");
        return nullptr;
    }
    // 参数校验
    if (napi_null == stringType) {
        // 处理异常
        LOG("参数异常 null");
        return nullptr;
    }
    // 获取传递的string长度
    size_t length = 0;
    if (napi_ok != napi_get_value_string_utf8(env, args[0], nullptr, 0, &length)) {
        // 处理异常
        LOG("参数长度异常");
        return nullptr;
    }
    // 如果传入的是""，则直接返回
    if (length == 0) {
        // 处理异常
        LOG("参数空字符");
        return nullptr;
    }
    // 读取传入的string放入buffer中
    char *url = new char[length + 1];
    if (napi_ok != napi_get_value_string_utf8(env, args[0], url, length + 1, &length)) {
        delete[] url;
        url = nullptr;
        // 处理异常
        LOG("url 异常");
        return nullptr;
    }
    int pType;
    napi_get_value_int32(env, args[1], &pType);
    LOG("fd type %{public}d", pType);
    int pOffset;
    napi_get_value_int32(env, args[2], &pOffset);
    LOG("fd size %{public}d", pOffset);
    int pSize;
    napi_get_value_int32(env, args[3], &pSize);
    LOG("fd size %{public}d", pSize);
    
    // 创建播放实例
    if(SampleManager::GetInstance()->player_) {
        OH_AVPlayer_Release(SampleManager::GetInstance()->player_);
    }
    OH_AVPlayer *player = OH_AVPlayer_Create();
    SampleManager::GetInstance()->SetAVPlayer(player);
    // 设置回调，监听信息
    LOG("call OH_AVPlayer_SetPlayerOnInfoCallback");
    int32_t ret = OH_AVPlayer_SetOnInfoCallback(player, OHAVPlayerOnInfoCallback, nullptr);
    LOG("OH_AVPlayer_SetPlayerOnInfoCallback ret:%{public}d", ret);
    LOG("call OH_AVPlayer_SetPlayerOnErrorCallback");
    ret = OH_AVPlayer_SetOnErrorCallback(player, OHAVPlayerOnErrorCallback, nullptr);
    LOG("OH_AVPlayer_SetPlayerOnErrorCallback ret:%{public}d", ret);
    {
        LOG("player %{public}s  >> fd: %{public}d offset: %{public}d fileSize: %{public}d", 
            url, pType, pOffset, pSize);
        LOG("call %{public}s", "OH_AVPlayer_SetFDSource");
        ret = OH_AVPlayer_SetFDSource(player, pType, pOffset, pSize);
        LOG("OH_AVPlayer_SetFDSource ret:%{public}d", ret);
    }
    // 设置音频流类型
    LOG("call %{public}s", "OH_AVPlayer_SetAudioRendererInfo");
    OH_AudioStream_Usage streamUsage = OH_AudioStream_Usage::AUDIOSTREAM_USAGE_UNKNOWN;
    ret = OH_AVPlayer_SetAudioRendererInfo(player, streamUsage);
    LOG("OH_AVPlayer_SetAudioRendererInfo ret:%{public}d", ret);
    // 设置音频流打断模式
    LOG("call OH_AVPlayer_SetAudioInterruptMode");
    OH_AudioInterrupt_Mode interruptMode = OH_AudioInterrupt_Mode::AUDIOSTREAM_INTERRUPT_MODE_INDEPENDENT;
    ret = OH_AVPlayer_SetAudioInterruptMode(player, interruptMode);
    LOG("OH_AVPlayer_SetAudioInterruptMode ret:%{public}d", ret);
    napi_value value;
    napi_create_int32(env, 0, &value);
    return value;
}
static napi_value NAPI_Global_Play(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Play(context->player_);
        LOG("OH_AVPlayer_Play ret:%{public}d", ret);
        bool isPlaying = false;
        isPlaying = OH_AVPlayer_IsPlaying(context->player_);
        LOG("OH_AVPlayer_IsPlaying :%{public}d", isPlaying);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_SetSpeed(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int speed_code;
    napi_get_value_int32(env, args[0], &speed_code);
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        switch (speed_code) {
        case 0:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_0_75_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_0_75_X);
            break;
        case 1:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_1_00_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_1_00_X);
            break;
        case 2:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_1_25_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_1_25_X);
            break;
        case 3:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_1_75_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_1_75_X);
            break;
        case 4:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_2_00_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_2_00_X);
            break;
        case 5:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_0_50_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_0_50_X);
            break;
        case 6:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_1_50_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_1_50_X);
            break;
        default:
            LOG("OH_AVPlayer_SetPlaybackSpeed AV_SPEED_FORWARD_1_00_X");
            ret = OH_AVPlayer_SetPlaybackSpeed(context->player_, AV_SPEED_FORWARD_1_00_X);
            break;
        }
        LOG("OH_AVPlayer_SetPlaybackSpeed ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_GetSpeed(napi_env env, napi_callback_info info) {
    auto context = SampleManager::GetInstance();
    AVPlaybackSpeed speed;
    if (context->player_ != NULL) {
        OH_AVPlayer_GetPlaybackSpeed(context->player_, &speed);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, speed, &value);
    return value;
}
static napi_value NAPI_Global_GetCurrentTrack(napi_env env, napi_callback_info info) {
    auto context = SampleManager::GetInstance();
    int currentTrack = 0; // 媒体类型。0：音频，1：视频
    int index;
    if (context->player_ != NULL) {
        OH_AVPlayer_GetCurrentTrack(context->player_, currentTrack, &index);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, index, &value);
    return value;
}
static napi_value NAPI_Global_Pause(napi_env env, napi_callback_info info) {
    int ret = 100;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Pause(context->player_);
        LOG("OH_AVPlayer_Pause ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_Stop(napi_env env, napi_callback_info info) {
    int ret = 100;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Stop(context->player_);
        LOG("OH_AVPlayer_Stop ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_Reset(napi_env env, napi_callback_info info) {
    int ret = 100;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Reset(context->player_);
        LOG("OH_AVPlayer_Pause ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_Seek(napi_env env, napi_callback_info info) {
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int seekValue;
    napi_get_value_int32(env, args[0], &seekValue);
    int mode;
    napi_get_value_int32(env, args[1], &mode);
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        int ret;
        switch (mode) {
        case 0:
            LOG("call NAPI_Global_Seek value:%{public}d  mode:AV_SEEK_NEXT_SYNC", seekValue);
            ret = OH_AVPlayer_Seek(context->player_, seekValue, AV_SEEK_NEXT_SYNC);
            break;
        case 1:
            LOG("call NAPI_Global_Seek value:%{public}d  mode:AV_SEEK_PREVIOUS_SYNC", seekValue);
            ret = OH_AVPlayer_Seek(context->player_, seekValue, AV_SEEK_PREVIOUS_SYNC);
            break;
        case 2:
            LOG("call NAPI_Global_Seek value:%{public}d  mode:AV_SEEK_CLOSEST", seekValue);
            ret = OH_AVPlayer_Seek(context->player_, seekValue, AV_SEEK_CLOSEST);
            break;
        default:
            LOG("call NAPI_Global_Seek value:%{public}d  mode:AV_SEEK_PREVIOUS_SYNC", seekValue);
            ret = OH_AVPlayer_Seek(context->player_, seekValue, AV_SEEK_PREVIOUS_SYNC);
            break;
        }
        LOG("OH_AVPlayer_Seek ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, 0, &value);
    return value;
}
static napi_value NAPI_Global_GetDuration(napi_env env, napi_callback_info info) {
    auto context = SampleManager::GetInstance();
    int ret;
    int32_t duration;
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_GetDuration(context->player_, &duration);
        if (ret != AV_ERR_OK) {
            LOG("OH_AVPlayer_GetDuration fail");
        }
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, duration, &value);
    return value;
}
static napi_value NAPI_Global_GetCurrentTime(napi_env env, napi_callback_info info) {
    auto context = SampleManager::GetInstance();
    int ret;
    int32_t currentTime;
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_GetCurrentTime(context->player_, &currentTime);
        if (ret != AV_ERR_OK) {
            LOG("OH_AVPlayer_GetCurrentTime fail");
        }
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, currentTime, &value);
    return value;
}
static napi_value NAPI_Global_GetVideoHeight(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        int32_t videoHeight;
        ret = OH_AVPlayer_GetVideoHeight(context->player_, &videoHeight);
        LOG("OH_AVPlayer_GetVideoHeight ret:%{public}d  videoHeight：%{public}d ", ret, videoHeight);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_GetVideoWidth(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        int32_t videoWidth;
        ret = OH_AVPlayer_GetVideoWidth(context->player_, &videoWidth);
        LOG("OH_AVPlayer_GetVideoWidth ret:%{public}d  videoWidth：%{public}d ", ret, videoWidth);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_SelectTrack(napi_env env, napi_callback_info info) {
    int ret = -1;
    int32_t index;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_SelectTrack(context->player_, index);
        LOG("OH_AVPlayer_SelectTrack index：%{public}d ", index);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, index, &value);
    return value;
}
static napi_value NAPI_Global_DeselectTrack(napi_env env, napi_callback_info info) {
    int ret = -1;
    int32_t index;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_DeselectTrack(context->player_, index);
        LOG("OH_AVPlayer_DeselectTrack index：%{public}d ", index);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, index, &value);
    return value;
}
static napi_value NAPI_Global_SelectBitRate(napi_env env, napi_callback_info info) {
    int ret = -1;
    uint32_t bitRate;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_SelectBitRate(context->player_, bitRate);
        LOG("OH_AVPlayer_SelectBitRate bitRate：%{public}d ", bitRate);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, bitRate, &value);
    return value;
}
static napi_value NAPI_Global_SetLooping(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    bool loop = true;
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_SetLooping(context->player_, loop);
        LOG("OH_AVPlayer_SetLooping ret:%{public}d", ret);
        bool isLooping = false;
        isLooping = OH_AVPlayer_IsLooping(context->player_);
        LOG("OH_AVPlayer_IsLooping :%{public}d", isLooping);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_Release(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Release(context->player_);
        LOG("OH_AVPlayer_Release ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_ReleaseSync(napi_env env, napi_callback_info info) {
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_ReleaseSync(context->player_);
        LOG("OH_AVPlayer_ReleaseSync ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"setup", nullptr, NAPI_Global_Setup, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"play", nullptr, NAPI_Global_Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSpeed", nullptr, NAPI_Global_SetSpeed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSpeed", nullptr, NAPI_Global_GetSpeed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCurrentTrack", nullptr, NAPI_Global_GetCurrentTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pause", nullptr, NAPI_Global_Pause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stop", nullptr, NAPI_Global_Stop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"reset", nullptr, NAPI_Global_Reset, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"seek", nullptr, NAPI_Global_Seek, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDuration", nullptr, NAPI_Global_GetDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCurrentTime", nullptr, NAPI_Global_GetCurrentTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoHeight", nullptr, NAPI_Global_GetVideoHeight, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoWidth", nullptr, NAPI_Global_GetVideoWidth, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"selectTrack", nullptr, NAPI_Global_SelectTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deselectTrack", nullptr, NAPI_Global_DeselectTrack, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"selectBitrate", nullptr, NAPI_Global_SelectBitRate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setLooping", nullptr, NAPI_Global_SetLooping, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"release", nullptr, NAPI_Global_Release, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"releaseSync", nullptr, NAPI_Global_ReleaseSync, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    SampleManager::GetInstance()->Export(env, exports);
    return exports;
}
EXTERN_C_END

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
