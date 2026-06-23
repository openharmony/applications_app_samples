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

#ifndef AVCODEC_SAMPLE_INFO_H
#define AVCODEC_SAMPLE_INFO_H
#include <bits/alltypes.h>
#include <chrono>
#include <cstdint>
#include <map>
#include <memory>
#include <multimedia/player_framework/native_avcodec_videoencoder.h>
#include <string>
#include <condition_variable>
#include <queue>
#include <fstream>
#include <native_buffer/native_buffer.h>
#include <atomic>
#include <shared_mutex>
#include "multimedia/player_framework/native_avcodec_base.h"
#include "multimedia/player_framework/native_avbuffer.h"

using namespace std;

constexpr int32_t BITRATE_10M = 10 * 1024 * 1024;
constexpr int32_t BITRATE_20M = 20 * 1024 * 1024;
constexpr int32_t BITRATE_30M = 30 * 1024 * 1024;

const unordered_map<OH_AVPixelFormat, string> PIXEL_FORMAT_TO_STRING = {
    {AV_PIXEL_FORMAT_YUVI420,           "YUVI420"},
    {AV_PIXEL_FORMAT_NV12,              "NV12"},
    {AV_PIXEL_FORMAT_NV21,              "NV21"},
    {AV_PIXEL_FORMAT_SURFACE_FORMAT,    "SURFACE_FORMAT"},
    {AV_PIXEL_FORMAT_RGBA,              "RGBA"},
};

struct SampleInfo {
    int32_t inputFd = -1;
    int32_t outputFd = -1;
    int64_t inputFileOffset = 0;
    int64_t inputFileSize = 0;
    string inputFilePath;
    string videoCodecMime = "";
    string audioCodecMime = "";
    int32_t videoWidth = 0;
    int32_t videoHeight = 0;
    double frameRate = 0.0;
    int64_t bitrate = 10 * 1024 * 1024;
    int64_t frameInterval = 0;
    OH_AVPixelFormat pixelFormat = AV_PIXEL_FORMAT_NV12;
    uint32_t bitrateMode = CBR;
    int32_t iFrameInterval = 100;
    int32_t rangFlag = 1;
    int32_t codecType = 0;
    int32_t codecRunMode = 0;
    int32_t codecSyncMode = 0;
    string outputFilePath;
    int32_t outputFormat = 2; // AV_OUTPUT_FORMAT_MPEG_4 = 2, AV_OUTPUT_FORMAT_FLV = 14

    int32_t audioSampleForamt = 0;
    int32_t audioSampleRate = 0;
    int32_t audioChannelCount = 0;
    int64_t audioChannelLayout = 0;
    int32_t audioBitRate = 0;
    uint8_t audioCodecConfig[100] = { 0 };
    size_t audioCodecSize = 0;
    int32_t audioMaxInputSize = 0;
    OH_AVFormat *audioFormat;

    int32_t isHDRVivid = 0;
    int32_t hevcProfile = HEVC_PROFILE_MAIN;
    OH_ColorPrimary primary = COLOR_PRIMARY_BT2020;
    OH_TransferCharacteristic transfer = TRANSFER_CHARACTERISTIC_HLG;
    OH_MatrixCoefficient matrix = MATRIX_COEFFICIENT_BT2020_CL;

    int32_t rotation = 0;
    OHNativeWindow *window = nullptr;

    bool isSmartFluencySupported = false; // 标记设备是否支持智能流畅倍速解码(API>=26)
    double speed = 1.0;                   // 当前播放倍速

    void (*playDoneCallback)(void *context) = nullptr;
    void *playDoneCallbackData = nullptr;
    uint8_t codecConfig[1024];
    size_t codecConfigLen = 0;
    int32_t aacAdts = -1;
};

struct CodecBufferInfo {
    uint32_t bufferIndex = 0;
    OH_AVBuffer *buffer = nullptr;
    uint8_t *bufferAddr = nullptr;
    OH_AVCodecBufferAttr attr = {0, 0, 0, AVCODEC_BUFFER_FLAGS_NONE};
    bool isValid = true;

