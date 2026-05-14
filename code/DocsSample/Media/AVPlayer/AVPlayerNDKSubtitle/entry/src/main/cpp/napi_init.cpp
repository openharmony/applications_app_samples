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
#include <rawfile/raw_file_manager.h>
#include <rawfile/raw_file.h>

#define LOG_MSG_TAG "AVPlayerNDK"

#define LOG(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
#define LOGE(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
#define CCLOG(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00,
    LOG_MSG_TAG, "[cclog] " format, ##__VA_ARGS__))

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
    std::string currentSubtitle_ = "";
    napi_env env_ = nullptr;
};
SampleManager SampleManager::pluginManager_;

void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
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
void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
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

void HandleStateInitialized(OH_AVPlayer *player) {
    LOG("AVPlayerState AV_INITIALIZED");
    auto context = SampleManager::GetInstance();
    int32_t ret = OH_AVPlayer_SetVideoSurface(player, context->nativeWindow_);
    LOG("OH_AVPlayer_SetVideoSurface ret:%{public}d", ret);
    ret = OH_AVPlayer_Prepare(player);  // 设置播放源后触发该状态上报
    if (ret != AV_ERR_OK) {
        LOG("player %{public}s", "OH_AVPlayer_Prepare Err");
    }
}

void HandleStatePrepared(OH_AVPlayer *player) {
    LOG("AVPlayerState AV_PREPARED");
    int32_t ret = OH_AVPlayer_SetAudioEffectMode(player, EFFECT_NONE);  // 设置音频音效模式
    LOG("OH_AVPlayer_SetAudioEffectMode ret:%{public}d", ret);
    ret = OH_AVPlayer_Play(player);  // 调用播放接口开始播放
    LOG("OH_AVPlayer_Play ret:%{public}d", ret);
}

void HandleStateChange(OH_AVPlayer *player, OH_AVFormat *infoBody) {
    int32_t state = -1;
    int32_t stateChangeReason = -1;
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_STATE, &state);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_STATE_CHANGE_REASON, &stateChangeReason);
    LOG("AV_INFO_TYPE_STATE_CHANGE state: %{public}d, reason: %{public}d", state, stateChangeReason);
    
    AVPlayerState avState = static_cast<AVPlayerState>(state);
    switch (avState) {
    case AV_IDLE:
        LOG("AVPlayerState AV_IDLE");
        break;
    case AV_INITIALIZED:
        HandleStateInitialized(player);
        break;
    case AV_PREPARED:
        HandleStatePrepared(player);
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
}

void HandleSubtitleUpdate(OH_AVFormat *infoBody) {
    CCLOG("AV_INFO_TYPE_SUBTITLE_UPDATE received");
    int32_t duration = 0;
    int32_t startTime = 0;
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_DURATION, &duration);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_START_TIME, &startTime);
    CCLOG("Subtitle duration: %{public}d, startTime: %{public}d", duration, startTime);
    
    const char *subtitleText = nullptr;
    OH_AVFormat_GetStringValue(infoBody, OH_PLAYER_SUBTITLE_UPDATE_INFO_TEXT, &subtitleText);
    
    auto manager = SampleManager::GetInstance();
    if (subtitleText != nullptr) {
        manager->currentSubtitle_ = std::string(subtitleText);
        CCLOG("Subtitle text updated: %{public}s", manager->currentSubtitle_.c_str());
    } else {
        manager->currentSubtitle_ = "";
        CCLOG("Subtitle text cleared (no data)");
    }
}

void HandleBitrateCollect(OH_AVFormat *infoBody) {
    uint8_t *bitRates = nullptr;
    size_t size = 0;
    OH_AVFormat_GetBuffer(infoBody, OH_PLAYER_BITRATE_ARRAY, &bitRates, &size);
    LOG("AV_INFO_TYPE_BITRATE_COLLECT size: %{public}zu", size);
    for (size_t i = 0, cnt = size / sizeof(uint32_t); i < cnt; i++) {
        LOG("AV_INFO_TYPE_BITRATE_COLLECT bitRates[%{public}zu]: %{public}u", i,
            *(static_cast<uint32_t *>(static_cast<void *>(bitRates)) + i));
    }
}

