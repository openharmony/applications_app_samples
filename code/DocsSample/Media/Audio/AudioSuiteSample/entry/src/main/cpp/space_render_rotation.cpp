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
#include <cmath>
#include <thread>
#include <atomic>
#include <chrono>
#include "space_render_rotation.h"
#include "hilog/log.h"

const int CHANNEL_COUNT = 2;
// OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE格式对应的字节大小。
const int SAMPLE_FORMAT_S16LE_BYTE_SIZE = 2;
// 20表示的是20ms的音频采样数据，如果samplingRate为11025请使用40ms来计算。
const int RENDER_FRAME_DURATION_MS = 20;
const int MS_PER_SECOND = 1000;
const double PI = 3.14159265358979323846;
const int FULL_CIRCLE_DEGREES = 360;
const int ROTATION_STEP_DEGREES = 1;
const int ROTATION_INTERVAL_MS = 20;
const float DEGREES_TO_RADIANS = 180.0;
const float SPACE_RENDER_RADIUS = 5.0;
const float POSITION_ORIGIN = 0.0;
// [Start audioSuite_SpaceRenderRotationInputNodeWriteDataCallBack]
// 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
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
// [End audioSuite_SpaceRenderRotationInputNodeWriteDataCallBack]

// [Start audioSuite_SpaceRenderRotationAudioRendererOnWriteData]
// 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
static OH_AudioData_Callback_Result AudioRendererOnWriteData(OH_AudioRenderer *renderer, void *userData,
                                                             void *audioData, int32_t audioDataSize)
{
    bool finishedFlag = false;
    int32_t writeSize = 0;
    OH_AudioSuite_Result result = OH_AudioSuiteEngine_RenderFrame(static_cast<OH_AudioSuitePipeline *>(userData),
                                                                  audioData, audioDataSize, &writeSize, &finishedFlag);
    if (result != OH_AudioSuite_Result::AUDIOSUITE_SUCCESS) {
        // 音频编创渲染失败。
        return AUDIO_DATA_CALLBACK_RESULT_INVALID;
    }
    // 音频编创渲染完成。
    if (finishedFlag) {
        // 开发者自定义的行为。
    }

    return AUDIO_DATA_CALLBACK_RESULT_VALID;
}
// [End audioSuite_SpaceRenderRotationAudioRendererOnWriteData]

// [Start audioSuite_SpaceRenderRotationVariable]
static OH_AudioSuiteEngine *g_audioSuiteEngine = nullptr;
static OH_AudioStreamBuilder *g_rendererBuilder = nullptr;
static OH_AudioSuitePipeline *g_audioSuitePipeline = nullptr;
static OH_AudioNode *g_inputNodeForVocals = nullptr;
static OH_AudioNode *g_inputNodeForAccompaniment = nullptr;
static OH_AudioNode *g_spaceNodeForVocals = nullptr;
static OH_AudioNode *g_spaceNodeForAccompaniment = nullptr;
static OH_AudioNode *g_mixerNode = nullptr;
static OH_AudioNode *g_outputNode = nullptr;
static OH_AudioRenderer *g_audioSpaceRenderRotationEffect = nullptr;
static std::atomic<bool> g_isRotating(false);
static std::thread g_rotationThread;
static std::atomic<int> g_angle(0);
// [End audioSuite_SpaceRenderRotationVariable]

static void ConfigureAudioFormat(OH_AudioFormat &audioFormat)
{
    audioFormat.samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000;
    audioFormat.channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO;
    audioFormat.channelCount = CHANNEL_COUNT;
    audioFormat.sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE;
    audioFormat.encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW;
}

