/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 */
#include <algorithm>
#include <cstdio>
// [Start audioSuite_ManualRenderingInclude]
#include <ohaudiosuite/native_audio_suite_base.h>
#include <ohaudiosuite/native_audio_suite_engine.h>
// [End audioSuite_ManualRenderingInclude]
#include <cstdint>
#include "hilog/log.h"

#include "manualRendering.h"

const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioSuiteApp_manual_cpp]";
const int CHANNEL_COUNT = 2;
// [Start audioSuite_InputNodeWriteDataCallBack]
// 输入节点请求数据的回调函数。
static int32_t InputNodeWriteDataCallBack(OH_AudioNode *audioNode, void *userData, void *audioData,
                                          int32_t audioDataSize, bool *finished)
{
    if ((audioNode == nullptr) || (userData == nullptr) || (audioData == nullptr) || (audioDataSize <= 0) ||
        (finished == nullptr)) {
        return -1;
    }
    struct AudioDataInfo *info = static_cast<struct AudioDataInfo *>(userData);
    // 要处理的音频大小。
    int32_t actualDataSize = std::min(audioDataSize, info->bufferSize - info->totalWriteSize);
    // 将PCM音频数据写入audioData。
    memcpy(static_cast<void *>(audioData), info->buffer + info->totalWriteSize, actualDataSize);
    info->totalWriteSize += actualDataSize;
    // 音频数据全部处理完。
    if (info->totalWriteSize >= info->bufferSize) {
        *finished = true;
    }
    return actualDataSize;
}
// [End audioSuite_InputNodeWriteDataCallBack]

static void CheckAndRemoveOutputFile(const char *filePath)
{
    FILE *checkFile = fopen(filePath, "rb");
    if (checkFile != nullptr) {
        if (fclose(checkFile) != 0) {
            OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close check file");
        }
        if (remove(filePath) == 0) {
            OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Output file exists, deleted: %{public}s", filePath);
        } else {
            OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to delete existing file: %{public}s", filePath);
        }
    }
}

struct BaseEditorContext {
    OH_AudioSuiteEngine *engine = nullptr;
    OH_AudioSuitePipeline *pipeline = nullptr;
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioNode *inputNode = nullptr;
    OH_AudioNode *eqNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
    OH_AudioFormat audioFormatOutput;
};

static void BaseEditorCreateEngineAndPipeline(BaseEditorContext *ctx)
{
    // [Start audioSuite_CreateEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);
    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateEngineAndPipeline]
    ctx->engine = audioSuiteEngine;
    ctx->pipeline = audioSuitePipeline;
}

static void BaseEditorCreateNodes(BaseEditorContext *ctx, AudioDataInfo *audioInfo)
{
    // [Start audioSuite_CreateBaseNode]
    //  创建节点构造器。
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioSuiteNodeBuilder_Create(&nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据要处理的音频数据格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatInput;
    audioFormatInput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatInput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatInput.channelCount = CHANNEL_COUNT;
    audioFormatInput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatInput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    // 设置音频流的回调。
    void *userData = static_cast<void *>(audioInfo);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建输入节点。
    OH_AudioNode *inputNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &inputNode);

    // 重置构造器配置并设置为均衡器节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_EQUALIZER);
    // 创建均衡器节点。
    OH_AudioNode *eqNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &eqNode);
    // 设置均衡器节点效果为默认。
    OH_AudioSuiteEngine_SetEqualizerFrequencyBandGains(eqNode, OH_EQUALIZER_PARAM_DEFAULT);

    // 重置构造器配置并设置为输出节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::OUTPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据预期输出的音频格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatOutput;
    audioFormatOutput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatOutput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatOutput.channelCount = CHANNEL_COUNT;
    audioFormatOutput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatOutput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatOutput);
    // 创建输出节点。
    OH_AudioNode *outputNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &outputNode);

    // 销毁节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(inputNode, eqNode);
    OH_AudioSuiteEngine_ConnectNodes(eqNode, outputNode);
    // [End audioSuite_CreateBaseNode]
    ctx->nodeBuilder = nodeBuilder;
    ctx->inputNode = inputNode;
    ctx->eqNode = eqNode;
    ctx->outputNode = outputNode;
    ctx->audioFormatOutput = audioFormatOutput;
}

