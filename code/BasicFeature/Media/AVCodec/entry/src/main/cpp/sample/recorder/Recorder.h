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

#ifndef VIDEO_CODEC_SAMPLE_RECODER_H
#define VIDEO_CODEC_SAMPLE_RECODER_H

#include <bits/alltypes.h>
#include <mutex>
#include <memory>
#include <atomic>
#include <thread>
#include <unistd.h>
#include "video_encoder.h"
#include "muxer.h"
#include "sample_info.h"

class Recorder {
public:
    Recorder(){};
    ~Recorder();

    static Recorder &GetInstance()
    {
        static Recorder recorder;
        return recorder;
    }

    int32_t Init(SampleInfo &sampleInfo);
    int32_t Start();
    int32_t Stop();

private:
    void EncOutputThread();
    void Release();
    void StartRelease();
    int32_t WaitForDone();

    std::unique_ptr<VideoEncoder> videoEncoder_ = nullptr;
    std::unique_ptr<Muxer> muxer_ = nullptr;

    std::mutex mutex_;
    std::atomic<bool> isStarted_{false};
    std::unique_ptr<std::thread> encOutputThread_ = nullptr;
    std::unique_ptr<std::thread> releaseThread_ = nullptr;
    std::condition_variable doneCond_;
    SampleInfo sampleInfo_;
    CodecUserData *encContext_ = nullptr;
};

#endif // VIDEO_CODEC_SAMPLE_RECODER_H
