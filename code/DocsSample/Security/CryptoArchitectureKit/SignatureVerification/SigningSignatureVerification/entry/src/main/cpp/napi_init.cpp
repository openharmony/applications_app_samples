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
#include "types/project/signing_signature_verification.h"
#include <hilog/log.h>

static napi_value TestRsaSignatureSeg(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_get_boolean(env, DoTestRsaSignatureSeg(), &ret);
    return ret;
}

static napi_value TestRsaSignature(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_get_boolean(env, DoTestRsaSignature(), &ret);
    return ret;
}

static napi_value TestRsaSignatureRecover(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_create_int32(env, DoTestRsaSignatureRecover(), &ret);
    return ret;
}

static napi_value TestRsaPssSignatureSeg(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_get_boolean(env, DoTestRsaPssSignatureSeg(), &ret);
    return ret;
}

static napi_value TestEcdsaSignature(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_get_boolean(env, DoTestEcdsaSignature(), &ret);
    return ret;
}

static napi_value TestSm2Signature(napi_env env, napi_callback_info info)
{
    napi_value ret;
    napi_get_boolean(env, DoTestSm2Signature(), &ret);
    return ret;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"signatureSeg", nullptr, TestRsaSignatureSeg, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"signature", nullptr, TestRsaSignature, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"signatureRecover", nullptr, TestRsaSignatureRecover, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"pssSignatureSeg", nullptr, TestRsaPssSignatureSeg, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"ecdsaSignature", nullptr, TestEcdsaSignature, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"sm2Signature", nullptr, TestSm2Signature, nullptr, nullptr, nullptr, napi_default, nullptr},
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
