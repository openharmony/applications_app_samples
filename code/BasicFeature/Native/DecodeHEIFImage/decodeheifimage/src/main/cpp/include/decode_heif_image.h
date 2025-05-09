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
#ifndef COMMONAPPDEVELOPMENT_DECODE_HEIF_IMAGE_H
#define COMMONAPPDEVELOPMENT_DECODE_HEIF_IMAGE_H
#include "common.h"
#include <cstdint>

class DecodeHEIFImage {
public:
    DecodeHEIFImage();  // 构造函数
    ~DecodeHEIFImage(); // 析构函数

    DecodeResult *decode_heif_image(MemoryStruct chunk);

private:
    void swapRBChannels(uint8_t *pixels, int pixelCount);
};

#endif // COMMONAPPDEVELOPMENT_DECODE_HEIF_IMAGE_H
