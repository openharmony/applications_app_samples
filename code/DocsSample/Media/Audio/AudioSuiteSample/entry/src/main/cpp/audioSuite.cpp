/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 */

#include "napi/native_api.h"
#include "ohaudio/native_audiocapturer.h"
#include <ohaudio/native_audiorenderer.h>
#include <ohaudio/native_audiostreambuilder.h>
#include "ohaudio/native_audio_session_manager.h"
#include <ohaudio/native_audio_resource_manager.h>
#include <cstdint>
#include <sstream>
#include "./manualRendering.h"
#include "pcmFileUtils.h"
#include "hilog/log.h"
#include "realTimeRendering.h"
const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioSuiteApp_init_cpp]";
const int AUDIO_RENDER_MODE_REALTIME = 2;

enum AudioFileType {
    AUDIO_FILE_ORIGINAL = 1,
    AUDIO_FILE_EFFECT = 2,
    AUDIO_FILE_ACCOMPANIMENT = 3,
    AUDIO_FILE_VOCALS = 4,
    AUDIO_FILE_MIX = 5
};

std::string g_filePath = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000.pcm";
std::string g_filePathEffect = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000_Effect.pcm";
std::string g_filePathVocals = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000_Vocals.pcm";
std::string g_filePathAccompaniment = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000_Accompaniment.pcm";
std::string g_filePathMix = "/data/storage/el2/base/haps/entry/files/S16LE_2_48000_Mix.pcm";
// BaseEditor 异步执行的数据结构
struct BaseEditorData {
    napi_async_work work;
    std::string inputFilePath;
    std::string outputFilePath;
    AudioDataInfo audioInfo;
    napi_ref callback;
};

// 异步执行函数
void BaseEditorExecute(napi_env env, void *data)
{
    BaseEditorData *asyncData = static_cast<BaseEditorData *>(data);
    ReadPcmFile(asyncData->inputFilePath.c_str(), &asyncData->audioInfo);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "audioInfo : %{public}d", asyncData->audioInfo.bufferSize);
    BaseEditorEffect(&asyncData->audioInfo, asyncData->outputFilePath.c_str());
    FreeAudioDataInfo(&asyncData->audioInfo);
}

// 异步完成函数
void BaseEditorComplete(napi_env env, napi_status status, void *data)
{
    BaseEditorData *asyncData = static_cast<BaseEditorData *>(data);

    if (status == napi_ok) {
        std::stringstream ss;
        ss << "均衡器效果添加成功\n";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);

        // 调用回调函数
        napi_value global;
        napi_get_global(env, &global);
        napi_value callback;
        napi_get_reference_value(env, asyncData->callback, &callback);
        napi_value undefined;
        napi_get_undefined(env, &undefined);
        napi_call_function(env, global, callback, 1, &retVal, nullptr);
    }

    // 清理资源
    napi_delete_reference(env, asyncData->callback);
    napi_delete_async_work(env, asyncData->work);
    delete asyncData;
}

napi_value BaseEditor(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 创建异步数据
    BaseEditorData *asyncData = new BaseEditorData();
    asyncData->inputFilePath = g_filePath;
    asyncData->outputFilePath = g_filePathEffect;

    // 保存回调函数
    napi_create_reference(env, argv[0], 1, &asyncData->callback);

    // 创建异步工作
    napi_value resource_name;
    napi_create_string_utf8(env, "BaseEditor", NAPI_AUTO_LENGTH, &resource_name);
    napi_create_async_work(env, nullptr, resource_name, BaseEditorExecute, BaseEditorComplete, asyncData,
                           &asyncData->work);

    // 将异步工作加入队列
    napi_queue_async_work(env, asyncData->work);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}
// AudioSourceSeparation 异步执行的数据结构
struct AudioSourceSeparationData {
    napi_async_work work;
    std::string inputFilePath;
    std::string vocalsFilePath;
    std::string accompanimentFilePath;
    AudioDataInfo audioInfo;
    napi_ref callback;
};

// 异步执行函数
void AudioSourceSeparationExecute(napi_env env, void *data)
{
    AudioSourceSeparationData *asyncData = static_cast<AudioSourceSeparationData *>(data);
    ReadPcmFile(asyncData->inputFilePath.c_str(), &asyncData->audioInfo);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "audioInfo : %{public}d", asyncData->audioInfo.bufferSize);
    AudioSourceSeparation(&asyncData->audioInfo, asyncData->vocalsFilePath.c_str(),
                          asyncData->accompanimentFilePath.c_str());
    FreeAudioDataInfo(&asyncData->audioInfo);
}

