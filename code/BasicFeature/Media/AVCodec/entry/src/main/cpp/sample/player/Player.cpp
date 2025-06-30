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

#include "Player.h"
#include "av_codec_sample_log.h"
#include "dfx/error/av_codec_sample_error.h"
#include <bits/alltypes.h>
#include <netinet/tcp.h>
#include <queue>

#undef LOG_TAG
#define LOG_TAG "samplePlayer"

namespace {
constexpr int BALANCE_VALUE = 5;
using namespace std::string_literals;
using namespace std::chrono_literals;
static const int MS_TO_S = 1000;
constexpr int64_t WAIT_TIME_US_THRESHOLD_WARNING = -1 * 40 * 1000; // warning threshold 40ms
constexpr int64_t WAIT_TIME_US_THRESHOLD = 1 * 1000 * 1000;        // max sleep time 1s
constexpr int64_t SINK_TIME_US_THRESHOLD = 100000;                 // max sink time 100ms
constexpr int32_t BYTES_PER_SAMPLE_2 = 2;                          // 2 bytes per sample
constexpr double VSYNC_TIME = 1000 / 60;                           // frame time
constexpr double LIP_SYNC_BALANCE_VALUE = 2;                       // the balance value of sync sound and picture
constexpr int8_t YUV420_SAMPLE_RATIO = 2;
constexpr int32_t TRIPLE_SPEED_MULTIPLIER = 3;
constexpr int32_t DOUBLE_SPEED_MULTIPLIER = 2;
constexpr int64_t MICROSECOND_TO_S = 1000000;
constexpr int64_t NANO_TO_S = 1000000000;

std::string ToString(OH_AVPixelFormat pixelFormat)
{
    std::string ret;
    auto iter = PIXEL_FORMAT_TO_STRING.find(pixelFormat);
    if (iter != PIXEL_FORMAT_TO_STRING.end()) {
        ret = PIXEL_FORMAT_TO_STRING.at(pixelFormat);
    }
    return ret;
}
} // namespace

Player::~Player() { Player::StartRelease(); }