static void CreateSpaceRenderNodes(AudioDataInfo *audioInfoForVocals, AudioDataInfo *audioInfoForAccompaniment)
{
    // [Start audioSuite_CreateSpaceRenderRotation]
    // 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
    // 创建节点构造器。
    OH_AudioNodeBuilder *nodeBuilder = nullptr;
    OH_AudioSuiteNodeBuilder_Create(&nodeBuilder);

    // 配置音频数据格式，开发者根据要处理的音频数据格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatInput;
    ConfigureAudioFormat(audioFormatInput);
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    // 用户可根据自己的音频源情况设置一个或者多个输入节点。
    // 设置第一个音频流的回调。
    void *userData = static_cast<void *>(audioInfoForVocals);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建第一个输入节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_inputNodeForVocals);

    // 重置构造器配置并设置为输入节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::INPUT_NODE_TYPE_DEFAULT);
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatInput);
    // 设置第二个音频流的回调。
    userData = static_cast<void *>(audioInfoForAccompaniment);
    OH_AudioSuiteNodeBuilder_SetRequestDataCallback(nodeBuilder, InputNodeWriteDataCallBack, userData);
    // 创建第二个输入节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_inputNodeForAccompaniment);

    // 用户设置空间渲染固定摆位的空间音频后也可实时更新空间音频的位置，来实现周期性的变化。
    // 重置构造器配置并设置为空间渲染节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_SPACE_RENDER);
    // 创建第一个空间渲染节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_spaceNodeForVocals);
    // 设置空间渲染节点为固定摆位。
    OH_AudioSuiteEngine_SetSpaceRenderPositionParams(
        g_spaceNodeForVocals,
        OH_AudioSuite_SpaceRenderPositionParams{-SPACE_RENDER_RADIUS, POSITION_ORIGIN, -SPACE_RENDER_RADIUS});

    // 重置构造器配置并设置为空间渲染节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_SPACE_RENDER);
    // 创建第二个空间渲染节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_spaceNodeForAccompaniment);
    // 设置空间渲染节点为固定摆位。
    OH_AudioSuiteEngine_SetSpaceRenderPositionParams(
        g_spaceNodeForAccompaniment,
        OH_AudioSuite_SpaceRenderPositionParams{SPACE_RENDER_RADIUS, POSITION_ORIGIN, SPACE_RENDER_RADIUS});

    // 重置构造器配置并设置为混音节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::EFFECT_NODE_TYPE_AUDIO_MIXER);
    // 创建混音节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_mixerNode);

    // 重置构造器配置并设置为输出节点类型。
    OH_AudioSuiteNodeBuilder_Reset(nodeBuilder);
    OH_AudioSuiteNodeBuilder_SetNodeType(nodeBuilder, OH_AudioNode_Type::OUTPUT_NODE_TYPE_DEFAULT);
    // 配置音频数据格式，开发者根据预期输出的音频格式设置采样率、声道分布、声道数、位深、编码格式参数。
    OH_AudioFormat audioFormatOutput;
    ConfigureAudioFormat(audioFormatOutput);
    OH_AudioSuiteNodeBuilder_SetFormat(nodeBuilder, audioFormatOutput);
    // 创建输出节点。
    OH_AudioSuiteEngine_CreateNode(g_audioSuitePipeline, nodeBuilder, &g_outputNode);

    // 销毁节点构造器。
    OH_AudioSuiteNodeBuilder_Destroy(nodeBuilder);

    // 连接各个节点组成组网。
    OH_AudioSuiteEngine_ConnectNodes(g_inputNodeForVocals, g_spaceNodeForVocals);
    OH_AudioSuiteEngine_ConnectNodes(g_spaceNodeForVocals, g_mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(g_inputNodeForAccompaniment, g_spaceNodeForAccompaniment);
    OH_AudioSuiteEngine_ConnectNodes(g_spaceNodeForAccompaniment, g_mixerNode);
    OH_AudioSuiteEngine_ConnectNodes(g_mixerNode, g_outputNode);
    // [End audioSuite_CreateSpaceRenderRotation]
}

