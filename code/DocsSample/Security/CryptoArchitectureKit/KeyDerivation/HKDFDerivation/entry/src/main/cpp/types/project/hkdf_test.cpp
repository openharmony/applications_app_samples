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

// [Start hkdf_test_cpp]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstdio>
#include <cstring>
#include "file.h"

static OH_Crypto_ErrCode setParams(OH_CryptoKdfParams **params)
{
    const char *keyData = "012345678901234567890123456789";
    Crypto_DataBlob key = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(keyData)),
        .len = strlen(keyData)
    };
    OH_Crypto_ErrCode ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_KEY_DATABLOB, &key);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 设置盐值。
    const char *saltData = "saltstring";
    Crypto_DataBlob salt = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(saltData)),
        .len = strlen(saltData)
    };
    ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_SALT_DATABLOB, &salt);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 设置应用程序特定信息（可选）。
    const char *infoData = "infostring";
    Crypto_DataBlob info = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(infoData)),
        .len = strlen(infoData)
    };
    ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_INFO_DATABLOB, &info);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
end:
    OH_CryptoKdfParams_Destroy(*params);
    *params = nullptr;
    return ret;
}

OH_Crypto_ErrCode doTestHkdf()
{
    // 创建HKDF参数对象。
    OH_CryptoKdfParams *params = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoKdfParams_Create("HKDF", &params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = setParams(&params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 创建密钥派生函数对象。
    OH_CryptoKdf *kdfCtx = nullptr;
    ret = OH_CryptoKdf_Create("HKDF|SHA256|EXTRACT_AND_EXPAND", &kdfCtx);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoKdfParams_Destroy(params);
        return ret;
    }

    // 派生密钥。
    Crypto_DataBlob out = {0};
    uint32_t keyLength = 32; // 生成32字节的密钥。
    ret = OH_CryptoKdf_Derive(kdfCtx, params, keyLength, &out);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoKdf_Destroy(kdfCtx);
        OH_CryptoKdfParams_Destroy(params);
        return ret;
    }

    printf("Derived key length: %u\n", out.len);

    // 清理资源。
    OH_Crypto_FreeDataBlob(&out);
    OH_CryptoKdf_Destroy(kdfCtx);
    OH_CryptoKdfParams_Destroy(params);
    return CRYPTO_SUCCESS;
}
// [End hkdf_test_cpp]