void HandleIntValueInfo(AVPlayerOnInfoType type, OH_AVFormat *infoBody, const char *key) {
    int32_t value = -1;
    OH_AVFormat_GetIntValue(infoBody, key, &value);
    LOG("%{public}d type: value: %{public}d", type, value);
}

void HandleResolutionChange(OH_AVFormat *infoBody) {
    int32_t width = -1;
    int32_t height = -1;
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_VIDEO_WIDTH, &width);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_VIDEO_HEIGHT, &height);
    LOG("AV_INFO_TYPE_RESOLUTION_CHANGE width: %{public}d, height: %{public}d", width, height);
}

void HandleInterruptEvent(OH_AVFormat *infoBody) {
    int32_t interruptType = -1;
    int32_t interruptForce = -1;
    int32_t interruptHint = -1;
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_TYPE, &interruptType);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_FORCE, &interruptForce);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_AUDIO_INTERRUPT_HINT, &interruptHint);
    LOG("AV_INFO_TYPE_INTERRUPT_EVENT type: %{public}d, force: %{public}d, hint: %{public}d", 
        interruptType, interruptForce, interruptHint);
}

void HandleVolumeChange(OH_AVFormat *infoBody) {
    float volume = 0.0;
    OH_AVFormat_GetFloatValue(infoBody, OH_PLAYER_VOLUME, &volume);
    LOG("AV_INFO_TYPE_VOLUME_CHANGE value: %{public}f", volume);
}

void HandleBufferingUpdate(OH_AVFormat *infoBody) {
    int32_t bufferType = -1;
    int32_t bufferValue = -1;
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_BUFFERING_TYPE, &bufferType);
    OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_BUFFERING_VALUE, &bufferValue);
}

void HandleSimpleLogInfo(AVPlayerOnInfoType type) {
    if (type == AV_INFO_TYPE_EOS) {
        LOG("AV_INFO_TYPE_EOS");
    } else if (type == AV_INFO_TYPE_TRACKCHANGE) {
        LOG("AV_INFO_TYPE_TRACKCHANGE");
    } else if (type == AV_INFO_TYPE_TRACK_INFO_UPDATE) {
        LOG("AV_INFO_TYPE_TRACK_INFO_UPDATE");
    }
}

static const char* GetKeyByInfoType(AVPlayerOnInfoType type) {
    switch (type) {
    case AV_INFO_TYPE_MESSAGE:
        return OH_PLAYER_MESSAGE_TYPE;
    case AV_INFO_TYPE_DURATION_UPDATE:
        return OH_PLAYER_DURATION;
    case AV_INFO_TYPE_IS_LIVE_STREAM:
        return OH_PLAYER_IS_LIVE_STREAM;
    case AV_INFO_TYPE_AUDIO_OUTPUT_DEVICE_CHANGE:
        return OH_PLAYER_AUDIO_DEVICE_CHANGE_REASON;
    default:
        return nullptr;
    }
}

void HandleIntValueInfoByType(AVPlayerOnInfoType type, OH_AVFormat *infoBody) {
    const char *key = GetKeyByInfoType(type);
    if (key != nullptr) {
        HandleIntValueInfo(type, infoBody, key);
    }
}

