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

#ifndef VMA_UTILS_H
#define VMA_UTILS_H

#include <cstdint>
#include <vector>
#include <string>

namespace vmaUtil {

#define VMA_MAX_PATH_NAME 256   /**< 最大路径名长度 */
#define VMA_MAX_PERMS 5         /**< 最大权限字符串长度（如 "r-xp"） */

struct VMARegion {
    uintptr_t start;                    /**< 起始地址 */
    uintptr_t end;                      /**< 结束地址 */
    uintptr_t size;                     /**< 区域大小（字节） */
    char perms[VMA_MAX_PERMS];          /**< 权限字符串（如 "r-xp"） */
    char pathname[VMA_MAX_PATH_NAME];   /**< 文件路径或区域名称 */
};

std::vector<VMARegion> GetFileVmas(const char* filename);

void SetTargetFiles(const std::vector<std::string>& targetFiles);

} // namespace vmaUtil

#endif // VMA_UTILS_H
