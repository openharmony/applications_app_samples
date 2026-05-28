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

#ifndef PCM_FILE_UTILS_H
#define PCM_FILE_UTILS_H

#include <cstdint>
#include <cstdio>
// [Start audioSuite_AudioDataInfo]
struct AudioDataInfo {
    uint8_t *buffer = nullptr;   // 音频数据。
    int32_t bufferSize = 0;      // 音频数据总大小。
    int32_t totalWriteSize = 0;  // 处理过的音频数据总大小。
    int32_t totalReadSize = 0;  // 已读取的音频数据总大小。
};
// [End audioSuite_AudioDataInfo]
bool ReadPcmFile(const char *filePath, AudioDataInfo *info);
bool WritePcmFile(const char *filePath, const AudioDataInfo *info);
void FreeAudioDataInfo(AudioDataInfo *info);

int CheckAndDeleteFile(const char *filePath);
void SafeCloseFile(FILE *fp, const char *fileName);

#endif