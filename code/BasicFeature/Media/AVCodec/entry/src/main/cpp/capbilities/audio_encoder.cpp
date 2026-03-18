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

#include "audio_encoder.h"

#undef LOG_TAG
#define LOG_TAG "AudioEncoder"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
constexpr int64_t TIMEOUT_US = 5000000;  // 5 seconds
}  // namespace

AudioEncoder::~AudioEncoder()
{
    Release();
}

int32_t AudioEncoder::Create(const std::string &codecMime)
{
    encoder_ = OH_AudioCodec_CreateByMime(codecMime.c_str(), true);
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::SetCallback(CodecUserData *codecUserData)
{
    int32_t ret = AV_ERR_OK;
    ret = OH_AudioCodec_RegisterCallback(encoder_,
                                         { SampleCallback::OnCodecError, SampleCallback::OnCodecFormatChange,
                                           SampleCallback::OnNeedInputBuffer, SampleCallback::OnNewOutputBuffer },
                                         codecUserData);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);
    AVCODEC_SAMPLE_LOGI("====== AudioEncoder SetCallback ======");

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::Configure(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");

    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUDIO_SAMPLE_FORMAT, sampleInfo.audioSampleForamt);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_CHANNEL_COUNT, sampleInfo.audioChannelCount);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_SAMPLE_RATE, sampleInfo.audioSampleRate);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_BITRATE, sampleInfo.audioBitRate);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_CHANNEL_LAYOUT, sampleInfo.audioChannelLayout);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_MAX_INPUT_SIZE, sampleInfo.audioMaxInputSize);
    AVCODEC_SAMPLE_LOGI("audioChannelCount:%{public}d audioSampleRate:%{public}d audioBitRate:%{public}d "
                        "audioChannelLayout:%{public}ld",
                        sampleInfo.audioChannelCount, sampleInfo.audioSampleRate, sampleInfo.audioBitRate,
                        sampleInfo.audioChannelLayout);
    if (sampleInfo.codecSyncMode) {
        OH_AVFormat_SetIntValue(format, OH_MD_KEY_ENABLE_SYNC_MODE, sampleInfo.codecSyncMode);
    }

    int ret = OH_AudioCodec_Configure(encoder_, format);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Config failed, ret: %{public}d", ret);
    OH_AVFormat_Destroy(format);
    format = nullptr;

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::Config(const SampleInfo &sampleInfo, CodecUserData *codecUserData)
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");
    CHECK_AND_RETURN_RET_LOG(codecUserData != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Invalid param: codecUserData");

    int32_t ret = Configure(sampleInfo);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed");

    if (!sampleInfo.codecSyncMode) {
        ret = SetCallback(codecUserData);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR,
                                 "Set callback failed, ret: %{public}d", ret);
    }

    {
        int ret = OH_AudioCodec_Prepare(encoder_);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed, ret: %{public}d", ret);
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

OH_AVBuffer *AudioEncoder::GetInputBuffer(CodecBufferInfo &info, int64_t timeoutUs)
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, nullptr, "Encoder is null");
    auto ret = OH_AudioCodec_QueryInputBuffer(encoder_, &info.bufferIndex, timeoutUs);
    switch (ret) {
        case AV_ERR_OK: {
            OH_AVBuffer *buffer = OH_AudioCodec_GetInputBuffer(encoder_, info.bufferIndex);
            CHECK_AND_RETURN_RET_LOG(buffer != nullptr, nullptr, "Input buffer is null");
            return buffer;
        }
        case AV_ERR_TRY_AGAIN_LATER: {
            AVCODEC_SAMPLE_LOGE("Get input buffer timeout.");
            return nullptr;
        }
        default: {
            return nullptr;
        }
    }
    return nullptr;
}

int32_t AudioEncoder::GetOutputBuffer(CodecBufferInfo &info, int64_t timeoutUs)
{
    // 当输入的数据量可以编码出多帧数据时，需要多次调用获取输出缓冲区，才能取完编码后的数据。
    OH_AVErrCode ret = OH_AudioCodec_QueryOutputBuffer(encoder_, &info.bufferIndex, timeoutUs);
    if (ret == AV_ERR_TRY_AGAIN_LATER) {
        // 超时，可能输入的数据不足以编码出一帧，或者超时时间设置过短。
        AVCODEC_SAMPLE_LOGW("Get output buffer timeout.");
        return AVCODEC_SAMPLE_ERR_AGAIN; // continue;
    }
    if (ret != AV_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("query output buffer failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR; // break;
    }

    OH_AVBuffer *outputBuf = OH_AudioCodec_GetOutputBuffer(encoder_, info.bufferIndex);
    if (outputBuf == nullptr) {
        AVCODEC_SAMPLE_LOGE("get output buffer failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR; // break;
    }
    ret = OH_AVBuffer_GetBufferAttr(outputBuf, &info.attr);
    if (ret != AV_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("get output buffer attr failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR; // break;
    }
    info.buffer = reinterpret_cast<uintptr_t *>(outputBuf);
    if (info.attr.flags & AVCODEC_BUFFER_FLAGS_EOS) {
        // 不要在这里释放 buffer，让调用者处理 EOS 数据后再释放
        AVCODEC_SAMPLE_LOGI("Out buffer EOS flag detected");
        return AVCODEC_SAMPLE_ERR_OK;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::Start()
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");

    int ret = OH_AudioCodec_Start(encoder_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Start failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::PushInputData(CodecBufferInfo &info)
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");
    int32_t ret = OH_AVBuffer_SetBufferAttr(reinterpret_cast<OH_AVBuffer *>(info.buffer), &info.attr);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set avbuffer attr failed");
    ret = OH_AudioCodec_PushInputBuffer(encoder_, info.bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Push input data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::FreeOutputData(uint32_t bufferIndex)
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    ret = OH_AudioCodec_FreeOutputBuffer(encoder_, bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Free output data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::NotifyEndOfStream()
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");

    // 获取输入 buffer 并发送 EOS
    CodecBufferInfo bufferInfo(nullptr);
    auto buffer = GetInputBuffer(bufferInfo, TIMEOUT_US);
    if (buffer == nullptr) {
        AVCODEC_SAMPLE_LOGW("GetInputBuffer for EOS failed");
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    // 设置 EOS 标志
    bufferInfo.attr.size = 0;
    bufferInfo.attr.flags = AVCODEC_BUFFER_FLAGS_EOS;
    int32_t ret = OH_AVBuffer_SetBufferAttr(buffer, &bufferInfo.attr);
    if (ret != AV_ERR_OK) {
        AVCODEC_SAMPLE_LOGE("SetBufferAttr for EOS failed, ret: %{public}d", ret);
        return AVCODEC_SAMPLE_ERR_ERROR;
    }

    bufferInfo.buffer = reinterpret_cast<uintptr_t *>(buffer);
    ret = OH_AudioCodec_PushInputBuffer(encoder_, bufferInfo.bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR,
                             "PushInputBuffer for EOS failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::Stop()
{
    CHECK_AND_RETURN_RET_LOG(encoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Encoder is null");

    int ret = OH_AudioCodec_Flush(encoder_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Flush failed, ret: %{public}d", ret);

    ret = OH_AudioCodec_Stop(encoder_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Stop failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t AudioEncoder::Release()
{
    if (encoder_ != nullptr) {
        OH_AudioCodec_Flush(encoder_);
        OH_AudioCodec_Stop(encoder_);
        OH_AudioCodec_Destroy(encoder_);
        encoder_ = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}