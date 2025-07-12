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
#include <cstdint>
#include <map>
#include <multimedia/player_framework/native_avcodec_videoencoder.h>
#include <string>
#include <condition_variable>
#include <queue>
#include <fstream>
#include <native_buffer/native_buffer.h>
#include "multimedia/player_framework/native_avcodec_base.h"
#include "multimedia/player_framework/native_avbuffer.h"

using namespace std;

constexpr int32_t BITRATE_10M = 10 * 1024 * 1024; // 10Mbps
constexpr int32_t BITRATE_20M = 20 * 1024 * 1024; // 20Mbps
constexpr int32_t BITRATE_30M = 30 * 1024 * 1024; // 30Mbps

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
    int64_t bitrate = 10 * 1024 * 1024; // 10Mbps;
    int64_t frameInterval = 0;
    OH_AVPixelFormat pixelFormat = AV_PIXEL_FORMAT_NV12;
    uint32_t bitrateMode = CBR;
    int32_t iFrameInterval = 100;
    int32_t rangFlag = 1;
    int32_t codecType = 0;
    int32_t codecRunMode = 0;
    string outputFilePath;

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
    
    void (*playDoneCallback)(void *context) = nullptr;
    void *playDoneCallbackData = nullptr;
    uint8_t codecConfig[1024];
    size_t codecConfigLen = 0;
    int32_t aacAdts = -1;
};

struct CodecBufferInfo {
    uint32_t bufferIndex = 0;
    uintptr_t *buffer = nullptr;
    uint8_t *bufferAddr = nullptr;
    OH_AVCodecBufferAttr attr = {0, 0, 0, AVCODEC_BUFFER_FLAGS_NONE};

    explicit CodecBufferInfo(uint8_t *addr) : bufferAddr(addr){};
    CodecBufferInfo(uint8_t *addr, int32_t bufferSize)
        : bufferAddr(addr), attr({0, bufferSize, 0, AVCODEC_BUFFER_FLAGS_NONE}){};
    CodecBufferInfo(uint32_t argBufferIndex, OH_AVBuffer *argBuffer)
        : bufferIndex(argBufferIndex), buffer(reinterpret_cast<uintptr_t *>(argBuffer))
    {
        OH_AVBuffer_GetBufferAttr(argBuffer, &attr);
    };
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

    uint32_t inputFrameCount = 0;
    mutex inputMutex;
    condition_variable inputCond;
    queue<CodecBufferInfo> inputBufferInfoQueue;

    uint32_t outputFrameCount = 0;
    mutex outputMutex;
    condition_variable outputCond;
    mutex renderMutex;
    condition_variable renderCond;
    queue<CodecBufferInfo> outputBufferInfoQueue;

    queue<unsigned char> renderQueue;

    int64_t speed = 1.0f;
    int64_t frameWrittenForSpeed = 0;
    int64_t endPosAudioBufferPts = 0;
    int64_t currentPosAudioBufferPts = 0;

    void ClearQueue()
    {
        {
            unique_lock<mutex> lock(inputMutex);
            auto emptyQueue = queue<CodecBufferInfo>();
            inputBufferInfoQueue.swap(emptyQueue);
        }
        {
            unique_lock<mutex> lock(outputMutex);
            auto emptyQueue = queue<CodecBufferInfo>();
            outputBufferInfoQueue.swap(emptyQueue);
        }
    }

    // Create cache
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

#endif // AVCODEC_SAMPLE_INFO_H