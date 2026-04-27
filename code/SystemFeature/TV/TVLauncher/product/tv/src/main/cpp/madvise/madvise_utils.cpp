/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include "madvise_utils.h"
#include "vma_utils.h"

#include <cstring>
#include <dlfcn.h>
#include <link.h>
#include <string>
#include <sys/mman.h>
#include <unordered_set>
#include <unistd.h>
#include <vector>

#include <hilog/log.h>

#define LOG_PRINT(fmt, ...) OH_LOG_Print(LOG_APP, LOG_INFO, 0x0001, "MadviseUtils", fmt, ##__VA_ARGS__)
#define LOG_ERROR(fmt, ...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0x0001, "MadviseUtils", fmt, ##__VA_ARGS__)

namespace madviseUtil {

typedef struct {
    int successCount;
    std::string targetLibBasename;
    std::unordered_set<std::string> processedLibs;
} MadviseDataOptimized;

/**
 * @brief 优化后的单库回调函数
 */
static int MadvisePhdrCallbackOptimized(struct dl_phdr_info* info, size_t size, void* data)
{
    (void)size;
    MadviseDataOptimized* madviseData = static_cast<MadviseDataOptimized*>(data);

    const char* currentLibName = info->dlpi_name;
    if (!currentLibName || strlen(currentLibName) == 0) {
        return 0;
    }

    const char* baseNamePos = strrchr(currentLibName, '/');
    const char* baseName = nullptr;
    if (baseNamePos == nullptr) {
        baseName = currentLibName;
    } else {
        baseName = baseNamePos + 1;
    }

    if (madviseData->targetLibBasename != baseName) {
        return 0;
    }

    if (madviseData->processedLibs.find(baseName) != madviseData->processedLibs.end()) {
        return 0;
    }
    madviseData->processedLibs.insert(baseName);

    int libSuccessCount = 0;
    size_t pageSize = getpagesize();

    for (int i = 0; i < info->dlpi_phnum; i++) {
        const ElfW(Phdr)* phdr = &info->dlpi_phdr[i];
        if (phdr->p_type != PT_LOAD) {
            continue;
        }

        bool isReadable = (phdr->p_flags & PF_R);
        bool isWritable = (phdr->p_flags & PF_W);
        if (!isReadable || isWritable) {
            continue;
        }

        void* startAddr = reinterpret_cast<void*>(info->dlpi_addr + phdr->p_vaddr);
        size_t len = phdr->p_memsz;
        void* alignedStart = reinterpret_cast<void*>(
            reinterpret_cast<uintptr_t>(startAddr) & ~(pageSize - 1));
        size_t alignedLen = (reinterpret_cast<uintptr_t>(startAddr) + len + pageSize - 1) & ~(pageSize - 1);
        alignedLen -= reinterpret_cast<uintptr_t>(alignedStart);

        if (madvise(alignedStart, alignedLen, MADV_DONTNEED) == 0) {
            libSuccessCount++;
        }
    }

    if (libSuccessCount > 0) {
        madviseData->successCount++;
    }

    return 0;
}

/**
 * @brief 优化后的单库madvise函数（对外暴露的核心接口）
 */
bool MadviseSingleLibraryOptimized(const char* libName)
{
    if (!libName || strlen(libName) == 0) {
        LOG_ERROR("Invalid library name: empty string");
        return false;
    }

    const char* inputBasenamePos = strrchr(libName, '/');
    const char* inputBasename = nullptr;
    if (inputBasenamePos == nullptr) {
        inputBasename = libName;
    } else {
        inputBasename = inputBasenamePos + 1;
    }

    MadviseDataOptimized madviseData = {0, inputBasename, {}};

    dl_iterate_phdr(MadvisePhdrCallbackOptimized, &madviseData);

    return (madviseData.successCount > 0);
}

/**
 * @brief 对单个 VMA 段应用 madvise
 */
static int ApplyMadviseToRegion(const vmaUtil::VMARegion& region, size_t pageSize)
{
    bool isReadonly = (strstr(region.perms, "r--") != nullptr);
    bool isExecutable = (strstr(region.perms, "r-x") != nullptr);
    if (!isReadonly && !isExecutable) {
        return 0;
    }

    void* startAddr = reinterpret_cast<void*>(region.start);
    void* alignedStart = reinterpret_cast<void*>(
        reinterpret_cast<uintptr_t>(startAddr) & ~(pageSize - 1));
    size_t alignedLen = (reinterpret_cast<uintptr_t>(region.end) + pageSize - 1) & ~(pageSize - 1);
    alignedLen -= reinterpret_cast<uintptr_t>(alignedStart);

    return (madvise(alignedStart, alignedLen, MADV_DONTNEED) == 0) ? 1 : 0;
}

/**
 * @brief 处理 VMA 列表（通用逻辑）
 */
static int ProcessVmaRegions(const std::vector<vmaUtil::VMARegion>& regions)
{
    if (regions.empty()) {
        return 0;
    }

    int successCount = 0;
    size_t pageSize = getpagesize();

    for (const auto& region : regions) {
        successCount += ApplyMadviseToRegion(region, pageSize);
    }

    return successCount;
}

/**
 * @brief 通用 madvise 接口 - 单个文件
 */
bool MadviseGeneralFile(const char* filename)
{
    if (!filename || strlen(filename) == 0) {
        LOG_ERROR("Invalid filename: empty string");
        return false;
    }

    std::vector<vmaUtil::VMARegion> regions = vmaUtil::GetFileVmas(filename);
    if (regions.empty()) {
        LOG_ERROR("No VMA regions found for %{public}s", filename);
        return false;
    }

    int successCount = ProcessVmaRegions(regions);
    return (successCount > 0);
}

} // namespace madviseUtil
