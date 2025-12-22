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
#include "ohaudio/native_audiocapturer.h"
// [Start Render_headFile]
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostreambuilder.h>
// [End Render_headFile]
#include "ohaudio/native_audio_session_manager.h"
// [Start GetAudioResourceManager]
#include <ohaudio/native_audio_resource_manager.h>
// [StartExclude GetAudioResourceManager]
// [Start CreateWorkgroup]
#include <chrono>
// [StartExclude CreateWorkgroup]
#include <cstdint>
#include <sstream>

// 全局变量 - 用于主要功能
// [Start Render_CreateStreamType]
// [Start Render_Create]
OH_AudioStreamBuilder* builder;
// [StartExclude Render_CreateStreamType]
// [StartExclude Render_Create]
// [Start Render_GenerateRenderer]
OH_AudioRenderer* audioRenderer;
// [StartExclude Render_GenerateRenderer]
// [EndExclude GetAudioResourceManager]
OH_AudioResourceManager *resMgr;
// [StartExclude GetAudioResourceManager]
// [EndExclude CreateWorkgroup]
int32_t g_tokenId;
OH_AudioWorkgroup *grp = nullptr;
// [StartExclude CreateWorkgroup]
// [Start Render_CustomCallback]
// [Start Render_callBackInit]
OH_AudioRenderer_Callbacks callbacks;
// [StartExclude Render_callBackInit]
// [StartExclude Render_CustomCallback]

// ==================== 回调函数 - CreateAudioRender 使用 ====================
// [Start Render_Create]
// [Start Render_Callback]
// [Start Render_SetRendererWriteDataCallback]
// 自定义写入数据函数。
static OH_AudioData_Callback_Result MyOnWriteData_New(
    OH_AudioRenderer* renderer,
    void* userData,
    void* audioData,
    int32_t audioDataSize)
{
    // 将待播放的数据，按audioDataSize长度写入audioData。
    // 如果开发者不希望播放某段audioData，返回AUDIO_DATA_CALLBACK_RESULT_INVALID即可。
    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}
// [StartExclude Render_SetRendererWriteDataCallback]

// 自定义音频中断事件函数。
void MyOnInterruptEvent_New(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioInterrupt_ForceType type,
    OH_AudioInterrupt_Hint hint)
{
    // 根据type和hint表示的音频中断信息，更新播放器状态和界面。
}

// 自定义异常回调函数。
void MyOnError_New(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioStream_Result error)
{
    // 根据error表示的音频异常信息，做出相应的处理。
}
// [StartExclude Render_Callback]

// [Start Render_SetWriteDataWithMetadataCallback]
// 自定义同时写入PCM数据和元数据函数。
int32_t MyOnWriteDataWithMetadata_New(
    OH_AudioRenderer* renderer,
    void* userData,
    void* audioData,
    int32_t audioDataSize,
    void* metadata,
    int32_t metadataSize)
{
    // 将待播放的PCM数据和元数据，分别按audioDataSize和metadataSize写入buffer。
    return 0;
}
// [StartExclude Render_SetWriteDataWithMetadataCallback]

// ==================== 回调函数 - registcallback 使用（Legacy API）====================
// [EndExclude Render_CustomCallback]
// [EndExclude Render_callBackInit]
// 自定义写入数据函数。
int32_t MyOnWriteData_Legacy(
    OH_AudioRenderer* renderer,
    void* userData,
    void* buffer,
    int32_t length)
{
    // 将待播放的数据，按length长度写入buffer。
    return 0;
}

// 自定义音频中断事件函数。
int32_t MyOnInterruptEvent_Legacy(
    OH_AudioRenderer* renderer,
    void* userData,
    OH_AudioInterrupt_ForceType type,
    OH_AudioInterrupt_Hint hint)
{
    // 根据type和hint表示的音频中断信息，更新播放器状态和界面。
    return 0;
}
// [StartExclude Render_callBackInit]
// [StartExclude Render_CustomCallback]

// 自定义同时写入PCM数据和元数据函数。
int32_t MyOnWriteDataWithMetadata_Legacy(
    OH_AudioRenderer* renderer,
    void* userData,
    void* audioData,
    int32_t audioDataSize,
    void* metadata,
    int32_t metadataSize)
{
    // 将待播放的PCM数据和元数据，分别按audioDataSize和metadataSize写入buffer。
    return 0;
}

// ==================== NAPI 函数实现 ====================

