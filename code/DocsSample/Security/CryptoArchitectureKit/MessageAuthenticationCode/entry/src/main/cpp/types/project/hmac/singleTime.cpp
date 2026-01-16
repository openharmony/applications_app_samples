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

// [Start message_auth_hmac_single_time]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstdio>
#include <cstring>

static OH_CryptoSymKey *GenerateHmacKey(const char *algoName)
{
    OH_CryptoSymKeyGenerator *keyGen = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSymKeyGenerator_Create(algoName, &keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return nullptr;
    }
    OH_CryptoSymKey *keyCtx = nullptr;
    ret = OH_CryptoSymKeyGenerator_Generate(keyGen, &keyCtx);
    OH_CryptoSymKeyGenerator_Destroy(keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return nullptr;
    }
    return keyCtx;
}

static OH_Crypto_ErrCode CreateHmacContext(OH_CryptoSymKey *keyCtx, OH_CryptoMac **ctx)
{
    OH_Crypto_ErrCode ret = OH_CryptoMac_Create("HMAC", ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 设置摘要算法名称为SM3。
    const char *digestName = "SM3";
    Crypto_DataBlob digestNameData = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(digestName)),
        .len = strlen(digestName)
    };
    ret = OH_CryptoMac_SetParam(*ctx, CRYPTO_MAC_DIGEST_NAME_STR, &digestNameData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoMac_Destroy(*ctx);
        return ret;
    }

    // 初始化HMAC计算。
    ret = OH_CryptoMac_Init(*ctx, keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoMac_Destroy(*ctx);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode UpdateHmacData(OH_CryptoMac *ctx)
{
    // 一次性传入所有数据。
    const char *message = "hmacTestMessage";
    Crypto_DataBlob input = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(message)),
        .len = strlen(message)
    };
    OH_Crypto_ErrCode ret = OH_CryptoMac_Update(ctx, &input);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode FinalizeHmac(OH_CryptoMac *ctx, Crypto_DataBlob *out, uint32_t *macLen)
{
    // 完成HMAC计算并获取结果。
    OH_Crypto_ErrCode ret = OH_CryptoMac_Final(ctx, out);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 获取HMAC值的长度。
    ret = OH_CryptoMac_GetLength(ctx, macLen);
    if (ret != CRYPTO_SUCCESS) {
        OH_Crypto_FreeDataBlob(out);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestHmacOnce()
{
    OH_CryptoSymKey *keyCtx = nullptr;
    OH_CryptoMac *ctx = nullptr;
    Crypto_DataBlob out = {0};
    OH_Crypto_ErrCode ret = CRYPTO_SUCCESS;
    uint32_t macLen = 0;

    // 生成HMAC密钥，使用SM3作为摘要算法。
    keyCtx = GenerateHmacKey("HMAC|SM3");
    if (keyCtx == nullptr) {
        ret = CRYPTO_OPERTION_ERROR;
        goto cleanup;
    }

    // 创建HMAC上下文。
    ret = CreateHmacContext(keyCtx, &ctx);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    // 一次性传入所有数据。
    ret = UpdateHmacData(ctx);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    // 完成HMAC计算。
    ret = FinalizeHmac(ctx, &out, &macLen);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    printf("HMAC calculation success, length: %u\n", macLen);

cleanup:
    // 清理资源。
    OH_Crypto_FreeDataBlob(&out);
    OH_CryptoMac_Destroy(ctx);
    OH_CryptoSymKey_Destroy(keyCtx);
    return ret;
}

// [End message_auth_hmac_single_time]