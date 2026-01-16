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

#include "video_decoder.h"

#undef LOG_TAG
#define LOG_TAG "VideoDecoder"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
constexpr int ROTATION_ANGLE = 90;
} // namespace

VideoDecoder::~VideoDecoder() { Release(); }

OH_AVCodec *VideoDecoder::GetCodecByCategory(const char *mime, bool isEncoder, OH_AVCodecCategory category)
{
    OH_AVCapability *capability = OH_AVCodec_GetCapabilityByCategory(mime, isEncoder, category);
    CHECK_AND_RETURN_RET_LOG(capability != nullptr, nullptr, "Capability is nullptr");
    const char *codecName = OH_AVCapability_GetName(capability);
    return OH_VideoDecoder_CreateByName(codecName);
}

int32_t VideoDecoder::Create(const std::string &videoCodecMime, int32_t videoDecoderType)
{
    switch (videoDecoderType) {
        case AUTO:
            decoder_ = OH_VideoDecoder_CreateByMime(videoCodecMime.c_str());
            CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Create failed");
            break;
        case VIDEO_HW_DECODER:
            if (!strcmp(videoCodecMime.data(), "video/avc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_AVC, false, HARDWARE);
            } else if (!strcmp(videoCodecMime.data(), "video/hevc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_HEVC, false, HARDWARE);
            } else if (!strcmp(videoCodecMime.data(), "video/vvc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_VVC, false, HARDWARE);
            } else {
                AVCODEC_SAMPLE_LOGE("INVALID MIMETYPE");
                return AVCODEC_SAMPLE_ERR_ERROR;
            }
            break;
        case VIDEO_SW_DECODER:
            if (!strcmp(videoCodecMime.data(), "video/avc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_AVC, false, SOFTWARE);
            } else if (!strcmp(videoCodecMime.data(), "video/hevc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_HEVC, false, SOFTWARE);
            } else if (!strcmp(videoCodecMime.data(), "video/vvc")) {
                decoder_ = GetCodecByCategory(OH_AVCODEC_MIMETYPE_VIDEO_VVC, false, SOFTWARE);
            } else {
                AVCODEC_SAMPLE_LOGE("INVALID MIMETYPE");
                return AVCODEC_SAMPLE_ERR_ERROR;
            }
            break;
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
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Set callback failed, ret: %{public}d", ret);

    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Configure(const SampleInfo &sampleInfo)
{
    OH_AVFormat *format = OH_AVFormat_Create();
    CHECK_AND_RETURN_RET_LOG(format != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "AVFormat create failed");

    OH_AVFormat_SetIntValue(format, OH_MD_KEY_WIDTH, sampleInfo.videoWidth);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_HEIGHT, sampleInfo.videoHeight);
    OH_AVFormat_SetDoubleValue(format, OH_MD_KEY_FRAME_RATE, sampleInfo.frameRate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_PIXEL_FORMAT, sampleInfo.pixelFormat);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_ROTATION, sampleInfo.rotation);
    if (sampleInfo.codecSyncMode) {
        OH_AVFormat_SetIntValue(format, OH_MD_KEY_ENABLE_SYNC_MODE, sampleInfo.codecSyncMode);
    }

    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");
    AVCODEC_SAMPLE_LOGI("%{public}d*%{public}d, %{public}.1ffps", sampleInfo.videoWidth, sampleInfo.videoHeight,
                        sampleInfo.frameRate);
    AVCODEC_SAMPLE_LOGI("====== VideoDecoder config ======");

    int ret = OH_VideoDecoder_Configure(decoder_, format);
    OH_AVFormat_Destroy(format);
    format = nullptr;
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Config failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Config(const SampleInfo &sampleInfo, CodecUserData *codecUserData)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    CHECK_AND_RETURN_RET_LOG(codecUserData != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Invalid param: codecUserData");

    // Configure video decoder
    int32_t ret = Configure(sampleInfo);
    CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Configure failed");

    // SetSurface from video decoder
    if (sampleInfo.window != nullptr) {
        int ret = OH_VideoDecoder_SetSurface(decoder_, sampleInfo.window);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK && sampleInfo.window, AVCODEC_SAMPLE_ERR_ERROR,
                                 "Set surface failed, ret: %{public}d", ret);
    }

    // SetCallback for video decoder
    if (!sampleInfo.codecSyncMode) {
        ret = SetCallback(codecUserData);
        CHECK_AND_RETURN_RET_LOG(ret == AVCODEC_SAMPLE_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR,
                                "Set callback failed, ret: %{public}d", ret);
    }

    // Prepare video decoder
    {
        int ret = OH_VideoDecoder_Prepare(decoder_);
        CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Prepare failed, ret: %{public}d", ret);
    }

    return AVCODEC_SAMPLE_ERR_OK;
}

OH_AVBuffer *VideoDecoder::GetInputBuffer(CodecBufferInfo &info, int64_t timeoutUs)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, nullptr, "Decoder is null");
    std::shared_lock<std::shared_mutex> lock(codecMutex);
    int32_t ret = OH_VideoDecoder_QueryInputBuffer(decoder_, &info.bufferIndex, timeoutUs);
    switch (ret) {
        case AV_ERR_OK: {
            OH_AVBuffer *buffer = OH_VideoDecoder_GetInputBuffer(decoder_, info.bufferIndex);
            CHECK_AND_RETURN_RET_LOG(buffer != nullptr, nullptr, "Input buffer is null");
            return buffer;
        /**
            uint8_t *addr = OH_AVBuffer_GetAddr(buffer);
            CHECK_AND_RETURN_RET_LOG(addr != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Input buffer addr is null");
            // buffer数据填充。
            int32_t capacity = OH_AVBuffer_GetCapacity(buffer);
            if (size > capacity) {
                // 异常处理。
            }
            memcpy(addr, frameData, size);

            OH_AVCodecBufferAttr info;
            // buffer属性配置。
            // 配置帧数据的输入尺寸、偏移量、时间戳等字段信息。
            info.size = size;
            info.offset = offset;
            info.pts = pts;
            if (inFile_->eof()) {
                info.flags = AVCODEC_BUFFER_FLAGS_EOS;
            } else {
                info.flags = flags;
            }
            OH_AVErrCode setBufferRet = OH_AVBuffer_SetBufferAttr(buffer, &info);
            if (setBufferRet != AV_ERR_OK) {
                // 异常处理。
                return false;
            }

            OH_AVErrCode pushInputRet = OH_VideoDecoder_PushInputBuffer(videoDec, index);
            if (pushInputRet != AV_ERR_OK) {
                // 异常处理。
                return false;
            }
            if (inFile_->eof()) {
                inputDone = 1;
            }
            break;
        **/
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

bool VideoDecoder::GetOutputBuffer(CodecBufferInfo &info, int64_t timeoutUs)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, false, "Decoder is null.");
    std::shared_lock<std::shared_mutex> lock(codecMutex);

    int32_t  ret = OH_VideoDecoder_QueryOutputBuffer(decoder_, &info.bufferIndex, timeoutUs);
    switch (ret) {
        case AV_ERR_OK: {
            OH_AVBuffer *buffer = OH_VideoDecoder_GetOutputBuffer(decoder_, info.bufferIndex);
            CHECK_AND_RETURN_RET_LOG(buffer != nullptr, false, "Output buffer is null.");
            // 获取解码后信息。
            OH_AVErrCode getBufferRet = OH_AVBuffer_GetBufferAttr(buffer, &info.attr);
            CHECK_AND_RETURN_RET_LOG(getBufferRet == AV_ERR_OK, false, "Get buffer attr error.");
            return true;
            /**
            if (info.flags & AVCODEC_BUFFER_FLAGS_EOS) {
                outputDone = 1;
            }

            // 解码输出数据处理。
            // 值由开发者决定。
            bool isRender;
            bool isNeedRenderAtTime;
            OH_AVErrCode result = AV_ERR_OK;
            if (isRender) {
                // 显示并释放已完成处理的信息，index为对应buffer队列的下标。
                if (isNeedRenderAtTime){
                    // 获取系统绝对时间，renderTimestamp由开发者结合业务指定显示时间。
                    int64_t renderTimestamp =
                        std::chrono::duration_cast<std::chrono::nanoseconds>
                            (std::chrono::high_resolution_clock::now().time_since_epoch()).count();
                    result = OH_VideoDecoder_RenderOutputBufferAtTime(videoDec, index, renderTimestamp);
                } else {
                    result = OH_VideoDecoder_RenderOutputBuffer(videoDec, index);
                }
            } else {
                // 释放已完成处理的信息。
                result = OH_VideoDecoder_FreeOutputBuffer(videoDec, index);
            }
            if (result != AV_ERR_OK) {
                // 异常处理。
                return false;
            }
            break;
            **/
        }
        case AV_ERR_TRY_AGAIN_LATER: {
            AVCODEC_SAMPLE_LOGE("Get input buffer timeout.");
            return false;
        }
        case AV_ERR_STREAM_CHANGED: {
            int32_t width = 0;
            int32_t height = 0;
            auto format =
                std::shared_ptr<OH_AVFormat>(OH_VideoDecoder_GetOutputDescription(decoder_), OH_AVFormat_Destroy);
            CHECK_AND_BREAK_LOG(format != nullptr, "Format is nullptr.");
            // 获取新宽高。
            bool getIntRet = OH_AVFormat_GetIntValue(format.get(), OH_MD_KEY_VIDEO_PIC_WIDTH, &width) &&
                             OH_AVFormat_GetIntValue(format.get(), OH_MD_KEY_VIDEO_PIC_HEIGHT, &height);
            CHECK_AND_BREAK_LOG(getIntRet, "Decoder get int value failed.");
            AVCODEC_SAMPLE_LOGI("Stream Changed. Width: %{public}i, height: %{public}i", width, height);
            return GetOutputBuffer(info, timeoutUs);
        }
        default: {
            return false;
        }
    }
    return false;
}

int32_t VideoDecoder::Start()
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int ret = OH_VideoDecoder_Start(decoder_);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Start failed, ret: %{public}d", ret);
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::PushInputBuffer(CodecBufferInfo &info)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");
    int32_t ret = OH_VideoDecoder_PushInputBuffer(decoder_, info.bufferIndex);
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Push input data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::FreeOutputBuffer(uint32_t bufferIndex, bool render)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    if (render) {
        ret = OH_VideoDecoder_RenderOutputBuffer(decoder_, bufferIndex);
    } else {
        ret = OH_VideoDecoder_FreeOutputBuffer(decoder_, bufferIndex);
    }
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Free output data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::FreeOutputBuffer(uint32_t bufferIndex, bool render, int64_t timeStamp)
{
    CHECK_AND_RETURN_RET_LOG(decoder_ != nullptr, AVCODEC_SAMPLE_ERR_ERROR, "Decoder is null");

    int32_t ret = AVCODEC_SAMPLE_ERR_OK;
    if (render) {
        ret = OH_VideoDecoder_RenderOutputBufferAtTime(decoder_, bufferIndex, timeStamp);
    } else {
        ret = OH_VideoDecoder_FreeOutputBuffer(decoder_, bufferIndex);
    }
    CHECK_AND_RETURN_RET_LOG(ret == AV_ERR_OK, AVCODEC_SAMPLE_ERR_ERROR, "Free output data failed");
    return AVCODEC_SAMPLE_ERR_OK;
}

int32_t VideoDecoder::Release()
{
    if (decoder_ != nullptr) {
        OH_VideoDecoder_Stop(decoder_);
        OH_VideoDecoder_Destroy(decoder_);
        decoder_ = nullptr;
    }
    return AVCODEC_SAMPLE_ERR_OK;
}