int32_t Player::CreateAudioDecoder()
{
    AVCODEC_SAMPLE_LOGW("audio mime:%{public}s", sampleInfo_.audioCodecMime.c_str());
    int32_t ret = audioDecoder_->Create(sampleInfo_.audioCodecMime);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        isAudioDone.store(true);
        AVCODEC_SAMPLE_LOGE("Create audio decoder failed, mime:%{public}s", sampleInfo_.audioCodecMime.c_str());
    } else {
        audioDecContext_ = new CodecUserData;
        ret = audioDecoder_->Config(sampleInfo_, audioDecContext_);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Audio Decoder config failed");
        OH_AudioStreamBuilder_Create(&builder_, AUDIOSTREAM_TYPE_RENDERER);
        OH_AudioStreamBuilder_SetLatencyMode(builder_, AUDIOSTREAM_LATENCY_MODE_NORMAL);
        // 设置音频采样率
        OH_AudioStreamBuilder_SetSamplingRate(builder_, sampleInfo_.audioSampleRate);
        // 设置音频声道
        OH_AudioStreamBuilder_SetChannelCount(builder_, sampleInfo_.audioChannelCount);
        // 设置音频采样格式
        OH_AudioStreamBuilder_SetSampleFormat(builder_, AUDIOSTREAM_SAMPLE_S16LE);
        // 设置音频流的编码类型
        OH_AudioStreamBuilder_SetEncodingType(builder_, AUDIOSTREAM_ENCODING_TYPE_RAW);
        // 设置输出音频流的工作场景
        OH_AudioStreamBuilder_SetRendererInfo(builder_, AUDIOSTREAM_USAGE_MOVIE);
        AVCODEC_SAMPLE_LOGW("Init audioSampleRate: %{public}d, ChannelCount: %{public}d", sampleInfo_.audioSampleRate,
                            sampleInfo_.audioChannelCount);
        OH_AudioRenderer_Callbacks callbacks;
        // 配置回调函数
#ifndef DEBUG_DECODE
        callbacks.OH_AudioRenderer_OnWriteData = SampleCallback::OnRenderWriteData;
#else
        callbacks.OH_AudioRenderer_OnWriteData = nullptr;
#endif
        callbacks.OH_AudioRenderer_OnStreamEvent = SampleCallback::OnRenderStreamEvent;
        callbacks.OH_AudioRenderer_OnInterruptEvent = SampleCallback::OnRenderInterruptEvent;
        callbacks.OH_AudioRenderer_OnError = SampleCallback::OnRenderError;
        // 设置输出音频流的回调
        OH_AudioStreamBuilder_SetRendererCallback(builder_, callbacks, audioDecContext_);
        OH_AudioStreamBuilder_GenerateRenderer(builder_, &audioRenderer_);
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::CreateVideoDecoder()
{
    AVCODEC_SAMPLE_LOGW("video mime:%{public}s", sampleInfo_.videoCodecMime.c_str());
    int32_t ret = videoDecoder_->Create(sampleInfo_.videoCodecMime, sampleInfo_.codecType);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        isVideoDone.store(true);
        AVCODEC_SAMPLE_LOGW("Create video decoder failed, mime:%{public}s", sampleInfo_.videoCodecMime.c_str());
    } else {
        videoDecContext_ = new CodecUserData;
        videoDecContext_->isDecFirstFrame = true;
        if (sampleInfo_.codecRunMode == SURFACE) {
            sampleInfo_.window = NativeXComponentSample::PluginManager::GetInstance()->pluginWindow_;
        } else {
            sampleInfo_.window = nullptr;
        }
        ret = videoDecoder_->Config(sampleInfo_, videoDecContext_);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, ret, "Video Decoder config failed");
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

// 新添加的错误处理函数
int32_t Player::HandleInitError(std::unique_lock<std::mutex>& outerLock)
{
    {
        std::unique_lock<std::mutex> doneLock(doneMutex);
        isAudioDone = true;
        isVideoDone = true;
        isReleased_ = false;
    }
    doneCond_.notify_all();
    if (outerLock.owns_lock()) {
        outerLock.unlock();
    }
    StartRelease();
    return AVCODEC_SAMPLE_ERR_ERROR;
}

int32_t Player::Init(SampleInfo &sampleInfo)
{
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK_AND_RETURN_RET_LOG(!isStarted_, AVCODEC_SAMPLE_ERR_ERROR, "Already started.");
    CHECK_AND_RETURN_RET_LOG(demuxer_ == nullptr && videoDecoder_ == nullptr && audioDecoder_ == nullptr,
                             AVCODEC_SAMPLE_ERR_ERROR, "Already started.");

    sampleInfo_ = sampleInfo;

    videoDecoder_ = std::make_unique<VideoDecoder>();
    audioDecoder_ = std::make_unique<AudioDecoder>();
    demuxer_ = std::make_unique<Demuxer>();

    int32_t ret = demuxer_->Create(sampleInfo_);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create demuxer failed");
        return HandleInitError(lock);
    }

    ret = CreateAudioDecoder();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create audio decoder failed");
        return HandleInitError(lock);
    }

    ret = CreateVideoDecoder();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Create video decoder failed");
        return HandleInitError(lock);
    }

    if (audioDecContext_ != nullptr) {
        audioDecContext_->sampleInfo = &sampleInfo_;
    }

    isReleased_ = false;
    AVCODEC_SAMPLE_LOGI("Succeed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::StartVideoDecoder()
{
    CHECK_AND_RETURN_RET_LOG(!videoDecInputThread_ && !videoDecOutputThread_,
                             AVCODEC_SAMPLE_ERR_ERROR, "Video threads already running");

    int32_t ret = videoDecoder_->Start();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Video Decoder start failed");
        return ret;
    }

    videoDecInputThread_ = std::make_unique<std::thread>(&Player::VideoDecInputThread, this);
    videoDecOutputThread_ = std::make_unique<std::thread>(&Player::VideoDecOutputThread, this);

    if (!videoDecInputThread_ || !videoDecOutputThread_) {
        AVCODEC_SAMPLE_LOGE("Create video threads failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t Player::StartAudioDecoder()
{
    CHECK_AND_RETURN_RET_LOG(!audioDecInputThread_ && !audioDecOutputThread_,
                             AVCODEC_SAMPLE_ERR_ERROR, "Audio threads already running");

    int32_t ret = audioDecoder_->Start();
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("Audio Decoder start failed");
        return ret;
    }

    audioDecInputThread_ = std::make_unique<std::thread>(&Player::AudioDecInputThread, this);
    audioDecOutputThread_ = std::make_unique<std::thread>(&Player::AudioDecOutputThread, this);
    
    if (!audioDecInputThread_ || !audioDecOutputThread_) {
        AVCODEC_SAMPLE_LOGE("Create audio threads failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

#ifdef DEBUG_DECODE
    audioOutputFile_.open("/data/storage/el2/base/haps/entry/files/audio_decode_out.pcm",
                          std::ios::out | std::ios::binary);
#endif

    // Clear audio render queue
    while (audioDecContext_ && !audioDecContext_->renderQueue.empty()) {
        audioDecContext_->renderQueue.pop();
    }
    
    return AVCODEC_SAMPLE_ERR_OK;
}

void Player::CleanupAfterStartFailure()
{
    StartRelease();
    doneCond_.notify_all();
}

int32_t Player::Start()
{
    std::unique_lock<std::mutex> lock(mutex_);
    
    CHECK_AND_RETURN_RET_LOG(!isStarted_, AVCODEC_SAMPLE_ERR_ERROR, "Already started");
    CHECK_AND_RETURN_RET_LOG(demuxer_, AVCODEC_SAMPLE_ERR_ERROR, "Demuxer not initialized");
    
    isStarted_ = true;
    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    
    if (videoDecContext_) {
        ret = StartVideoDecoder();
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            lock.unlock();
            CleanupAfterStartFailure();
            return ret;
        }
    }
    
    if (audioDecContext_) {
        ret = StartAudioDecoder();
        if (ret == AVCODEC_SAMPLE_ERR_OK && audioRenderer_) {
            OH_AudioRenderer_Start(audioRenderer_);
        }
        
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            lock.unlock();
            CleanupAfterStartFailure();
            return ret;
        }
    }
    
    AVCODEC_SAMPLE_LOGI("Player started successfully");
    doneCond_.notify_all();
    return AVCODEC_SAMPLE_ERR_OK;
}

void Player::SetSpeed(float multiplier)
{
    if (this->speed == multiplier) {
        AVCODEC_SAMPLE_LOGE("Same speed value");
        return;
    }
    if (audioRenderer_) {
        OH_AudioRenderer_SetSpeed(audioRenderer_, multiplier);
    }
    this->speed = multiplier;
    if (audioDecContext_) {
        audioDecContext_->speed = multiplier;
    }
}

void Player::StartRelease()
{
    AVCODEC_SAMPLE_LOGI("StartRelease");
    std::unique_lock<std::mutex> lock(doneMutex);
    doneCond_.wait(lock, [this]() { return isAudioDone.load() && isVideoDone.load(); });
    if (audioRenderer_) {
        OH_AudioRenderer_Stop(audioRenderer_);
    }
    if (!isReleased_) {
        isReleased_ = true;
        Release();
    }
}

void Player::ReleaseThread()
{
    if (videoDecInputThread_ && videoDecInputThread_->joinable()) {
        videoDecInputThread_->detach();
        videoDecInputThread_.reset();
    }
    if (videoDecOutputThread_ && videoDecOutputThread_->joinable()) {
        videoDecOutputThread_->detach();
        videoDecOutputThread_.reset();
    }
    if (audioDecInputThread_ && audioDecInputThread_->joinable()) {
        audioDecInputThread_->detach();
        audioDecInputThread_.reset();
    }
    if (audioDecOutputThread_ && audioDecOutputThread_->joinable()) {
        audioDecOutputThread_->detach();
        audioDecOutputThread_.reset();
    }
}

void Player::Release()
{
    std::lock_guard<std::mutex> lock(mutex_);
    isStarted_ = false;
    isAudioDone = false;
    isVideoDone = false;
    if (audioRenderer_ != nullptr) {
        OH_AudioRenderer_Release(audioRenderer_);
        audioRenderer_ = nullptr;
    }
#ifdef DEBUG_DECODE
    if (audioOutputFile_.is_open()) {
        audioOutputFile_.close();
    }
#endif
    ReleaseThread();

    if (demuxer_ != nullptr) {
        demuxer_->Release();
        demuxer_.reset();
    }
    if (videoDecoder_ != nullptr) {
        videoDecoder_->Release();
        videoDecoder_.reset();
    }
    if (videoDecContext_ != nullptr) {
        delete videoDecContext_;
        videoDecContext_ = nullptr;
    }
    if (audioDecoder_ != nullptr) {
        audioDecoder_->Release();
        audioDecoder_.reset();
    }
    if (audioDecContext_ != nullptr) {
        delete audioDecContext_;
        audioDecContext_ = nullptr;
    }
    outputFile_ = nullptr;
    if (builder_ != nullptr) {
        OH_AudioStreamBuilder_Destroy(builder_);
        builder_ = nullptr;
    }
    doneCond_.notify_all();
    // 触发回调
    sampleInfo_.playDoneCallback(sampleInfo_.playDoneCallbackData);
    // 清空队列
    while (audioDecContext_ && !audioDecContext_->renderQueue.empty()) {
        audioDecContext_->renderQueue.pop();
    }
    AVCODEC_SAMPLE_LOGI("Succeed");
}

void Player::DumpOutput(CodecBufferInfo &bufferInfo)
{
    auto &info = sampleInfo_;
    if (info.codecRunMode != BUFFER) {
        return;
    }
    if (outputFile_ == nullptr) {
        auto time = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        // dump file /data/app/el2/100/base/com.samples.avcodecsample/haps/entry/files/haps/entry/files/
        if (info.outputFilePath.empty()) {
            info.outputFilePath = "/data/storage/el2/base/haps/entry/files/VideoDecoderOut_"s +
                                  ToString(info.pixelFormat) + "_" + std::to_string(info.videoWidth) + "_" +
                                  std::to_string(info.videoHeight) + "_" + std::to_string(time) + ".yuv";
        }

        outputFile_ = std::make_unique<std::ofstream>(info.outputFilePath, std::ios::out | std::ios::trunc);
        if (!outputFile_->is_open()) {
            outputFile_ = nullptr;
            AVCODEC_SAMPLE_LOGE("Output file open failed");
            return;
        }
    }

    uint8_t *bufferAddr = OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    switch (info.pixelFormat) {
        case AV_PIXEL_FORMAT_YUVI420:
            WriteOutputFileWithStrideYUV420P(bufferAddr);
            break;
        case AV_PIXEL_FORMAT_NV12:
            [[fallthrough]];
        case AV_PIXEL_FORMAT_NV21:
            WriteOutputFileWithStrideYUV420SP(bufferAddr);
            break;
        case AV_PIXEL_FORMAT_RGBA:
            WriteOutputFileWithStrideRGBA(bufferAddr);
            break;
        default:
            AVCODEC_SAMPLE_LOGE("Unsupported pixel format, skip");
            break;
    }
}

void Player::WriteOutputFileWithStrideYUV420P(uint8_t *bufferAddr)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int32_t videoWidth =
        videoDecContext_->width *
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);
    int32_t &stride = videoDecContext_->widthStride;
    int32_t uvWidth = videoWidth / YUV420_SAMPLE_RATIO;
    int32_t uvStride = stride / YUV420_SAMPLE_RATIO;

    // copy Y
    for (int32_t row = 0; row < videoDecContext_->height; row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), videoWidth);
        bufferAddr += stride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) * stride;

    // copy U
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), uvWidth);
        bufferAddr += uvStride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) / YUV420_SAMPLE_RATIO * uvStride;
    // copy V
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), uvWidth);
        bufferAddr += uvStride;
    }
}

