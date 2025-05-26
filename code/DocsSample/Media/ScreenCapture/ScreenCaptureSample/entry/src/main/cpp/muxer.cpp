/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

#include "muxer.h"
#include "hilog/log.h"

#undef LOG_TAG
#define LOG_TAG "Muxer"

namespace {
constexpr int32_t VERTICAL_ANGLE = 90;
constexpr int32_t HORIZONTAL_ANGLE = 0;
}

Muxer::~Muxer()
{
    Release();
}

int32_t Muxer::Create(int32_t fd)
{
    muxer_ = OH_AVMuxer_Create(fd, AV_OUTPUT_FORMAT_MPEG_4);
    return 0;
}

int32_t Muxer::Config(SampleInfo &sampleInfo)
{
    OH_LOG_INFO(LOG_APP, "==DEMO== Config");
    OH_AVFormat *formatVideo = OH_AVFormat_CreateVideoFormat(sampleInfo.codecMime.data(),
        sampleInfo.videoWidth, sampleInfo.videoHeight);

    OH_AVFormat_SetDoubleValue(formatVideo, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(formatVideo, OH_MD_KEY_WIDTH, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(formatVideo, OH_MD_KEY_HEIGHT, sampleInfo.videoHeight);
    OH_AVFormat_SetStringValue(formatVideo, OH_MD_KEY_CODEC_MIME, sampleInfo.codecMime.data());
    
    int32_t ret = OH_AVMuxer_AddTrack(muxer_, &videoTrackId_, formatVideo);
    OH_AVFormat_Destroy(formatVideo);
    OH_LOG_INFO(LOG_APP, "==DEMO== Config End");
    return 0;
}

int32_t Muxer::Start()
{
    int ret = OH_AVMuxer_Start(muxer_);
    return 0;
}

int32_t Muxer::WriteSample(OH_AVBuffer *buffer, OH_AVCodecBufferAttr &attr)
{
    int32_t ret = OH_AVBuffer_SetBufferAttr(buffer, &attr);
    ret = OH_AVMuxer_WriteSampleBuffer(muxer_, videoTrackId_, buffer);
    return 0;
}

int32_t Muxer::Stop()
{
    int32_t ret = OH_AVMuxer_Stop(muxer_);
    return 0;
}

int32_t Muxer::Release()
{
    if (muxer_ != nullptr) {
        OH_AVMuxer_Destroy(muxer_);
        muxer_ = nullptr;
    }
    return 0;
}
