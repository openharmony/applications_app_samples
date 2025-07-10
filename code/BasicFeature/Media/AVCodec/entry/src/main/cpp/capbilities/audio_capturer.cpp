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

#include "audio_capturer.h"
#include "sample_callback.h"


AudioCapturer::~AudioCapturer()
{
    AudioCapturerRelease();
}

// AudioCapturer Callback
static int32_t AudioCapturerOnReadData(OH_AudioCapturer *capturer, void *userData, void *buffer, int32_t bufferLen)
{
    (void)capturer;
    CodecUserData *codecUserData = static_cast<CodecUserData *>(userData);
    if (codecUserData != nullptr) {
        std::unique_lock<std::mutex> lock(codecUserData->inputMutex);
        codecUserData->WriteCache(buffer, bufferLen);
        codecUserData->inputCond.notify_all();
    }
    return 0;
}

void AudioCapturer::AudioCapturerInit(SampleInfo &sampleInfo, CodecUserData *audioEncContext)
{
    AudioCapturerRelease();

    // Create builder
    OH_AudioStream_Type type = AUDIOSTREAM_TYPE_CAPTURER;
    OH_AudioStreamBuilder_Create(&builder_, type);
    // set params and callbacks
    OH_AudioStreamBuilder_SetSamplingRate(builder_, sampleInfo.audioSampleRate);
    OH_AudioStreamBuilder_SetChannelCount(builder_, sampleInfo.audioChannelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder_, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetLatencyMode(builder_, AUDIOSTREAM_LATENCY_MODE_NORMAL);
    OH_AudioStreamBuilder_SetEncodingType(builder_, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioCapturer_Callbacks callbacks;
    callbacks.OH_AudioCapturer_OnReadData = AudioCapturerOnReadData;
    OH_AudioStreamBuilder_SetCapturerCallback(builder_, callbacks, audioEncContext);
    // create OH_AudioCapturer
    OH_AudioStreamBuilder_GenerateCapturer(builder_, &audioCapturer_);
}

void AudioCapturer::AudioCapturerStart()
{
    if (audioCapturer_ != nullptr) {
        OH_AudioCapturer_Start(audioCapturer_);
    }
}

void AudioCapturer::AudioCapturerRelease()
{
    if (audioCapturer_ != nullptr) {
        OH_AudioCapturer_Stop(audioCapturer_);
        OH_AudioCapturer_Release(audioCapturer_);
        audioCapturer_ = nullptr;
    }
    if (builder_ != nullptr) {
        OH_AudioStreamBuilder_Destroy(builder_);
        builder_ = nullptr;
    }
}