void Player::WriteOutputFileWithStrideYUV420SP(uint8_t *bufferAddr)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int32_t videoWidth =
        videoDecContext_->width *
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);
    int32_t &stride = videoDecContext_->widthStride;
    int32_t uvWidth = videoWidth / YUV420_SAMPLE_RATIO;
    int32_t uvStride = stride / YUV420_SAMPLE_RATIO;

    // copy Y
    for (int32_t row = 0; row < videoDecContext_->height; row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), videoWidth);
        bufferAddr += stride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) * stride;

    // copy U
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), uvWidth);
        bufferAddr += uvStride;
    }
    bufferAddr += (videoDecContext_->heightStride - videoDecContext_->height) / YUV420_SAMPLE_RATIO * uvStride;
    // copy V
    for (int32_t row = 0; row < (videoDecContext_->height / YUV420_SAMPLE_RATIO); row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), uvWidth);
        bufferAddr += uvStride;
    }
}

void Player::WriteOutputFileWithStrideRGBA(uint8_t *bufferAddr)
{
    CHECK_AND_RETURN_LOG(bufferAddr != nullptr, "Buffer is nullptr");
    auto &info = sampleInfo_;
    int32_t width =
        videoDecContext_->width *
        ((info.videoCodecMime == OH_AVCODEC_MIMETYPE_VIDEO_HEVC && info.hevcProfile == HEVC_PROFILE_MAIN_10) ? 2 : 1);
    int32_t &stride = videoDecContext_->widthStride;

    for (int32_t row = 0; row < videoDecContext_->heightStride; row++) {
        outputFile_->write(reinterpret_cast<char *>(bufferAddr), width * 4); // 4: RGBA 4 channels
        bufferAddr += stride;
    }
}

