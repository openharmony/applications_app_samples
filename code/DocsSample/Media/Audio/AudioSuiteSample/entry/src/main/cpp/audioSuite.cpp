/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
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
#include "./manualRendering.h"
#include "pcmFileUtils.h"
#include "hilog/log.h"
const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioSuiteApp_init_cpp]";

std::string g_filePath = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000.pcm";
std::string g_filePathEffect = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000_Effect.pcm";
napi_value BaseEditor(napi_env env, napi_callback_info info)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"1111111111111111111");
    AudioDataInfo audioInfo;
    ReadPcmFile(g_filePath.c_str(),&audioInfo);
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"audioInfo : %{public}d",audioInfo.bufferSize);
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"222222222222222222222");

    BaseEditorEffect(&audioInfo,g_filePathEffect.c_str());
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"33333333333333333333");

    std::stringstream ss;
    ss << "均衡器效果添加成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 全局变量 - 用于主要功能
// [Start Render_CreateStreamType]
// [Start Render_Create]
OH_AudioStreamBuilder* builderRender;
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


FILE *g_fp = nullptr;
int32_t g_mode = 0;

const int SAMPLING_RATE_48K = 48000;
const int channelCount = 2;


// ==================== 回调函数 - CreateAudioRender 使用 ====================
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
    int32_t readCount = fread(audioData, audioDataSize, 1, g_fp);
    if (readCount < 0) {
        return AUDIO_DATA_CALLBACK_RESULT_INVALID;
    }
    if (feof(g_fp)) {
        fseek(g_fp, 0, SEEK_SET);
    }
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
    size_t argc = 1;
    napi_value *argv = new napi_value[argc];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);
    // Determine the current work mode based on the input parameters
    unsigned int type = -1;
    napi_status status = napi_get_value_uint32(env, argv[0], &type);
    if (status != napi_ok) {
        delete[] argv;
        return nullptr;
    }
    delete[] argv;
    // [EndExclude Render_Create]
    OH_AudioStreamBuilder_Create(&builderRender, AUDIOSTREAM_TYPE_RENDERER);
    // [End Render_Create]
    // [Start Render_ConfigStream]
    // 设置音频采样率。
    OH_AudioStreamBuilder_SetSamplingRate(builderRender, SAMPLING_RATE_48K);
    // 设置音频声道。
    OH_AudioStreamBuilder_SetChannelCount(builderRender, channelCount);
    // 设置音频采样格式。
    OH_AudioStreamBuilder_SetSampleFormat(builderRender, AUDIOSTREAM_SAMPLE_S16LE);
    // 设置音频流的编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builderRender, AUDIOSTREAM_ENCODING_TYPE_RAW);
    // 设置输出音频流的工作场景。
    OH_AudioStreamBuilder_SetRendererInfo(builderRender, AUDIOSTREAM_USAGE_MUSIC);
    // [End Render_ConfigStream]
    
    // [EndExclude Render_SetRendererWriteDataCallback]
    // 配置写入音频数据回调函数。
    OH_AudioRenderer_OnWriteDataCallback writeDataCb = MyOnWriteData_New;
    OH_AudioStreamBuilder_SetRendererWriteDataCallback(builderRender, writeDataCb, nullptr);
    // [End Render_SetRendererWriteDataCallback]
    // [End Render_Callback]
    //设置时延模式
    // [Start OH_AudioStreamBuilder_SetLatencyMode]
    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builderRender, latencyMode);
    // [End OH_AudioStreamBuilder_SetLatencyMode]

    //设置声道布局
    // [Start Render_SetChannelLayout]
    OH_AudioStreamBuilder_SetChannelLayout(builderRender, CH_LAYOUT_STEREO);
    // [End Render_SetChannelLayout]
    // [EndExclude Render_GenerateRenderer]
    OH_AudioStreamBuilder_GenerateRenderer(builderRender, &audioRenderer);
    // [End Render_GenerateRenderer]
    // [EndExclude Render_SetWriteDataWithMetadataCallback]
    // 设置编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builderRender, AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID);
    // 配置回调函数。
    OH_AudioRenderer_WriteDataWithMetadataCallback metadataCallback = MyOnWriteDataWithMetadata_New;
    // 设置同时写入PCM数据和元数据的回调。
    OH_AudioStreamBuilder_SetWriteDataWithMetadataCallback(builderRender, metadataCallback, nullptr);
    // [End Render_SetWriteDataWithMetadataCallback]
    const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioEditTestApp_AudioEdit_cpp]";
     OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"log type : %{public}d", type);
    if (type == 1) {
           OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "log type 1111 : %{public}d", type);
        g_fp = fopen(g_filePath.c_str(), "rb");
    } else if (type == 2) {
         OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,"log type 2222 : %{public}d", type);
        g_fp = fopen(g_filePathEffect.c_str(), "rb");
    }
  
    OH_AudioRenderer_Start(audioRenderer);

    std::stringstream ss;
    ss << "播放成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value DestroyAudioRender(napi_env env, napi_callback_info info)
{
    std::stringstream ss;
    OH_AudioRenderer_Stop(audioRenderer);
    OH_AudioRenderer_Release(audioRenderer);
    audioRenderer = nullptr;
    if (g_fp) {
        (void)fclose(g_fp);
        g_fp = nullptr;
    }
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"CreateAudioRender", nullptr, CreateAudioRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"DestroyAudioRender", nullptr, DestroyAudioRender, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"BaseEditor", nullptr, BaseEditor, nullptr, nullptr, nullptr, napi_default, nullptr },
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
