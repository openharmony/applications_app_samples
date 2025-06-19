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
#include "napi/native_api.h"
#include <cstdint>
#include <map>
#include <js_native_api.h>
#include "multimedia/player_framework/avtranscoder.h"
#include "multimedia/player_framework/avtranscoder_base.h"
#include <fstream>
#include <hilog/log.h>
#include <thread>
#include <vector>
#include <string>
#include <future>
#define FAIL (-1)
#define SUCCESS 0
#define PARAM_0 0
#define PARAM_1 1
#define PARAM_2 2
#define PARAM_3 3
#define PARAM_4 4
#define LOG_MSG_TAG "AVTransCoderNdk"
#define LOG(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
#define LOGE(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_ERROR, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
#define LOGD(format, ...) ((void)OH_LOG_Print(LOG_APP, LOG_DEBUG, 0xFF00, LOG_MSG_TAG, format, ##__VA_ARGS__))
const std::string CREATEAVTRANSCODER_EVENT = "create";
const std::string PREPAREAVTRANSCODER_EVENT = "prepare";
const std::string STARTAVTRANSCODER_EVENT = "setVideoType";
const std::string PAUSEAVTRANSCODER_EVENT = "pause";
const std::string RESUMEAVTRANSCODER_EVENT = "resume";
const std::string CANCELAVTRANSCODER_EVENT = "cancel";
const std::string RELEASEAVTRANSCODER_EVENT = "release";
const std::string ERROR_EVENT = "error";
const std::string END_EVENT = "end";
const std::int32_t AUDIO_BITRATE = 200000;
const std::int32_t VIDEO_BITRATE = 3000000;

typedef struct NdkAVTransCoderUser {
    using StateChangeFunc = std::function<void()>;
    NdkAVTransCoderUser();
    NdkAVTransCoderUser(const NdkAVTransCoderUser &other) = delete;
    NdkAVTransCoderUser &operator=(const NdkAVTransCoderUser &other) = delete;
    ~NdkAVTransCoderUser();

    void OnStateChangeCb(OH_AVTranscoder *transcoder, OH_AVTranscoder_State state);
    void OnErrorCb(OH_AVTranscoder *transcoder, int32_t errorCode, const char *errorMsg);
    void OnProgressUpdateCb(OH_AVTranscoder *transcoder, int progress);
    std::map<uint32_t, StateChangeFunc> stateChangeFuncs_;

    OH_AVTranscoder *transcoder = nullptr;
    int32_t errorCode = AV_ERR_OK;
    OH_AVTranscoder_State transCoderState = AVTRANSCODER_PREPARED;
    int avTranscoderProgress = 0;
    int inStartStateCount = 0;
} NdkAVTransCoderUser;
NdkAVTransCoderUser::NdkAVTransCoderUser() {}
NdkAVTransCoderUser::~NdkAVTransCoderUser() {}

typedef struct NdkAVTransCoderContext {
    NdkAVTransCoderUser *transcoderUser = nullptr;
    OH_AVTranscoder *transcoder = nullptr;
    OH_AVTranscoder_Config *config = nullptr;
    OH_AVTranscoder_State transCoderState = AVTRANSCODER_PREPARED;
} NdkAVTransCoderContext;
static NdkAVTransCoderContext g_ctx;

void NdkAVTransCoderUser::OnProgressUpdateCb(OH_AVTranscoder *transcoder, int progress)
{
    LOG("NdkAVTransCoderUser OnProgressUpdateCb progress: %{public}d", progress);
    this->avTranscoderProgress = progress;
}

void NdkAVTransCoderUser::OnErrorCb(OH_AVTranscoder *transcoder, int32_t errorCode, const char *errorMsg)
{
    LOG("NdkAVTransCoderUser OnErrorCb errorCode: %{public}d ,errorMsg: %{public}s", errorCode,
        errorMsg == nullptr ? "unknown" : errorMsg);
    this->errorCode = errorCode;
}