void Player::VideoDecInputThread()
{
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder input thread out");
        std::unique_lock<std::mutex> lock(videoDecContext_->inputMutex);
        bool condRet = videoDecContext_->inputCond.wait_for(
            lock, 5s, [this]() { return !isStarted_ || !videoDecContext_->inputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted_, "Work done, thread out");
        CHECK_AND_CONTINUE_LOG(!videoDecContext_->inputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = videoDecContext_->inputBufferInfoQueue.front();
        videoDecContext_->inputBufferInfoQueue.pop();
        videoDecContext_->inputFrameCount++;
        lock.unlock();

        demuxer_->ReadSample(demuxer_->GetVideoTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                             bufferInfo.attr);

        int32_t ret = videoDecoder_->PushInputBuffer(bufferInfo);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Push data failed, thread out");

        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
    }
}

bool Player::ProcessVideoWithoutAudio(CodecBufferInfo& bufferInfo,
    std::chrono::time_point<std::chrono::system_clock>& lastPushTime)
{
    DumpOutput(bufferInfo);
    int32_t ret = videoDecoder_->FreeOutputBuffer(bufferInfo.bufferIndex, !sampleInfo_.codecRunMode, GetCurrentTime());
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("FreeOutputBuffer failed: %{public}d", ret);
        return false;
    }
    this->speed == 1 ? sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate
        : this->speed == DOUBLE_SPEED_MULTIPLIER ? sampleInfo_.frameInterval =
                        MICROSECOND_TO_S / sampleInfo_.frameRate / DOUBLE_SPEED_MULTIPLIER
                   : sampleInfo_.frameInterval =
                        MICROSECOND_TO_S / sampleInfo_.frameRate / TRIPLE_SPEED_MULTIPLIER;
    std::this_thread::sleep_until(lastPushTime + std::chrono::microseconds(sampleInfo_.frameInterval));
    lastPushTime = std::chrono::system_clock::now();
    
    return true;
}