// 异步完成函数
void AudioSourceSeparationComplete(napi_env env, napi_status status, void *data)
{
    AudioSourceSeparationData *asyncData = static_cast<AudioSourceSeparationData *>(data);
    if (status == napi_ok) {
        std::stringstream ss;
        ss << "音源分离成功\n";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);

        // 调用回调函数
        napi_value global;
        napi_get_global(env, &global);
        napi_value callback;
        napi_get_reference_value(env, asyncData->callback, &callback);
        napi_value undefined;
        napi_get_undefined(env, &undefined);
        napi_call_function(env, global, callback, 1, &retVal, nullptr);
    }
    // 清理资源
    napi_delete_reference(env, asyncData->callback);
    napi_delete_async_work(env, asyncData->work);
    delete asyncData;
}

napi_value AudioSourceSeparationNapi(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 创建异步数据
    AudioSourceSeparationData *asyncData = new AudioSourceSeparationData();
    asyncData->inputFilePath = g_filePath;
    asyncData->vocalsFilePath = g_filePathVocals;
    asyncData->accompanimentFilePath = g_filePathAccompaniment;

    // 保存回调函数
    napi_create_reference(env, argv[0], 1, &asyncData->callback);

    // 创建异步工作
    napi_value resource_name;
    napi_create_string_utf8(env, "AudioSourceSeparation", NAPI_AUTO_LENGTH, &resource_name);
    napi_create_async_work(env, nullptr, resource_name, AudioSourceSeparationExecute, AudioSourceSeparationComplete,
                           asyncData, &asyncData->work);

    // 将异步工作加入队列
    napi_queue_async_work(env, asyncData->work);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

// MixingAndCascading 异步执行的数据结构
struct MixingAndCascadingData {
    napi_async_work work;
    std::string inputFilePath1;
    std::string inputFilePath2;
    std::string outputFilePath;
    AudioDataInfo audioInfo1;
    AudioDataInfo audioInfo2;
    napi_ref callback;
};

// 异步执行函数
void MixingAndCascadingExecute(napi_env env, void *data)
{
    MixingAndCascadingData *asyncData = static_cast<MixingAndCascadingData *>(data);
    ReadPcmFile(asyncData->inputFilePath1.c_str(), &asyncData->audioInfo1);
    ReadPcmFile(asyncData->inputFilePath2.c_str(), &asyncData->audioInfo2);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "audioInfo1 : %{public}d, audioInfo2 : %{public}d",
                 asyncData->audioInfo1.bufferSize, asyncData->audioInfo2.bufferSize);
    MixingAndCascading(&asyncData->audioInfo1, &asyncData->audioInfo2, asyncData->outputFilePath.c_str());
    FreeAudioDataInfo(&asyncData->audioInfo1);
    FreeAudioDataInfo(&asyncData->audioInfo2);
}

// 异步完成函数
void MixingAndCascadingComplete(napi_env env, napi_status status, void *data)
{
    MixingAndCascadingData *asyncData = static_cast<MixingAndCascadingData *>(data);

    if (status == napi_ok) {
        std::stringstream ss;
        ss << "混音与级联成功\n";
        napi_value retVal;
        napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);

        // 调用回调函数
        napi_value global;
        napi_get_global(env, &global);
        napi_value callback;
        napi_get_reference_value(env, asyncData->callback, &callback);
        napi_value undefined;
        napi_get_undefined(env, &undefined);
        napi_call_function(env, global, callback, 1, &retVal, nullptr);
    }

    // 清理资源
    napi_delete_reference(env, asyncData->callback);
    napi_delete_async_work(env, asyncData->work);
    delete asyncData;
}

napi_value MixingAndCascadingNapi(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value argv[1];
    napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr);

    // 创建异步数据
    MixingAndCascadingData *asyncData = new MixingAndCascadingData();
    asyncData->inputFilePath1 = g_filePathVocals;         // 原始音频
    asyncData->inputFilePath2 = g_filePathAccompaniment;  // 均衡器效果音频
    asyncData->outputFilePath = g_filePathMix;            // 混音输出

    // 保存回调函数
    napi_create_reference(env, argv[0], 1, &asyncData->callback);

    // 创建异步工作
    napi_value resource_name;
    napi_create_string_utf8(env, "MixingAndCascading", NAPI_AUTO_LENGTH, &resource_name);
    napi_create_async_work(env, nullptr, resource_name, MixingAndCascadingExecute, MixingAndCascadingComplete,
                           asyncData, &asyncData->work);

    // 将异步工作加入队列
    napi_queue_async_work(env, asyncData->work);

    napi_value undefined;
    napi_get_undefined(env, &undefined);
    return undefined;
}

AudioDataInfo g_audioInfoEqualizerEffect;
napi_value EqualizerEffectNapi(napi_env env, napi_callback_info info)
{
    ReadPcmFile(g_filePath.c_str(), &g_audioInfoEqualizerEffect);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "audioInfo : %{public}d",
                 g_audioInfoEqualizerEffect.bufferSize);
    EqualizerEffect(&g_audioInfoEqualizerEffect);
    std::stringstream ss;
    ss << "实时渲染播放成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

