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
#include "lpp_audio_streamer.h"
#include "lpp_video_streamer.h"
#include "multimedia/player_framework/native_avbuffer.h"
#include "demuxer.h"
#include "sample_info.h"
#include "plugin_manager.h"
enum AVSinkState {
    IDLE,
    INIT,
    PREPARED,
    PLAYING,
    PAUSE,
    STOP, 
};
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
    int32_t Stop();
    int32_t Reset();
    int32_t Pause();
    int32_t Resume();
    int32_t SetSpeed(double speed);
    int32_t SetSurface(int64_t surfaceId);
    int32_t SetVolume(double volume);
    int32_t Flush();
    int32_t Seek(int64_t seekTime, int32_t mode, bool acc);
    int32_t Prepare();
    int32_t StartDecoder();
    int32_t RenderFirstFrame();
    int32_t StartRender();
    int32_t StartAudio();
    void Release();
    void StartRelease();
    int64_t GetDurationTime();
    int64_t GetProgressTime();

private:
    void LppDataNeededThread1();
    void LppVideoDataNeededThread();
    void SeekInner(int64_t seekTime, int32_t mode);
    void ReleaseThread();
    int32_t CreateLppAudioStreamer();
    int32_t CreateLppVideoStreamer();
    bool Intercept();
    
    int64_t ReadToAudioTargetPts(int64_t pts);
    
    std::shared_ptr<LppAudioStreamer> lppAudioStreamer_ = nullptr;
    std::shared_ptr<LppVideoStreamer> lppVideoStreamer_ = nullptr;
    std::unique_ptr<Demuxer> demuxer_ = nullptr;
    
    std::mutex mutex_;
    std::atomic<bool> isStarted_ { false };
    std::atomic<bool> isReleased_ { false };
    std::atomic<bool> isAudioDone { false };
    std::atomic<bool> isVideoDone { false };
    std::condition_variable doneCond_;
    std::mutex doneMutex;
    SampleInfo sampleInfo_;
    
    LppUserData *lppContext_ = nullptr;
    // 等回调消费数据
    std::unique_ptr<std::thread> LppDataNeededThread_ = nullptr;
    // 生产数据，Max
    std::unique_ptr<std::thread> LppDataProducerThread_ = nullptr;
    
    LppUserData *lppVideoContext_ = nullptr;
    std::unique_ptr<std::thread> lppVideoDataNeededThread_ = nullptr;
    std::unique_ptr<std::thread> lppSeekThread_ = nullptr;
    
    int64_t progress = 0;
    int64_t nowTimeStamp = 0;
    int64_t audioTimeStamp = 0;
    int64_t writtenSampleCnt = 0;
    int64_t audioBufferPts = 0;
    std::mutex SeekMutex;
    OH_AVBuffer *audioBuffer_ = nullptr;
    OH_AVBuffer *videoBuffer_ = nullptr;
    std::queue<CodecBufferInfo> videoBufferInfo_;
    bool seekFlag_ = false;
    AVSinkState state_ = IDLE;
    static constexpr int64_t MICROSECOND_TO_S = 1000000;
    static constexpr int64_t NANO_TO_S = 1000000000;
};

#endif // VIDEO_CODEC_PLAYER_H