void NdkAVTransCoderUser::OnStateChangeCb(OH_AVTranscoder *transcoder, OH_AVTranscoder_State state)
{
    this->transCoderState = state;
    if (transcoder == nullptr) {
        return;
    }
    int32_t ret = -1;
    switch (state) {
        case AVTRANSCODER_PREPARED: {
            this->transCoderState = AVTRANSCODER_PREPARED;
            if (this->stateChangeFuncs_.count(AVTRANSCODER_PREPARED) > 0) {
                this->stateChangeFuncs_[AVTRANSCODER_PREPARED]();
            }
            break;
        }
        case AVTRANSCODER_STARTED: {
            this->transCoderState = AVTRANSCODER_STARTED;
            if (this->stateChangeFuncs_.count(AVTRANSCODER_STARTED) > 0) {
                this->stateChangeFuncs_[AVTRANSCODER_STARTED]();
            }
            break;
        }
        case AVTRANSCODER_PAUSED: {
            this->transCoderState = AVTRANSCODER_PAUSED;
            if (this->stateChangeFuncs_.count(AVTRANSCODER_PAUSED) > 0) {
                this->stateChangeFuncs_[AVTRANSCODER_PAUSED]();
            }
            break;
        }
        case AVTRANSCODER_CANCELLED: {
            this->transCoderState = AVTRANSCODER_CANCELLED;
            if (this->stateChangeFuncs_.count(AVTRANSCODER_CANCELLED) > 0) {
                this->stateChangeFuncs_[AVTRANSCODER_CANCELLED]();
            }
            break;
        }
        case AVTRANSCODER_COMPLETED: {
            this->transCoderState = AVTRANSCODER_COMPLETED;
            if (this->stateChangeFuncs_.count(AVTRANSCODER_COMPLETED) > 0) {
                this->stateChangeFuncs_[AVTRANSCODER_COMPLETED]();
            }
            break;
        }
        default:
            break;
    }
}

static void AvTranscoderStateChangeCbImpl(OH_AVTranscoder *transcoder, OH_AVTranscoder_State state, void *userData)
{
    LOG("AvTranscoderStateChangeCbImpl state: %{public}d", state);
    NdkAVTransCoderUser *ndkAVTransCoderUser = reinterpret_cast<NdkAVTransCoderUser *>(userData);
    if (ndkAVTransCoderUser == nullptr || transcoder == nullptr) {
        LOGE("AvTranscoderStateChangeCbImpl ndkAVTransCoderUser or transcoder is nullptr");
        return;
    }
    ndkAVTransCoderUser->OnStateChangeCb(transcoder, state);
}

static void AvTranscoderErrorCbImpl(OH_AVTranscoder *transcoder, int32_t errorCode, const char *errorMsg,
                                    void *userData)
{
    LOG("AvTranscoderErrorCbImpl errorCode: %{public}d, errorMsg: %{public}s", errorCode,
        errorMsg == nullptr ? "unknown" : errorMsg);
    NdkAVTransCoderUser *ndkAVTransCoderUser = reinterpret_cast<NdkAVTransCoderUser *>(userData);
    if (ndkAVTransCoderUser == nullptr || transcoder == nullptr) {
        LOGE("AvTranscoderErrorCbImpl ndkAVTransCoderUser or transcoder is nullptr");
        return;
    }
    ndkAVTransCoderUser->OnErrorCb(transcoder, errorCode, errorMsg);
}

static void AvTranscoderProgressUpdateCbImpl(OH_AVTranscoder *transcoder, int progress, void *userData)
{
    LOG("AvTranscoderProgressUpdateCbImpl progress: %{public}d", progress);
    NdkAVTransCoderUser *ndkAVTransCoderUser = reinterpret_cast<NdkAVTransCoderUser *>(userData);
    if (ndkAVTransCoderUser == nullptr || transcoder == nullptr) {
        LOGE("AvTranscoderProgressUpdateCbImpl ndkAVTransCoderUser or transcoder is nullptr");
        return;
    }
    ndkAVTransCoderUser->OnProgressUpdateCb(transcoder, progress);
}

