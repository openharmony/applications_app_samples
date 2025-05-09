/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef COMMONAPPDEVELOPMENT_MEMORYSTRUCT_H
#define COMMONAPPDEVELOPMENT_MEMORYSTRUCT_H

#include "stdint.h"
#include <cstddef>
#include <cstdlib>
#include <hilog/log.h>

const int GLOBAL_RESMGR = 0xFF00;
const char *TAG = "[decodeheifimage]";

struct MemoryStruct {
    char *memory = nullptr;
    size_t size;

    // 构造函数
    MemoryStruct() : memory(nullptr), size(0)
    {
        memory = (char *)malloc(1); // 初始分配1字节
        if (memory) {
            memory[0] = '\0'; // 确保字符串以空字符结尾
        }
    }

    // 析构函数
    ~MemoryStruct()
    {
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "析构 MemoryStruct");
    }
};

struct DecodeResult {
    uint8_t *data;
    int heifImageStride;
    int heifImageWidth;
    int heifImageHeight;

    DecodeResult(uint8_t *data, int stride, int width, int height)
    {
        this->data = data;
        this->heifImageStride = stride;
        this->heifImageWidth = width;
        this->heifImageHeight = height;
    }

    ~DecodeResult()
    {
        this->data = nullptr;
        OH_LOG_Print(LOG_APP, LOG_INFO, GLOBAL_RESMGR, TAG, "析构 DecodeResult");
    }
};

#endif // COMMONAPPDEVELOPMENT_MEMORYSTRUCT_H
