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

#include "Recorder.h"
#include <bits/alltypes.h>
#include "av_codec_sample_log.h"
#include "dfx/error/av_codec_sample_error.h"

#undef LOG_TAG
#define LOG_TAG "recorder"

namespace {
using namespace std::chrono_literals;
constexpr int64_t MICROSECOND = 1000000;
}

Recorder::~Recorder() { StartRelease(); }

int32_t Recorder::Init(SampleInfo &sampleInfo)
{
    std::lock_guard<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!isStarted_, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    CHECK_AND_RETURN_RET_LOG(videoEncoder_ == nullptr && muxer_ == nullptr,
                             AVCODEC_SAMPLE_ERR_ERROR, "Already started.");

    sampleInfo_ = sampleInfo;

    videoEncoder_ = std::make_unique<VideoEncoder>();
    muxer_ = std::make_unique<Muxer>();
    
    int32_t ret = videoEncoder_->Create(sampleInfo_.videoCodecMime);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Create video encoder failed");
    ret = muxer_->Create(sampleInfo_.outputFd);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Create muxer with fd(%{public}d) failed",
                             sampleInfo_.outputFd);

    encContext_ = new CodecUserData;
    encContext_->isEncFirstFrame = true;
    ret = videoEncoder_->Config(sampleInfo_, encContext_);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Encoder config failed");

    ret = muxer_->Config(sampleInfo_);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Recorder muxer config failed");
    
    sampleInfo.window = sampleInfo_.window;

    releaseThread_ = nullptr;
    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Recorder::Start()
{
    std::lock_guard<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!isStarted_, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    CHECK_AND_RETURN_RET_LOG(encContext_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR,
                             "Already started.");
    CHECK_AND_RETURN_RET_LOG(videoEncoder_ != nullptr && muxer_ != nullptr,
                             AVCODEC_SAMPLE_ERR_ERROR, "Already started.");

    int32_t ret = muxer_->Start();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Muxer start failed");
    ret = videoEncoder_->Start();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Encoder start failed");

    isStarted_ = true;
    encOutputThread_ = std::make_unique<std::thread>(&Recorder::EncOutputThread, this);
    if (encOutputThread_ == nullptr) {
        AVCODEC_SAMPLE_LOGE("Create thread failed");
        StartRelease();
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

void Recorder::EncOutputThread()
{
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Work done, thread out");
        std::unique_lock<std::mutex> lock(encContext_->outputMutex);
        bool condRet = encContext_->outputCond.wait_for(
            lock, 5s, [this]() { return !isStarted_ || !encContext_->outputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted_, "Work done, thread out");
        CHECK_AND_CONTINUE_LOG(!encContext_->outputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = encContext_->outputBufferInfoQueue.front();
        encContext_->outputBufferInfoQueue.pop();
        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
        lock.unlock();
        if ((bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_SYNC_FRAME) ||
                (bufferInfo.attr.flags == AVCODEC_BUFFER_FLAGS_NONE)) {
                    encContext_->outputFrameCount++;
                    bufferInfo.attr.pts = encContext_->outputFrameCount * MICROSECOND / sampleInfo_.frameRate;
        } else {
            bufferInfo.attr.pts = 0;
        }

        AVCODEC_SAMPLE_LOGW("Out buffer count: %{public}u, size: %{public}d, flag: %{public}u, pts: %{public}" PRId64,
                            encContext_->outputFrameCount, bufferInfo.attr.size, bufferInfo.attr.flags,
                            bufferInfo.attr.pts);

        muxer_->WriteSample(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer), bufferInfo.attr);
        int32_t ret = videoEncoder_->FreeOutputBuffer(bufferInfo.bufferIndex);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Encoder output thread out");
    }
    AVCODEC_SAMPLE_LOGI("Exit, frame count: %{public}u", encContext_->outputFrameCount);
    StartRelease();
}

void Recorder::StartRelease()
{
    if (releaseThread_ == nullptr) {
        AVCODEC_SAMPLE_LOGI("Start release CodecTest");
        releaseThread_ = std::make_unique<std::thread>(&Recorder::Release, this);
    }
}

void Recorder::Release()
{
    std::lock_guard<std::mutex> lock(mutex_);
    isStarted_ = false;
    if (encOutputThread_ && encOutputThread_->joinable()) {
        encOutputThread_->join();
        encOutputThread_.reset();
    }
    if (muxer_ != nullptr) {
        muxer_->Release();
        muxer_.reset();
        AVCODEC_SAMPLE_LOGI("Muxer release successful");
    }
    if (videoEncoder_ != nullptr) {
        videoEncoder_->Stop();
        if (sampleInfo_.window != nullptr) {
            OH_NativeWindow_DestroyNativeWindow(sampleInfo_.window);
            sampleInfo_.window = nullptr;
        }
        videoEncoder_->Release();
        videoEncoder_.reset();
        AVCODEC_SAMPLE_LOGI("Video encoder release successful");
    }
    
    if (encContext_ != nullptr) {
        delete encContext_;
        encContext_ = nullptr;
    }
    doneCond_.notify_all();
    AVCODEC_SAMPLE_LOGI("Succeed");
}

int32_t Recorder::WaitForDone()
{
    AVCODEC_SAMPLE_LOGI("Wait called");
    std::unique_lock<std::mutex> lock(mutex_);
    doneCond_.wait(lock);
    if (releaseThread_ && releaseThread_->joinable()) {
        releaseThread_->join();
        releaseThread_.reset();
    }
    AVCODEC_SAMPLE_LOGI("Done");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Recorder::Stop()
{
    if (isStarted_) {
        int32_t ret = videoEncoder_->NotifyEndOfStream();
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Encoder notifyEndOfStream failed");
    } else {
        StartRelease();
    }
    return WaitForDone();
}