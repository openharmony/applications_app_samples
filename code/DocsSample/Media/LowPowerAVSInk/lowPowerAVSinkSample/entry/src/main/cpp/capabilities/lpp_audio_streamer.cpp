/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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

#include "lpp_audio_streamer.h"
#include "lppCallback.h"
#include "multimedia/player_framework/lowpower_audio_sink_base.h"
#include "multimedia/player_framework/lowpower_audio_sink.h"

#undef LOG_TAG
#define LOG_TAG "LppAudioStreamer"
#define RAW_SAMPLE_S24LE 24

LppAudioStreamer::~LppAudioStreamer()
{
    if (lppAudioStreamer_ != nullptr) {
        Release();
    }
}

int32_t LppAudioStreamer::Create(const std::string &audioCodecMime)
{
    // [Start OH_LowPowerAudioSink_CreateByMime]
    lppAudioStreamer_ = OH_LowPowerAudioSink_CreateByMime(audioCodecMime.c_str());
    // [End OH_LowPowerAudioSink_CreateByMime]
    AVCODEC_SAMPLE_LOGI("codecMime.c_str()  %{public}s", audioCodecMime.c_str());
    CHECK_AND_RETURN_RET_LOG(lppAudioStreamer_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::SetCallback(LppUserData *lppUserData)
{
    int32_t ret = AV_ERR_OK;
    // [Start OH_LowPowerAudioSinkCallback_Create]
    lppAudioStreamerCallback_ = OH_LowPowerAudioSinkCallback_Create();
    OH_LowPowerAudioSinkCallback_SetDataNeededListener(lppAudioStreamerCallback_,
        LppCallback::OnDataNeeded, lppUserData);
    OH_LowPowerAudioSinkCallback_SetErrorListener(lppAudioStreamerCallback_, LppCallback::OnError, lppUserData);
    OH_LowPowerAudioSinkCallback_SetPositionUpdateListener(lppAudioStreamerCallback_,
        LppCallback::OnPositionUpdated, lppUserData);
    OH_LowPowerAudioSinkCallback_SetInterruptListener(lppAudioStreamerCallback_,
        LppCallback::OnInterrupted, lppUserData);
    ret = OH_LowPowerAudioSink_RegisterCallback(lppAudioStreamer_, lppAudioStreamerCallback_);
    // [End OH_LowPowerAudioSinkCallback_Create]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::Configure()
{
    OH_AVFormat *format = OH_AVFormat_Create();
    int ret = OH_LowPowerAudioSink_Configure(lppAudioStreamer_, format);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::SetVolume(const float volume)
{
    int ret = OH_LowPowerAudioSink_SetVolume(lppAudioStreamer_, volume);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "SetVolume failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::SetPlayBackSpeed(const float speed)
{
    int ret = OH_LowPowerAudioSink_SetPlaybackSpeed(lppAudioStreamer_, speed);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "SetSpeed failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}


int32_t LppAudioStreamer::Start()
{
    int ret = OH_LowPowerAudioSink_Start(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Start failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::returnFrames(LppUserData *lppUserData)
{
    OH_LowPowerAudioSink_ReturnSamples(lppAudioStreamer_, lppUserData->framePacket_);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::SetParameter(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    if (sampleInfo.audioCodecConfig != nullptr) {
        OH_AVFormat_SetBuffer(format, "codec_config", sampleInfo.audioCodecConfig, sampleInfo.audioCodecSize);
    }

    OH_AVFormat_SetIntValue(format, "audio_sample_format", SAMPLE_S16LE);
    OH_AVFormat_SetIntValue(format, "audio.raw.sample.format", RAW_SAMPLE_S24LE);
    OH_AVFormat_SetIntValue(format, "channel_count", sampleInfo.audioChannelCount);
    AVCODEC_SAMPLE_LOGI("audioChannelCount  %{public}d", sampleInfo.audioChannelCount);
    OH_AVFormat_SetIntValue(format, "sample_rate", sampleInfo.audioSampleRate);
    OH_AVFormat_SetLongValue(format, "channel_layout", sampleInfo.audioChannelLayout);
    OH_LowPowerAudioSink_Configure(lppAudioStreamer_, format);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::Prepare()
{
    // [Start OH_LowPowerAudioSink_Prepare]
    auto ret = OH_LowPowerAudioSink_Prepare(lppAudioStreamer_);
    // [End OH_LowPowerAudioSink_Prepare]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::Pause()
{
    auto ret = OH_LowPowerAudioSink_Pause(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Pause failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}
    
int32_t LppAudioStreamer::Resume()
{
    auto ret = OH_LowPowerAudioSink_Resume(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Resume failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}
    
int32_t LppAudioStreamer::Flush()
{
    auto ret = OH_LowPowerAudioSink_Flush(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Flush failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}
    
int32_t LppAudioStreamer::Stop()
{
    auto ret = OH_LowPowerAudioSink_Stop(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Stop failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}
    
int32_t LppAudioStreamer::Reset()
{
    AVCODEC_SAMPLE_LOGI("reset in3");
    auto ret = OH_LowPowerAudioSink_Reset(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Reset failed.");
    AVCODEC_SAMPLE_LOGI("reset in6");
    return AVCODEC_SAMPLE_ERR_OK;
}
    
int32_t LppAudioStreamer::Destroy()
{
    AVCODEC_SAMPLE_LOGI("====== LppAudioStreamer Destroy ======");
    auto ret = OH_LowPowerAudioSink_Destroy(lppAudioStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Destroy failed.");
    lppAudioStreamer_ = nullptr;
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppAudioStreamer::Release()
{
    Stop();
    Destroy();
    return AVCODEC_SAMPLE_ERR_OK;
}

