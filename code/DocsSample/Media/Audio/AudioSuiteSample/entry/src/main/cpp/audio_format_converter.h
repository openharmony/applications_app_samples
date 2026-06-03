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

#ifndef AUDIO_FORMAT_CONVERTER_H
#define AUDIO_FORMAT_CONVERTER_H

#include <cstdint>

// 格式转换测试数据结构（前向声明）
struct AudioConverterDataInfo {
    uint8_t *buffer = nullptr;   // 音频数据。
    int32_t bufferSize = 0;      // 音频数据总大小。
    int32_t readDataOffSet = 0;  // 处理过的音频数据偏移量。
    bool readDataFinish = false; // 输入数据读取是否完成。
};

bool AudioFormatConverter(const char *inputFilePath, const char *outputFilePath);

#endif