static bool BaseEditorStartPipeline(BaseEditorContext *ctx, const char *newFilePath)
{
    // [Start audioSuite_StartBasePipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * ctx->audioFormatOutput.samplingRate * ctx->audioFormatOutput.channelCount * byteSize / 1000;
    // 用于接收渲染后的输出音频数据。
    uint8_t *audioData = (uint8_t *)malloc(frameSize);
    int32_t responseSize = 0;
    bool finished = false;
    // 渲染。
    OH_AudioSuiteEngine_StartPipeline(ctx->pipeline);
    // [StartExclude audioSuite_StartBasePipeline]
    // 打开输出文件
    FILE *fp = fopen(newFilePath, "wb");
    if (fp == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output file: %{public}s", newFilePath);
        OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);
        free(audioData);
        audioData = nullptr;
        OH_AudioSuiteEngine_DestroyNode(ctx->inputNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->eqNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);
        OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);
        OH_AudioSuiteEngine_Destroy(ctx->engine);
        return false;
    }
    // [EndExclude audioSuite_StartBasePipeline]
    do {
        OH_AudioSuite_Result result = OH_AudioSuiteEngine_RenderFrame(
            ctx->pipeline, static_cast<void *>(audioData), frameSize, &responseSize, &finished);
        if ((result != OH_AudioSuite_Result::AUDIOSUITE_SUCCESS) || (responseSize <= 0)) {
            // 本次音频编创渲染失败。
            break;
        } else {
            // audioData是渲染过后的音频数据，音频数据长度为responseSize，开发者根据业务场景自行使用或者保存。
            // [StartExclude audioSuite_StartBasePipeline]
            // 直接写入文件
            fwrite(audioData, 1, responseSize, fp);
            // [EndExclude audioSuite_StartBasePipeline]
        }
    } while (!finished);
    // [StartExclude audioSuite_StartBasePipeline]
    // 关闭文件
    if (fclose(fp) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close file");
    }
    // [EndExclude audioSuite_StartBasePipeline]
    OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);
    free(audioData);
    audioData = nullptr;
    // [End audioSuite_StartBasePipeline]
    return true;
}

static void BaseEditorDestroy(BaseEditorContext *ctx)
{
    // [Start audioSuite_DestroyBase]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(ctx->inputNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->eqNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(ctx->engine);
    // [End audioSuite_DestroyBase]
}

void BaseEditorEffect(AudioDataInfo *audioInfo, const char *newFilePath)
{
    CheckAndRemoveOutputFile(newFilePath);
    BaseEditorContext ctx;
    BaseEditorCreateEngineAndPipeline(&ctx);
    BaseEditorCreateNodes(&ctx, audioInfo);
    if (!BaseEditorStartPipeline(&ctx, newFilePath)) {
        return;
    }
    BaseEditorDestroy(&ctx);
}

static void CheckAndRemoveOutputFiles(const char **filePaths, int count)
{
    for (int i = 0; i < count; i++) {
        CheckAndRemoveOutputFile(filePaths[i]);
    }
}

struct SourceSeparationContext {
    OH_AudioSuiteEngine *engine = nullptr;
    OH_AudioSuitePipeline *pipeline = nullptr;
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioNode *inputNode = nullptr;
    OH_AudioNode *aissNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
    OH_AudioFormat audioFormatOutput;
};

static void SourceSeparationCreateEngineAndPipeline(SourceSeparationContext *ctx)
{
    // [Start audioSuite_CreateSeparationEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);

    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateSeparationEngineAndPipeline]
    ctx->engine = audioSuiteEngine;
    ctx->pipeline = audioSuitePipeline;
}