bool Player::CalculateSyncParameters(CodecBufferInfo& bufferInfo, int64_t framePosition,
                                     int64_t& waitTimeUs, bool& dropFrame,
                                     int64_t perSinkTimeThreshold)
{
    // after seek, audio render flush, framePosition = 0, then writtenSampleCnt = 0
    int64_t latency = (audioDecContext_->frameWrittenForSpeed - framePosition) * 1000 * 1000 /
                      sampleInfo_.audioSampleRate / speed;
    AVCODEC_SAMPLE_LOGI("VD latency: %{public}li writtenSampleCnt: %{public}li", latency, writtenSampleCnt);
    
    nowTimeStamp = GetCurrentTime();
    int64_t anchorDiff = (nowTimeStamp - audioTimeStamp) / 1000;
    
    // us, audio buffer accelerate render time
    int64_t audioPlayedTime = audioDecContext_->currentPosAudioBufferPts - latency + anchorDiff;
    // us, video buffer expected render time
    int64_t videoPlayedTime = bufferInfo.attr.pts;
    
    // audio render timestamp and now timestamp diff
    waitTimeUs = videoPlayedTime - audioPlayedTime; // us
    
    AVCODEC_SAMPLE_LOGI("VD bufferInfo.bufferIndex: %{public}li", bufferInfo.bufferIndex);
    AVCODEC_SAMPLE_LOGI(
        "VD audioPlayedTime: %{public}li, videoPlayedTime: %{public}li, nowTimeStamp_:{public}ld, "
        "audioTimeStamp_ :{public}ld, waitTimeUs :{public}ld, anchordiff :%{public}ld",
        audioPlayedTime, videoPlayedTime, nowTimeStamp, audioTimeStamp, waitTimeUs, anchorDiff);
    dropFrame = false;
    // video buffer is too late, drop it
    if (waitTimeUs < WAIT_TIME_US_THRESHOLD_WARNING) {
        dropFrame = true;
        AVCODEC_SAMPLE_LOGI("VD buffer is too late");
    } else {
        AVCODEC_SAMPLE_LOGE("VD buffer is too early waitTimeUs:%{public}ld", waitTimeUs);
        // [0, ), render it wait waitTimeUs, max 1s
        // [-40, 0), render it
        if (waitTimeUs > WAIT_TIME_US_THRESHOLD) {
            waitTimeUs = WAIT_TIME_US_THRESHOLD;
        }
        // per frame render time reduced by frame interval
        if (waitTimeUs > sampleInfo_.frameInterval + perSinkTimeThreshold) {
            waitTimeUs = sampleInfo_.frameInterval + perSinkTimeThreshold;
            AVCODEC_SAMPLE_LOGE("VD buffer is too early and reduced, waitTimeUs: %{public}ld", waitTimeUs);
        }
    }
    return true;
}

