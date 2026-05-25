/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

#include <algorithm>
#include <cstdio>
// [Start audioSuite_ManualRenderingInclude]
#include <ohaudiosuite/native_audio_suite_base.h>
#include <ohaudiosuite/native_audio_suite_engine.h>
// [End audioSuite_ManualRenderingInclude]
#include <cstdint>
#include "hilog/log.h"
#include "pcmFileUtils.h"
#include "manualRendering.h"


const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioSuiteApp_manual_cpp]";
const int CHANNEL_COUNT = 2;

struct BaseEditorNodes {
    OH_AudioNode *inputNode = nullptr;
    OH_AudioNode *eqNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
};

struct SeparationNodes {
    OH_AudioNode *inputNode = nullptr;
    OH_AudioNode *aissNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
};

struct MixingNodes {
    OH_AudioNode *inputNodeForField = nullptr;
    OH_AudioNode *inputNodeForMix = nullptr;
    OH_AudioNode *fieldNode = nullptr;
    OH_AudioNode *mixerNode = nullptr;
    OH_AudioNode *outputNode = nullptr;
};
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
    if (actualDataSize > 0) {
        std::copy(info->buffer + info->totalWriteSize, info->buffer + info->totalWriteSize + actualDataSize,
                  static_cast<uint8_t *>(audioData));
    }
    info->totalWriteSize += actualDataSize;
    // 音频数据全部处理完。
    if (info->totalWriteSize >= info->bufferSize) {
        *finished = true;
    }
    return actualDataSize;
}
// [End audioSuite_InputNodeWriteDataCallBack]

static BaseEditorNodes CreateBaseEditorNodes(OH_AudioSuitePipeline *pipeline, AudioDataInfo *audioInfo)
{
    BaseEditorNodes nodes;
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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.inputNode);

    // 重置构造器配置并设置为均衡器节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_EQUALIZER);
    // 创建均衡器节点。
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.eqNode);
    // 设置均衡器节点效果为默认。
    OH_AudioSuiteEngine_SetEqualizerFrequencyBandGains(nodes.eqNode, OH_EQUALIZER_PARAM_DEFAULT);

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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.outputNode);

    // 销毁节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(nodes.inputNode, nodes.eqNode);
    OH_AudioSuiteEngine_ConnectNodes(nodes.eqNode, nodes.outputNode);
    // [End audioSuite_CreateBaseNode]

    return nodes;
}

static void RunBaseEditorPipeline(OH_AudioSuitePipeline *pipeline, const char *outputPath)
{
    // [Start audioSuite_StartBasePipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * 48000 * CHANNEL_COUNT * byteSize / 1000;
    // 用于接收渲染后的输出音频数据。
    uint8_t *audioData = (uint8_t *)malloc(frameSize);
    int32_t responseSize = 0;
    bool finished = false;
    // 渲染。
    OH_AudioSuiteEngine_StartPipeline(pipeline);
    // [StartExclude audioSuite_StartBasePipeline]
    // 打开输出文件
    FILE *fp = fopen(outputPath, "wb");
    if (fp == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output file: %{public}s", outputPath);
        OH_AudioSuiteEngine_StopPipeline(pipeline);
        free(audioData);
        audioData = nullptr;
        return;
    }
    // [EndExclude audioSuite_StartBasePipeline]
    do {
        OH_AudioSuite_Result result = OH_AudioSuiteEngine_RenderFrame(pipeline, static_cast<void *>(audioData),
                                                                      frameSize, &responseSize, &finished);
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
    SafeCloseFile(fp, outputPath);
    // [EndExclude audioSuite_StartBasePipeline]
    OH_AudioSuiteEngine_StopPipeline(pipeline);
    free(audioData);
    audioData = nullptr;
    // [End audioSuite_StartBasePipeline]
}

static void DestroyBaseEditorResources(OH_AudioSuitePipeline *pipeline, OH_AudioSuiteEngine *engine,
                                       const BaseEditorNodes &nodes)
{
    // [Start audioSuite_DestroyBase]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(nodes.inputNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.eqNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(engine);
    // [End audioSuite_DestroyBase]
}

static SeparationNodes CreateSeparationNodes(OH_AudioSuitePipeline *pipeline, AudioDataInfo *audioInfo)
{
    SeparationNodes nodes;
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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.inputNode);

    // 重置构造器配置并设置为音源分离节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder,
                                         OH_AudioNode_Type::EFFECT_MULTII_OUTPUT_NODE_TYPE_AUDIO_SEPARATION);

    // 创建音源分离节点。
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.aissNode);

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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.outputNode);

    // 销毁节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(nodes.inputNode, nodes.aissNode);
    OH_AudioSuiteEngine_ConnectNodes(nodes.aissNode, nodes.outputNode);
    // [End audioSuite_CreateSeparationNode]

    return nodes;
}