static void SourceSeparationCreateNodes(SourceSeparationContext *ctx, AudioDataInfo *audioInfo)
{
    // [Start audioSuite_CreateSeparationNode]
    //  创建节点构造器。
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioSuiteNodeBuilder_Create(&nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);

    // 配置音频数据格式，开发者根据要处理的音频数据格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatInput;
    audioFormatInput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatInput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatInput.channelCount = CHANNEL_COUNT;
    audioFormatInput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatInput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    void *userData = static_cast<void *>(audioInfo);
    // 设置音频流的回调。
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);

    // 创建输入节点。
    OH_AudioNode *inputNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &inputNode);

    // 重置构造器配置并设置为音源分离节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder,
                                         OH_AudioNode_Type::EFFECT_MULTII_OUTPUT_NODE_TYPE_AUDIO_SEPARATION);

    // 创建音源分离节点。
    OH_AudioNode *aissNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &aissNode);

    // 重置构造器配置并设置为输出节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::OUTPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据预期输出的音频格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatOutput;
    audioFormatOutput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatOutput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatOutput.channelCount = CHANNEL_COUNT;
    audioFormatOutput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatOutput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatOutput);

    // 创建输出节点。
    OH_AudioNode *outputNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &outputNode);

    // 销毁节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(inputNode, aissNode);
    OH_AudioSuiteEngine_ConnectNodes(aissNode, outputNode);
    // [End audioSuite_CreateSeparationNode]
    ctx->nodeBuilder = nodeBuilder;
    ctx->inputNode = inputNode;
    ctx->aissNode = aissNode;
    ctx->outputNode = outputNode;
    ctx->audioFormatOutput = audioFormatOutput;
}

static bool SourceSeparationStartPipeline(SourceSeparationContext *ctx, const char *vocalsFilePath,
                                          const char *accompanimentFilePath)
{
    // [Start audioSuite_StartSeparationPipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * ctx->audioFormatOutput.samplingRate * ctx->audioFormatOutput.channelCount * byteSize / 1000;
    // 用于接收渲染后的输出音频数据。
    OH_AudioDataArray audioDataArray;
    int32_t outPutNum = 2;
    audioDataArray.audioDataArray = (void **)malloc(outPutNum * sizeof(void *));
    for (int32_t i = 0; i < outPutNum; i++) {
        audioDataArray.audioDataArray[i] = (void *)malloc(frameSize);
    }
    audioDataArray.arraySize = outPutNum;
    audioDataArray.requestFrameSize = frameSize;
    int32_t responseSize = 0;
    bool finished = false;

    // 渲染。
    OH_AudioSuiteEngine_StartPipeline(ctx->pipeline);
    // [StartExclude audioSuite_StartSeparationPipeline]
    // 打开两个输出文件
    FILE *fpVocals = fopen(vocalsFilePath, "wb");
    FILE *fpAccompaniment = fopen(accompanimentFilePath, "wb");

    if (fpVocals == nullptr || fpAccompaniment == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output files");
        if (fpVocals) {
            if (fclose(fpVocals) != 0) {
                OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close vocals file");
            }
        }
        if (fpAccompaniment) {
            if (fclose(fpAccompaniment) != 0) {
                OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close accompaniment file");
            }
        }
        OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);
        for (int32_t i = 0; i < outPutNum; i++) {
            free(audioDataArray.audioDataArray[i]);
        }
        free(audioDataArray.audioDataArray);
        OH_AudioSuiteEngine_DestroyNode(ctx->inputNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->aissNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);
        OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);
        OH_AudioSuiteEngine_Destroy(ctx->engine);
        return false;
    }
    // [EndExclude audioSuite_StartSeparationPipeline]
    do {
        OH_AudioSuite_Result result =
            OH_AudioSuiteEngine_MultiRenderFrame(ctx->pipeline, &audioDataArray, &responseSize, &finished);
        if ((result != OH_AudioSuite_Result::AUDIOSUITE_SUCCESS) || (responseSize <= 0)) {
            // 本次音频编创渲染失败。
            break;
        } else {
            // audioDataArray.audioDataArray[0]是提取的人声。
            // audioDataArray.audioDataArray[1]是提取的背景声。
            // 音频数据长度为responseSize，开发者根据业务场景自行使用或者保存。
            // [StartExclude audioSuite_StartSeparationPipeline]
            fwrite(audioDataArray.audioDataArray[0], 1, responseSize, fpVocals);         // 写入人声
            fwrite(audioDataArray.audioDataArray[1], 1, responseSize, fpAccompaniment);  // 写入背景声
            // [EndExclude audioSuite_StartSeparationPipeline]
        }
    } while (!finished);
    // [StartExclude audioSuite_StartSeparationPipeline]
    // 关闭文件
    if (fclose(fpVocals) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close vocals file");
    }
    if (fclose(fpAccompaniment) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close accompaniment file");
    }
    // [EndExclude audioSuite_StartSeparationPipeline]
    OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);

    for (int32_t i = 0; i < outPutNum; i++) {
        free(audioDataArray.audioDataArray[i]);
        audioDataArray.audioDataArray[i] = nullptr;
    }
    free(audioDataArray.audioDataArray);
    audioDataArray.audioDataArray = nullptr;
    // [End audioSuite_StartSeparationPipeline]
    return true;
}

