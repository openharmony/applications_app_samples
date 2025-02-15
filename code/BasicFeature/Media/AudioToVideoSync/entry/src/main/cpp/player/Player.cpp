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

#include "Player.h"
#include <cstdint>
#include <queue>
#include "AVCodecSampleLog.h"
#include "dfx/error/AVCodecSampleError.h"

#undef LOG_TAG
#define LOG_TAG "player"

namespace {
constexpr int BALANCE_VALUE = 5;
constexpr int64_t WAIT_TIME_US_THRESHOLD_WARNING = -1 * 40 * 1000; // warning threshold 40ms
constexpr int64_t WAIT_TIME_US_THRESHOLD = 1 * 1000 * 1000;        // max sleep time 1s
constexpr int64_t PER_SINK_TIME_THRESHOLD = 33 * 1000;             // max per sink time 33ms
constexpr int64_t SINK_TIME_US_THRESHOLD = 100000;                 // max sink time 100ms
constexpr int64_t NANOSECONDS_PER_SECOND = 1000000000;             // nano seconds to second
constexpr int32_t BYTES_PER_SAMPLE_2 = 2;                          // 2 bytes per sample
using namespace std::chrono_literals;
} // namespace

Player::~Player() { Player::StartRelease(); }

int32_t Player::CreateAudioDecoder()
{
    AVCODEC_SAMPLE_LOGW("audio mime:%{public}s", sampleInfo.audioCodecMime.c_str());
    int32_t ret = audioDecoder->Create(sampleInfo.audioCodecMime);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create audio decoder failed, mime:%{public}s", sampleInfo.audioCodecMime.c_str());
    } else {
        audioDecContext = new CodecUserData;
        ret = audioDecoder->Config(sampleInfo, audioDecContext);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Audio Decoder config failed");
        OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_RENDERER);
        OH_AudioStreamBuilder_SetLatencyMode(builder, AUDIOSTREAM_LATENCY_MODE_NORMAL);
        // Set the audio sample rate
        OH_AudioStreamBuilder_SetSamplingRate(builder, sampleInfo.audioSampleRate);
        // Set the audio channel
        OH_AudioStreamBuilder_SetChannelCount(builder, sampleInfo.audioChannelCount);
        // Set the audio sample format
        OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
        // Sets the encoding type of the audio stream
        OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
        // Set the working scenario for the output audio stream
        OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);
        AVCODEC_SAMPLE_LOGW("Init audioSampleRate: %{public}d, ChannelCount: %{public}d", sampleInfo.audioSampleRate,
                            sampleInfo.audioChannelCount);
        OH_AudioRenderer_Callbacks callbacks;
        // Configure the callback function
        callbacks.OH_AudioRenderer_OnWriteData = SampleCallback::OnRenderWriteData;
        callbacks.OH_AudioRenderer_OnStreamEvent = SampleCallback::OnRenderStreamEvent;
        callbacks.OH_AudioRenderer_OnInterruptEvent = SampleCallback::OnRenderInterruptEvent;
        callbacks.OH_AudioRenderer_OnError = SampleCallback::OnRenderError;
        // Set the callback for the output audio stream
        OH_AudioStreamBuilder_SetRendererCallback(builder, callbacks, audioDecContext);
        OH_AudioStreamBuilder_GenerateRenderer(builder, &audioRenderer);
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::CreateVideoDecoder()
{
    AVCODEC_SAMPLE_LOGW("video mime:%{public}s", sampleInfo.videoCodecMime.c_str());
    int32_t ret = videoDecoder->Create(sampleInfo.videoCodecMime);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGW("Create video decoder failed, mime:%{public}s", sampleInfo.videoCodecMime.c_str());
    } else {
        videoDecContext = new CodecUserData;
        sampleInfo.window = NativeXComponentSample::PluginManager::GetInstance()->pluginWindow_;
        ret = videoDecoder->Config(sampleInfo, videoDecContext);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Video Decoder config failed");
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::Init(SampleInfo &info)
{
    std::lock_guard<std::mutex> lock(mutex);
    CHECK_AND_RETURN_RET_LOG(!isStarted, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    CHECK_AND_RETURN_RET_LOG(demuxer == nullptr && videoDecoder == nullptr && audioDecoder == nullptr,
                             AVCODEC_SAMPLE_ERR_ERROR, "Already started.");

    sampleInfo = info;

    videoDecoder = std::make_unique<VideoDecoder>();
    audioDecoder = std::make_unique<AudioDecoder>();
    demuxer = std::make_unique<Demuxer>();

    int32_t ret = demuxer->Create(sampleInfo);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Create demuxer failed");

    ret = CreateAudioDecoder();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Create audio decoder failed");

    ret = CreateVideoDecoder();
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Create video decoder failed");

    if (audioDecContext != nullptr) {
        audioDecContext->sampleInfo = &sampleInfo;
    }

    isReleased = false;
    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::Start()
{
    std::lock_guard<std::mutex> lock(mutex);
    int32_t ret;
    CHECK_AND_RETURN_RET_LOG(!isStarted, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    CHECK_AND_RETURN_RET_LOG(demuxer != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    if (videoDecContext) {
        ret = videoDecoder->Start();
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Video Decoder start failed");
        isStarted = true;
        videoDecInputThread = std::make_unique<std::thread>(&Player::VideoDecInputThread, this);
        videoDecOutputThread = std::make_unique<std::thread>(&Player::VideoDecOutputThread, this);

        if (videoDecInputThread == nullptr || videoDecOutputThread == nullptr) {
            AVCODEC_SAMPLE_LOGE("Create thread failed");
            StartRelease();
            return AVCODEC_SAMPLE_ERR_ERROR;
        }
    }
    if (audioDecContext) {
        ret = audioDecoder->Start();
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Audio Decoder start failed");
        isStarted = true;
        audioDecInputThread = std::make_unique<std::thread>(&Player::AudioDecInputThread, this);
        audioDecOutputThread = std::make_unique<std::thread>(&Player::AudioDecOutputThread, this);
        if (audioDecInputThread == nullptr || audioDecOutputThread == nullptr) {
            AVCODEC_SAMPLE_LOGE("Create thread failed");
            StartRelease();
            return AVCODEC_SAMPLE_ERR_ERROR;
        }
        // Clear the queue
        while (audioDecContext && !audioDecContext->renderQueue.empty()) {
            audioDecContext->renderQueue.pop();
        }
        if (audioRenderer) {
            OH_AudioRenderer_Start(audioRenderer);
        }
    }
    AVCODEC_SAMPLE_LOGI("Succeed");
    doneCond.notify_all();
    return AVCODEC_SAMPLE_ERR_OK;
}

void Player::SetSpeed(float newSpeed)
{
    if (this->speed == newSpeed) {
        AVCODEC_SAMPLE_LOGE("Same speed value");
        return;
    }

    OH_AudioRenderer_SetSpeed(audioRenderer, newSpeed);
    this->speed = newSpeed;
    audioDecContext->speed = newSpeed;
}

void Player::StartRelease()
{
    if (audioRenderer) {
        OH_AudioRenderer_Stop(audioRenderer);
    }
    if (!isReleased) {
        isReleased = true;
        Release();
    }
}

void Player::ReleaseThread()
{
    if (videoDecInputThread && videoDecInputThread->joinable()) {
        videoDecInputThread->detach();
        videoDecInputThread.reset();
    }
    if (videoDecOutputThread && videoDecOutputThread->joinable()) {
        videoDecOutputThread->detach();
        videoDecOutputThread.reset();
    }
    if (audioDecInputThread && audioDecInputThread->joinable()) {
        audioDecInputThread->detach();
        audioDecInputThread.reset();
    }
    if (audioDecOutputThread && audioDecOutputThread->joinable()) {
        audioDecOutputThread->detach();
        audioDecOutputThread.reset();
    }
}

void Player::Release()
{
    std::lock_guard<std::mutex> lock(mutex);
    isStarted = false;

    // Clear the queue
    while (audioDecContext && !audioDecContext->renderQueue.empty()) {
        audioDecContext->renderQueue.pop();
    }
    if (audioRenderer != nullptr) {
        OH_AudioRenderer_Release(audioRenderer);
        audioRenderer = nullptr;
    }
    ReleaseThread();

    if (demuxer != nullptr) {
        demuxer->Release();
        demuxer.reset();
    }
    if (videoDecoder != nullptr) {
        videoDecoder->Release();
        videoDecoder.reset();
    }
    if (videoDecContext != nullptr) {
        delete videoDecContext;
        videoDecContext = nullptr;
    }
    if (audioDecoder != nullptr) {
        audioDecoder->Release();
        audioDecoder.reset();
    }
    if (audioDecContext != nullptr) {
        delete audioDecContext;
        audioDecContext = nullptr;
    }
    if (builder != nullptr) {
        OH_AudioStreamBuilder_Destroy(builder);
        builder = nullptr;
    }
    doneCond.notify_all();
    // Trigger the callback
    sampleInfo.playDoneCallback(sampleInfo.playDoneCallbackData);
    AVCODEC_SAMPLE_LOGI("Succeed");
}

void Player::VideoDecInputThread()
{
    while (isStarted) {
        CHECK_AND_BREAK_LOG(isStarted, "Decoder input thread out");
        std::unique_lock<std::mutex> lock(videoDecContext->inputMutex);
        bool condRet = videoDecContext->inputCond.wait_for(
            lock, 5s, [this]() { return !isStarted || !videoDecContext->inputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted, "Work done, thread out");
        CHECK_AND_CONTINUE_LOG(!videoDecContext->inputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = videoDecContext->inputBufferInfoQueue.front();
        videoDecContext->inputBufferInfoQueue.pop();
        videoDecContext->inputFrameCount++;
        lock.unlock();

        demuxer->ReadSample(demuxer->GetVideoTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                            bufferInfo.attr);

        int32_t ret = videoDecoder->PushInputBuffer(bufferInfo);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Push data failed, thread out");

        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
    }
}

bool Player::ProcessWaitTime(int64_t &waitTimeUs)
{
    bool dropFrame = false;
    // video buffer is too late, drop it
    if (waitTimeUs < WAIT_TIME_US_THRESHOLD_WARNING) {
        dropFrame = true;
        AVCODEC_SAMPLE_LOGE("VD buffer is too late");
    } else {
        AVCODEC_SAMPLE_LOGE("VD buffer is too early waitTimeUs: %{public}ld", waitTimeUs);
        // [0, ), render it with waitTimeUs, max 1s
        // [-40,0), render it
        if (waitTimeUs > WAIT_TIME_US_THRESHOLD) {
            waitTimeUs = WAIT_TIME_US_THRESHOLD;
        }
        // per frame render time reduced by 33ms
        if (waitTimeUs > sampleInfo.frameInterval + PER_SINK_TIME_THRESHOLD) {
            waitTimeUs = sampleInfo.frameInterval + PER_SINK_TIME_THRESHOLD;
            AVCODEC_SAMPLE_LOGE("VD buffer is too early and reduced 33ms, waitTimeUs: %{public}ld", waitTimeUs);
        }
    }
    if (waitTimeUs > 0) {
        std::this_thread::sleep_for(std::chrono::microseconds(waitTimeUs));
    }
    return dropFrame;
}

void Player::VideoDecOutputThread()
{
    sampleInfo.frameInterval = kMicrosecond / sampleInfo.frameRate;
    while (isStarted) {
        thread_local auto lastPushTime = std::chrono::system_clock::now();
        CHECK_AND_BREAK_LOG(isStarted, "VD Decoder output thread out");
        std::unique_lock<std::mutex> lock(videoDecContext->outputMutex);
        bool condRet = videoDecContext->outputCond.wait_for(
            lock, 5s, [this]() { return !isStarted || !videoDecContext->outputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted, "VD Decoder output thread out");
        CHECK_AND_CONTINUE_LOG(!videoDecContext->outputBufferInfoQueue.empty(),
                               "VD Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = videoDecContext->outputBufferInfoQueue.front();
        videoDecContext->outputBufferInfoQueue.pop();
        AVCODEC_SAMPLE_LOGI("VD bufferInfo.bufferIndex: %{public}d", bufferInfo.bufferIndex);
        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
        videoDecContext->outputFrameCount++;
        AVCODEC_SAMPLE_LOGW(
            "VD Out buffer count: %{public}u, size: %{public}d, flag: %{public}u, pts: %{public}" PRId64,
            videoDecContext->outputFrameCount, bufferInfo.attr.size, bufferInfo.attr.flags, bufferInfo.attr.pts);
        lock.unlock();

        // get audio render position
        int64_t framePosition = 0;
        int64_t timeStamp = 0;
        int32_t ret = OH_AudioRenderer_GetTimestamp(audioRenderer, CLOCK_MONOTONIC, &framePosition, &timeStamp);

        audioTimeStamp = timeStamp;

        // audio render getTimeStamp error, render it
        if (ret != AUDIOSTREAM_SUCCESS || (timeStamp == 0) || (framePosition == 0)) {
            // first frame, render without wait
            videoDecoder->FreeOutputBuffer(bufferInfo.bufferIndex, true);
            std::this_thread::sleep_until(lastPushTime + std::chrono::microseconds(sampleInfo.frameInterval));
            lastPushTime = std::chrono::system_clock::now();
            continue;
        }

        // after seek, audio render flush, framePosition = 0, then writtenSampleCnt = 0
        int64_t latency =
            (audioDecContext->frameWrittenForSpeed - framePosition) * 1000 * 1000 / sampleInfo.audioSampleRate / speed;
        AVCODEC_SAMPLE_LOGI("VD latency: %{public}ld writtenSampleCnt: %{public}ld", latency, writtenSampleCnt);

        nowTimeStamp = GetCurrentTime();
        int64_t anchorDiff = (nowTimeStamp - audioTimeStamp) / 1000;
        // us, audio buffer accelerate render time
        int64_t audioPlayedTime = audioDecContext->currentPosAudioBufferPts - latency + anchorDiff;
        // us, video buffer expected render time
        int64_t videoPlayedTime = bufferInfo.attr.pts;

        // audio render timeStamp and now timeStamp diff
        int64_t waitTimeUs = videoPlayedTime - audioPlayedTime;
        
        AVCODEC_SAMPLE_LOGI("VD audioPlayedTime: %{public}ld, videoPlayedTime: %{public}ld, nowTimeStamp: %{public}ld, "
                            "audioTimeStamp: %{public}ld, waitTimeUs: %{public}ld, anchorDiff: %{public}ld",
                            audioPlayedTime, videoPlayedTime, nowTimeStamp, audioTimeStamp, waitTimeUs, anchorDiff);

        bool dropFrame = ProcessWaitTime(waitTimeUs);
        lastPushTime = std::chrono::system_clock::now();
        ret = videoDecoder->FreeOutputBuffer(bufferInfo.bufferIndex, !dropFrame);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Decoder output thread out");
    }
    writtenSampleCnt = 0;
    audioBufferPts = 0;
    StartRelease();
}

int64_t Player::GetCurrentTime()
{
    int64_t result = -1; // -1 for bad result
    struct timespec time;
    clockid_t clockId = CLOCK_MONOTONIC;
    int ret = clock_gettime(clockId, &time);
    CHECK_AND_RETURN_RET_LOG(ret >= 0, result, "GetCurNanoTime fail, result: %{public}d", ret);
    result = (time.tv_sec * NANOSECONDS_PER_SECOND) + time.tv_nsec;
    return result;
}

void Player::AudioDecInputThread()
{
    while (isStarted) {
        CHECK_AND_BREAK_LOG(isStarted, "Decoder input thread out");
        std::unique_lock<std::mutex> lock(audioDecContext->inputMutex);
        bool condRet = audioDecContext->inputCond.wait_for(
            lock, 5s, [this]() { return !isStarted || !audioDecContext->inputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted, "Work done, thread out");
        CHECK_AND_CONTINUE_LOG(!audioDecContext->inputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = audioDecContext->inputBufferInfoQueue.front();
        audioDecContext->inputBufferInfoQueue.pop();
        audioDecContext->inputFrameCount++;
        lock.unlock();

        demuxer->ReadSample(demuxer->GetAudioTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                            bufferInfo.attr);

        int32_t ret = audioDecoder->PushInputBuffer(bufferInfo);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Push data failed, thread out");

        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
    }
}

void Player::AudioDecOutputThread()
{
    while (isStarted) {
        CHECK_AND_BREAK_LOG(isStarted, "Decoder output thread out");
        std::unique_lock<std::mutex> lock(audioDecContext->outputMutex);
        bool condRet = audioDecContext->outputCond.wait_for(
            lock, 5s, [this]() { return !isStarted || !audioDecContext->outputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted, "Decoder output thread out");
        CHECK_AND_CONTINUE_LOG(!audioDecContext->outputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = audioDecContext->outputBufferInfoQueue.front();
        audioDecContext->outputBufferInfoQueue.pop();
        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
        audioDecContext->outputFrameCount++;
        AVCODEC_SAMPLE_LOGW("Out buffer count: %{public}u, size: %{public}d, flag: %{public}u, pts: %{public}" PRId64,
                            audioDecContext->outputFrameCount, bufferInfo.attr.size, bufferInfo.attr.flags,
                            bufferInfo.attr.pts);
        uint8_t *source = OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
        // Put the decoded PMC data into the queue
        for (int i = 0; i < bufferInfo.attr.size; i++) {
            audioDecContext->renderQueue.push(*(source + i));
        }
        lock.unlock();

        int32_t ret = audioDecoder->FreeOutputBuffer(bufferInfo.bufferIndex, true);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Decoder output thread out");

        // SAMPLE_S16LE 2 bytes per frame
        // if set speed, cnt / speed
        writtenSampleCnt += (bufferInfo.attr.size / sampleInfo.audioChannelCount / BYTES_PER_SAMPLE_2);
        AVCODEC_SAMPLE_LOGI("writtenSampleCnt: %ld, bufferInfo.attr.size: %d, sampleInfo.audioChannelCount: %d",
                            writtenSampleCnt, bufferInfo.attr.size, sampleInfo.audioChannelCount);
        audioBufferPts = bufferInfo.attr.pts;
        audioDecContext->endPosAudioBufferPts = audioBufferPts;

        std::unique_lock<std::mutex> lockRender(audioDecContext->renderMutex);
        audioDecContext->renderCond.wait_for(lockRender, 20ms, [this, bufferInfo]() {
            return audioDecContext->renderQueue.size() < BALANCE_VALUE * bufferInfo.attr.size;
        });
    }
    AVCODEC_SAMPLE_LOGI("Out buffer end");
    StartRelease();
}