void OHAVPlayerOnInfoCallback(OH_AVPlayer *player, AVPlayerOnInfoType type, OH_AVFormat *infoBody, void *userData) {
    switch (type) {
    case AV_INFO_TYPE_STATE_CHANGE:
        HandleStateChange(player, infoBody);
        break;
    case AV_INFO_TYPE_SEEKDONE:
        HandleIntValueInfo(type, infoBody, OH_PLAYER_SEEK_POSITION);
        break;
    case AV_INFO_TYPE_SPEEDDONE:
        HandleIntValueInfo(type, infoBody, OH_PLAYER_PLAYBACK_SPEED);
        break;
    case AV_INFO_TYPE_BITRATEDONE:
        HandleIntValueInfo(type, infoBody, OH_PLAYER_BITRATE);
        break;
    case AV_INFO_TYPE_EOS:
    case AV_INFO_TYPE_TRACKCHANGE:
    case AV_INFO_TYPE_TRACK_INFO_UPDATE:
        HandleSimpleLogInfo(type);
        break;
    case AV_INFO_TYPE_POSITION_UPDATE:
        OH_AVFormat_GetIntValue(infoBody, OH_PLAYER_CURRENT_POSITION, nullptr);
        break;
    case AV_INFO_TYPE_MESSAGE:
    case AV_INFO_TYPE_DURATION_UPDATE:
    case AV_INFO_TYPE_IS_LIVE_STREAM:
    case AV_INFO_TYPE_AUDIO_OUTPUT_DEVICE_CHANGE:
        HandleIntValueInfoByType(type, infoBody);
        break;
    case AV_INFO_TYPE_VOLUME_CHANGE:
        HandleVolumeChange(infoBody);
        break;
    case AV_INFO_TYPE_RESOLUTION_CHANGE:
        HandleResolutionChange(infoBody);
        break;
    case AV_INFO_TYPE_BUFFERING_UPDATE:
        HandleBufferingUpdate(infoBody);
        break;
    case AV_INFO_TYPE_BITRATE_COLLECT:
        HandleBitrateCollect(infoBody);
        break;
    case AV_INFO_TYPE_INTERRUPT_EVENT:
        HandleInterruptEvent(infoBody);
        break;
    case AV_INFO_TYPE_SUBTITLE_UPDATE:
        HandleSubtitleUpdate(infoBody);
        break;
    default:
        break;
    }
}
void OHAVPlayerOnErrorCallback(OH_AVPlayer *player, int32_t errorCode, const char *errorMsg, void *userData)
{
    LOG("OHAVPlayerOnErrorCallback errorCode: %{public}d ,errorMsg: %{public}s", errorCode, errorMsg);
}
static char* GetUrlFromNapiArg(napi_env env, napi_value arg, bool &success) {
    // 获取参数类型
    napi_valuetype stringType;
    if (napi_ok != napi_typeof(env, arg, &stringType)) {
        // 处理异常
        LOG("参数异常");
        success = false;
        return nullptr;
    }
    // 参数校验
    if (napi_null == stringType) {
        // 处理异常
        LOG("参数异常 null");
        success = false;
        return nullptr;
    }
    
    // 获取传递的string长度
    size_t length = 0;
    if (napi_ok != napi_get_value_string_utf8(env, arg, nullptr, 0, &length)) {
        // 处理异常
        LOG("参数长度异常");
        success = false;
        return nullptr;
    }
    // 如果传入的是""，则直接返回
    if (length == 0) {
        // 处理异常
        LOG("参数空字符");
        success = false;
        return nullptr;
    }
    
    // 读取传入的string放入buffer中
    char *url = new char[length + 1];
    if (napi_ok != napi_get_value_string_utf8(env, arg, url, length + 1, &length)) {
        delete[] url;
        // 处理异常
        LOG("url 异常");
        success = false;
        return nullptr;
    }
    
    success = true;
    return url;
}

static void GetFdParamsFromNapiArgs(napi_env env, napi_value args[4], int &fd, int &offset, int &size) {
    napi_get_value_int32(env, args[1], &fd);
    LOG("fd type %{public}d", fd);
    napi_get_value_int32(env, args[2], &offset);
    LOG("fd size %{public}d", offset);
    napi_get_value_int32(env, args[3], &size);
    LOG("fd size %{public}d", size);
}

