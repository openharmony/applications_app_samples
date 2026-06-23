//
// Created on 2025/2/26.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

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
    
    static void OnInterrupted(OH_LowPowerAudioSink *decoder, OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint, void *userData);
    
    static void OnDeviceChanged(OH_LowPowerAudioSink *decoder, OH_AudioStream_DeviceChangeReason reason, void *userData);
    
    static void OnEos(OH_LowPowerAudioSink *decoder, void * userData);
    
    //
    static void OnDataNeededVideo(OH_LowPowerVideoSink *streamer, OH_AVSamplesBuffer *framePacket, void *userData);
    
    static void OnAnchorUpdated(OH_LowPowerVideoSink *streamer, long *anchorPts, long *anchorClock, void *userData);
    
    static void OnError(OH_LowPowerVideoSink *streamer, OH_AVErrCode errCode, const char *errMsg, void *userData);
    
    static void OnTargetArrived(OH_LowPowerVideoSink *streamer, const long targetPts, const bool isTimeout, void *userData);
    
    static void OnRenderStarted(OH_LowPowerVideoSink *streamer, void *userData);
    
    static void OnEos(OH_LowPowerVideoSink *streamer, void *userData);
    
    static void OH_LowPowerVideoSink_OnStreamChanged(OH_LowPowerVideoSink *streamer, OH_AVFormat *format, void *userData);
    
};

#endif //AVCODECSAMPLE_MASTER_LPPCALLBACK_H
