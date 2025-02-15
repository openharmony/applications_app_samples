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

#include "VideoDecoder.h"

#undef LOG_TAG
#define LOG_TAG "VideoDecoder"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
} // namespace

VideoDecoder::~VideoDecoder()
{
    Release();
}

int32_t VideoDecoder::Create(const std::string &videoCodecMime)
{
    decoder = OH_VideoDecoder_CreateByMime(videoCodecMime.c_str());
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::SetCallback(CodecUserData *codecUserData)
{
    int32_t ret = AV_ERR_OK;
    ret = OH_VideoDecoder_RegisterCallback(decoder,
        {SampleCallback::OnCodecError, SampleCallback::OnCodecFormatChange,
         SampleCallback::OnNeedInputBuffer, SampleCallback::OnNewOutputBuffer}, codecUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Configure(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");
    
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_ROTATION, sampleInfo.videoRotation);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, sampleInfo.videoHeight);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, sampleInfo.pixelFormat);

    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");
    AVCODEC_SAMPLE_LOGI("%{public}d*%{public}d, %{public}.1ffps", sampleInfo.videoWidth, sampleInfo.videoHeight,
                        sampleInfo.frameRate);
    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");

    int ret = OH_VideoDecoder_Configure(decoder, format);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Config failed, ret: %{public}d", ret);
    OH_AVFormat_Destroy(format);
    format = nullptr;

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Config(const SampleInfo &sampleInfo, CodecUserData *codecUserData)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    CHECK_AND_RETURN_RET_LOG(codecUserData != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Invalid param: codecUserData");

    // Configure video decoder
    int32_t ret = Configure(sampleInfo);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed");

    // SetSurface from video decoder
    if (sampleInfo.window != nullptr) {
        int ret = OH_VideoDecoder_SetSurface(decoder, sampleInfo.window);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK && sampleInfo.window, AVCODEC_SAMPLE_ERR_ERROR,
            "Set surface failed, ret: %{public}d", ret);
    }

    // SetCallback for video decoder
    ret = SetCallback(codecUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR,
                             "Set callback failed, ret: %{public}d", ret);

    // Prepare video decoder
    {
        int ret = OH_VideoDecoder_Prepare(decoder);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed, ret: %{public}d", ret);
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Start()
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int ret = OH_VideoDecoder_Start(decoder);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Start failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::PushInputBuffer(CodecBufferInfo &info)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    int32_t ret = OH_VideoDecoder_PushInputBuffer(decoder, info.bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Push input data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::FreeOutputBuffer(uint32_t bufferIndex, bool render)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    
    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    if (render) {
        ret = OH_VideoDecoder_RenderOutputBuffer(decoder, bufferIndex);
    } else {
        ret = OH_VideoDecoder_FreeOutputBuffer(decoder, bufferIndex);
    }
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Free output data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Release()
{
    if (decoder != nullptr) {
        OH_VideoDecoder_Flush(decoder);
        OH_VideoDecoder_Stop(decoder);
        OH_VideoDecoder_Destroy(decoder);
        decoder = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}