static void RunSeparationPipeline(OH_AudioSuitePipeline *pipeline, const char *vocalsPath,
                                  const char *accompanimentPath)
{
    // [Start audioSuite_StartSeparationPipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * 48000 * CHANNEL_COUNT * byteSize / 1000;
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
    OH_AudioSuiteEngine_StartPipeline(pipeline);
    // [StartExclude audioSuite_StartSeparationPipeline]
    // 打开两个输出文件
    FILE *fpVocals = fopen(vocalsPath, "wb");
    FILE *fpAccompaniment = fopen(accompanimentPath, "wb");

    if (fpVocals == nullptr || fpAccompaniment == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output files");
        SafeCloseFile(fpVocals, vocalsPath);
        SafeCloseFile(fpAccompaniment, accompanimentPath);
        OH_AudioSuiteEngine_StopPipeline(pipeline);
        for (int32_t i = 0; i < outPutNum; i++) {
            free(audioDataArray.audioDataArray[i]);
        }
        free(audioDataArray.audioDataArray);
        return;
    }
    // [EndExclude audioSuite_StartSeparationPipeline]
    do {
        OH_AudioSuite_Result result =
            OH_AudioSuiteEngine_MultiRenderFrame(pipeline, &audioDataArray, &responseSize, &finished);
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
    SafeCloseFile(fpVocals, vocalsPath);
    SafeCloseFile(fpAccompaniment, accompanimentPath);
    // [EndExclude audioSuite_StartSeparationPipeline]
    OH_AudioSuiteEngine_StopPipeline(pipeline);

    for (int32_t i = 0; i < outPutNum; i++) {
        free(audioDataArray.audioDataArray[i]);
        audioDataArray.audioDataArray[i] = nullptr;
    }
    free(audioDataArray.audioDataArray);
    audioDataArray.audioDataArray = nullptr;
    // [End audioSuite_StartSeparationPipeline]
}

static void DestroySeparationResources(OH_AudioSuitePipeline *pipeline, OH_AudioSuiteEngine *engine,
                                       const SeparationNodes &nodes)
{
    // [Start audioSuite_DestroySeparation]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(nodes.inputNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.aissNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(engine);
    // [End audioSuite_DestroySeparation]
}

static MixingNodes CreateMixingNodes(OH_AudioSuitePipeline *pipeline, AudioDataInfo *audioInfoForField,
                                     AudioDataInfo *audioInfoForMix)
{
    MixingNodes nodes;
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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.inputNodeForField);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    // 设置第二个音频流的回调。
    userData = static_cast<void *>(audioInfoForMix);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建第二个输入节点。
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.inputNodeForMix);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_SOUND_FIELD);
    // 创建声场节点并设置声场模式为聆听。
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.fieldNode);
    OH_AudioSuiteEngine_SetSoundFieldType(nodes.fieldNode, SOUND_FIELD_FRONT_FACING);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_AUDIO_MIXER);
    // 创建混音节点。
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.mixerNode);

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
    OH_AudioSuiteEngine_CreateNode(pipeline, nodeBuilder, &nodes.outputNode);

    // 销毁输出节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(nodes.inputNodeForField, nodes.fieldNode);
    OH_AudioSuiteEngine_ConnectNodes(nodes.fieldNode, nodes.mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(nodes.inputNodeForMix, nodes.mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(nodes.mixerNode, nodes.outputNode);
    // [End audioSuite_CreateMixingNode]

    return nodes;
}

static void RunMixingPipeline(OH_AudioSuitePipeline *pipeline, const char *mixFilePath)
{
    // [Start audioSuite_StartMixingPipeline]
    int32_t byteSize = 2;  // OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
    // 根据输出节点的格式计算单帧处理数据大小。
    // 1000是时间转换单位，20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
    int32_t frameSize = 20 * 48000 * CHANNEL_COUNT * byteSize / 1000;
    // 用于接收渲染后的输出音频数据。
    uint8_t *audioData = (uint8_t *)malloc(frameSize);
    int32_t responseSize = 0;
    bool finished = false;

    // 渲染。
    OH_AudioSuiteEngine_StartPipeline(pipeline);
    // [StartExclude audioSuite_StartMixingPipeline]
    // 打开输出文件
    FILE *fp = fopen(mixFilePath, "wb");
    if (fp == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output file: %{public}s", mixFilePath);
        OH_AudioSuiteEngine_StopPipeline(pipeline);
        free(audioData);
        audioData = nullptr;
        return;
    }
    // [EndExclude audioSuite_StartMixingPipeline]
    do {
        OH_AudioSuite_Result result = OH_AudioSuiteEngine_RenderFrame(pipeline, static_cast<void *>(audioData),
                                                                      frameSize, &responseSize, &finished);
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
    SafeCloseFile(fp, mixFilePath);
    // [EndExclude audioSuite_StartMixingPipeline]
    OH_AudioSuiteEngine_StopPipeline(pipeline);
    free(audioData);
    audioData = nullptr;
    // [End audioSuite_StartMixingPipeline]
}

static void DestroyMixingResources(OH_AudioSuitePipeline *pipeline, OH_AudioSuiteEngine *engine,
                                   const MixingNodes &nodes)
{
    // [Start audioSuite_DestroyMixing]
    //  销毁节点。
    OH_AudioSuiteEngine_DestroyNode(nodes.inputNodeForMix);
    OH_AudioSuiteEngine_DestroyNode(nodes.inputNodeForField);
    OH_AudioSuiteEngine_DestroyNode(nodes.fieldNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.mixerNode);
    OH_AudioSuiteEngine_DestroyNode(nodes.outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(pipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(engine);
    // [End audioSuite_DestroyMixing]
}

/**
 * 基础离线编辑
 * @return
 */
void BaseEditorEffect(AudioDataInfo *audioInfo, const char *newFilePath)
{
    CheckAndDeleteFile(newFilePath);
    // [Start audioSuite_CreateEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);
    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateEngineAndPipeline]

    auto nodes = CreateBaseEditorNodes(audioSuitePipeline, audioInfo);
    RunBaseEditorPipeline(audioSuitePipeline, newFilePath);
    DestroyBaseEditorResources(audioSuitePipeline, audioSuiteEngine, nodes);
}

/***
 * 音源分离场景
 */
void AudioSourceSeparation(AudioDataInfo *audioInfo, const char *vocalsFilePath, const char *accompanimentFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "AudioSourceSeparation start");

    CheckAndDeleteFile(vocalsFilePath);
    CheckAndDeleteFile(accompanimentFilePath);

    // [Start audioSuite_CreateSeparationEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);

    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateSeparationEngineAndPipeline]

    auto nodes = CreateSeparationNodes(audioSuitePipeline, audioInfo);
    RunSeparationPipeline(audioSuitePipeline, vocalsFilePath, accompanimentFilePath);
    DestroySeparationResources(audioSuitePipeline, audioSuiteEngine, nodes);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "AudioSourceSeparation end");
}

/**
 * 混音与级联
 */

void MixingAndCascading(AudioDataInfo *audioInfoForField, AudioDataInfo *audioInfoForMix, const char *mixFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "MixingAndCascading start");

    CheckAndDeleteFile(mixFilePath);

    // [Start audioSuite_CreateMixingEngineAndPipeline]
    //  创建引擎。
    OH_AudioSuiteEngine *audioSuiteEngine = nullptr;
    OH_AudioSuiteEngine_Create(&audioSuiteEngine);

    // 创建管线。
    OH_AudioSuitePipeline *audioSuitePipeline = nullptr;
    OH_AudioSuiteEngine_CreatePipeline(audioSuiteEngine, &audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_EDIT_MODE);
    // [End audioSuite_CreateMixingEngineAndPipeline]

    auto nodes = CreateMixingNodes(audioSuitePipeline, audioInfoForField, audioInfoForMix);
    RunMixingPipeline(audioSuitePipeline, mixFilePath);
    DestroyMixingResources(audioSuitePipeline, audioSuiteEngine, nodes);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "MixingAndCascading end");
}
