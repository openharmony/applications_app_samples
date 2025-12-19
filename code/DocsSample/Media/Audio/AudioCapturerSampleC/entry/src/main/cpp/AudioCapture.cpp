/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

#include "napi/native_api.h"
#include "ohaudio/native_audiorenderer.h"
// [Start header_file]
#include <ohaudio/native_audiocapturer.h>
#include <ohaudio/native_audiostreambuilder.h>
// [End header_file]
#include <sstream>
#include <cstring>

// [Start Set_AudioCallbackFunction]
void MyOnReadData_NewAPI(
    OH_AudioCapturer* capturer,
    void* userData,
    void* audioData,
    int32_t audioDataSize)
{
    // 从buffer中取出length长度的录音数据。
}

void MyOnInterruptEvent_NewAPI(
    OH_AudioCapturer* capturer,
    void* userData,
    OH_AudioInterrupt_ForceType type,
    OH_AudioInterrupt_Hint hint)
{
    // 根据type和hint表示的音频中断信息，更新录制器状态和界面。
}

void MyOnError_NewAPI(
    OH_AudioCapturer* capturer,
    void* userData,
    OH_AudioStream_Result error)
{
    // 根据error表示的音频异常信息，做出相应的处理。
}
// [StartExclude Set_AudioCallbackFunction]

// [Start callback_Capture]
// [Start callbackNullptr_Capture]
// [Start SetCapturerReadDataCallback]
// [Start public_Function]
// [Start SetCapturerCallback]
int32_t MyOnReadData_Legacy(
    OH_AudioCapturer* capturer,
    void* userData,
    void* buffer,
    int32_t length)
{
    // 从buffer中取出length长度的录音数据。
    return 0;
}
// [StartExclude SetCapturerReadDataCallback]
// [StartExclude public_Function]
int32_t MyOnInterruptEvent_Legacy(
    OH_AudioCapturer* capturer,
    void* userData,
    OH_AudioInterrupt_ForceType type,
    OH_AudioInterrupt_Hint hint)
{
    // 根据type和hint表示的音频中断信息，更新录制器状态和界面。
    return 0;
}
// [StartExclude callback_Capture]
// [StartExclude callbackNullptr_Capture]

int32_t MyOnStreamEvent_Legacy(
    OH_AudioCapturer* capturer,
    void* userData,
    OH_AudioStream_Event event)
{
    // 根据event表示的音频流事件信息，更新录制器状态和界面。
    return 0;
}

int32_t MyOnError_Legacy(
    OH_AudioCapturer* capturer,
    void* userData,
    OH_AudioStream_Result error)
{
    // 根据error表示的音频异常信息，做出相应的处理。
    return 0;
}
// [StartExclude SetCapturerCallback]

// [EndExclude public_Function]
// [Start SetRendererCallback]
int32_t MyOnWriteData(
    OH_AudioRenderer* renderer,
    void* userData,
    void* buffer,
    int32_t length)
{
    // 从公共缓存BUFFER中读取数据，并按length长度写入buffer。
    return 0;
}
// [End public_Function]
int32_t MyOnStreamEvent_Renderer(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioStream_Event event)
{
    // 根据event表示的音频流事件信息，更新播放器状态和界面。
    return 0;
}

int32_t MyOnInterruptEvent_Renderer(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioInterrupt_ForceType type,
    OH_AudioInterrupt_Hint hint)
{
    // 根据type和hint表示的音频中断信息，更新播放器状态和界面。
    return 0;
}

int32_t MyOnError_Renderer(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioStream_Result error)
{
    // 根据error表示的音频异常信息，做出相应的处理。
    return 0;
}
// [StartExclude SetRendererCallback]