// 全局变量 - 用于主要功能
OH_AudioStreamBuilder *builderRender;
OH_AudioRenderer *audioRenderer;
OH_AudioResourceManager *resMgr;
int32_t g_tokenId;
OH_AudioWorkgroup *grp = nullptr;
OH_AudioRenderer_Callbacks callbacks;

FILE *g_fp = nullptr;
int32_t g_mode = 0;

const int SAMPLING_RATE_48K = 48000;
const int CHANNEL_COUNT = 2;

// 自定义写入数据函数。
static OH_AudioData_Callback_Result MyOnWriteData_New(OH_AudioRenderer *renderer, void *userData, void *audioData,
                                                      int32_t audioDataSize)
{
    // 将待播放的数据，按audioDataSize长度写入audioData。
    // 如果开发者不希望播放某段audioData，返回AUDIO_DATA_CALLBACK_RESULT_INVALID即可。
    size_t readCount = fread(audioData, audioDataSize, 1, g_fp);
    if (readCount != 1 && !feof(g_fp)) {
        return AUDIO_DATA_CALLBACK_RESULT_INVALID;
    }
    if (feof(g_fp)) {
        if (fseek(g_fp, 0, SEEK_SET) != 0) {
            return AUDIO_DATA_CALLBACK_RESULT_INVALID;
        }
    }
    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}

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
    OH_AudioStreamBuilder_Create(&builderRender, AUDIOSTREAM_TYPE_RENDERER);
    // 设置音频采样率。
    OH_AudioStreamBuilder_SetSamplingRate(builderRender, SAMPLING_RATE_48K);
    // 设置音频声道。
    OH_AudioStreamBuilder_SetChannelCount(builderRender, CHANNEL_COUNT);
    // 设置音频采样格式。
    OH_AudioStreamBuilder_SetSampleFormat(builderRender, AUDIOSTREAM_SAMPLE_S16LE);
    // 设置音频流的编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builderRender, AUDIOSTREAM_ENCODING_TYPE_RAW);
    // 设置输出音频流的工作场景。
    OH_AudioStreamBuilder_SetRendererInfo(builderRender, AUDIOSTREAM_USAGE_MUSIC);
    // 配置写入音频数据回调函数。
    OH_AudioRenderer_OnWriteDataCallback writeDataCb = MyOnWriteData_New;
    OH_AudioStreamBuilder_SetRendererWriteDataCallback(builderRender, writeDataCb, nullptr);
    // 设置时延模式
    OH_AudioStream_LatencyMode latencyMode = AUDIOSTREAM_LATENCY_MODE_FAST;
    OH_AudioStreamBuilder_SetLatencyMode(builderRender, latencyMode);

    // 设置声道布局
    OH_AudioStreamBuilder_SetChannelLayout(builderRender, CH_LAYOUT_STEREO);
    OH_AudioStreamBuilder_GenerateRenderer(builderRender, &audioRenderer);
    // 设置编码类型。
    OH_AudioStreamBuilder_SetEncodingType(builderRender, AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID);
    // 根据type选择播放的音频文件
    std::string selectedFile;
    switch (type) {
        case AUDIO_FILE_ORIGINAL:
            selectedFile = g_filePath;
            break;
        case AUDIO_FILE_EFFECT:
            selectedFile = g_filePathEffect;
            break;
        case AUDIO_FILE_ACCOMPANIMENT:
            selectedFile = g_filePathAccompaniment;
            break;
        case AUDIO_FILE_VOCALS:
            selectedFile = g_filePathVocals;
            break;
        case AUDIO_FILE_MIX:
            selectedFile = g_filePathMix;
            break;
        default:
            selectedFile = g_filePath;
            break;
    }
    g_fp = fopen(selectedFile.c_str(), "rb");
    OH_AudioRenderer_Start(audioRenderer);
    std::stringstream ss;
    ss << "播放成功\n";
    napi_value retVal;
    napi_create_string_utf8(env, ss.str().c_str(), NAPI_AUTO_LENGTH, &retVal);
    return retVal;
}

napi_value DestroyAudioRender(napi_env env, napi_callback_info info)
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
    std::stringstream ss;
    if (type == AUDIO_RENDER_MODE_REALTIME) {
        DestroyEqualizerEffect();
        // 释放音频数据资源
        FreeAudioDataInfo(&g_audioInfoEqualizerEffect);
    } else {
        OH_AudioRenderer_Stop(audioRenderer);
        OH_AudioRenderer_Release(audioRenderer);
        audioRenderer = nullptr;
        if (g_fp) {
            (void)fclose(g_fp);
            g_fp = nullptr;
        }
    }

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
        {"BaseEditor", nullptr, BaseEditor, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"AudioSourceSeparationNapi", nullptr, AudioSourceSeparationNapi, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"MixingAndCascadingNapi", nullptr, MixingAndCascadingNapi, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"EqualizerEffectNapi", nullptr, EqualizerEffectNapi, nullptr, nullptr, nullptr, napi_default, nullptr},
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
