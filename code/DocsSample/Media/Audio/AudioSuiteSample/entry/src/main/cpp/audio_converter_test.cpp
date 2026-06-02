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

// [Start audio_format_converter_example]
#include "audio_converter_test.h"
#include <cstring>
#include <algorithm>
#include "hilog/log.h"
// [Start format_conversion_header_file]
#include "ohaudiosuite/native_audio_converter.h"
// [End format_conversion_header_file]

const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioConverterTest]";
// 内存大小安全限制系数，防止申请过大的内存。
static const int32_t MAX_MEMORY_SIZE_SAFETY_FACTOR = 2;

// 输入数据回调函数。
// [Start input_callback]
int32_t AudioConverterRequestDataCallback(
    void *userData, const void **outInputData, OH_AudioConverter_InputStatus *outStatus)
{
    if ((userData == nullptr) || (outInputData == nullptr) || (outStatus == nullptr)) {
        return -1;
    }

    AudioConverterData *audioData = static_cast<AudioConverterData *>(userData);

    // 设置输出数据指针。
    // 注意：数据指针的值并不一定要从userData中获取，也可以是存储数据的缓存地址。
    // 例如：从文件中读取数据放入缓存，然后将该缓存地址赋值给输出数据指针。
    // 只要确保数据指针在OH_AudioConverter_Process()返回前保持有效即可。
    *outInputData = audioData->inputAudioInfo.buffer + audioData->inputAudioInfo.totalReadSize;

    // 计算本次可提供的数据大小（单次回调最多返回400KB）。
    // bufferSize：文件的总字节数（在ReadPcmFile中赋值）。
    // totalReadSize：已读取的字节数（每次回调递增）。
    int32_t maxDataSize = 400 * 1024;
    int32_t remainingSize = audioData->inputAudioInfo.bufferSize - audioData->inputAudioInfo.totalReadSize;
    int32_t actualDataSize = (remainingSize < maxDataSize) ? remainingSize : maxDataSize;

    // 更新已读取位置。
    audioData->inputAudioInfo.totalReadSize += actualDataSize;

    // 设置输入数据状态。
    if (actualDataSize == 0) {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_NO_AVAILABLE_DATA;
    } else if (audioData->inputAudioInfo.totalReadSize >= audioData->inputAudioInfo.bufferSize) {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_DATA_FINISHED;
    } else {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_HAVE_DATA;
    }

    return actualDataSize;
}
// [End input_callback]

// 执行格式转换。
bool AudioFormatConverterTest(const char *inputFilePath, const char *outputFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Start format conversion test");

    // 读取输入PCM文件。
    AudioConverterData audioData = {}; // 使用C++安全初始化替代memset。

    if (!ReadPcmFile(inputFilePath, &audioData.inputAudioInfo)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to read input file: %{public}s", inputFilePath);
        return false;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "Input file read successfully: %{public}d byte", audioData.inputAudioInfo.bufferSize);

    // 创建转换器并设置回调。
    if (!CreateAudioConverter(&audioData)) {
        FreeAudioDataInfo(&audioData.inputAudioInfo);
        return false;
    }

    // 分配输出缓冲区（估算大小，考虑采样率和声道数的变化）。
    // 采样率从48000到192000（4倍），声道从2到6（3倍），采样格式从16bit到24bit（1.5倍）。
    // 总倍数约4 * 3 * 1.5 = 18倍。
    int32_t estimatedOutputSize = audioData.inputAudioInfo.bufferSize * 18;

    if (!AllocateOutputBuffer(&audioData, estimatedOutputSize)) {
        OH_AudioConverter_Destroy(audioData.converter);
        FreeAudioDataInfo(&audioData.inputAudioInfo);
        return false;
    }

    // 处理音频数据。
    if (!ProcessAudioData(&audioData, estimatedOutputSize)) {
        CleanupResources(&audioData);
        return false;
    }

    // 写入输出文件。
    if (!WriteOutputFile(outputFilePath, &audioData)) {
        CleanupResources(&audioData);
        return false;
    }

    // 清理资源。
    CleanupResources(&audioData);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Format conversion test completed successfully");
    return true;
}

