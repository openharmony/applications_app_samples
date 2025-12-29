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

static napi_value NAPI_Global_doTestSm2EncMessage(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestSm2EncMessage(), &ret);
    return ret;
}

static napi_value NAPI_Global_doTestGetCipherTextSpec(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestGetCipherTextSpec(), &ret);
    return ret;
}

static napi_value NAPI_Global_doTestGenCipherTextBySpec(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestGenCipherTextBySpec(), &ret);
    return ret;
}

static napi_value NAPI_Global_doTestRsaEncDec(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestRsaEncDec(), &ret);
    return ret;
}

static napi_value NAPI_Global_doTestRsaEncLongMessage(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, doTestRsaEncLongMessage(), &ret);
    return ret;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"doTestSm2EncMessage", nullptr, NAPI_Global_doTestSm2EncMessage, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"doTestGetCipherTextSpec", nullptr, NAPI_Global_doTestGetCipherTextSpec, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"doTestGenCipherTextBySpec", nullptr, NAPI_Global_doTestGenCipherTextBySpec, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"doTestRsaEncDec", nullptr, NAPI_Global_doTestRsaEncDec, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"doTestRsaEncLongMessage", nullptr, NAPI_Global_doTestRsaEncLongMessage, nullptr, nullptr, nullptr,
         napi_default, nullptr },
    };
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
