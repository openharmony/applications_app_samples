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

#ifndef NAPI_SETTINGS_LOG_H
#define NAPI_SETTINGS_LOG_H

#ifndef LOG_TAG
#define LOG_TAG
#endif

#include <cstring>

#include "hilog/log.h"

namespace OHOS::Settings {
extern const OHOS::HiviewDFX::HiLogLabel SETTINGS_LABEL;

inline const char *GetSettingsFileName(const char *filePath)
{
    const char *slashFileName = std::strrchr(filePath, '/');
    const char *backslashFileName = std::strrchr(filePath, '\\');
    const char *fileName = slashFileName;
    if (backslashFileName != nullptr && (fileName == nullptr || backslashFileName > fileName)) {
        fileName = backslashFileName;
    }
    return fileName == nullptr ? filePath : fileName + 1;
}

#define SETTINGS_FILE_NAME OHOS::Settings::GetSettingsFileName(__FILE__)

#define SETTING_LOG_DEBUG(fmt, ...) \
    (void)OHOS::HiviewDFX::HiLog::Debug(SETTINGS_LABEL, \
    "[%{public}s(%{public}s:%{public}d)]" fmt, SETTINGS_FILE_NAME, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SETTING_LOG_INFO(fmt, ...) \
    (void)OHOS::HiviewDFX::HiLog::Info(SETTINGS_LABEL, \
    "[%{public}s(%{public}s:%{public}d)]" fmt, SETTINGS_FILE_NAME, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SETTING_LOG_WARN(fmt, ...) \
    (void)OHOS::HiviewDFX::HiLog::Warn(SETTINGS_LABEL, \
    "[%{public}s(%{public}s:%{public}d)]" fmt, SETTINGS_FILE_NAME, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SETTING_LOG_ERROR(fmt, ...) \
    (void)OHOS::HiviewDFX::HiLog::Error(SETTINGS_LABEL, \
    "[%{public}s(%{public}s:%{public}d)]" fmt, SETTINGS_FILE_NAME, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SETTING_LOG_FATAL(fmt, ...) \
    (void)OHOS::HiviewDFX::HiLog::Fatal(SETTINGS_LABEL, \
    "[%{public}s(%{public}s:%{public}d)]" fmt, SETTINGS_FILE_NAME, __FUNCTION__, __LINE__, ##__VA_ARGS__)
} // namespace OHOS::Settings
#endif
