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

// [Start message_auth_cmac_segmentation]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstdio>
#include <cstring>

static OH_CryptoSymKey *GenerateAesKey(const char *algoName)
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

static OH_Crypto_ErrCode CreateCmacContext(OH_CryptoSymKey *keyCtx, OH_CryptoMac **ctx)
{
    OH_Crypto_ErrCode ret = OH_CryptoMac_Create("CMAC", ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 设置分组密码算法名称为AES128。
    const char *cipherName = "AES128";
    Crypto_DataBlob cipherNameData = {
        .data = reinterpret_cast<uint8_t *>(const_cast<char *>(cipherName)),
        .len = strlen(cipherName)
    };
    ret = OH_CryptoMac_SetParam(*ctx, CRYPTO_MAC_CIPHER_NAME_STR, &cipherNameData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoMac_Destroy(*ctx);
        return ret;
    }

    // 初始化CMAC计算。
    ret = OH_CryptoMac_Init(*ctx, keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoMac_Destroy(*ctx);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode ProcessCmacSegments(OH_CryptoMac *ctx)
{
    // 分段传入数据。
    const char *message = "aaaaa.....bbbbb.....ccccc.....ddddd.....eee";
    size_t messageLen = strlen(message);
    size_t segmentSize = 20; // 每段20字节。

    for (size_t i = 0; i < messageLen; i += segmentSize) {
        size_t currentSize = (i + segmentSize <= messageLen) ? segmentSize : (messageLen - i);
        Crypto_DataBlob segment = {
            .data = reinterpret_cast<uint8_t *>(const_cast<char *>(message + i)),
            .len = currentSize
        };
        OH_Crypto_ErrCode ret = OH_CryptoMac_Update(ctx, &segment);
        if (ret != CRYPTO_SUCCESS) {
            return ret;
        }
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode FinalizeCmac(OH_CryptoMac *ctx, Crypto_DataBlob *out, uint32_t *macLen)
{
    // 完成CMAC计算并获取结果。
    OH_Crypto_ErrCode ret = OH_CryptoMac_Final(ctx, out);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 获取CMAC值的长度。
    ret = OH_CryptoMac_GetLength(ctx, macLen);
    if (ret != CRYPTO_SUCCESS) {
        OH_Crypto_FreeDataBlob(out);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestCmacBySegments()
{
    OH_CryptoSymKey *keyCtx = nullptr;
    OH_CryptoMac *ctx = nullptr;
    Crypto_DataBlob out = {0};
    OH_Crypto_ErrCode ret = CRYPTO_SUCCESS;
    uint32_t macLen = 0;

    // 生成AES128密钥。
    keyCtx = GenerateAesKey("AES128");
    if (keyCtx == nullptr) {
        ret = CRYPTO_OPERTION_ERROR;
        goto cleanup;
    }

    // 创建CMAC上下文。
    ret = CreateCmacContext(keyCtx, &ctx);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    // 分段处理数据。
    ret = ProcessCmacSegments(ctx);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    // 完成CMAC计算。
    ret = FinalizeCmac(ctx, &out, &macLen);
    if (ret != CRYPTO_SUCCESS) {
        goto cleanup;
    }

    printf("CMAC calculation success, length: %u\n", macLen);

cleanup:
    // 清理资源。
    OH_Crypto_FreeDataBlob(&out);
    OH_CryptoMac_Destroy(ctx);
    OH_CryptoSymKey_Destroy(keyCtx);
    return ret;
}

// [End message_auth_cmac_segmentation]