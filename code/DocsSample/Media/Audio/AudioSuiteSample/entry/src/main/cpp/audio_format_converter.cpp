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

#include "audio_format_converter.h"
#include <cstring>
#include <cstdio>
#include "hilog/log.h"
// [Start format_conversion_header_file]
#include "ohaudiosuite/native_audio_converter.h"
// [End format_conversion_header_file]

const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioConverterTest]";
static const int32_t MAX_DATA_SIZE = 400 * 1024;
static const long MAX_ALLOC_SIZE = 1024 * 1024 * 1024;

// 输入数据回调函数。
int32_t AudioConverterRequestDataCallback(
    void *userData, const void **outInputData, OH_AudioConverter_InputStatus *outStatus)
{
    if ((userData == nullptr) || (outInputData == nullptr) || (outStatus == nullptr)) {
        return -1;
    }
    AudioConverterDataInfo *dataInfo = static_cast<AudioConverterDataInfo *>(userData);
    
    // [Start input_callback]
    // 设置输出数据指针。
    // 注意：数据指针的值并不一定要从userData中获取，也可以是存储数据的缓存地址。
    // 例如：从文件中读取数据放入缓存，然后将该缓存地址赋值给输出数据指针。
    // 只要确保数据指针在OH_AudioConverter_Process()返回前保持有效即可。
    *outInputData = dataInfo->buffer + dataInfo->readDataOffSet;

    // 计算本次可提供的数据大小（单次回调最多返回400KB）。
    // bufferSize：文件的总字节数。
    // readDataOffSet：已读取的字节数偏移量。
    int32_t remainingSize = dataInfo->bufferSize - dataInfo->readDataOffSet;
    if (remainingSize < 0) {
        return -1;
    }
    int32_t actualDataSize = (remainingSize < MAX_DATA_SIZE) ? remainingSize : MAX_DATA_SIZE;

    // 更新已读取位置。
    dataInfo->readDataOffSet += actualDataSize;

    // 设置输入数据状态。
    if (dataInfo->readDataOffSet >= dataInfo->bufferSize) {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_DATA_FINISHED;
        dataInfo->readDataFinish = true;
    } else {
        *outStatus = OH_AudioConverter_InputStatus::AUDIOCONVERTER_INPUT_HAVE_DATA;
    }
    // [End input_callback]

    return actualDataSize;
}

void SafeCloseConverterFile(FILE *fp, const char *fileName)
{
    if (fp == nullptr) {
        return;
    }
    if (fclose(fp) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close file: %{public}s",
                     fileName != nullptr ? fileName : "unknown");
    }
}

// 获取文件大小。
long GetFileSize(FILE *fp)
{
    if (fseek(fp, 0, SEEK_END) != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to seek file end");
        return -1;
    }

    long fileSize = ftell(fp);
    if (fileSize < 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to get file size");
        return -1;
    }

    if (fseek(fp, 0, SEEK_SET) != 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to seek file start");
        return -1;
    }

    return fileSize;
}

// 读取文件数据到缓冲区。
bool ReadFileData(FILE *fp, uint8_t **buffer, long fileSize)
{
    if (fileSize <= 0 || fileSize > MAX_ALLOC_SIZE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Invalid file size: %{public}ld", fileSize);
        return false;
    }
    *buffer = new uint8_t[fileSize];
    if (*buffer == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to allocate buffer");
        return false;
    }

    size_t readSize = fread(*buffer, 1, fileSize, fp);
    if (readSize != static_cast<size_t>(fileSize)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to read file data");
        delete[] *buffer;
        *buffer = nullptr;
        return false;
    }

    return true;
}

bool ReadPcmFile(const char *filePath, AudioConverterDataInfo *dataInfo)
{
    if (filePath == nullptr || dataInfo == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Invalid parameters");
        return false;
    }

    FILE *fp = fopen(filePath, "rb");
    if (fp == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open file: %{public}s", filePath);
        return false;
    }

    long fileSize = GetFileSize(fp);
    if (fileSize <= 0) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Invalid file size: %{public}ld", fileSize);
        SafeCloseConverterFile(fp, filePath);
        return false;
    }

    if (!ReadFileData(fp, &dataInfo->buffer, fileSize)) {
        SafeCloseConverterFile(fp, filePath);
        return false;
    }

    dataInfo->bufferSize = static_cast<int32_t>(fileSize);
    dataInfo->readDataOffSet = 0;
    dataInfo->readDataFinish = false;

    SafeCloseConverterFile(fp, filePath);
    return true;
}

