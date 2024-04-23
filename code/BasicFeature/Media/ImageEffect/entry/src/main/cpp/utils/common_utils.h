/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#ifndef COMMON_UTILS_H
#define COMMON_UTILS_H

#include <string>
#include "napi/native_api.h"

#include "logging.h"
#include <multimedia/image_effect/image_effect_filter.h>

#define CHECK_AND_RETURN_RET_LOG(cond, ret, fmt, ...)  \
    do {                                               \
        if (!(cond)) {                                 \
            LOG_E(fmt, ##__VA_ARGS__);                 \
            return ret;                                \
        }                                              \
    } while (0)

#define CHECK_AND_RETURN_LOG(cond, fmt, ...)           \
    do {                                               \
        if (!(cond)) {                                 \
            LOG_E(fmt, ##__VA_ARGS__);                 \
            return;                                    \
        }                                              \
    } while (0)

#define CHECK_AND_NO_RETURN_LOG(cond, fmt, ...)        \
    do {                                               \
        if (!(cond)) {                                 \
            LOG_E(fmt, ##__VA_ARGS__);                 \
        }                                              \
    } while (0)

#define CHECK_AND_RETURN_NO_RET(cond, fmt, ...)        \
    do {                                               \
        if (!(cond)) {                                 \
            LOG_E(fmt, ##__VA_ARGS__);                 \
            return;                                    \
        }                                              \
    } while (0)

class CommonUtils {
public:
    static const char *GetStringArgument(napi_env env, napi_value value);
    
    static std::string EffectInfoToString(OH_EffectFilterInfo *info);
};

#endif // COMMON_UTILS_H