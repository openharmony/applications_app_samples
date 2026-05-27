/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
 */
// [Start audio_format_converter_example]
#include "audio_converter_test.h"
#include <cstring>
#include <algorithm>
#include "hilog/log.h"
#include "ohaudiosuite/native_audio_converter.h"

const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioConverterTest]";
// 内存大小安全限制系数，防止申请过大的内存
static const int32_t MAX_MEMORY_SIZE_SAFETY_FACTOR = 2;

// 输入数据回调函数
// [Start input_callback]
int32_t AudioConverterRequestDataCallback(
    void *userData, const void **outInputData, OH_AudioConverter_InputStatus *outStatus)
{
    if ((userData == nullptr) || (outInputData == nullptr) || (outStatus == nullptr)) {
        return -1;
    }

    AudioConverterTestData *testData = static_cast<AudioConverterTestData *>(userData);

    // 设置输出数据指针。
    // 注意：数据指针的值并不一定要从 userData 中获取，也可以是存储数据的缓存地址。
    // 例如：从文件中读取数据放入缓存，然后将该缓存地址赋值给输出数据指针。
    // 只要确保数据指针在 OH_AudioConverter_Process() 返回前保持有效即可。
    *outInputData = testData->inputAudioInfo.buffer + testData->inputAudioInfo.totalReadSize;

    // 计算本次可提供的数据大小（单次回调最多返回 400KB）
    // bufferSize: 文件的总字节数（在 ReadPcmFile 中赋值）
    // totalReadSize: 已读取的字节数（每次回调递增）
    int32_t maxDataSize = 400 * 1024;
    int32_t remainingSize = testData->inputAudioInfo.bufferSize - testData->inputAudioInfo.totalReadSize;
    int32_t actualDataSize = (remainingSize < maxDataSize) ? remainingSize : maxDataSize;

    // 更新已读取位置
    testData->inputAudioInfo.totalReadSize += actualDataSize;

    // 设置输入数据状态
    if (actualDataSize == 0) {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_NO_AVAILABLE_DATA;
    } else if (testData->inputAudioInfo.totalReadSize >= testData->inputAudioInfo.bufferSize) {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_DATA_FINISHED;
    } else {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_HAVE_DATA;
    }

    return actualDataSize;
}
// [End input_callback]

// 执行格式转换
bool AudioFormatConverterTest(const char *inputFilePath, const char *outputFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "开始格式转换测试");

    // 读取输入 PCM 文件
    AudioConverterTestData testData = {}; // 使用 C++ 安全初始化替代 memset

    if (!ReadPcmFile(inputFilePath, &testData.inputAudioInfo)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "读取输入文件失败: %{public}s", inputFilePath);
        return false;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "读取输入文件成功: %{public}d 字节", testData.inputAudioInfo.bufferSize);

    // 创建转换器并设置回调
    if (!CreateAudioConverter(&testData)) {
        FreeAudioDataInfo(&testData.inputAudioInfo);
        return false;
    }

    // 分配输出缓冲区（估算大小，考虑采样率和声道数的变化）
    // 采样率从 48000 到 192000 (4倍)，声道从 2 到 6 (3倍)，采样格式从 16bit 到 24bit (1.5倍)
    // 总倍数约 4 * 3 * 1.5 = 18 倍
    int32_t estimatedOutputSize = testData.inputAudioInfo.bufferSize * 18;

    if (!AllocateOutputBuffer(&testData, estimatedOutputSize)) {
        OH_AudioConverter_Destroy(testData.converter);
        FreeAudioDataInfo(&testData.inputAudioInfo);
        return false;
    }

    // 处理音频数据
    if (!ProcessAudioData(&testData, estimatedOutputSize)) {
        CleanupResources(&testData);
        return false;
    }

    // 写入输出文件
    if (!WriteOutputFile(outputFilePath, &testData)) {
        CleanupResources(&testData);
        return false;
    }

    // 清理资源
    CleanupResources(&testData);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "格式转换测试成功完成");
    return true;
}