bool Player::RenderAndRelease(CodecBufferInfo& bufferInfo, int64_t waitTimeUs, bool dropFrame)
{
    if (static_cast<double>(waitTimeUs) > VSYNC_TIME * LIP_SYNC_BALANCE_VALUE) {
        std::this_thread::sleep_for(std::chrono::microseconds(
            static_cast<int64_t>(static_cast<double>(waitTimeUs) - VSYNC_TIME * LIP_SYNC_BALANCE_VALUE)));
    }
    DumpOutput(bufferInfo);
    int32_t ret = videoDecoder_->FreeOutputBuffer(bufferInfo.bufferIndex,
        sampleInfo_.codecRunMode ? false : !dropFrame,
        VSYNC_TIME * LIP_SYNC_BALANCE_VALUE * MS_TO_S + GetCurrentTime());
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("FreeOutputBuffer failed: %{public}d", ret);
        return false;
    }
    return true;
}

bool Player::ProcessVideoWithAudio(CodecBufferInfo& bufferInfo,
    std::chrono::time_point<std::chrono::system_clock>& lastPushTime, int64_t perSinkTimeThreshold)
{
    // get audio render position
    int64_t framePosition = 0;
    int64_t timestamp = 0;
    int32_t ret = OH_AudioRenderer_GetTimestamp(audioRenderer_, CLOCK_MONOTONIC, &framePosition, &timestamp);
    AVCODEC_SAMPLE_LOGI("VD framePosition: %{public}li, nowTimeStamp: %{public}li", framePosition, nowTimeStamp);
    audioTimeStamp = timestamp; // ns
    
    // audio render getTimeStamp error, render it
    if (ret != AUDIOSTREAM_SUCCESS || (timestamp == 0) || (framePosition == 0)) {
        DumpOutput(bufferInfo);
        // first frame, render without wait
        ret = videoDecoder_->FreeOutputBuffer(bufferInfo.bufferIndex, sampleInfo_.codecRunMode ? false : true,
                                              GetCurrentTime());
        if (ret != AVCODEC_SAMPLE_ERR_OK) {
            AVCODEC_SAMPLE_LOGW("FreeOutputBuffer failed: %{public}d", ret);
            return false;
        }
        std::this_thread::sleep_until(lastPushTime + std::chrono::microseconds(sampleInfo_.frameInterval));
        lastPushTime = std::chrono::system_clock::now();
        return true;
    }
    int64_t waitTimeUs = 0;
    bool dropFrame = false;
    if (!CalculateSyncParameters(bufferInfo, framePosition, waitTimeUs,
        dropFrame, perSinkTimeThreshold)) {
        return false;
    }
    return RenderAndRelease(bufferInfo, waitTimeUs, dropFrame);
}

