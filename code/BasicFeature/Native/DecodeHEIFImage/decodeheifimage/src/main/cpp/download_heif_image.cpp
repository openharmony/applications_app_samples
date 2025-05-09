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
#include "download_heif_image.h"
#include <algorithm>

#include "curl.h"
#include "easy.h"
/**
 * 下载HEIF图像（.heic格式网络图片）
 * @param imageUrl HEIF图像下载链接
 * @return 下载的HEIF图像数据
 */

DownloadHEIFImage::DownloadHEIFImage(){};  // 构造函数
DownloadHEIFImage::~DownloadHEIFImage(){}; // 析构函数
/**
 *
 * @param contents
 * @param size
 * @param nmemb
 * @param userp
 * @return
 */
size_t DownloadHEIFImage::HttpPostWriteBack(void* contents, size_t size, size_t nmemb, void* userp)
{
    const size_t realsize = size * nmemb;
    auto* mem = static_cast<MemoryStruct*>(userp);

    // 新内存块总大小 = 当前数据大小 + 新数据大小 + 结束符
    const size_t newTotal = mem->size + realsize + 1;

    // 使用 malloc 分配新内存（不保留旧数据）
    char* new_memory = static_cast<char*>(malloc(newTotal));
    if (!new_memory) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG,
            "内存分配失败 (需要 %zu 字节)", newTotal);
        // 安全释放旧内存
        if (mem->memory) {
            free(mem->memory);
            mem->memory = nullptr;
            mem->size = 0;
        }
        return 0;
    }

    // 分步拷贝数据
    try {
        // 1. 拷贝旧数据（如果有）
        if (mem->memory && mem->size > 0) {
            std::copy(mem->memory, mem->memory + mem->size, new_memory);
        }

        // 2. 追加新数据
        const char* src_begin = static_cast<const char*>(contents);
        const char* src_end = src_begin + realsize;
        std::copy(src_begin, src_end, new_memory + mem->size);
    } catch (const std::exception& e) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "数据拷贝异常: %s", e.what());
        free(new_memory);
        return 0;
    }

    // 更新内存指针（原子操作保证线程安全）
    char* old_memory = mem->memory;
    mem->memory = new_memory;
    mem->size += realsize;
    mem->memory[mem->size] = '\0';

    // 释放旧内存（必须在所有操作完成后）
    if (old_memory) {
        free(old_memory);
    }
    return realsize;
}

MemoryStruct DownloadHEIFImage::get(std::string imageUrl)
{
    CURL *curl = curl_easy_init();
    // 获取数据
    MemoryStruct chunk;
    if (!curl) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "Failed to init curl!");
        chunk.size = -1;
        if (chunk.memory) {
            free(chunk.memory);
            chunk.memory = nullptr;
        }
        return chunk;
    }

    // 支持https
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
    // 访问网址
    curl_easy_setopt(curl, CURLOPT_URL, imageUrl.c_str());

    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &DownloadHEIFImage::HttpPostWriteBack);

    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);

    // 运行
    CURLcode res = curl_easy_perform(curl);
    if (res != CURLE_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, GLOBAL_RESMGR, TAG, "curl_easy_perform() failed: %{public}s",
                     curl_easy_strerror(res));
        if (chunk.memory) {
            free(chunk.memory);     // 释放内存
            chunk.memory = nullptr; // 防止悬空指针
            chunk.size = 0;         // 清空大小
        }
    }
    curl_easy_cleanup(curl); // 释放句柄

    return chunk;
}