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

#ifndef AUDIO_CONVERTER_TEST_H
#define AUDIO_CONVERTER_TEST_H

#include <ohaudiosuite/native_audio_converter.h>
#include "pcm_file_utils.h"

// 格式转换测试数据结构（前向声明）
struct AudioConverterData {
    AudioDataInfo inputAudioInfo;
    AudioDataInfo outputAudioInfo;
    OH_AudioConverter *converter;
};

bool AudioFormatConverterTest(const char *inputFilePath, const char *outputFilePath);

// 子函数声明
bool CreateAudioConverter(AudioConverterData *audioData);
bool AllocateOutputBuffer(AudioConverterData *audioData, int32_t estimatedOutputSize);
bool ProcessAudioData(AudioConverterData *audioData, int32_t estimatedOutputSize);
bool WriteOutputFile(const char *outputFilePath, AudioConverterData *audioData);
void CleanupResources(AudioConverterData *audioData);

#endif