// 创建音频转换器并设置回调。
bool CreateAudioConverter(AudioConverterDataInfo *dataInfo, OH_AudioConverter *&converter)
{
    // [Start converter_create]
    // 用户需按照实际情况设置输入格式。
    OH_AudioConverter_Format inputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_48000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_STEREO,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S16LE
    };

    // 用户需按照实际情况设置输出格式。
    OH_AudioConverter_Format outputFormat = {
        .encodingType = OH_Audio_EncodingType::AUDIO_ENCODING_TYPE_RAW,
        .samplingRate = OH_Audio_SampleRate::SAMPLE_RATE_192000,
        .channelLayout = OH_AudioChannelLayout::CH_LAYOUT_6POINT0_FRONT,
        .sampleFormat = OH_Audio_SampleFormat::AUDIO_SAMPLE_S24LE
    };

    // 创建转换器。
    OH_AudioConverter_Result result = OH_AudioConverter_Create(&inputFormat, &outputFormat, &converter);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to create converter: %{public}d", result);
        return false;
    }
    // [End converter_create]
    
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Converter created successfully");
    
    // [Start set_input_callback]
    // 设置输入回调。
    result = OH_AudioConverter_SetInputCallback(converter, AudioConverterRequestDataCallback, dataInfo);
    if (result != AUDIOCONVERTER_SUCCESS) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to set input callback: %{public}d", result);
        OH_AudioConverter_Destroy(converter);
        return false;
    }
    // [End set_input_callback]

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Set input callback successfully");
    return true;
}

// 处理音频数据。
bool ProcessAudioData(AudioConverterDataInfo *dataInfo, const char *outputFilePath, OH_AudioConverter *converter)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Start processing audio data...");

    // 打开输出文件。
    FILE *outputFile = fopen(outputFilePath, "wb");
    if (outputFile == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to open output file: %{public}s", outputFilePath);
        return false;
    }
    
    // [Start converter_process]
    // 分配处理缓冲区。
    const int32_t processBufferSize = 4096 * 4; // 16KB。
    uint8_t *processBuffer = new uint8_t[processBufferSize];
    int32_t outputSize = 0;
    int32_t totalOutputSize = 0;
    OH_AudioConverter_Result result;

    do {
        result = OH_AudioConverter_Process(converter, processBuffer, processBufferSize, &outputSize);
        if (result != AUDIOCONVERTER_SUCCESS) {
            OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Audio data processing failed: %{public}d", result);
            delete[] processBuffer;
            SafeCloseConverterFile(outputFile, outputFilePath);
            return false;
        }
        
        if (outputSize > 0) {
            // 用户可以根据自己的业务要求做相应的处理。
            size_t written = fwrite(processBuffer, 1, outputSize, outputFile);
            if (written != static_cast<size_t>(outputSize)) {
                OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to write output data");
                delete[] processBuffer;
                SafeCloseConverterFile(outputFile, outputFilePath);
                return false;
            }
            totalOutputSize += outputSize;
        }
        // outputSize返回0，且用户写入数据完成。
    } while (outputSize > 0 || !dataInfo->readDataFinish);

    delete[] processBuffer;
    processBuffer = nullptr;
    SafeCloseConverterFile(outputFile, outputFilePath);
    // [End converter_process]

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "Format conversion completed: enter %{public}d byte, output %{public}d byte",
                 dataInfo->bufferSize, totalOutputSize);

    return true;
}

// 清理资源。
void CleanupResources(AudioConverterDataInfo *dataInfo, OH_AudioConverter *converter)
{
    // [Start converter_destroy]
    OH_AudioConverter_Destroy(converter);
    // [End converter_destroy]
    delete[] dataInfo->buffer;
}

// 执行格式转换。
bool AudioFormatConverter(const char *inputFilePath, const char *outputFilePath)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Start format conversion test");

    // 读取输入PCM文件到AudioConverterDataInfo。
    AudioConverterDataInfo dataInfo = {};
    dataInfo.readDataFinish = false;
    if (!ReadPcmFile(inputFilePath, &dataInfo)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to read input file: %{public}s", inputFilePath);
        return false;
    }

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG,
                 "Input file read successfully: %{public}d byte", dataInfo.bufferSize);

    // 创建转换器并设置回调。
    OH_AudioConverter *converter = nullptr;
    if (!CreateAudioConverter(&dataInfo, converter)) {
        delete[] dataInfo.buffer;
        return false;
    }

    // 处理音频数据并直接写入输出文件。
    if (!ProcessAudioData(&dataInfo, outputFilePath, converter)) {
        CleanupResources(&dataInfo, converter);
        return false;
    }

    // 清理资源。
    CleanupResources(&dataInfo, converter);

    OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Format conversion test completed successfully");
    return true;
}