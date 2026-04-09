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

#include <pthread.h>
#include <unistd.h>

#include "napi_settings.h"
#include "napi/native_api.h"
#include "napi/native_node_api.h"
#include "napi_settings_log.h"

namespace OHOS {
namespace Settings {
EXTERN_C_START
/*
 * function for module exports
 */
static napi_value Init(napi_env env, napi_value exports)
{
    SETTING_LOG_INFO("napi_moudule Init start...");

    napi_property_descriptor desc[] = {
        DECLARE_NAPI_FUNCTION("getURI", napi_get_uri),
        DECLARE_NAPI_FUNCTION("getValue", napi_get_value),
        DECLARE_NAPI_FUNCTION("setValue", napi_set_value),
        DECLARE_NAPI_FUNCTION("getUriSync", napi_get_uri_sync),
        DECLARE_NAPI_FUNCTION("getValueSync", napi_get_value_sync),
        DECLARE_NAPI_FUNCTION("setValueSync", napi_set_value_sync),
        DECLARE_NAPI_FUNCTION("enableAirplaneMode", napi_enable_airplane_mode),
        DECLARE_NAPI_FUNCTION("canShowFloating", napi_can_show_floating),
    };

    // init settings class
    NAPI_CALL(env, napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc));
    InitNapiClass(env, exports);
    SETTING_LOG_INFO("napi_moudule Init end...");
    return exports;
}
EXTERN_C_END

/*
 * Module define
 */
static napi_module _module = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "settings",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

/*
 * Module register function
 */
extern "C" __attribute__((constructor)) void RegisterModule(void)
{
    napi_module_register(&_module);
}
}  // namespace Settings
}  // namespace OHOS