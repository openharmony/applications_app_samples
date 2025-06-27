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

#include "sample_callback.h"
#include "av_codec_sample_log.h"

namespace {
constexpr int LIMIT_LOGD_FREQUENCY = 50;
constexpr int32_t BYTES_PER_SAMPLE_2 = 2;
} // namespace

// 自定义写入数据函数
int32_t SampleCallback::OnRenderWriteData(OH_AudioRenderer *renderer, void *userData, void *buffer, int32_t length)
{
    (void)renderer;
    (void)length;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);

    // 将待播放的数据，按length长度写入buffer
    uint8_t *dest = (uint8_t *)buffer;
    size_t index = 0;
    std::unique_lock<std::mutex> lock(codecUserData->outputMutex);
    // 从队列中取出需要播放的长度为length的数据
    while (!codecUserData->renderQueue.empty() && index < length) {
        dest[index++] = codecUserData->renderQueue.front();
        codecUserData->renderQueue.pop();
    }
    AVCODEC_SAMPLE_LOGD("render BufferLength:%{public}d Out buffer count: %{public}u, renderQueue.size: %{public}u "
                        "renderReadSize: %{public}u",
                        length, codecUserData->outputFrameCount, codecUserData->renderQueue.size(), index);

    codecUserData->frameWrittenForSpeed +=
        length / codecUserData->speed / codecUserData->sampleInfo->audioChannelCount / BYTES_PER_SAMPLE_2;
    codecUserData->currentPosAudioBufferPts =
        codecUserData->endPosAudioBufferPts - codecUserData->renderQueue.size() /
                                                  codecUserData->sampleInfo->audioSampleRate /
                                                  codecUserData->sampleInfo->audioChannelCount / BYTES_PER_SAMPLE_2;

    if (codecUserData->renderQueue.size() < length) {
        codecUserData->renderCond.notify_all();
    }
    return 0;
}
// 自定义音频流事件函数
int32_t SampleCallback::OnRenderStreamEvent(OH_AudioRenderer *renderer, void *userData, OH_AudioStream_Event event)
{
    (void)renderer;
    (void)userData;
    (void)event;
    // 根据event表示的音频流事件信息，更新播放器状态和界面
    return 0;
}
// 自定义音频中断事件函数
int32_t SampleCallback::OnRenderInterruptEvent(OH_AudioRenderer *renderer, void *userData,
                                               OH_AudioInterrupt_ForceType type, OH_AudioInterrupt_Hint hint)
{
    (void)renderer;
    (void)userData;
    (void)type;
    (void)hint;
    // 根据type和hint表示的音频中断信息，更新播放器状态和界面
    return 0;
}
// 自定义异常回调函数
int32_t SampleCallback::OnRenderError(OH_AudioRenderer *renderer, void *userData, OH_AudioStream_Result error)
{
    (void)renderer;
    (void)userData;
    (void)error;
    AVCODEC_SAMPLE_LOGE("OnRenderError");
    // 根据error表示的音频异常信息，做出相应的处理
    return 0;
}

void SampleCallback::OnCodecError(OH_AVCodec *codec, int32_t errorCode, void *userData)
{
    (void)codec;
    (void)errorCode;
    (void)userData;
    AVCODEC_SAMPLE_LOGE("On codec error, error code: %{public}d", errorCode);
}

void SampleCallback::OnCodecFormatChange(OH_AVCodec *codec, OH_AVFormat *format, void *userData)
{
    AVCODEC_SAMPLE_LOGI("On codec format change");
}

void SampleCallback::OnNeedInputBuffer(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *buffer, void *userData)
{
    if (userData == nullptr) {
        return;
    }
    (void)codec;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);
    std::unique_lock<std::mutex> lock(codecUserData->inputMutex);
    if (codecUserData->isEncFirstFrame) {
        OH_AVFormat *format = OH_VideoEncoder_GetInputDescription(codec);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_PIC_WIDTH, &codecUserData->width);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_PIC_HEIGHT, &codecUserData->height);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_STRIDE, &codecUserData->widthStride);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_SLICE_HEIGHT, &codecUserData->heightStride);
        OH_AVFormat_Destroy(format);
        codecUserData->isEncFirstFrame = false;
    }
    codecUserData->inputBufferInfoQueue.emplace(index, buffer);
    codecUserData->inputCond.notify_all();
}

void SampleCallback::OnNewOutputBuffer(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *buffer, void *userData)
{
    if (userData == nullptr) {
        return;
    }
    (void)codec;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);
    std::unique_lock<std::mutex> lock(codecUserData->outputMutex);
    if (codecUserData->isDecFirstFrame) {
        OH_AVFormat *format = OH_VideoDecoder_GetOutputDescription(codec);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_PIC_WIDTH, &codecUserData->width);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_PIC_HEIGHT, &codecUserData->height);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_STRIDE, &codecUserData->widthStride);
        OH_AVFormat_GetIntValue(format, OH_MD_KEY_VIDEO_SLICE_HEIGHT, &codecUserData->heightStride);
        OH_AVFormat_Destroy(format);
        codecUserData->isDecFirstFrame = false;
    }
    codecUserData->outputBufferInfoQueue.emplace(index, buffer);
    codecUserData->outputCond.notify_all();
}
