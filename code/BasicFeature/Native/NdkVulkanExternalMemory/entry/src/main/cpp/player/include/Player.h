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

#ifndef VULKAN_PLAYER_H
#define VULKAN_PLAYER_H

#include <mutex>
#include <memory>
#include <atomic>
#include <thread>
#include "Demuxer.h"
#include "VideoDecoder.h"
#include "SampleInfo.h"

namespace {
constexpr int BALANCE_VALUE = 2;
using namespace std::chrono_literals;
} // namespace

enum AVCodecSampleError : int {
    AVCODEC_SAMPLE_ERR_OK = 0,
    AVCODEC_SAMPLE_ERR_ERROR = -1,
};

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
    void Stop();
private:
    void VideoDecInputThread();
    void VideoDecOutputThread();
    void Release();
    void StartRelease();
    void ReleaseThread();
    int32_t CreateVideoDecoder();

    std::unique_ptr<VideoDecoder> videoDecoder_ = nullptr;
    std::unique_ptr<Demuxer> demuxer_ = nullptr;

    std::mutex mutex_;
    std::mutex doneMutex;
    std::atomic<bool> isStarted_{false};
    std::atomic<bool> isReleased_{false};
    std::unique_ptr<std::thread> videoDecInputThread_ = nullptr;
    std::unique_ptr<std::thread> videoDecOutputThread_ = nullptr;
    std::condition_variable doneCond_;
    SampleInfo sampleInfo_;
    CodecUserData *videoDecContext_ = nullptr;
    static constexpr int64_t MICROSECOND = 1000000;
};

#endif //VULKAN_PLAYER_H
