/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. 2026-2026. ALL rights reserved.
 */

#include "pcmFileUtils.h"
#include <cstdio>
#include <cstring>

bool ReadPcmFile(const char *filePath, AudioDataInfo *info) {
    if (filePath == nullptr || info == nullptr) {
        return false;
    }

    FILE *fp = fopen(filePath, "rb");
    if (fp == nullptr) {
        return false;
    }

    fseek(fp, 0, SEEK_END);
    long fileSize = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    if (fileSize <= 0) {
        fclose(fp);
        return false;
    }

    info->buffer = new uint8_t[fileSize];
    if (info->buffer == nullptr) {
        fclose(fp);
        return false;
    }

    size_t readSize = fread(info->buffer, 1, fileSize, fp);
    if (readSize != static_cast<size_t>(fileSize)) {
        delete[] info->buffer;
        info->buffer = nullptr;
        fclose(fp);
        return false;
    }

    info->bufferSize = static_cast<int32_t>(fileSize);
    fclose(fp);
    return true;
}

bool WritePcmFile(const char *filePath, const AudioDataInfo *info) {
    if (filePath == nullptr || info == nullptr || info->buffer == nullptr || info->bufferSize <= 0) {
        return false;
    }
    FILE *fp = fopen(filePath, "wb");
    if (fp == nullptr) {
        return false;
    }

    size_t writeSize = fwrite(info->buffer, 1, info->bufferSize, fp);
    fclose(fp);

    return writeSize == static_cast<size_t>(info->bufferSize);
}

void FreeAudioDataInfo(AudioDataInfo *info) {
    if (info != nullptr && info->buffer != nullptr) {
        delete[] info->buffer;
        info->buffer = nullptr;
        info->bufferSize = 0;
        info->totalWriteSize = 0;
    }
}