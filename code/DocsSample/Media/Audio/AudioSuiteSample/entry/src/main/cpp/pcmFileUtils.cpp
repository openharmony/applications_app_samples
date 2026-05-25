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

#include "pcmFileUtils.h"
#include <cstdio>
#include <cstring>
#include "hilog/log.h"

const int GLOBAL_RESMGR = 0xFF00;
static const char *TAG = "[AudioFileUtils]";

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

int CheckAndDeleteFile(const char *filePath)
{
    if (filePath == nullptr) {
        return -1;
    }

    FILE *checkFile = fopen(filePath, "rb");
    if (checkFile != nullptr) {
        (void)fclose(checkFile);
        if (remove(filePath) == 0) {
            OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "Output file exists, deleted: %{public}s", filePath);
        } else {
            OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to delete existing file: %{public}s", filePath);
        }
    }
    return 0;
}

void SafeCloseFile(FILE *fp, const char *fileName)
{
    if (fp == nullptr) {
        return;
    }
    if (fclose(fp) != 0) {
        OH_LOG_Print(LOG_APP, LOG_WARN, GLOBAL_RESMGR, TAG, "Failed to close file: %{public}s",
                     fileName != nullptr ? fileName : "unknown");
    }
}