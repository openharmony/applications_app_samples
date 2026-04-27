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

#ifndef MADVISE_UTILS_H
#define MADVISE_UTILS_H

#include <cstdint>
#include <string>
#include <vector>

namespace madviseUtil {
bool MadviseSingleLibrary(const char* libName);
bool MadviseSingleLibraryOptimized(const char* libName);
int MadviseMultipleLibraries(const std::vector<std::string>& libNames);
bool MadviseGeneralFile(const char* filename);
} // namespace madviseUtil

#endif // MADVISE_UTILS_H
