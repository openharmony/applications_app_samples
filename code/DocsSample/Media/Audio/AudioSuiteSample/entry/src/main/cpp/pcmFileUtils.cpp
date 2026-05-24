/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 */

#include "pcmFileUtils.h"
#include <cstdio>
#include <cstring>

bool ReadPcmFile(const char *filePath, AudioDataInfo *info)
{
    if (filePath == nullptr || info == nullptr) {
        return false;
    }

    FILE *fp = fopen(filePath, "rb");
    if (fp == nullptr) {
        return false;
    }

    if (fseek(fp, 0, SEEK_END) != 0) {
        (void)fclose(fp);
        return false;
    }
    long fileSize = ftell(fp);
    if (fileSize < 0) {
        (void)fclose(fp);
        return false;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        (void)fclose(fp);
        return false;
    }

    if (fileSize <= 0) {
        (void)fclose(fp);
        return false;
    }

    info->buffer = new uint8_t[fileSize];
    if (info->buffer == nullptr) {
        (void)fclose(fp);
        return false;
    }

    size_t readSize = fread(info->buffer, 1, fileSize, fp);
    if (readSize != static_cast<size_t>(fileSize)) {
        delete[] info->buffer;
        info->buffer = nullptr;
        (void)fclose(fp);
        return false;
    }

    info->bufferSize = static_cast<int32_t>(fileSize);
    (void)fclose(fp);
    return true;
}

bool WritePcmFile(const char *filePath, const AudioDataInfo *info)
{
    if (filePath == nullptr || info == nullptr || info->buffer == nullptr || info->bufferSize <= 0) {
        return false;
    }
    FILE *fp = fopen(filePath, "wb");
    if (fp == nullptr) {
        return false;
    }

    size_t writeSize = fwrite(info->buffer, 1, info->bufferSize, fp);
    (void)fclose(fp);

    return writeSize == static_cast<size_t>(info->bufferSize);
}

void FreeAudioDataInfo(AudioDataInfo *info)
{
    if (info != nullptr && info->buffer != nullptr) {
        delete[] info->buffer;
        info->buffer = nullptr;
        info->bufferSize = 0;
        info->totalWriteSize = 0;
    }
}