napi_value CreateAudioRender(napi_env env, napi_callback_info info)
{
    // [EndExclude Render_Create]
    OH_AudioStreamBuilder_Create(&builder, AUDIOSTREAM_TYPE_RENDERER);
    // [End Render_Create]
    // [Start Render_ConfigStream]
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
    // 设置输出音频流的工作场景。
    OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);
    // [End Render_ConfigStream]
    
    // [EndExclude Render_Callback]
    // 配置音频中断事件回调函数。
    OH_AudioRenderer_OnInterruptCallback OnIntereruptCb = MyOnInterruptEvent_New;
    OH_AudioStreamBuilder_SetRendererInterruptCallback(builder, OnIntereruptCb, nullptr);
    
    // 配置音频异常回调函数。
    OH_AudioRenderer_OnErrorCallback OnErrorCb = MyOnError_New;
    OH_AudioStreamBuilder_SetRendererErrorCallback(builder, OnErrorCb, nullptr);
    
    // [EndExclude Render_SetRendererWriteDataCallback]
    // 配置写入音频数据回调函数。
    OH_AudioRenderer_OnWriteDataCallback writeDataCb = MyOnWriteData_New;
    OH_AudioStreamBuilder_SetRendererWriteDataCallback(builder, writeDataCb, nullptr);
    // [End Render_SetRendererWriteDataCallback]
    // [End Render_Callback]
    
    //设置时延模式
    // [Start OH_AudioStreamBuilder_SetLatencyMode]
    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builder, latencyMode);
    // [End OH_AudioStreamBuilder_SetLatencyMode]

    //设置声道布局
    // [Start Render_SetChannelLayout]
    OH_AudioStreamBuilder_SetChannelLayout(builder, CH_LAYOUT_STEREO);
    // [End Render_SetChannelLayout]
    // [EndExclude Render_GenerateRenderer]
    OH_AudioStreamBuilder_GenerateRenderer(builder, &audioRenderer);
    // [End Render_GenerateRenderer]

    // [EndExclude Render_SetWriteDataWithMetadataCallback]
    // 设置编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID);
    // 配置回调函数。
    OH_AudioRenderer_WriteDataWithMetadataCallback metadataCallback = MyOnWriteDataWithMetadata_New;
    // 设置同时写入PCM数据和元数据的回调。
    OH_AudioStreamBuilder_SetWriteDataWithMetadataCallback(builder, metadataCallback, nullptr);
    // [End Render_SetWriteDataWithMetadataCallback]
    
    std::stringstream ss;
    ss << "创建播放流成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value DestroyAudioRender(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    if (builder) {
        // [Start Render_Destroy]
        OH_AudioStreamBuilder_Destroy(builder);
        // [End Render_Destroy]
        ss << "销毁播放流成功";
    }
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value SetVolume(napi_env env, napi_callback_info info)
{
    // [Start Render_SetVolume]
    float volume = 0.5f;

    // 设置当前音频流音量值。
    OH_AudioRenderer_SetVolume(audioRenderer, volume);
    // [End Render_SetVolume]
    std::stringstream ss;
    ss << "设置音量成功\n";
    ss << "音量值: " << volume;
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value setLatencyMode(napi_env env, napi_callback_info info)
{
    // [Start Render_SetLatencyMode]
    OH_AudioStreamBuilder_SetLatencyMode(builder, AUDIOSTREAM_LATENCY_MODE_FAST);
    // [End Render_SetLatencyMode]
    std::stringstream ss;
    ss << "设置时延模式成功\n";
    ss << "模式: FAST";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value getLatencyMode(napi_env env, napi_callback_info info)
{
    // [Start Render_CheckLatencyMode]
    OH_AudioStream_Result OH_AudioRenderer_GetLatencyMode
    (OH_AudioRenderer *renderer, OH_AudioStream_LatencyMode *latencyMode);
    // [End Render_CheckLatencyMode]
    std::stringstream ss;
    ss << "获取时延模式成功\n";
    ss << "当前模式: ";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value workgroupcreate(napi_env env, napi_callback_info info)
{
    // [EndExclude GetAudioResourceManager]
    OH_AudioManager_GetAudioResourceManager(&resMgr);
    // [End GetAudioResourceManager]
    // [EndExclude CreateWorkgroup]
    OH_AudioResourceManager_CreateWorkgroup(resMgr, "workgroup", &grp);
    OH_AudioWorkgroup_AddCurrentThread(grp, &g_tokenId);
    // [End CreateWorkgroup]
    std::stringstream ss;
    ss << "创建工作组成功\n";
    ss << "工作组名: workgroup\n";
    ss << "Token ID: " << g_tokenId;
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value workgroupprocess(napi_env env, napi_callback_info info)
{
    // [Start OH_AudioWorkgroup_Start]
    constexpr static uint64_t intervalMs = 20;
    bool threadShouldRun = true;

    while (threadShouldRun) {
        auto now = std::chrono::system_clock::now().time_since_epoch();
        auto startTimeMs = std::chrono::duration_cast<std::chrono::milliseconds>(now).count();
        OH_AudioWorkgroup_Start(grp, startTimeMs, startTimeMs + intervalMs);
        threadShouldRun = false;
        // 应用音频数据处理。
        OH_AudioWorkgroup_Stop(grp);
    }
    // [End OH_AudioWorkgroup_Start]
    
    // [Start OH_AudioWorkgroup_RemoveThread]
    // 当线程已经不需要接入分组时，将其从工作组中移除。
    OH_AudioWorkgroup_RemoveThread(grp, g_tokenId);

    OH_AudioResourceManager_ReleaseWorkgroup(resMgr, grp);
    grp = nullptr;
    // [End OH_AudioWorkgroup_RemoveThread]
    std::stringstream ss;
    ss << "工作组处理完成\n";
    ss << "已释放工作组资源";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value registcallback1(napi_env env, napi_callback_info info)
{
    // [EndExclude Render_CustomCallback]
    // 配置回调函数，如果需要监听，则赋值。
    callbacks.OH_AudioRenderer_OnWriteData = MyOnWriteData_Legacy;
    callbacks.OH_AudioRenderer_OnInterruptEvent = MyOnInterruptEvent_Legacy;

    // （必选）无触发回调场景，使用空指针初始化。从API version 11开始，开发者如果需要监听设备变化，
    // 可直接使用OH_AudioRenderer_OutputDeviceChangeCallback替代。
    callbacks.OH_AudioRenderer_OnStreamEvent = nullptr;
    // （必选）如果不需要监听，使用空指针初始化。
    callbacks.OH_AudioRenderer_OnError = nullptr;
    // [End Render_CustomCallback]
    
    std::stringstream ss;
    ss << "注册回调函数1成功\n";
    ss << "已配置写入数据和中断事件回调";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value registcallback2(napi_env env, napi_callback_info info)
{
    // [EndExclude Render_callBackInit]
    // 使用前，初始化并清零结构体。
    OH_AudioRenderer_Callbacks callbacks = {0};

    // 配置需要的回调函数。
    callbacks.OH_AudioRenderer_OnWriteData = MyOnWriteData_Legacy;
    callbacks.OH_AudioRenderer_OnInterruptEvent = MyOnInterruptEvent_Legacy;
    // [End Render_callBackInit]
    
    std::stringstream ss;
    ss << "注册回调函数2成功\n";
    ss << "已使用memset初始化并配置回调";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value CreateAudioRender02(napi_env env, napi_callback_info info)
{
    // [EndExclude Render_CreateStreamType]
    OH_AudioStream_Type streamType = AUDIOSTREAM_TYPE_RENDERER;
    // [End Render_CreateStreamType]
    OH_AudioStreamBuilder_Create(&builder, streamType);
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
    // 设置输出音频流的工作场景。
    OH_AudioStreamBuilder_SetRendererInfo(builder, AUDIOSTREAM_USAGE_MUSIC);

    OH_AudioStreamBuilder_SetLatencyMode(builder, AUDIOSTREAM_LATENCY_MODE_FAST);
    
    OH_AudioStreamBuilder_GenerateRenderer(builder, &audioRenderer);

    // 设置编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builder, AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID);
    // 配置回调函数。
    OH_AudioRenderer_WriteDataWithMetadataCallback metadataCallback = MyOnWriteDataWithMetadata_Legacy;
    // 设置同时写入PCM数据和元数据的回调。
    OH_AudioStreamBuilder_SetWriteDataWithMetadataCallback(builder, metadataCallback, nullptr);
    
    std::stringstream ss;
    ss << "创建播放流02成功\n";
    ss << "已配置AudioVivid编码和元数据回调";
    
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"CreateAudioRender", nullptr, CreateAudioRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"DestroyAudioRender", nullptr, DestroyAudioRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"SetVolume", nullptr, SetVolume, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setLatencyMode", nullptr, setLatencyMode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getLatencyMode", nullptr, getLatencyMode, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"workgroupcreate", nullptr, workgroupcreate, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"workgroupprocess", nullptr, workgroupprocess, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registcallback1", nullptr, registcallback1, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"registcallback2", nullptr, registcallback2, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CreateAudioRender02", nullptr, CreateAudioRender02, nullptr, nullptr, nullptr, napi_default, nullptr},
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
