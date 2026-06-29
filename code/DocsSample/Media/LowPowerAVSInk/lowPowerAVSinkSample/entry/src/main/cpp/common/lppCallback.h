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

#ifndef AVCODECSAMPLE_MASTER_LPPCALLBACK_H
#define AVCODECSAMPLE_MASTER_LPPCALLBACK_H

#include <multimedia/player_framework/lowpower_avsink_base.h>
#include <multimedia/player_framework/lowpower_video_sink_base.h>
#include <multimedia/player_framework/lowpower_audio_sink_base.h>
class LppCallback {
public:
    static void OnDataNeeded(OH_LowPowerAudioSink *decoder, OH_AVSamplesBuffer *framePacket, void *userData);
    
    static void OnPositionUpdated(OH_LowPowerAudioSink *decoder, long currentPosition, void *userData);
    
    static void OnError(OH_LowPowerAudioSink *decoder, OH_AVErrCode errCode, const char *errorMsg, void *userData);
    
    static void OnInterrupted(OH_LowPowerAudioSink *decoder, OH_AudioInterrupt_ForceType type,
        OH_AudioInterrupt_Hint hint, void *userData);
    
    static void OnDeviceChanged(OH_LowPowerAudioSink *decoder, OH_AudioStream_DeviceChangeReason reason,
        void *userData);
    
    static void OnEos(OH_LowPowerAudioSink *decoder, void *userData);
    
    static void OnDataNeededVideo(OH_LowPowerVideoSink *streamer, OH_AVSamplesBuffer *framePacket, void *userData);
    
    static void OnAnchorUpdated(OH_LowPowerVideoSink *streamer, long *anchorPts, long *anchorClock, void *userData);
    
    static void OnError(OH_LowPowerVideoSink *streamer, OH_AVErrCode errCode, const char *errMsg, void *userData);
    
    static void OnTargetArrived(OH_LowPowerVideoSink *streamer, const long targetPts, const bool isTimeout,
        void *userData);
    
    static void OnRenderStarted(OH_LowPowerVideoSink *streamer, void *userData);
    
    static void OnEos(OH_LowPowerVideoSink *streamer, void *userData);
    
    static void OH_LowPowerVideoSink_OnStreamChanged(OH_LowPowerVideoSink *streamer, OH_AVFormat *format,
        void *userData);
};

#endif //AVCODECSAMPLE_MASTER_LPPCALLBACK_H
