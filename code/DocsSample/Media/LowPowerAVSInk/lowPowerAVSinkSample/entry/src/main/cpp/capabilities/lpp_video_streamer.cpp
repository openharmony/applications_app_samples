/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
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

#include "lpp_video_streamer.h"
#include "lppCallback.h"
#include "multimedia/player_framework/lowpower_audio_sink_base.h"
#include "multimedia/player_framework/lowpower_audio_sink.h"
#include "multimedia/player_framework/lowpower_video_sink.h"
#include "multimedia/player_framework/lowpower_video_sink_base.h"
#include "multimedia/player_framework/lowpower_avsink_base.h"


#undef LOG_TAG
#define LOG_TAG "LppVideoStreamer"

LppVideoStreamer::~LppVideoStreamer()
{
    if (lppVideoStreamer_ != nullptr) {
        Release();
    }
}

int32_t LppVideoStreamer::Create(const std::string &videoCodecMime)
{
    // [Start OH_LowPowerVideoSink_CreateByMime]
    lppVideoStreamer_ = OH_LowPowerVideoSink_CreateByMime(videoCodecMime.c_str());
    // [End OH_LowPowerVideoSink_CreateByMime]
    CHECK_AND_RETURN_RET_LOG(lppVideoStreamer_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetCallback(LppUserData *lppUserData)
{
    int32_t ret = AV_ERR_OK;
    lppVideoStreamerCallback_ = OH_LowPowerVideoSinkCallback_Create();
    OH_LowPowerVideoSinkCallback_SetDataNeededListener(lppVideoStreamerCallback_, LppCallback::OnDataNeededVideo,
        lppUserData);
    OH_LowPowerVideoSinkCallback_SetErrorListener(lppVideoStreamerCallback_, LppCallback::OnError, lppUserData);
    OH_LowPowerVideoSinkCallback_SetStreamChangedListener(lppVideoStreamerCallback_,
        LppCallback::OH_LowPowerVideoSink_OnStreamChanged, lppUserData);
    ret = OH_LowPowerVideoSink_RegisterCallback(lppVideoStreamer_, lppVideoStreamerCallback_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Configure(const SampleInfo &sampleInfo)
{
    // [Start OH_LowPowerVideoSink_Configure]
    OH_AVFormat *format = OH_AVFormat_Create();

    // [StartExclude OH_LowPowerVideoSink_Configure]
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");
    format = sampleInfo.format_video;
    // [EndExclude OH_LowPowerVideoSink_Configure]
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, sampleInfo.videoHeight);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, sampleInfo.pixelFormat);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_ROTATION, sampleInfo.rotation);
    
    // [StartExclude OH_LowPowerVideoSink_Configure]
    OH_AVFormat_SetIntValue(format, "lpp", true);
    AVCODEC_SAMPLE_LOGI("%{public}d*%{public}d, %{public}.1ffps, %{public}d,%{public}d", sampleInfo.videoWidth,
        sampleInfo.videoHeight, sampleInfo.frameRate, sampleInfo.pixelFormat, sampleInfo.rotation);
    // [EndExclude OH_LowPowerVideoSink_Configure]
    int ret = OH_LowPowerVideoSink_Configure(lppVideoStreamer_, format);
    // [End OH_LowPowerVideoSink_Configure]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::returnFrames(LppUserData *lppUserData)
{
    auto ret = OH_LowPowerVideoSink_ReturnSamples(lppVideoStreamer_, lppUserData->framePacket_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "returnFrames failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetParameter(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");

    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, sampleInfo.videoHeight);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, sampleInfo.pixelFormat);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_ROTATION, sampleInfo.rotation);

    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");
    AVCODEC_SAMPLE_LOGI("%{public}d*%{public}d, %{public}.1ffps", sampleInfo.videoWidth, sampleInfo.videoHeight,
                        sampleInfo.frameRate);
    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");
    int ret = OH_LowPowerVideoSink_SetParameter(lppVideoStreamer_, format);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Prepare()
{
    // [Start OH_LowPowerVideoSink_Prepare]
    auto ret = OH_LowPowerVideoSink_Prepare(lppVideoStreamer_);
    // [End OH_LowPowerVideoSink_Prepare]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Resume()
{
    auto ret = OH_LowPowerVideoSink_Resume(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Flush()
{
    auto ret = OH_LowPowerVideoSink_Flush(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Stop()
{
    auto ret = OH_LowPowerVideoSink_Stop(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Reset()
{
    auto ret = OH_LowPowerVideoSink_Reset(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Destroy()
{
    auto ret = OH_LowPowerVideoSink_Destroy(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    lppVideoStreamer_ = nullptr;
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::StartDecode(bool flag)
{
    // [Start OH_LowPowerVideoSink_StartDecoder]
    auto ret = OH_LowPowerVideoSink_StartDecoder(lppVideoStreamer_);
    // [End OH_LowPowerVideoSink_StartDecoder]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::StartRender()
{
    // [Start OH_LowPowerVideoSink_StartRenderer]
    auto ret = OH_LowPowerVideoSink_StartRenderer(lppVideoStreamer_);
    // [End OH_LowPowerVideoSink_StartRenderer]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Pause()
{
    auto ret = OH_LowPowerVideoSink_Pause(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetVideoSurface(const SampleInfo &sampleInfo)
{
    if (sampleInfo.window != nullptr) {
        auto ret = OH_LowPowerVideoSink_SetVideoSurface(lppVideoStreamer_, sampleInfo.window);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetSyncAudioStreamer(OH_LowPowerAudioSink *audioStreamer)
{
    // [Start OH_LowPowerVideoSink_SetSyncAudioSink]
    auto ret = OH_LowPowerVideoSink_SetSyncAudioSink(lppVideoStreamer_, audioStreamer);
    // [End OH_LowPowerVideoSink_SetSyncAudioSink]
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetTargetStartFrame(const long framePts,
    OH_LowPowerVideoSink_OnTargetArrived onTargetArrived, const long timeoutMs, LppUserData *lppUserData)
{
    auto ret = OH_LowPowerVideoSink_SetTargetStartFrame(lppVideoStreamer_, framePts,
        onTargetArrived, timeoutMs, lppUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::SetPlaybackSpeed(const float speed)
{
    auto ret = OH_LowPowerVideoSink_SetPlaybackSpeed(lppVideoStreamer_, speed);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::Release()
{
    Stop();
    Destroy();
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t LppVideoStreamer::RenderFirstFrame()
{
    auto ret = OH_LowPowerVideoSink_RenderFirstFrame(lppVideoStreamer_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed.");
    return AVCODEC_SAMPLE_ERR_OK;
}

