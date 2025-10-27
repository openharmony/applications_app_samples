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

#include <hilog/log.h>
#include "VideoDecoder.h"
#include "Player.h"
#include "SampleCallback.h"

#undef LOG_TAG
#define LOG_TAG "VideoDecoder"

VideoDecoder::~VideoDecoder() { Release(); }

int32_t VideoDecoder::Create(const std::string &videoCodecMime)
{
    decoder_ = OH_VideoDecoder_CreateByMime(videoCodecMime.c_str());
    if (decoder_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Create failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::SetCallback(CodecUserData *codecUserData)
{
    int32_t ret = AV_ERR_OK;
    ret = OH_VideoDecoder_RegisterCallback(decoder_,
                                           {SampleCallback::OnCodecError, SampleCallback::OnCodecFormatChange,
                                            SampleCallback::OnNeedInputBuffer, SampleCallback::OnNewOutputBuffer},
                                           codecUserData);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Set callback failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Configure(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    if (format == nullptr) {
        OH_LOG_ERROR(LOG_APP, "AVFormat create failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, sampleInfo.videoHeight);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, sampleInfo.pixelFormat);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_ROTATION, sampleInfo.rotation);

    OH_LOG_INFO(LOG_APP, "====== VideoDecoder config ======");
    OH_LOG_INFO(LOG_APP, "%{public}d*%{public}d, %{public}.1ffps", sampleInfo.videoWidth, sampleInfo.videoHeight,
                sampleInfo.frameRate);
    OH_LOG_INFO(LOG_APP, "====== VideoDecoder config ======");

    int ret = OH_VideoDecoder_Configure(decoder_, format);

    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Config failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    OH_AVFormat_Destroy(format);
    format = nullptr;
    
    return AVCODEC_SAMPLE_ERR_OK;
}

// [Start config_video_decoder]
int32_t VideoDecoder::Config(const SampleInfo &sampleInfo, CodecUserData *codecUserData)
{
    if (decoder_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Decoder is null");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    if (codecUserData == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Invalid param: codecUserData");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    
    int32_t ret = Configure(sampleInfo);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Configure failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    if (sampleInfo.window != nullptr) {
        int ret = OH_VideoDecoder_SetSurface(decoder_, sampleInfo.window);
        if (ret != AV_ERR_OK) {
            OH_LOG_ERROR(LOG_APP, "Set surface failed, ret: %{public}d", ret);
            return AVCODEC_SAMPLE_ERR_ERROR;
        }
    }
    
    ret = SetCallback(codecUserData);
    if (ret != AVCODEC_SAMPLE_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Set callback failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    
    ret = OH_VideoDecoder_Prepare(decoder_);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Prepare failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    return AVCODEC_SAMPLE_ERR_OK;
}
// [End config_video_decoder]

int32_t VideoDecoder::Start()
{
    if (decoder_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Decoder is null.");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    int ret = OH_VideoDecoder_Start(decoder_);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Start failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::PushInputBuffer(CodecBufferInfo &info)
{
    if (decoder_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Decoder is null.");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    int32_t ret = OH_VideoDecoder_PushInputBuffer(decoder_, info.bufferIndex);
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Push input data failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

// [Start render_output_buffer]
int32_t VideoDecoder::FreeOutputBuffer(uint32_t bufferIndex, bool render)
{
    if (decoder_ == nullptr) {
        OH_LOG_ERROR(LOG_APP, "Decoder is null");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    if (render) {
        ret = OH_VideoDecoder_RenderOutputBuffer(decoder_, bufferIndex);
    } else {
        ret = OH_VideoDecoder_FreeOutputBuffer(decoder_, bufferIndex);
    }
    if (ret != AV_ERR_OK) {
        OH_LOG_ERROR(LOG_APP, "Free output data failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}
// [End render_output_buffer]

int32_t VideoDecoder::Release()
{
    if (decoder_ != nullptr) {
        OH_VideoDecoder_Flush(decoder_);
        OH_VideoDecoder_Stop(decoder_);
        OH_VideoDecoder_Destroy(decoder_);
        decoder_ = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}