// 创建录制音频流（新版回调）
napi_value CreateAudioCapturer(napi_env env, napi_callback_info info)
{
    // [Start Create_Capture]
    OH_AudioStreamBuilder* builder;
    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER);
    // [End Create_Capture]

    // [Start Configure_Capture]
    // 设置音频采样率。
    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    // 设置音频声道。
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    // 设置音频采样格式。
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    // 设置音频流的编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    // 设置输入音频流的工作场景。
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);
    // [End Configure_Capture]

    // [EndExclude Set_AudioCallbackFunction]
    // 配置音频中断事件回调函数。
    OH_AudioCapturer_OnInterruptCallback OnIntereruptCb = MyOnInterruptEvent_NewAPI;
    OH_AudioStreamBuilder_SetCapturerInterruptCallback(builder, OnIntereruptCb, nullptr);

    // 配置音频异常回调函数。
    OH_AudioCapturer_OnErrorCallback OnErrorCb = MyOnError_NewAPI;
    OH_AudioStreamBuilder_SetCapturerErrorCallback(builder, OnErrorCb, nullptr);

    // 配置音频输入流的回调。
    OH_AudioCapturer_OnReadDataCallback OnReadDataCb = MyOnReadData_NewAPI;
    OH_AudioStreamBuilder_SetCapturerReadDataCallback(builder, OnReadDataCb, nullptr);
    // [End Set_AudioCallbackFunction]

    // [Start GenerateCapturer_Capture]
    OH_AudioCapturer* audioCapturer;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &audioCapturer);
    // [End GenerateCapturer_Capture]
    
    // [Start Destroy_Capture]
    OH_AudioStreamBuilder_Destroy(builder);
    // [End Destroy_Capture]

    std::stringstream ss;
    ss << "创建录制音频流成功\n";
    ss << "采样率: 48000Hz\n";
    ss << "声道数: 2\n";
    ss << "回调方式: 新版API";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 创建录制音频流（旧版回调 - 方式1）
napi_value CreateAudioCapturerLegacy1(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    OH_AudioStreamBuilder* builder;
    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER);

    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);

    OH_AudioCapturer_Callbacks callbacks;
    
    // [EndExclude callback_Capture]
    // 配置回调函数，如果需要监听，则赋值。
    callbacks.OH_AudioCapturer_OnReadData = MyOnReadData_Legacy;
    callbacks.OH_AudioCapturer_OnInterruptEvent = MyOnInterruptEvent_Legacy;
    
    // （必选）如果不需要监听，使用空指针初始化。
    callbacks.OH_AudioCapturer_OnStreamEvent = nullptr;
    callbacks.OH_AudioCapturer_OnError = nullptr;
    // [End callback_Capture]

    OH_AudioStreamBuilder_SetCapturerCallback(builder, callbacks, nullptr);

    OH_AudioCapturer* audioCapturer;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &audioCapturer);
    OH_AudioStreamBuilder_Destroy(builder);

    ss << "创建录制音频流成功（使用空指针初始化）\n";
    ss << "使用空指针初始化未使用的回调";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 创建录制音频流（旧版回调 - 方式2）
napi_value CreateAudioCapturerLegacy2(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    OH_AudioStreamBuilder* builder;
    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER);

    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);

    // [EndExclude callbackNullptr_Capture]
    // 使用前，初始化并清零结构体。
    OH_AudioCapturer_Callbacks callbacks = {0};
    // 配置需要的回调函数。
    callbacks.OH_AudioCapturer_OnReadData = MyOnReadData_Legacy;
    callbacks.OH_AudioCapturer_OnInterruptEvent = MyOnInterruptEvent_Legacy;
    // [End callbackNullptr_Capture]

    OH_AudioStreamBuilder_SetCapturerCallback(builder, callbacks, nullptr);

    OH_AudioCapturer* audioCapturer;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &audioCapturer);
    OH_AudioStreamBuilder_Destroy(builder);

    ss << "创建录制音频流成功（使用清零结构体初始化）\n";
    ss << "使用清零结构体";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 创建耳返录制流
