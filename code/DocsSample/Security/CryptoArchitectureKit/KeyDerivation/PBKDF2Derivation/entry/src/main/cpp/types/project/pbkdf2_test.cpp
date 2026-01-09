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

// [Start pbkdf2_test_cpp]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstdio>
#include <cstring>
#include "file.h"

static OH_Crypto_ErrCode setParams(OH_CryptoKdfParams **params)
{
    // 设置密码。
    const char *password = "123456";
    Crypto_DataBlob passwordBlob = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(password)),
        .len = strlen(password)
    };
    OH_Crypto_ErrCode ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_KEY_DATABLOB, &passwordBlob);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 设置盐值。
    const char *salt = "saltstring";
    Crypto_DataBlob saltBlob = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(salt)),
        .len = strlen(salt)
    };
    ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_SALT_DATABLOB, &saltBlob);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 设置迭代次数。
    int iterations = 10000;
    Crypto_DataBlob iterationsBlob = {
        .data = reinterpret_cast<uint8_t *>(&iterations),
        .len = sizeof(int)
    };
    ret = OH_CryptoKdfParams_SetParam(*params, CRYPTO_KDF_ITER_COUNT_INT, &iterationsBlob);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
end:
    OH_CryptoKdfParams_Destroy(*params);
    *params = nullptr;
    return ret;
}

OH_Crypto_ErrCode doTestPbkdf2()
{
    // 创建PBKDF2参数对象。
    OH_CryptoKdfParams *params = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoKdfParams_Create("PBKDF2", &params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = setParams(&params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 创建密钥派生函数对象。
    OH_CryptoKdf *kdfCtx = nullptr;
    ret = OH_CryptoKdf_Create("PBKDF2|SHA256", &kdfCtx);
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
// [End pbkdf2_test_cpp]