static void SourceSeparationDestroy(SourceSeparationContext *ctx)
{
    // [Start audioSuite_DestroySeparation]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(ctx->inputNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->aissNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(ctx->engine);
    // [End audioSuite_DestroySeparation]
}

void AudioSourceSeparation(AudioDataInfo *audioInfo, const char *vocalsFilePath, const char *accompanimentFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "AudioSourceSeparation start");
    const char *filePaths[] = {vocalsFilePath, accompanimentFilePath};
    CheckAndRemoveOutputFiles(filePaths, 2);
    SourceSeparationContext ctx;
    SourceSeparationCreateEngineAndPipeline(&ctx);
    SourceSeparationCreateNodes(&ctx, audioInfo);
    if (!SourceSeparationStartPipeline(&ctx, vocalsFilePath, accompanimentFilePath)) {
        return;
    }
    SourceSeparationDestroy(&ctx);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "AudioSourceSeparation end");
}

struct MixingAndCascadingContext {
    OH_AudioSuiteEngine *engine = nullptr;
    OH_AudioSuitePipeline *pipeline = nullptr;
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioNode *inputNodeForField = nullptr;
    OH_AudioNode *inputNodeForMix = nullptr;
    OH_AudioNode *fieldNode = nullptr;
    OH_AudioNode *mixerNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
    OH_AudioFormat audioFormatOutput;
};

static void MixingCreateEngineAndPipeline(MixingAndCascadingContext *ctx)
{
    // [Start audioSuite_CreateMixingEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);

    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateMixingEngineAndPipeline]
    ctx->engine = audioSuiteEngine;
    ctx->pipeline = audioSuitePipeline;
}

