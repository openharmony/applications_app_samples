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

#ifndef AVCODEC_SAMPLE_INFO_H
#define AVCODEC_SAMPLE_INFO_H
#include <bits/alltypes.h>
#include <cstdint>
#include <map>
#include <multimedia/player_framework/native_avcodec_videoencoder.h>
#include <multimedia/player_framework/lowpower_audio_sink_base.h>
#include <multimedia/player_framework/lowpower_avsink_base.h>
#include "multimedia/player_framework/native_avdemuxer.h"
#include <string>
#include <condition_variable>
#include <queue>
#include <fstream>
#include <native_buffer/native_buffer.h>
#include "multimedia/player_framework/native_avcodec_base.h"
#include "multimedia/player_framework/native_avbuffer.h"

const std::string_view MIME_VIDEO_AVC = "video/avc";
const std::string_view MIME_VIDEO_HEVC = "video/hevc";
const std::string_view MIME_AUDIO_MPEG = "audio/mpeg";

constexpr int32_t BITRATE_10M = 10 * 1024 * 1024; // 10Mbps
constexpr int32_t BITRATE_20M = 20 * 1024 * 1024; // 20Mbps
constexpr int32_t BITRATE_30M = 30 * 1024 * 1024; // 30Mbps

struct SampleInfo {
    OH_AVFormat* format_audio;
    OH_AVFormat* format_video;
    int32_t inputFd = -1;
    int32_t outputFd = -1;
    int64_t inputFileOffset = 0;
    int64_t inputFileSize = 0;
    std::string inputFilePath;
    std::string videoCodecMime = "";
    std::string audioCodecMime = "";
    int32_t videoWidth = 0;
    int32_t videoHeight = 0;
    double frameRate = 0.0;
    int64_t bitrate = 10 * 1024 * 1024; // 10Mbps;
    int64_t frameInterval = 0;
    OH_AVPixelFormat pixelFormat = AV_PIXEL_FORMAT_NV12;
    uint32_t bitrateMode = CBR;
    int32_t iFrameInterval = 100;
    int32_t rangFlag = 1;

    int32_t audioSampleForamt = 0;
    int32_t audioSampleRate = 0;
    int32_t audioChannelCount = 0;
    int64_t audioChannelLayout = 0;
    int64_t duration = 0;
    uint8_t* audioCodecConfig = nullptr;
    size_t audioCodecSize = 0;
    bool isInit = false;

    
    int32_t isHDRVivid = 0;
    int32_t hevcProfile = HEVC_PROFILE_MAIN;
    OH_ColorPrimary primary = COLOR_PRIMARY_BT2020;
    OH_TransferCharacteristic transfer = TRANSFER_CHARACTERISTIC_HLG;
    OH_MatrixCoefficient matrix = MATRIX_COEFFICIENT_BT2020_CL;
    
    int32_t rotation = 0;
    OHNativeWindow *window = nullptr;
    
    void (*playDoneCallback)(void *context) = nullptr;
    void (*audioCallback)(void *context) = nullptr;
    void *playDoneCallbackData = nullptr;
    void *audioCallbackData = nullptr;
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

struct LppUserData {
public:
    std::mutex inputMutex;
    std::condition_variable inputCond;
    std::condition_variable eosCond_;
    std::mutex eosMutex;
    std::mutex eosFlagMutex;
    bool eosFlag_ {false};
    OH_AVSamplesBuffer *framePacket_ = nullptr;
    std::queue<CodecBufferInfo> cacheQueue;
    bool returnFrame = false;
    int32_t num = 0;
    int32_t count = 0;
    std::mutex seekMutex_;
    std::condition_variable seekCond_;
    bool seekReturn_ = false;
    int64_t position = 0;
    void (*audioCallback)(void *context) = nullptr;
    void *audioCallbackData = nullptr;

};
#endif // AVCODEC_SAMPLE_INFO_H