napi_value CreateAudioCapturerLoopback(napi_env env, napi_callback_info info)
{
    OH_AudioStream_Type streamType = AUDIOSTREAM_TYPE_CAPTURER;
    // [Start create_StreamType]
    OH_AudioStreamBuilder* builder;
    OH_AudioStreamBuilder_Create(&builder, streamType);
    // [End create_StreamType]
    
    // [Start latencyMode_Capture]
    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builder, latencyMode);
    // [End latencyMode_Capture]
    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);
    // [EndExclude SetCapturerCallback]
    OH_AudioCapturer_Callbacks callbacks;
    // 配置回调函数。
    callbacks.OH_AudioCapturer_OnReadData = MyOnReadData_Legacy;
    callbacks.OH_AudioCapturer_OnStreamEvent = MyOnStreamEvent_Legacy;
    callbacks.OH_AudioCapturer_OnInterruptEvent = MyOnInterruptEvent_Legacy;
    callbacks.OH_AudioCapturer_OnError = MyOnError_Legacy;

    OH_AudioStreamBuilder_SetCapturerCallback(builder, callbacks, nullptr);
    // [End SetCapturerCallback]

    OH_AudioCapturer* audioCapturer;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &audioCapturer);
    OH_AudioStreamBuilder_Destroy(builder);

    std::stringstream ss;
    ss << "创建耳返录制流成功\n";
    ss << "时延模式: FAST";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 创建低时延模式录制流
napi_value CreateLowLatencyModeCapturer(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    OH_AudioStreamBuilder* builder;

    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_CAPTURER);

    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builder, latencyMode);

    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(builder, AUDIOSTREAM_SOURCE_TYPE_MIC);

    // [EndExclude SetCapturerReadDataCallback]
    // 配置读入音频数据回调函数。
    OH_AudioCapturer_OnReadDataCallback readDataCb = MyOnReadData_NewAPI;
    OH_AudioStreamBuilder_SetCapturerReadDataCallback(builder, readDataCb, nullptr);
    // [End SetCapturerReadDataCallback]

    OH_AudioCapturer* audioCapturer;
    OH_AudioStreamBuilder_GenerateCapturer(builder, &audioCapturer);
    OH_AudioStreamBuilder_Destroy(builder);

    ss << "创建低时延模式录制流成功\n";
    ss << "时延模式: FAST\n";
    ss << "适用场景: k歌、直播";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 创建耳返播放流
napi_value CreateAudioRendererLoopback(napi_env env, napi_callback_info info)
{
    // [Start Create_Renderer]
    OH_AudioStreamBuilder* builder;
    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_RENDERER);
    // [End Create_Renderer]

    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builder, latencyMode);

    const int SAMPLING_RATE_48K = 48000;
    OH_AudioStreamBuilder_SetSamplingRate(builder, SAMPLING_RATE_48K);
    const int channelCount = 2;
    OH_AudioStreamBuilder_SetChannelCount(builder, channelCount);
    OH_AudioStreamBuilder_SetSampleFormat(builder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    // [Start SetRendererInfo]
    OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);
    // [End SetRendererInfo]

    // [EndExclude SetRendererCallback]
    OH_AudioRenderer_Callbacks callbacks;
    
    // 配置回调函数。
    callbacks.OH_AudioRenderer_OnWriteData = MyOnWriteData;
    callbacks.OH_AudioRenderer_OnStreamEvent = MyOnStreamEvent_Renderer;
    callbacks.OH_AudioRenderer_OnInterruptEvent = MyOnInterruptEvent_Renderer;
    callbacks.OH_AudioRenderer_OnError = MyOnError_Renderer;

    // 设置输出音频流的回调。
    OH_AudioStreamBuilder_SetRendererCallback(builder, callbacks, nullptr);
    // [End SetRendererCallback]

    // [Start GenerateRenderer]
    OH_AudioRenderer* audioRenderer;
    OH_AudioStreamBuilder_GenerateRenderer(builder, &audioRenderer);
    // [End GenerateRenderer]
    OH_AudioStreamBuilder_Destroy(builder);

    std::stringstream ss;
    ss << "创建耳返播放流成功\n";
    ss << "时延模式: FAST";

    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"CreateAudioCapturer", nullptr, CreateAudioCapturer, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateAudioCapturerLegacy1", nullptr, CreateAudioCapturerLegacy1, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"CreateAudioCapturerLegacy2", nullptr, CreateAudioCapturerLegacy2, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"CreateAudioCapturerLoopback", nullptr, CreateAudioCapturerLoopback, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"CreateLowLatencyModeCapturer", nullptr, CreateLowLatencyModeCapturer, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"CreateAudioRendererLoopback", nullptr, CreateAudioRendererLoopback, nullptr, nullptr, nullptr, napi_default,
         nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
