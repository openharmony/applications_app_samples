/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

#include "hilog/log.h"
#include "napi/native_api.h"
#include "napi_info_util.h"

EXTERN_C_START

/**
 * @brief  For N-API modules registration
 *
 * @param[in] env The environment that the Node-API call is invoked under
 * @param[in] exports  An empty object via the exports parameter as a convenience
 *
 * @return The return value from Init is treated as the exports object for the module
 */
static napi_value Init(napi_env env, napi_value exports)
{
    OH_LOG_INFO(LOG_APP, "napi_moudule Init start...");
    napi_property_descriptor properties[] = {
        { "getRandomNumber", nullptr, OHOS::NAPI_GetRandomNumber, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(properties) / sizeof(properties[0]), properties);
    OH_LOG_INFO(LOG_APP, "napi_moudule Init end...");
    return exports;
}

EXTERN_C_END

// Define a Node-API module.
static napi_module _module = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "infoutil",
    .nm_priv = ((void *)0),
    .reserved = {0}
};

// Registers a Node-API module.
extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&_module);
}