    explicit CodecBufferInfo(uint8_t *addr) : bufferAddr(addr){};
    CodecBufferInfo(uint8_t *addr, int32_t bufferSize)
        : bufferAddr(addr), attr({0, bufferSize, 0, AVCODEC_BUFFER_FLAGS_NONE}){};
    CodecBufferInfo(uint32_t argBufferIndex, OH_AVBuffer *argBuffer)
        : bufferIndex(argBufferIndex), buffer(argBuffer)
    {
        OH_AVBuffer_GetBufferAttr(argBuffer, &attr);
    };
};

class CodecBufferQueue {
public:
    void Enqueue(const std::shared_ptr<CodecBufferInfo> bufferInfo)
    {
        std::unique_lock<std::mutex> lock(mutex_);
        bufferQueue_.push(bufferInfo);
        cond_.notify_all();
    }

    std::shared_ptr<CodecBufferInfo> Dequeue(int32_t timeoutMs = 1000)
    {
        std::unique_lock<std::mutex> lock(mutex_);
        (void)cond_.wait_for(lock, std::chrono::milliseconds(timeoutMs), [this]() { return !bufferQueue_.empty(); });
        if (bufferQueue_.empty()) {
            return nullptr;
        }
        std::shared_ptr<CodecBufferInfo> bufferInfo = bufferQueue_.front();
        bufferQueue_.pop();
        return bufferInfo;
    }

    void Flush()
    {
        std::unique_lock<std::mutex> lock(mutex_);
        while (!bufferQueue_.empty()) {
            std::shared_ptr<CodecBufferInfo> bufferInfo = bufferQueue_.front();
            bufferInfo->isValid = false;
            bufferQueue_.pop();
        }
    }

private:
    std::mutex mutex_;
    std::condition_variable cond_;
    std::queue<std::shared_ptr<CodecBufferInfo>> bufferQueue_;
};

enum CodecType {
    AUTO = 0,
    VIDEO_HW_DECODER = 1,
    VIDEO_SW_DECODER = 2,
    VIDEO_HW_ENCODER = 3,
    VIDEO_SW_ENCODER = 4,
};

enum CodecRunMode {
    SURFACE = 0,
    BUFFER = 1
};

struct CodecUserData {
public:
    SampleInfo *sampleInfo = nullptr;
    bool isDecFirstFrame = false;
    bool isEncFirstFrame = false;

    int32_t width = 0;
    int32_t height = 0;
    int32_t widthStride = 0;
    int32_t heightStride = 0;

    std::shared_mutex codecMutex;
    uint32_t inputFrameCount = 0;
    mutex inputMutex;
    condition_variable inputCond;
    CodecBufferQueue inputBufferQueue;

    uint32_t outputFrameCount = 0;
    mutex outputMutex;
    mutex renderMutex;
    condition_variable renderCond;
    CodecBufferQueue outputBufferQueue;

    queue<unsigned char> renderQueue;

    int64_t speed = 1.0f;
    int64_t frameWrittenForSpeed = 0;
    int64_t endPosAudioBufferPts = 0;
    int64_t currentPosAudioBufferPts = 0;

    std::atomic<bool> isDestroyed { false };

    void ClearQueue()
    {
        inputBufferQueue.Flush();
        outputBufferQueue.Flush();
    }

    std::vector<char> cache;
    int32_t remainlen = 0;

    void ClearCache()
    {
        cache.clear();
        remainlen = 0;
    }

    void WriteCache(void *buffer, int32_t bufferLen)
    {
        if (bufferLen + remainlen > cache.size()) {
            cache.resize(remainlen + bufferLen);
        }
        std::memcpy(cache.data() + remainlen, buffer, bufferLen);
        remainlen += bufferLen;
    }

    bool ReadCache(void *buffer, int32_t bufferLen)
    {
        if (remainlen < bufferLen) {
            return false;
        }
        std::memcpy(buffer, cache.data(), bufferLen);
        remainlen = remainlen - bufferLen;
        if (remainlen > 0) {
            std::memmove(cache.data(), cache.data() + bufferLen, remainlen);
        }
        return true;
    }
};

#endif
