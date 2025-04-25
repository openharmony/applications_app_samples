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

#ifndef COMMONAPPDEVELOPMENT_DOWNLOAD_HEIF_IMAGE_H
#define COMMONAPPDEVELOPMENT_DOWNLOAD_HEIF_IMAGE_H

#include "common.h"
#include <string>

class DownloadHEIFImage {
public:
    DownloadHEIFImage();  // 构造函数
    ~DownloadHEIFImage(); // 析构函数

    MemoryStruct get(std::string url);
    static size_t HttpPostWriteBack(void *contents, size_t size, size_t nmemb, void *userp);

private:
};

#endif // COMMONAPPDEVELOPMENT_DECODE_HEIF_IMAGE_H