static void MixingCreateNodes(MixingAndCascadingContext *ctx, AudioDataInfo *audioInfoForField, AudioDataInfo *audioInfoForMix)
{
    // [Start audioSuite_CreateMixingNode]
    //  创建节点构造器。
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioSuiteNodeBuilder_Create(&nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据要处理的音频数据格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatInput;
    audioFormatInput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatInput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatInput.channelCount = CHANNEL_COUNT;
    audioFormatInput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatInput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    // 设置第一个音频流的回调。
    void *userData = static_cast<void *>(audioInfoForField);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建第一个输入节点。
    OH_AudioNode *inputNodeForField = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &inputNodeForField);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    // 设置第二个音频流的回调。
    userData = static_cast<void *>(audioInfoForMix);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建第二个输入节点。
    OH_AudioNode *inputNodeForMix = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &inputNodeForMix);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_SOUND_FIELD);
    // 创建声场节点并设置声场模式为聆听。
    OH_AudioNode *fieldNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &fieldNode);
    OH_AudioSuiteEngine_SetSoundFieldType(fieldNode, SOUND_FIELD_FRONT_FACING);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_AUDIO_MIXER);
    OH_AudioNode *mixerNode = nullptr;
    // 创建混音节点。
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &mixerNode);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::OUTPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据预期输出的音频格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatOutput;
    audioFormatOutput.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormatOutput.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormatOutput.channelCount = CHANNEL_COUNT;
    audioFormatOutput.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormatOutput.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatOutput);
    // 创建输出节点。
    OH_AudioNode *outputNode = nullptr;
    OH_AudioSuiteEngine_CreateNode(ctx->pipeline, nodeBuilder, &outputNode);

    // 销毁输出节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(inputNodeForField, fieldNode);
    OH_AudioSuiteEngine_ConnectNodes(fieldNode, mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(inputNodeForMix, mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(mixerNode, outputNode);
    // [End audioSuite_CreateMixingNode]
    ctx->nodeBuilder = nodeBuilder;
    ctx->inputNodeForField = inputNodeForField;
    ctx->inputNodeForMix = inputNodeForMix;
    ctx->fieldNode = fieldNode;
    ctx->mixerNode = mixerNode;
    ctx->outputNode = outputNode;
    ctx->audioFormatOutput = audioFormatOutput;
}

static bool MixingStartPipeline(MixingAndCascadingContext *ctx, const char *mixFilePath)
{
    // [Start audioSuite_StartMixingPipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * ctx->audioFormatOutput.samplingRate * ctx->audioFormatOutput.channelCount * byteSize / 1000;
    // 用于接收渲染后的输出音频数据。
    uint8_t *audioData = (uint8_t *)malloc(frameSize);
    int32_t responseSize = 0;
    bool finished = false;

    // 渲染。
    OH_AudioSuiteEngine_StartPipeline(ctx->pipeline);
    // [StartExclude audioSuite_StartMixingPipeline]
    // 打开输出文件
    FILE *fp = fopen(mixFilePath, "wb");
    if (fp == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output file: %{public}s", mixFilePath);
        OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);
        free(audioData);
        audioData = nullptr;
        OH_AudioSuiteEngine_DestroyNode(ctx->inputNodeForMix);
        OH_AudioSuiteEngine_DestroyNode(ctx->inputNodeForField);
        OH_AudioSuiteEngine_DestroyNode(ctx->fieldNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->mixerNode);
        OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);
        OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);
        OH_AudioSuiteEngine_Destroy(ctx->engine);
        return false;
    }
    // [EndExclude audioSuite_StartMixingPipeline]
    do {
        OH_AudioSuite_Result result = OH_AudioSuiteEngine_RenderFrame(
            ctx->pipeline, static_cast<void *>(audioData), frameSize, &responseSize, &finished);
        if ((result != OH_AudioSuite_Result::AUDIOSUITE_SUCCESS) || (responseSize <= 0)) {
            // 本次音频编创渲染失败。
            break;
        } else {
            // audioData是渲染过后的音频数据，音频数据长度为responseSize，开发者根据业务场景自行使用或者保存。
            // [StartExclude audioSuite_StartMixingPipeline]
            // 直接写入文件
            fwrite(audioData, 1, responseSize, fp);
            // [EndExclude audioSuite_StartMixingPipeline]
        }
    } while (!finished);
    // [StartExclude audioSuite_StartMixingPipeline]
    // 关闭文件
    if (fclose(fp) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close file");
    }
    // [EndExclude audioSuite_StartMixingPipeline]
    OH_AudioSuiteEngine_StopPipeline(ctx->pipeline);
    free(audioData);
    audioData = nullptr;
    // [End audioSuite_StartMixingPipeline]
    return true;
}

static void MixingDestroy(MixingAndCascadingContext *ctx)
{
    // [Start audioSuite_DestroyMixing]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(ctx->inputNodeForMix);
    OH_AudioSuiteEngine_DestroyNode(ctx->inputNodeForField);
    OH_AudioSuiteEngine_DestroyNode(ctx->fieldNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->mixerNode);
    OH_AudioSuiteEngine_DestroyNode(ctx->outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(ctx->pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(ctx->engine);
    // [End audioSuite_DestroyMixing]
}

void MixingAndCascading(AudioDataInfo *audioInfoForField, AudioDataInfo *audioInfoForMix, const char *mixFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "MixingAndCascading start");
    CheckAndRemoveOutputFile(mixFilePath);
    MixingAndCascadingContext ctx;
    MixingCreateEngineAndPipeline(&ctx);
    MixingCreateNodes(&ctx, audioInfoForField, audioInfoForMix);
    if (!MixingStartPipeline(&ctx, mixFilePath)) {
        return;
    }
    MixingDestroy(&ctx);
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "MixingAndCascading end");
}
