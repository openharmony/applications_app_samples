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

#include "vma_utils.h"

#include <cerrno>
#include <cinttypes>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <unordered_map>
#include <vector>

#include <hilog/log.h>

#define LOG_ERROR(fmt, ...) OH_LOG_Print(LOG_APP, LOG_ERROR, 0x0001, "VMAUtils", fmt, ##__VA_ARGS__)
#define LOG_DEBUG(fmt, ...) OH_LOG_Print(LOG_APP, LOG_DEBUG, 0x0001, "VMAUtils", fmt, ##__VA_ARGS__)

namespace {

constexpr size_t HEX_SHIFT_BITS = 4;
constexpr uintptr_t DECIMAL_TO_HEX_OFFSET = 10;
constexpr size_t PERM_LEN = 4;
constexpr size_t PERM_LAST_INDEX = 3;
constexpr size_t PERM_END_INDEX = 4;
constexpr size_t PERM_MID_INDEX = 2;
constexpr size_t BUFFER_SIZE = 1024;

std::vector<std::string> TARGET_FILES = {};
static std::unordered_map<std::string, std::vector<vmaUtil::VMARegion>> g_target_vma_cache;
static bool g_cacheLoaded = false;

/**
 * @brief 高性能十六进制字符串转整数
 */
static constexpr uintptr_t HexToUintptr(const char* str, size_t len)
{
    uintptr_t value = 0;
    for (size_t i = 0; i < len; i++) {
        value <<= HEX_SHIFT_BITS;
        char c = str[i];
        if (c >= '0' && c <= '9') {
            value |= (c - '0');
        } else if (c >= 'a' && c <= 'f') {
            value |= (c - 'a' + DECIMAL_TO_HEX_OFFSET);
        } else if (c >= 'A' && c <= 'F') {
            value |= (c - 'A' + DECIMAL_TO_HEX_OFFSET);
        }
    }
    return value;
}

/**
 * @brief 快速跳过空白字符
 */
static constexpr const char* SkipWhitespace(const char* ptr)
{
    while (*ptr == ' ' || *ptr == '\t') {
        ptr++;
    }
    return ptr;
}

/**
 * @brief 跳过固定数量的空白分隔字段
 */
static const char* SkipFields(const char* ptr, int count)
{
    for (int i = 0; i < count; i++) {
        ptr = strchr(ptr, ' ');
        if (!ptr) {
            return nullptr;
        }
        ptr = SkipWhitespace(ptr + 1);
    }
    return ptr;
}

/**
 * @brief 解析路径名到region
 */
static bool ParsePathname(const char* ptr, vmaUtil::VMARegion* region)
{
    if (*ptr != '\0' && *ptr != '\n') {
        size_t maxLen = sizeof(region->pathname) - 1;
        size_t copyLen = strnlen(ptr, maxLen);
        if (copyLen > 0 && copyLen < maxLen) {
            for (size_t i = 0; i < copyLen; i++) {
                region->pathname[i] = ptr[i];
            }
            region->pathname[copyLen] = '\0';
        }
    } else {
        region->pathname[0] = '\0';
    }
    return true;
}

/**
 * @brief 解析 /proc/self/maps 的一行
 */
static bool ParseMapsLine(const char* line, size_t lineLen, vmaUtil::VMARegion* region)
{
    if (!line || lineLen == 0) {
        return false;
    }

    const char* ptr = line;

    const char* dash = strchr(ptr, '-');
    if (!dash) {
        return false;
    }

    region->start = HexToUintptr(ptr, static_cast<size_t>(dash - ptr));
    ptr = dash + 1;

    const char* space = strchr(ptr, ' ');
    if (!space) {
        return false;
    }
    region->end = HexToUintptr(ptr, static_cast<size_t>(space - ptr));
    region->size = region->end - region->start;
    ptr = space + 1;

    ptr = SkipWhitespace(ptr);
    if (ptr[0] == '\0' || ptr[1] == '\0' || ptr[PERM_MID_INDEX] == '\0' || ptr[PERM_LAST_INDEX] == '\0') {
        return false;
    }
    region->perms[0] = ptr[0];
    region->perms[1] = ptr[1];
    region->perms[PERM_MID_INDEX] = ptr[PERM_MID_INDEX];
    region->perms[PERM_LAST_INDEX] = ptr[PERM_LAST_INDEX];
    region->perms[PERM_END_INDEX] = '\0';
    ptr += PERM_LEN;

    // skip offset, dev, inode fields
    ptr = SkipFields(SkipWhitespace(ptr), PERM_MID_INDEX + 1);
    if (!ptr) {
        return false;
    }

    return ParsePathname(ptr, region);
}

/**
 * @brief 处理maps文件中的一行，尝试匹配目标文件并缓存VMA
 */
static void ProcessMapsLine(const char* line)
{
    const char* fnPtr = strrchr(line, '/');
    if (!fnPtr) {
        return;
    }
    fnPtr++;

    for (const auto& target : TARGET_FILES) {
        if (strncmp(fnPtr, target.c_str(), target.length()) == 0) {
            vmaUtil::VMARegion region;
            if (ParseMapsLine(line, strlen(line), &region)) {
                g_target_vma_cache[target].push_back(region);
            }
            break;
        }
    }
}

/**
 * @brief 加载指定文件的VMA缓存
 */
static bool LoadTargetVmaCache()
{
    FILE* fp = fopen("/proc/self/maps", "r");
    if (!fp) {
        LOG_ERROR("Failed to open /proc/self/maps: %{public}d", errno);
        return false;
    }

    char line[BUFFER_SIZE];
    char* fgetsRet = nullptr;
    while ((fgetsRet = fgets(line, sizeof(line), fp)) != nullptr) {
        ProcessMapsLine(line);
    }

    int closeRet = fclose(fp);
    if (closeRet != 0) {
        LOG_ERROR("fclose failed: %{public}d", closeRet);
    }
    g_cacheLoaded = true;

    return true;
}

/**
 * @brief 清除VMA缓存
 */
static void ClearVmaCache()
{
    g_target_vma_cache.clear();
    g_cacheLoaded = false;
}

/**
 * @brief 仅处理指定文件的匹配（删除非指定文件逻辑）
 */
static int IterateMapsInternal(const char* filename, int (*callback)(const vmaUtil::VMARegion*, void*), void* userdata)
{
    if (!g_cacheLoaded) {
        LoadTargetVmaCache();
    }

    auto it = g_target_vma_cache.find(filename);
    if (it == g_target_vma_cache.end()) {
        LOG_ERROR("MadviseTest未找到指定文件 %{public}s 的VMA缓存", filename);
        return 0;
    }

    int count = 0;
    for (const auto& region : it->second) {
        count++;
        if (callback && callback(&region, userdata) != 0) {
            break;
        }
    }

    LOG_DEBUG("MadviseMemory 匹配指定文件 %{public}s，找到 %{public}d 个VMA段", filename, count);
    return count;
}

} // anonymous namespace

namespace vmaUtil {

/**
 * @brief 设置目标文件列表
 */
void SetTargetFiles(const std::vector<std::string>& targetFiles)
{
    TARGET_FILES = targetFiles;
    ClearVmaCache();
}

/**
 * @brief 获取单个指定文件的所有 VMA 区域（仅处理指定文件）
 */
std::vector<VMARegion> GetFileVmas(const char* filename)
{
    if (!filename || strlen(filename) == 0) {
        LOG_ERROR("Invalid filename: null or empty");
        return {};
    }

    std::vector<VMARegion> vma_list;

    auto collectCallback = [](const VMARegion* region, void* userdata) -> int {
        static_cast<std::vector<VMARegion>*>(userdata)->push_back(*region);
        return 0;
    };

    IterateMapsInternal(filename, collectCallback, &vma_list);

    if (!TARGET_FILES.empty()) {
        const std::string& lastFile = TARGET_FILES.back();
        if (strcmp(filename, lastFile.c_str()) == 0) {
            LOG_ERROR("MadviseTest检测到最后一个文件 %{public}s，开始清理VMA缓存", filename);
            ClearVmaCache();
        }
    }

    return vma_list;
}

} // namespace vmaUtil