static OH_AVPlayer* CreateAndConfigurePlayer(int fd, int offset, int size, const char *url) {
    // 创建播放实例
    if (SampleManager::GetInstance()->player_) {
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
    
    LOG("call %{public}s", "OH_AVPlayer_SetFDSource");
    ret = OH_AVPlayer_SetFDSource(player, fd, offset, size);
    
    // 设置音频流类型
    LOG("call %{public}s", "OH_AVPlayer_SetAudioRendererInfo");
    OH_AudioStream_Usage streamUsage = OH_AudioStream_Usage::AUDIOSTREAM_USAGE_UNKNOWN;
    ret = OH_AVPlayer_SetAudioRendererInfo(player, streamUsage);
    
    // 设置音频流打断模式
    LOG("call OH_AVPlayer_SetAudioInterruptMode");
    OH_AudioInterrupt_Mode interruptMode = OH_AudioInterrupt_Mode::AUDIOSTREAM_INTERRUPT_MODE_INDEPENDENT;
    ret = OH_AVPlayer_SetAudioInterruptMode(player, interruptMode);
    
    return player;
}

static napi_value NAPI_Global_Setup(napi_env env, napi_callback_info info) {
    LOG("Call NAPI AVPlayer setup");
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    bool success = false;
    char *url = GetUrlFromNapiArg(env, args[0], success);
    if (!success) {
        return nullptr;
    }
    
    int fd = 0, offset = 0, size = 0;
    GetFdParamsFromNapiArgs(env, args, fd, offset, size);
    
    OH_AVPlayer *player = CreateAndConfigurePlayer(fd, offset, size, url);
    delete[] url;
    
    napi_value value;
    napi_create_int32(env, 0, &value);
    return value;
}
static napi_value NAPI_Global_Play(napi_env env, napi_callback_info info)
{
    int ret = -1;
    auto context = SampleManager::GetInstance();
    if (context->player_ != NULL) {
        ret = OH_AVPlayer_Play(context->player_);
        LOG("OH_AVPlayer_Play ret:%{public}d", ret);
    } else {
        LOG("no found Player Instances");
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}
static napi_value NAPI_Global_SetSpeed(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_GetSpeed(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_Pause(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_Seek(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_GetDuration(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_GetCurrentTime(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_GetVideoHeight(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_GetVideoWidth(napi_env env, napi_callback_info info)
{
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
static napi_value NAPI_Global_Release(napi_env env, napi_callback_info info)
{
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
static char* GetFileNameFromNapiArg(napi_env env, napi_value arg, bool &success)
{
    napi_valuetype valueType;
    napi_typeof(env, arg, &valueType);
    if (valueType != napi_string) {
        CCLOG("AddSubtitle error: first parameter should be string");
        success = false;
        return nullptr;
    }
    
    size_t length = 0;
    napi_get_value_string_utf8(env, arg, nullptr, 0, &length);
    if (length == 0) {
        CCLOG("AddSubtitle error: empty file name");
        success = false;
        return nullptr;
    }
    
    char *fileName = new char[length + 1];
    napi_get_value_string_utf8(env, arg, fileName, length + 1, &length);
    CCLOG("AddSubtitle fileName: %{public}s", fileName);
    success = true;
    return fileName;
}

static NativeResourceManager* GetResourceManagerFromContext(napi_env env, napi_value contextArg, bool &success)
{
    napi_valuetype contextType;
    napi_typeof(env, contextArg, &contextType);
    if (contextType != napi_object) {
        CCLOG("AddSubtitle error: second parameter should be object (context)");
        success = false;
        return nullptr;
    }
    
    napi_value resourceManagerObj = nullptr;
    if (napi_get_named_property(env, contextArg, "resourceManager", &resourceManagerObj) != napi_ok) {
        CCLOG("AddSubtitle error: failed to get resourceManager from context");
        success = false;
        return nullptr;
    }
    
    NativeResourceManager *resManager = OH_ResourceManager_InitNativeResourceManager(env, resourceManagerObj);
    if (resManager == nullptr) {
        CCLOG("AddSubtitle error: failed to init NativeResourceManager");
        success = false;
        return nullptr;
    }
    
    success = true;
    return resManager;
}

static bool GetRawFileDescriptor(NativeResourceManager *resManager, const char *fileName,
    RawFileDescriptor &descriptor, RawFile* &outRawFile)
{
    RawFile *rawFile = OH_ResourceManager_OpenRawFile(resManager, fileName);
    if (rawFile == nullptr) {
        CCLOG("AddSubtitle error: failed to open rawfile %{public}s", fileName);
        return false;
    }
    
    long rawFileSize = OH_ResourceManager_GetRawFileSize(rawFile);
    CCLOG("AddSubtitle: rawfile opened, size %{public}ld", rawFileSize);
    
    bool getDescriptorResult = OH_ResourceManager_GetRawFileDescriptor(rawFile, descriptor);
    if (!getDescriptorResult) {
        CCLOG("AddSubtitle error: failed to get rawfile descriptor");
        OH_ResourceManager_CloseRawFile(rawFile);
        return false;
    }
    
    CCLOG("AddSubtitle: got descriptor fd=%{public}d, start=%{public}lld, length=%{public}lld",
          descriptor.fd, (long long)descriptor.start, (long long)descriptor.length);
    
    outRawFile = rawFile;
    return true;
}

static napi_value CreateInt32Result(napi_env env, int32_t value)
{
    napi_value result;
    napi_create_int32(env, value, &result);
    return result;
}

static napi_value NAPI_Global_AddSubtitle(napi_env env, napi_callback_info info)
{
    CCLOG("NAPI_Global_AddSubtitle called");
    size_t argc = 2;
    size_t argNum = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    
    bool success = false;
    char *fileName = GetFileNameFromNapiArg(env, args[0], success);
    if (!success) {
        return CreateInt32Result(env, -1);
    }
    
    auto manager = SampleManager::GetInstance();
    if (manager->player_ == nullptr) {
        CCLOG("AddSubtitle error: player not initialized");
        delete[] fileName;
        return CreateInt32Result(env, -1);
    }
    
    if (argc < argNum || args[1] == nullptr) {
        CCLOG("AddSubtitle error: missing context parameter");
        delete[] fileName;
        return CreateInt32Result(env, -1);
    }
    
    NativeResourceManager *resManager = GetResourceManagerFromContext(env, args[1], success);
    if (!success) {
        delete[] fileName;
        return CreateInt32Result(env, -1);
    }
    
    RawFileDescriptor descriptor;
    RawFile *rawFile = nullptr;
    bool descriptorOk = GetRawFileDescriptor(resManager, fileName, descriptor, rawFile);
    if (!descriptorOk) {
        OH_ResourceManager_ReleaseNativeResourceManager(resManager);
        delete[] fileName;
        return CreateInt32Result(env, -1);
    }
    
    OH_AVErrCode ret = OH_AVPlayer_AddFdSubtitleSource(
        manager->player_, descriptor.fd, descriptor.start, descriptor.length);
    
    OH_ResourceManager_CloseRawFile(rawFile);
    OH_ResourceManager_ReleaseNativeResourceManager(resManager);
    delete[] fileName;
    
    return CreateInt32Result(env, ret);
}

static napi_value NAPI_Global_GetSubtitle(napi_env env, napi_callback_info info)
{
    auto context = SampleManager::GetInstance();
    CCLOG("GetSubtitle called, current text: %{public}s", context->currentSubtitle_.c_str());
    napi_value result;
    napi_create_string_utf8(env, context->currentSubtitle_.c_str(), context->currentSubtitle_.length(), &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"setup", nullptr, NAPI_Global_Setup, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"play", nullptr, NAPI_Global_Play, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setSpeed", nullptr, NAPI_Global_SetSpeed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSpeed", nullptr, NAPI_Global_GetSpeed, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pause", nullptr, NAPI_Global_Pause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"seek", nullptr, NAPI_Global_Seek, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getDuration", nullptr, NAPI_Global_GetDuration, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getCurrentTime", nullptr, NAPI_Global_GetCurrentTime, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoHeight", nullptr, NAPI_Global_GetVideoHeight, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getVideoWidth", nullptr, NAPI_Global_GetVideoWidth, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"release", nullptr, NAPI_Global_Release, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addSubtitle", nullptr, NAPI_Global_AddSubtitle, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSubtitle", nullptr, NAPI_Global_GetSubtitle, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    SampleManager::GetInstance()->Export(env, exports);
    SampleManager::GetInstance()->env_ = env;
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