static void ConfigureAndStartRenderer()
{
    // [Start audioSuite_StartSpaceRenderRotationPipeline]
    // 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
    // 创建构建器。
    OH_AudioStreamBuilder_Create(&g_rendererBuilder, OH_AudioStream_Type::AUDIOSTREAM_TYPE_RENDERER);
    OH_AudioStreamBuilder_SetSamplingRate(g_rendererBuilder, OH_Audio_SampleRate::SAMPLE_RATE_48000);
    OH_AudioStreamBuilder_SetChannelCount(g_rendererBuilder, CHANNEL_COUNT);
    OH_AudioStreamBuilder_SetSampleFormat(g_rendererBuilder, AUDIOSTREAM_SAMPLE_S16LE);
    OH_AudioStreamBuilder_SetEncodingType(g_rendererBuilder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetRendererInfo(g_rendererBuilder, AUDIOSTREAM_USAGE_MUSIC);

    // 如果samplingRate为11025请使用40ms来计算。
    OH_AudioFormat audioFormatOutput;
    ConfigureAudioFormat(audioFormatOutput);
    int32_t frameSize = RENDER_FRAME_DURATION_MS * audioFormatOutput.samplingRate * audioFormatOutput.channelCount *
                        SAMPLE_FORMAT_S16LE_BYTE_SIZE / MS_PER_SECOND;
    // 设置audioDataSize长度（待播放的数据大小）。
    OH_AudioStreamBuilder_SetFrameSizeInCallback(g_rendererBuilder, frameSize);
    // 配置写入音频数据回调函数。
    OH_AudioStreamBuilder_SetRendererWriteDataCallback(g_rendererBuilder, AudioRendererOnWriteData,
                                                       static_cast<void *>(g_audioSuitePipeline));

    // 启动管线。
    OH_AudioSuiteEngine_StartPipeline(g_audioSuitePipeline);
    // [StartExclude audioSuite_StartSpaceRenderRotationPipeline]
    StartAutoRotation();
    // 设置声道布局。
    OH_AudioStreamBuilder_GenerateRenderer(g_rendererBuilder, &g_audioSpaceRenderRotationEffect);
    // 设置编码类型。
    OH_AudioStreamBuilder_SetEncodingType(g_rendererBuilder, AUDIOSTREAM_ENCODING_TYPE_AUDIOVIVID);
    OH_AudioRenderer_Start(g_audioSpaceRenderRotationEffect);
}

static void DestroySpaceRenderResources()
{
    StopAutoRotation();
    OH_AudioRenderer_Stop(g_audioSpaceRenderRotationEffect);
    OH_AudioRenderer_Release(g_audioSpaceRenderRotationEffect);
    // [EndExclude audioSuite_StartSpaceRenderRotationPipeline]
    // 停止管线。
    OH_AudioSuiteEngine_StopPipeline(g_audioSuitePipeline);
    // [End audioSuite_StartSpaceRenderRotationPipeline]

    // [Start audioSuite_DestroySpaceRenderRotation]
    // 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
    // 销毁流构造器。
    OH_AudioStreamBuilder_Destroy(g_rendererBuilder);

    // 销毁节点。
    OH_AudioSuiteEngine_DestroyNode(g_inputNodeForVocals);
    OH_AudioSuiteEngine_DestroyNode(g_inputNodeForAccompaniment);
    OH_AudioSuiteEngine_DestroyNode(g_spaceNodeForVocals);
    OH_AudioSuiteEngine_DestroyNode(g_spaceNodeForAccompaniment);
    OH_AudioSuiteEngine_DestroyNode(g_mixerNode);
    OH_AudioSuiteEngine_DestroyNode(g_outputNode);

    // 销毁管线。
    OH_AudioSuiteEngine_DestroyPipeline(g_audioSuitePipeline);

    // 销毁引擎。
    OH_AudioSuiteEngine_Destroy(g_audioSuiteEngine);
    // [End audioSuite_DestroySpaceRenderRotation]
}

/**
 * 空间渲染效果
 */
void SpaceRenderEffect(AudioDataInfo *audioInfoForVocals, AudioDataInfo *audioInfoForAccompaniment)
{
    // [Start audioSuite_CreateSpaceRenderRotationEngineAndPipeline]
    // 示例接口未包含返回值校验，实际使用时请务必添加校验逻辑。
    // 创建引擎。
    OH_AudioSuiteEngine_Create(&g_audioSuiteEngine);

    // 创建实时播放空间渲染的管线。
    OH_AudioSuiteEngine_CreatePipeline(g_audioSuiteEngine, &g_audioSuitePipeline,
                                       OH_AudioSuite_PipelineWorkMode::AUDIOSUITE_PIPELINE_REALTIME_MODE);
    // [End audioSuite_CreateSpaceRenderRotationEngineAndPipeline]
    CreateSpaceRenderNodes(audioInfoForVocals, audioInfoForAccompaniment);
    ConfigureAndStartRenderer();
}

void StartAutoRotation()
{
    if (g_isRotating) {
        return;
    }
    g_isRotating = true;
    g_angle = 0;
    g_rotationThread = std::thread([]() {
        while (g_isRotating) {
            g_angle = (g_angle + ROTATION_STEP_DEGREES) % FULL_CIRCLE_DEGREES;
            float radians = g_angle * PI / DEGREES_TO_RADIANS;
            float radius = SPACE_RENDER_RADIUS;
            float x = radius * cos(radians);
            float z = POSITION_ORIGIN;
            float y = radius * sin(radians);
            OH_AudioSuiteEngine_SetSpaceRenderPositionParams(g_spaceNodeForVocals,
                                                             OH_AudioSuite_SpaceRenderPositionParams{x, y, z});
            OH_AudioSuiteEngine_SetSpaceRenderPositionParams(g_spaceNodeForAccompaniment,
                                                             OH_AudioSuite_SpaceRenderPositionParams{-x, -y, -z});
            std::this_thread::sleep_for(std::chrono::milliseconds(ROTATION_INTERVAL_MS));
        }
    });
    g_rotationThread.detach();
}

void StopAutoRotation()
{
    g_isRotating = false;
}

void DestroySpaceRenderEffect()
{
    DestroySpaceRenderResources();
}