void Player::VideoDecOutputThread()
{
    sampleInfo_.frameInterval = MICROSECOND_TO_S / sampleInfo_.frameRate;
    int64_t perSinkTimeThreshold = MS_TO_S / sampleInfo_.frameRate * MS_TO_S; // max per sink time
    while (true) {
        thread_local auto lastPushTime = std::chrono::system_clock::now();
        CHECK_AND_BREAK_LOG(isStarted_, "VD Decoder output thread out");
        std::unique_lock<std::mutex> lock(videoDecContext_->outputMutex);
        bool condRet = videoDecContext_->outputCond.wait_for(
            lock, 5s, [this]() { return !isStarted_ || !videoDecContext_->outputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted_, "VD Decoder output thread out");
        CHECK_AND_CONTINUE_LOG(!videoDecContext_->outputBufferInfoQueue.empty(),
            "Buffer queue is empty, continue, cond ret: %{public}d", condRet);
        CodecBufferInfo bufferInfo = videoDecContext_->outputBufferInfoQueue.front();
        videoDecContext_->outputBufferInfoQueue.pop();
        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
        videoDecContext_->outputFrameCount++;
        AVCODEC_SAMPLE_LOGW("Out buffer count: %{public}u, size: %{public}d, flag: %{public}u, pts: %{public}" PRId64,
                           videoDecContext_->outputFrameCount, bufferInfo.attr.size, bufferInfo.attr.flags,
                           bufferInfo.attr.pts);
        lock.unlock();
        bool success = false;
        if (!audioDecContext_) {
            success = ProcessVideoWithoutAudio(bufferInfo, lastPushTime);
        } else {
            success = ProcessVideoWithAudio(bufferInfo, lastPushTime,
                perSinkTimeThreshold);
        }
        if (!success) {
            break;
        }
    }
    writtenSampleCnt = 0;
    audioBufferPts = 0;
    std::unique_lock<std::mutex> lock(doneMutex);
    isVideoDone.store(true);
    lock.unlock();
    doneCond_.notify_all();
    StartRelease();
}

void Player::AudioDecInputThread()
{
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder input thread out");
        std::unique_lock<std::mutex> lock(audioDecContext_->inputMutex);
        bool condRet = audioDecContext_->inputCond.wait_for(
            lock, 5s, [this]() { return !isStarted_ || !audioDecContext_->inputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted_, "Work done, thread out");
        CHECK_AND_CONTINUE_LOG(!audioDecContext_->inputBufferInfoQueue.empty(),
                               "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = audioDecContext_->inputBufferInfoQueue.front();
        audioDecContext_->inputBufferInfoQueue.pop();
        audioDecContext_->inputFrameCount++;
        lock.unlock();

        demuxer_->ReadSample(demuxer_->GetAudioTrackId(), reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer),
                             bufferInfo.attr);

        int32_t ret = audioDecoder_->PushInputBuffer(bufferInfo);
        CHECK_AND_BREAK_LOG(ret == AVCODEC_SAMPLE_ERR_OK, "Push data failed, thread out");

        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
    }
}

bool Player::ProcessAudioOutput(CodecBufferInfo &bufferInfo)
{
    int32_t ret = audioDecoder_->FreeOutputBuffer(bufferInfo.bufferIndex, true);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        AVCODEC_SAMPLE_LOGW("FreeOutputBuffer failed: %{public}d", ret);
        return false;
    }

    // SAMPLE_S16LE 2 bytes per frame
    writtenSampleCnt += (bufferInfo.attr.size / sampleInfo_.audioChannelCount / BYTES_PER_SAMPLE_2);
    AVCODEC_SAMPLE_LOGI("writtenSampleCnt_: %{public}ld, bufferInfo.attr.size: %{public}d, "
                        "sampleInfo_.audioChannelCount: %{public}d",
                        writtenSampleCnt, bufferInfo.attr.size, sampleInfo_.audioChannelCount);
                        
    audioBufferPts = bufferInfo.attr.pts;
    audioDecContext_->endPosAudioBufferPts = audioBufferPts;

    std::unique_lock<std::mutex> lockRender(audioDecContext_->renderMutex);
    audioDecContext_->renderCond.wait_for(lockRender, 20ms, [this, bufferInfo]() {
        return audioDecContext_->renderQueue.size() < BALANCE_VALUE * bufferInfo.attr.size;
    });
    
    return true;
}

