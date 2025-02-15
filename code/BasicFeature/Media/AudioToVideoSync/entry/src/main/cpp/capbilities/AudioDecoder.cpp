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

#include "AudioDecoder.h"

#undef LOG_TAG
#define LOG_TAG "AudioDecoder"

AudioDecoder::~AudioDecoder() { Release(); }

int32_t AudioDecoder::Create(const std::string &codecMime)
{
    decoder = OH_AudioCodec_CreateByMime(codecMime.c_str(), false);
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::SetCallback(CodecUserData *codecUserData)
{
    int32_t ret = AV_ERR_OK;
    ret = OH_AudioCodec_RegisterCallback(decoder,
                                         {SampleCallback::OnCodecError, SampleCallback::OnCodecFormatChange,
                                          SampleCallback::OnNeedInputBuffer, SampleCallback::OnNewOutputBuffer},
                                         codecUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::Configure(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");

    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUDIO_SAMPLE_FORMAT, SAMPLE_S16LE);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_CHANNEL_COUNT, sampleInfo.audioChannelCount);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_SAMPLE_RATE, sampleInfo.audioSampleRate);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_CHANNEL_LAYOUT, sampleInfo.audioChannelLayout);
    AVCODEC_SAMPLE_LOGI("====== AudioDecoder config ======");

    int ret = OH_AudioCodec_Configure(decoder, format);
    AVCODEC_SAMPLE_LOGI("====== AudioDecoder config ======");
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Config failed, ret: %{public}d", ret);
    OH_AVFormat_Destroy(format);
    format = nullptr;

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::Config(const SampleInfo &sampleInfo, CodecUserData *codecUserData)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    CHECK_AND_RETURN_RET_LOG(codecUserData != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Invalid param: codecUserData");

    // Configure audio decoder
    int32_t ret = Configure(sampleInfo);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed");

    // SetCallback for audio decoder
    ret = SetCallback(codecUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR,
                             "Set callback failed, ret: %{public}d", ret);

    // Prepare audio decoder
    {
        int ret = OH_AudioCodec_Prepare(decoder);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed, ret: %{public}d", ret);
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::Start()
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int ret = OH_AudioCodec_Start(decoder);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Start failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::PushInputBuffer(CodecBufferInfo &info)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    int32_t ret = OH_AVBuffer_SetBufferAttr(reinterpret_cast<OH_AVBuffer *>(info.buffer), &info.attr);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set avbuffer attr failed");
    ret = OH_AudioCodec_PushInputBuffer(decoder, info.bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Push input data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::FreeOutputBuffer(uint32_t bufferIndex, bool render)
{
    CHECK_AND_RETURN_RET_LOG(decoder != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    ret = OH_AudioCodec_FreeOutputBuffer(decoder, bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Free output data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioDecoder::Release()
{
    if (decoder != nullptr) {
        OH_AudioCodec_Flush(decoder);
        OH_AudioCodec_Stop(decoder);
        OH_AudioCodec_Destroy(decoder);
        decoder = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}