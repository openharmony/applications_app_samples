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
#include "VideoDecoder.h"
#include "AudioDecoder.h"
#include "multimedia/player_framework/native_avbuffer.h"
#include "Demuxer.h"
#include "SampleInfo.h"
#include "PluginManager.h"

class Player {
public:
    Player(){};
    ~Player();

    static Player &GetInstance()
    {
        static Player player;
        return player;
    }

    int32_t Init(SampleInfo &sampleInfo);
    int32_t Start();
    void SetSpeed(float speed);

private:
    void VideoDecInputThread();
    void VideoDecOutputThread();
    void AudioDecInputThread();
    void AudioDecOutputThread();
    bool ProcessWaitTime(int64_t& waitTimeUs);
    void Release();
    void StartRelease();
    void ReleaseThread();
    
    int32_t CreateAudioDecoder();
    int32_t CreateVideoDecoder();
    int64_t GetCurrentTime();
    std::unique_ptr<VideoDecoder> videoDecoder = nullptr;
    std::shared_ptr<AudioDecoder> audioDecoder = nullptr;
    std::unique_ptr<Demuxer> demuxer = nullptr;

    std::mutex mutex;
    std::atomic<bool> isStarted{false};
    std::atomic<bool> isReleased{false};
    std::unique_ptr<std::thread> videoDecInputThread = nullptr;
    std::unique_ptr<std::thread> videoDecOutputThread = nullptr;
    std::unique_ptr<std::thread> audioDecInputThread = nullptr;
    std::unique_ptr<std::thread> audioDecOutputThread = nullptr;
    std::condition_variable doneCond;
    SampleInfo sampleInfo;
    CodecUserData *videoDecContext = nullptr;
    CodecUserData *audioDecContext = nullptr;
    OH_AudioStreamBuilder *builder = nullptr;
    OH_AudioRenderer *audioRenderer = nullptr;
    
    int64_t nowTimeStamp = 0;
    int64_t audioTimeStamp = 0;
    int64_t writtenSampleCnt = 0;
    int64_t audioBufferPts = 0;
    static constexpr int64_t kMicrosecond = 1000000;
    
    float speed = 1.0f;
};

#endif // VIDEO_CODEC_PLAYER_H