void Player::AudioDecOutputThread()
{
    while (true) {
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder output thread out");
        std::unique_lock<std::mutex> lock(audioDecContext_->outputMutex);
        bool condRet = audioDecContext_->outputCond.wait_for(
            lock, 5s, [this]() { return !isStarted_ || !audioDecContext_->outputBufferInfoQueue.empty(); });
        CHECK_AND_BREAK_LOG(isStarted_, "Decoder output thread out");
        CHECK_AND_CONTINUE_LOG(!audioDecContext_->outputBufferInfoQueue.empty(),
            "Buffer queue is empty, continue, cond ret: %{public}d", condRet);

        CodecBufferInfo bufferInfo = audioDecContext_->outputBufferInfoQueue.front();
        audioDecContext_->outputBufferInfoQueue.pop();
        CHECK_AND_BREAK_LOG(!(bufferInfo.attr.flags & AVCODEC_BUFFER_FLAGS_EOS), "Catch EOS, thread out");
        
        audioDecContext_->outputFrameCount++;
        AVCODEC_SAMPLE_LOGW("Out buffer count: %{public}u, size: %{public}d, flag: %{public}u, pts: %{public}" PRId64,
                           audioDecContext_->outputFrameCount, bufferInfo.attr.size, bufferInfo.attr.flags,
                           bufferInfo.attr.pts);
        
        uint8_t *source = OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer));
        // 将解码后的PCM数据放入队列中
        for (int i = 0; i < bufferInfo.attr.size; i++) {
            audioDecContext_->renderQueue.push(*(source + i));
        }
    
#ifdef DEBUG_DECODE
    if (audioOutputFile_.is_open()) {
        audioOutputFile_.write(
            (const char *)OH_AVBuffer_GetAddr(reinterpret_cast<OH_AVBuffer *>(bufferInfo.buffer)),
            bufferInfo.attr.size);
    }
#endif
        lock.unlock();
        if (!ProcessAudioOutput(bufferInfo)) {
            break;
        }
    }
    std::unique_lock<std::mutex> lockRender(audioDecContext_->renderMutex);
    audioDecContext_->renderCond.wait_for(lockRender, 500ms,
        [this]() { return audioDecContext_->renderQueue.size() < 1; });
    AVCODEC_SAMPLE_LOGI("Out buffer end");
    std::unique_lock<std::mutex> lock(doneMutex);
    isAudioDone = true;
    lock.unlock();
    doneCond_.notify_all();
    StartRelease();
}

int64_t Player::GetCurrentTime()
{
    auto now = std::chrono::steady_clock::now();
    auto now_ns = std::chrono::time_point_cast<std::chrono::nanoseconds>(now);
    return now_ns.time_since_epoch().count();
}
