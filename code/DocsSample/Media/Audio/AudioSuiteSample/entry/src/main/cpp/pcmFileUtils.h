/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
};
// [End audioSuite_AudioDataInfo]
bool ReadPcmFile(const char *filePath, AudioDataInfo *info);
bool WritePcmFile(const char *filePath, const AudioDataInfo *info);
void FreeAudioDataInfo(AudioDataInfo *info);

int CheckAndDeleteFile(const char *filePath);
void SafeCloseFile(FILE *fp, const char *fileName);

#endif