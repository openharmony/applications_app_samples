/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

#include "napi_info_util.h"

#include <list>
#include <string>

#include "hilog/log.h"
#include "napi/native_api.h"

#define LOG_TAG "InfoUtil"

namespace OHOS {
napi_value NAPI_GetRandomNumber(napi_env env, napi_callback_info info)
{
    napi_value ret = nullptr;
    OH_LOG_INFO(LOG_APP, "%{public}s called", __func__);
    size_t requireArgc = 2;
    size_t argc = 2;
    napi_value args[2] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    napi_valuetype valueType0;
    napi_typeof(env, args[0], &valueType0);
    napi_valuetype valueType1;
    napi_typeof(env, args[1], &valueType1);
    if (valueType0 != napi_number || valueType1 != napi_number) {
        OH_LOG_ERROR(LOG_APP, "Error value type for args");
        return ret;
    }
    int32_t startNum = 0;
    napi_get_value_int32(env, args[0], &startNum);
    int32_t endNum = 0;
    napi_get_value_int32(env, args[1], &endNum);
    auto current = time(nullptr);
    if (current < 0) {
        current = 0;
    }
    srand(current);
    int32_t randSeed = rand();
    int32_t randomNumber = startNum + randSeed % (endNum - startNum + 1);
    napi_create_int32(env, randomNumber, &ret);
    OH_LOG_INFO(LOG_APP, "[%{public}d %{public}d] -> %{public}d %{public}d",
        startNum, endNum, randomNumber, randSeed);
    return ret;
}
} // namespace OHOS