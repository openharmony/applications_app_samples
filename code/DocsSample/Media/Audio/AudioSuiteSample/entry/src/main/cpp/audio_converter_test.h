/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
 */

#ifndef AUDIO_CONVERTER_TEST_H
#define AUDIO_CONVERTER_TEST_H

#include <ohaudiosuite/native_audio_converter.h>
#include "pcmFileUtils.h"

// 格式转换测试数据结构（前向声明）
struct AudioConverterTestData {
    AudioDataInfo inputAudioInfo;
    AudioDataInfo outputAudioInfo;
    OH_AudioConverter *converter;
};

bool AudioFormatConverterTest(const char *inputFilePath, const char *outputFilePath);

// 子函数声明
bool CreateAudioConverter(AudioConverterTestData *testData);
bool AllocateOutputBuffer(AudioConverterTestData *testData, int32_t estimatedOutputSize);
bool ProcessAudioData(AudioConverterTestData *testData, int32_t estimatedOutputSize);
bool WriteOutputFile(const char *outputFilePath, AudioConverterTestData *testData);
void CleanupResources(AudioConverterTestData *testData);

#endif