static OH_AVTranscoder_Config *createDefaultTransCoderConfig(int32_t dstFd)
{
    OH_AVTranscoder_Config *config = OH_AVTranscoderConfig_Create();
    OH_AVTranscoderConfig_SetDstFD(config, dstFd);                                  // 设置转码的目标文件属dstFd。
    OH_AVTranscoderConfig_SetDstFileType(config, AV_OUTPUT_FORMAT_MPEG_4);          // 封装格式。
    OH_AVTranscoderConfig_SetDstVideoType(config, "video/avc");                     // 视频编码格式，可选。
    OH_AVTranscoderConfig_SetDstAudioType(config, "audio/mp4a-latm");               // 音频编码格式，可选。
    OH_AVTranscoderConfig_SetDstAudioBitrate(config, AUDIO_BITRATE);                // 音频比特率，可选。
    OH_AVTranscoderConfig_SetDstVideoBitrate(config, VIDEO_BITRATE);                // 视频比特率，可选。
    return config;
}
static napi_value OHAvTranscoderNdkPlay(napi_env env, napi_callback_info info)
{
    napi_value result = nullptr;
    int backParam = FAIL;
    size_t argc = PARAM_4;
    napi_value args[PARAM_4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    int32_t srcFd = PARAM_0;
    napi_get_value_int32(env, args[PARAM_0], &srcFd);
    int64_t srcOffset = PARAM_0;
    napi_get_value_int64(env, args[PARAM_1], &srcOffset);
    int64_t length = PARAM_0;
    napi_get_value_int64(env, args[PARAM_2], &length);
    int32_t dstFd = PARAM_0;
    napi_get_value_int32(env, args[PARAM_3], &dstFd);

    OH_AVTranscoder *transcoder = OH_AVTranscoder_Create();
    NdkAVTransCoderUser *transcoderUser = nullptr;
    transcoderUser = new NdkAVTransCoderUser();
    transcoderUser->transcoder = transcoder;
    g_ctx.transcoder = transcoder;
    g_ctx.config = createDefaultTransCoderConfig(dstFd);

    OH_AVTranscoderConfig_SetSrcFD(g_ctx.config, srcFd, srcOffset, length); // 设置转码源视频FD
    OH_AVTranscoder_SetStateCallback(transcoder, AvTranscoderStateChangeCbImpl, transcoderUser); // 设置状态回调
    OH_AVTranscoder_SetErrorCallback(transcoder, AvTranscoderErrorCbImpl, transcoderUser); // 设置错误码回调
    OH_AVTranscoder_SetProgressUpdateCallback(transcoder, AvTranscoderProgressUpdateCbImpl, transcoderUser); // 设置进度值回调
    g_ctx.transcoderUser = transcoderUser;
    transcoderUser->stateChangeFuncs_ = {{AVTRANSCODER_PREPARED, [transcoderUser]() {
                                            // 状态为AVTRANSCODER_PREPARED时开始转码
                                            OH_AVErrCode errCode = OH_AVTranscoder_Start(transcoderUser->transcoder);
                                            transcoderUser->errorCode = errCode;
                                            LOG("OH_AVTranscoder_Start errCode:%{public}d", errCode);
                                        }}};
    OH_AVErrCode errCode = AV_ERR_OK;
    if (errCode == AV_ERR_OK) {
        errCode = OH_AVTranscoder_Prepare(transcoder, g_ctx.config);
    } else {
        backParam = errCode;
    }
    LOG("Transcoder OHAvTranscoderConfigSetDstVideoType ret %{public}d", backParam);
    napi_create_int32(env, backParam, &result);
    return result;
}

static napi_value OHAvTranscoderNdkPause(napi_env env, napi_callback_info info)
{
    int ret = 100;
    ret = OH_AVTranscoder_Pause(g_ctx.transcoder); // 暂停转码
    LOG("OH_AVTranscoder_Pause ret:%{public}d", ret);
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}

static napi_value OHAvTranscoderNdkResume(napi_env env, napi_callback_info info)
{
    int ret = 100;
    ret = OH_AVTranscoder_Resume(g_ctx.transcoder); // 恢复转码
    LOG("OH_AVTranscoder_Resume ret:%{public}d", ret);
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}

static napi_value OHAvTranscoderNdkCancel(napi_env env, napi_callback_info info)
{
    int ret = 100;
    ret = OH_AVTranscoder_Cancel(g_ctx.transcoder); // 取消转码
    LOG("OH_AVTranscoder_Cancel ret:%{public}d", ret);
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}

static napi_value OHAvTranscoderNdkRelease(napi_env env, napi_callback_info info)
{
    int ret = 100;
    LOG("OH_AVTranscoder_Release ret:%{public}d", ret);
    if (g_ctx.transcoder != nullptr) {
        ret = OH_AVTranscoder_Release(g_ctx.transcoder); // 释放转码实例
        LOG("OH_AVTranscoder_Release ret:%{public}d", ret);
        g_ctx.transcoder = nullptr;
    }
    if (g_ctx.config != nullptr) {
        ret = OH_AVTranscoderConfig_Release(g_ctx.config); // 释放转码配置实例
        LOG("OH_AVTranscoderConfig_Release ret:%{public}d", ret);
        g_ctx.config = nullptr;
    }
    napi_value value;
    napi_create_int32(env, ret, &value);
    return value;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"AvTranscoderNdkPlay", nullptr, OHAvTranscoderNdkPlay, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AvTranscoderNdkPause", nullptr, OHAvTranscoderNdkPause, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AvTranscoderNdkResume", nullptr, OHAvTranscoderNdkResume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AvTranscoderNdkCancel", nullptr, OHAvTranscoderNdkCancel, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AvTranscoderNdkRelease", nullptr, OHAvTranscoderNdkRelease, nullptr, nullptr, nullptr, napi_default,
         nullptr}};
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
