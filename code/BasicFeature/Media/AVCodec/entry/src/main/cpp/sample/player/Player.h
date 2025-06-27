/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#ifndef VIDEO_CODEC_PLAYER_H
#define VIDEO_CODEC_PLAYER_H

#include <bits/alltypes.h>
#include <mutex>
#include <memory>
#include <atomic>
#include <thread>
#include <unistd.h>
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostreambuilder.h>
#include <fstream>
#include "video_decoder.h"
#include "audio_decoder.h"
#include "multimedia/player_framework/native_avbuffer.h"
#include "demuxer.h"
#include "sample_info.h"
#include "plugin_manager.h"

class Player {
public:
    Player(){};
    ~Player();
    
    static Player& GetInstance()
    {
        static Player player;
        return player;
    }

    int32_t Init(SampleInfo &sampleInfo);
    int32_t Start();
    void SetSpeed(float multiplier);

private:
    void VideoDecInputThread();
    void VideoDecOutputThread();
    void AudioDecInputThread();
    void AudioDecOutputThread();
    void Release();
    void StartRelease();
    void ReleaseThread();
    int32_t CreateAudioDecoder();
    int32_t CreateVideoDecoder();
    int64_t GetCurrentTime();
    void DumpOutput(CodecBufferInfo &bufferInfo);
    void WriteOutputFileWithStrideYUV420P(uint8_t *bufferAddr);
    void WriteOutputFileWithStrideYUV420SP(uint8_t *bufferAddr);
    void WriteOutputFileWithStrideRGBA(uint8_t *bufferAddr);
    int32_t HandleInitError(std::unique_lock<std::mutex>& outerLock);
    int32_t StartVideoDecoder();
    int32_t StartAudioDecoder();
    void CleanupAfterStartFailure();
    bool ProcessAudioOutput(CodecBufferInfo &bufferInfo);
    bool ProcessVideoWithoutAudio(CodecBufferInfo& bufferInfo,
        std::chrono::time_point<std::chrono::system_clock>& lastPushTime);
    bool ProcessVideoWithAudio(CodecBufferInfo& bufferInfo,
        std::chrono::time_point<std::chrono::system_clock>& lastPushTime, int64_t perSinkTimeThreshold);
    bool CalculateSyncParameters(CodecBufferInfo& bufferInfo, int64_t framePosition,
                                     int64_t& waitTimeUs, bool& dropFrame,
                                     int64_t perSinkTimeThreshold);
    bool RenderAndRelease(CodecBufferInfo& bufferInfo, int64_t waitTimeUs, bool dropFrame);

    std::unique_ptr<std::ofstream> outputFile_ = nullptr;
    std::unique_ptr<VideoDecoder> videoDecoder_ = nullptr;
    std::shared_ptr<AudioDecoder> audioDecoder_ = nullptr;
    std::unique_ptr<Demuxer> demuxer_ = nullptr;
    
    std::mutex mutex_;
    std::atomic<bool> isStarted_ { false };
    std::atomic<bool> isReleased_ { false };
    std::atomic<bool> isAudioDone { false };
    std::atomic<bool> isVideoDone { false };
    std::unique_ptr<std::thread> videoDecInputThread_ = nullptr;
    std::unique_ptr<std::thread> videoDecOutputThread_ = nullptr;
    std::unique_ptr<std::thread> audioDecInputThread_ = nullptr;
    std::unique_ptr<std::thread> audioDecOutputThread_ = nullptr;
    std::condition_variable doneCond_;
    std::mutex doneMutex;
    SampleInfo sampleInfo_;
    CodecUserData *videoDecContext_ = nullptr;
    CodecUserData *audioDecContext_ = nullptr;
    OH_AudioStreamBuilder* builder_ = nullptr;
    OH_AudioRenderer* audioRenderer_ = nullptr;
    
    int64_t nowTimeStamp = 0;
    int64_t audioTimeStamp = 0;
    int64_t writtenSampleCnt = 0;
    int64_t audioBufferPts = 0;
#ifdef DEBUG_DECODE
    std::ofstream audioOutputFile_; // for debug
#endif
    float speed = 1.0f;
};

#endif // VIDEO_CODEC_PLAYER_H