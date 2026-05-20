/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
 */

#ifndef PCM_FILE_UTILS_H
#define PCM_FILE_UTILS_H

#include <cstdint>

struct AudioDataInfo {
    uint8_t *buffer = nullptr;  // 音频数据。
    int32_t bufferSize = 0;     // 音频数据总大小。
    int32_t totalWriteSize = 0; // 处理过的音频数据总大小。
};
bool ReadPcmFile(const char *filePath, AudioDataInfo *info);
bool WritePcmFile(const char *filePath, const AudioDataInfo *info);
void FreePcmData(AudioDataInfo *info);

#endif