/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "napi/native_api.h"
#include "types/project/file.h"

static napi_value NAPI_Global_doTestDataCovertAsymKey(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestDataCovertAsymKey(), &ret);
    return ret;
}

static napi_value NAPI_Global_doAsymEccCovert(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doAsymEccCovert(), &ret);
    return ret;
}

static napi_value NAPI_Global_doAsymSm2Covert(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doAsymSm2Covert(), &ret);
    return ret;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"doTestDataCovertAsymKey", nullptr, NAPI_Global_doTestDataCovertAsymKey, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"doAsymEccCovert", nullptr, NAPI_Global_doAsymEccCovert, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"doAsymSm2Covert", nullptr, NAPI_Global_doAsymSm2Covert, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