// 创建音频转换器并设置回调。
bool CreateAudioConverter(AudioConverterData *audioData)
{
    // [Start converter_create]
    // 设置输入格式。
    OH_AudioConverter_Format inputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE
    };

    // 设置输出格式。
    OH_AudioConverter_Format outputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_192000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_6POINT0_FRONT,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S24LE
    };

    // 创建转换器。
    OH_AudioConverter_Result result = OH_AudioConverter_Create(&inputFormat, &outputFormat, &audioData->converter);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create converter: %{public}d", result);
        return false;
    }
    // [End converter_create]
    
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Converter created successfully");
    
    // [Start set_input_callback]
    // 设置输入回调。
    result = OH_AudioConverter_SetInputCallback(audioData->converter, AudioConverterRequestDataCallback, audioData);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to set input callback: %{public}d", result);
        OH_AudioConverter_Destroy(audioData->converter);
        return false;
    }
    // [End set_input_callback]

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Set input callback successfully");
    return true;
}

// 分配输出缓冲区。
bool AllocateOutputBuffer(AudioConverterData *audioData, int32_t estimatedOutputSize)
{
    if (estimatedOutputSize <= 0 || estimatedOutputSize > INT32_MAX / MAX_MEMORY_SIZE_SAFETY_FACTOR) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG,
                     "The estimated output buffer size is invalid: %{public}d", estimatedOutputSize);
        OH_AudioConverter_Destroy(audioData->converter);
        FreeAudioDataInfo(&audioData->inputAudioInfo);
        return false;
    }
    audioData->outputAudioInfo.buffer = new uint8_t[estimatedOutputSize];
    if (audioData->outputAudioInfo.buffer == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Output buffer allocation failed");
        return false;
    }

    audioData->outputAudioInfo.bufferSize = 0;
    audioData->inputAudioInfo.totalReadSize = 0;
    return true;
}

// [Start converter_process]
// 处理音频数据。
bool ProcessAudioData(AudioConverterData *audioData, int32_t estimatedOutputSize)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Start processing audio data...");
    
    // 分配输出缓冲区。
    const int32_t processBufferSize = 4096 * 4; // 16KB。
    uint8_t *processBuffer = new uint8_t[processBufferSize];
    // 标记是否所有输入数据已结束。
    bool allInputDataFinished = false;
    int32_t outputSize = 0;
    OH_AudioConverter_Result result;

    do {
        result = OH_AudioConverter_Process(audioData->converter, processBuffer, processBufferSize, &outputSize);
        if (result != AUDIOCONVERTER_SUCCESS) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Audio data processing failed: %{public}d", result);
            delete[] processBuffer;
            return false;
        }
        
        // processBuffer是转换后的音频数据，数据长度为outputSize，开发者根据业务场景自行使用或者保存。
        if (outputSize > 0) { 
            // 将输出数据复制到输出缓冲区。
            if (audioData->outputAudioInfo.bufferSize + outputSize <= estimatedOutputSize) {
                std::copy(processBuffer, processBuffer + outputSize,
                          audioData->outputAudioInfo.buffer + audioData->outputAudioInfo.bufferSize);
                audioData->outputAudioInfo.bufferSize += outputSize;
            } else {
                OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Output buffer overflow");
                delete[] processBuffer;
                return false;
            }
        }
        // 检查是否所有输入数据已结束，当totalReadSize >= bufferSize时，表示已读取完所有输入数据。
    } while (outputSize > 0 || !(audioData->inputAudioInfo.totalReadSize >= audioData->inputAudioInfo.bufferSize));

    delete[] processBuffer;
    processBuffer = nullptr;

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "Format conversion completed: enter %{public}d byte, output %{public}d byte",
                 audioData->inputAudioInfo.bufferSize, audioData->outputAudioInfo.bufferSize);

    return true;
}
// [End converter_process]

// 写入输出文件。
bool WriteOutputFile(const char *outputFilePath, AudioConverterData *audioData)
{
    if (!WritePcmFile(outputFilePath, &audioData->outputAudioInfo)) {
        OH_LOG_Print(
            LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to write to output file: %{public}s", outputFilePath);
        return false;
    }

    OH_LOG_Print(
        LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Successfully written to output file: %{public}s", outputFilePath);
    return true;
}

// 清理资源。
void CleanupResources(AudioConverterData *audioData)
{
    delete[] audioData->outputAudioInfo.buffer;
    // [Start converter_destroy]
    OH_AudioConverter_Destroy(audioData->converter);
    // [End converter_destroy]
    FreeAudioDataInfo(&audioData->inputAudioInfo);
}
// [End audio_format_converter_example]