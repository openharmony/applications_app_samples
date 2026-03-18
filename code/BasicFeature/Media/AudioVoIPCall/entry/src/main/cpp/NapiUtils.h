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

#ifndef AUDIOVOIPCALLSAMPLE_NAPIUTILS_H
#define AUDIOVOIPCALLSAMPLE_NAPIUTILS_H

#undef LOG_DOMAIN
#undef LOG_TAG
#define LOG_DOMAIN 0x3200
#define LOG_TAG "AudioVoIPSample"

#include "hilog/log.h"
#include <string>
#include "napi/native_api.h"

#define CHECK_AND_RETURN_RET_LOG(cond, ret, fmt, ...) \
    do {                                              \
        if (!cond) {                                  \
            OH_LOG_Print(LOG_APP, LOG_ERROR, 0x3200, LOG_TAG, fmt, ##__VA_ARGS__);      \
            return ret;                               \
        }                                             \
    } while (0)

class NapiUtils {
public:
    static napi_status GetValueInt32(const napi_env &env, int32_t &value, napi_value in);
    static napi_status SetValueString(const napi_env &env, std::string &stringValue, napi_value &result);
    static napi_status SetValueInt32(const napi_env &env, int32_t value, napi_value &result);
};
#endif //AUDIOVOIPCALLSAMPLE_NAPIUTILS_H
