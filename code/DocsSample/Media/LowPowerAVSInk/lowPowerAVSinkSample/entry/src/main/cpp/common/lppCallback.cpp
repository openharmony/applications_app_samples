/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 */
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

#include "av_codec_sample_log.h"
#include "lppCallback.h"
#include "sample_info.h"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
}

#undef LOG_TAG
#define LOG_TAG "lppcallback"

void LppCallback::OnDataNeeded(OH_LowPowerAudioSink *decoder, OH_AVSamplesBuffer *framePacket, void *userData)
{
//     AVCODEC_SAMPLE_LOGI("OnDataNeeded");
    LppUserData *lppUserData = static_cast<LppUserData *>(userData);
    std::unique_lock<std::mutex> lock(lppUserData->inputMutex);
    if(lppUserData->framePacket_==nullptr)
        {
//             AVCODEC_SAMPLE_LOGI("ggggfd");
        }
    lppUserData->framePacket_ = framePacket;
    if(lppUserData->framePacket_==nullptr)
    {
//         AVCODEC_SAMPLE_LOGI("ggdfsd");
    }
    lppUserData->count++;
    lppUserData->returnFrame = true;
    lppUserData->inputCond.notify_all();
    lock.unlock();
}

void LppCallback::OnPositionUpdated(OH_LowPowerAudioSink *decoder, long currentPosition, void *userData)
{
    AVCODEC_SAMPLE_LOGI("currentPosition %{public}ld",currentPosition);
    LppUserData *lppUserData = static_cast<LppUserData *>(userData);
    std::unique_lock<std::mutex> lock(lppUserData->inputMutex);
    lppUserData->position = currentPosition;
    lock.unlock();
}

void LppCallback::OnError(OH_LowPowerAudioSink *decoder, OH_AVErrCode errCode, const char *errorMsg, void *userData)
{
    AVCODEC_SAMPLE_LOGI("errCode %{public}d",errCode);
}

void LppCallback::OnInterrupted(OH_LowPowerAudioSink *decoder, OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint, void *userData)
{
    AVCODEC_SAMPLE_LOGI("callback OnInterrupted %{public}d", type);
    LppUserData *lppUserData = static_cast<LppUserData *>(userData);
    std::unique_lock<std::mutex> lock(lppUserData->inputMutex);
    lppUserData->audioCallback(lppUserData->audioCallbackData);
    lock.unlock();
    
}
    
void LppCallback::OnDeviceChanged(OH_LowPowerAudioSink *decoder, OH_AudioStream_DeviceChangeReason reason, void *userData)
{
    AVCODEC_SAMPLE_LOGI("reason %{public}d",reason);
}
    
void LppCallback::OnEos(OH_LowPowerAudioSink *decoder, void * userData)
{
//     AVCODEC_SAMPLE_LOGI("reason %{public}d",reason);
}

void LppCallback::OnDataNeededVideo(OH_LowPowerVideoSink *streamer, OH_AVSamplesBuffer *framePacket, void *userData)
{
    AVCODEC_SAMPLE_LOGI("OH_LowPowerVideoSink OnDataNeeded");
    LppUserData *lppUserData = static_cast<LppUserData *>(userData);
    std::unique_lock<std::mutex> lock(lppUserData->inputMutex);
    if(lppUserData->framePacket_==nullptr)
        {
//             AVCODEC_SAMPLE_LOGI("ggggfd");
        }
    lppUserData->framePacket_ = framePacket;
    if(lppUserData->framePacket_==nullptr)
    {
//         AVCODEC_SAMPLE_LOGI("ggdfsd");
    }
//     AVCODEC_SAMPLE_LOGI("OH_LowPowerVideoSink OnDataNeeded");
    lppUserData->count++;
    lppUserData->returnFrame = true;
    lppUserData->inputCond.notify_all();
//     AVCODEC_SAMPLE_LOGI("OH_LowPowerVideoSink OnDataNeeded notify");
//     AVCODEC_SAMPLE_LOGI("OH_LowPowerVideoSink num %{public}d",lppUserData->num);
}
    
void LppCallback::OnAnchorUpdated(OH_LowPowerVideoSink *streamer, long *anchorPts, long *anchorClock, void *userData)
{
    
}
    
void LppCallback::OnError(OH_LowPowerVideoSink *streamer, OH_AVErrCode errCode, const char *errMsg, void *userData)
{
    AVCODEC_SAMPLE_LOGI("errCode %{public}d",errCode);
}
    
void LppCallback::OnTargetArrived(OH_LowPowerVideoSink *streamer, const long targetPts, const bool isTimeout, void *userData)
{
    LppUserData *lppUserData = static_cast<LppUserData *>(userData);
    std::unique_lock<std::mutex> lock(lppUserData->seekMutex_);
    AVCODEC_SAMPLE_LOGI("OnTargetArrived accSeek");
    if(isTimeout){
        AVCODEC_SAMPLE_LOGI("OnTargetArrived timeout");
    }
    lppUserData->inputCond.notify_all();
}

void LppCallback::OH_LowPowerVideoSink_OnStreamChanged(OH_LowPowerVideoSink *streamer, OH_AVFormat *format, void *userData)
{
    if(format == nullptr){
        AVCODEC_SAMPLE_LOGI("OnOutputFormatChanged format nullptr");
        return;
    }
    int32_t width = 0;
    OH_AVFormat_GetIntValue(format, "video_picture_width", &width);
    int32_t height = 0;
    OH_AVFormat_GetIntValue(format, "video_picture_height", &height);
    AVCODEC_SAMPLE_LOGI("OnOutputFormatChanged width= %{public}d height= %{public}d",width, height);
}
    
void LppCallback::OnRenderStarted(OH_LowPowerVideoSink *streamer, void *userData)
{
    
}
    
void LppCallback::OnEos(OH_LowPowerVideoSink *streamer, void *userData)
{
    
}