// 创建音频转换器并设置回调
bool CreateAudioConverter(AudioConverterTestData *testData)
{
    // [Start converter_create]
    // 设置输入格式
    OH_AudioConverter_Format inputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE
    };

    // 设置输出格式
    OH_AudioConverter_Format outputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_192000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_6POINT0_FRONT,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S24LE
    };

    // 创建转换器
    OH_AudioConverter_Result result = OH_AudioConverter_Create(&inputFormat, &outputFormat, &testData->converter);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "创建转换器失败: %{public}d", result);
        return false;
    }
    // [End converter_create]
    
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "创建转换器成功");
    
    // [Start set_input_callback]
    // 设置输入回调
    result = OH_AudioConverter_SetInputCallback(testData->converter, AudioConverterRequestDataCallback, testData);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "设置输入回调失败: %{public}d", result);
        OH_AudioConverter_Destroy(testData->converter);
        return false;
    }
    // [End set_input_callback]

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "设置输入回调成功");
    return true;
}

// 分配输出缓冲区
bool AllocateOutputBuffer(AudioConverterTestData *testData, int32_t estimatedOutputSize)
{
    if (estimatedOutputSize <= 0 || estimatedOutputSize > INT32_MAX / MAX_MEMORY_SIZE_SAFETY_FACTOR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG,
                     "估算的输出缓冲区大小不合法: %{public}d", estimatedOutputSize);
        OH_AudioConverter_Destroy(testData->converter);
        FreeAudioDataInfo(&testData->inputAudioInfo);
        return false;
    }
    testData->outputAudioInfo.buffer = new uint8_t[estimatedOutputSize];
    if (testData->outputAudioInfo.buffer == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "分配输出缓冲区失败");
        return false;
    }

    testData->outputAudioInfo.bufferSize = 0;
    testData->inputAudioInfo.totalReadSize = 0;
    return true;
}

// [Start converter_process]
// 处理音频数据
bool ProcessAudioData(AudioConverterTestData *testData, int32_t estimatedOutputSize)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "开始处理音频数据...");
    
    // 分配输出缓冲区。
    const int32_t processBufferSize = 4096 * 4; // 16KB
    uint8_t *processBuffer = new uint8_t[processBufferSize];
    // 标记是否所有输入数据已结束
    bool allInputDataFinished = false;
    int32_t outputSize = 0;
    OH_AudioConverter_Result result;

    do {
        result = OH_AudioConverter_Process(testData->converter, processBuffer, processBufferSize, &outputSize);
        if (result != AUDIOCONVERTER_SUCCESS) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "处理音频数据失败: %{public}d", result);
            delete[] processBuffer;
            return false;
        }

        if (outputSize > 0) { // processBuffer 是转换后的音频数据，数据长度为 outputSize，开发者根据业务场景自行使用或者保存。
            // 将输出数据复制到输出缓冲区
            if (testData->outputAudioInfo.bufferSize + outputSize <= estimatedOutputSize) {
                std::copy(processBuffer, processBuffer + outputSize,
                          testData->outputAudioInfo.buffer + testData->outputAudioInfo.bufferSize);
                testData->outputAudioInfo.bufferSize += outputSize;
            } else {
                OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "输出缓冲区溢出");
                delete[] processBuffer;
                return false;
            }
        }

        // 检查是否所有输入数据已结束，当 totalReadSize >= bufferSize 时，表示已读取完所有输入数据
        if (testData->inputAudioInfo.totalReadSize >= testData->inputAudioInfo.bufferSize) {
            allInputDataFinished = true;
        }
    } while (outputSize > 0 || !allInputDataFinished);

    delete[] processBuffer;
    processBuffer = nullptr;

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "格式转换完成: 输入 %{public}d 字节, 输出 %{public}d 字节",
                 testData->inputAudioInfo.bufferSize, testData->outputAudioInfo.bufferSize);

    return true;
}
// [End converter_process]

// 写入输出文件
bool WriteOutputFile(const char *outputFilePath, AudioConverterTestData *testData)
{
    if (!WritePcmFile(outputFilePath, &testData->outputAudioInfo)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "写入输出文件失败: %{public}s", outputFilePath);
        return false;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "写入输出文件成功: %{public}s", outputFilePath);
    return true;
}

// 清理资源
void CleanupResources(AudioConverterTestData *testData)
{
    delete[] testData->outputAudioInfo.buffer;
    // [Start converter_destroy]
    OH_AudioConverter_Destroy(testData->converter);
    // [End converter_destroy]
    FreeAudioDataInfo(&testData->inputAudioInfo);
}
// [End audio_format_converter_example]