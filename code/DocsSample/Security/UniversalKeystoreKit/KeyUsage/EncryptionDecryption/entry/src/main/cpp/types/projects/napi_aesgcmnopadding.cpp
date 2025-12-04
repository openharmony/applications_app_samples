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

// [Start encrypt_and_decrypt_AESGCMNoPadding_cpp]
#include "huks/native_huks_api.h"
#include "huks/native_huks_param.h"
#include "napi/native_api.h"
#include <cstring>
#include "CryptoArchitectureKit/crypto_architecture_kit.h"

static OH_Huks_Result InitParamSet(struct OH_Huks_ParamSet **paramSet, const struct OH_Huks_Param *params,
    uint32_t paramCount)
{
    OH_Huks_Result ret = OH_Huks_InitParamSet(paramSet);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    ret = OH_Huks_AddParams(*paramSet, params, paramCount);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        OH_Huks_FreeParamSet(paramSet);
        return ret;
    }
    ret = OH_Huks_BuildParamSet(paramSet);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        OH_Huks_FreeParamSet(paramSet);
        return ret;
    }
    return ret;
}

static OH_Crypto_ErrCode genRandomNumber(uint32_t randomLength, uint8_t *out)
{
    // 创建随机数生成器。
    OH_CryptoRand *rand = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoRand_Create(&rand);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    Crypto_DataBlob blob = {out, randomLength};
    // 生成指定长度的随机数。
    ret = OH_CryptoRand_GenerateRandom(rand, randomLength, &blob);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoRand_Destroy(rand);
        return ret;
    }
    OH_CryptoRand_Destroy(rand);
 
    return CRYPTO_SUCCESS;
}

static const uint32_t NONCE_SIZE = 12;
static const uint32_t AAD_SIZE = 16;
static const uint32_t AE_TAG_SIZE = 16;
static char AEAD[AE_TAG_SIZE] = {0};
static char AAD[AAD_SIZE] = "cdcdcdcdcdcdcdc"; // this is a test value, for real use it should be different every time
static uint8_t NONCE[NONCE_SIZE] = {0};
static OH_Crypto_ErrCode ret = genRandomNumber(NONCE_SIZE, NONCE);
static struct OH_Huks_Param g_genEncDecParams[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_AES},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_ENCRYPT | OH_HUKS_KEY_PURPOSE_DECRYPT},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_AES_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PADDING, .uint32Param = OH_HUKS_PADDING_NONE},
    {.tag = OH_HUKS_TAG_BLOCK_MODE, .uint32Param = OH_HUKS_MODE_GCM}};

static struct OH_Huks_Param g_encryptParams[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_AES},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_ENCRYPT},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_AES_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PADDING, .uint32Param = OH_HUKS_PADDING_NONE},
    {.tag = OH_HUKS_TAG_BLOCK_MODE, .uint32Param = OH_HUKS_MODE_GCM},
    {.tag = OH_HUKS_TAG_NONCE,
     .blob = {
         .size = NONCE_SIZE,
         .data = (uint8_t *)NONCE // this is a test value, for real use the iv should be different every time
     }},
    {.tag = OH_HUKS_TAG_ASSOCIATED_DATA,
     .blob = {
         .size = AAD_SIZE,
         .data = (uint8_t *)AAD // this is a test value, for real use the iv should be different every time
     }}};

static struct OH_Huks_Param g_decryptParams[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_AES},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_DECRYPT},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_AES_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PADDING, .uint32Param = OH_HUKS_PADDING_NONE},
    {.tag = OH_HUKS_TAG_BLOCK_MODE, .uint32Param = OH_HUKS_MODE_GCM},
    {.tag = OH_HUKS_TAG_NONCE,
     .blob = {
         .size = NONCE_SIZE,
         .data = (uint8_t *)NONCE // this is a test value, for real use the iv should be different every time
     }},
    {.tag = OH_HUKS_TAG_ASSOCIATED_DATA,
     .blob = {
         .size = AAD_SIZE,
         .data = (uint8_t *)AAD // this is a test value, for real use the iv should be different every time
     }},
    {.tag = OH_HUKS_TAG_AE_TAG,
     .blob = {
         .size = AE_TAG_SIZE,
         .data = (uint8_t *)AEAD // this is a test value, for real use the iv should be different every time
     }}};

static const uint32_t AES_GCM_SIZE = 1024;
OH_Huks_Result HksAesGcmTestEncrypt(const struct OH_Huks_Blob *keyAlias,
    const struct OH_Huks_ParamSet *encryptParamSet,
    const struct OH_Huks_Blob *inData, struct OH_Huks_Blob *cipherText)
{
    uint8_t handleE[sizeof(uint64_t)] = {0};
    struct OH_Huks_Blob handleEncrypt = {sizeof(uint64_t), handleE};
    OH_Huks_Result ret = OH_Huks_InitSession(keyAlias, encryptParamSet, &handleEncrypt, nullptr);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    ret = OH_Huks_FinishSession(&handleEncrypt, encryptParamSet, inData, cipherText);
    return ret;
}

OH_Huks_Result HksAesGcmTestDecrypt(const struct OH_Huks_Blob *keyAlias,
    const struct OH_Huks_ParamSet *decryptParamSet,
    const struct OH_Huks_Blob *cipherText, struct OH_Huks_Blob *plainText,
    const struct OH_Huks_Blob *inData)
{
    uint8_t handleD[sizeof(uint64_t)] = {0};
    struct OH_Huks_Blob handleDecrypt = {sizeof(uint64_t), handleD};
    OH_Huks_Result ret = OH_Huks_InitSession(keyAlias, decryptParamSet, &handleDecrypt, nullptr);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    ret = OH_Huks_FinishSession(&handleDecrypt, decryptParamSet, cipherText, plainText);
    return ret;
}

napi_value TestAesGcm(napi_env env, napi_callback_info info)
{
    char tmpKeyAlias[] = "test_enc_dec";
    struct OH_Huks_Blob keyAlias = {(uint32_t)strlen(tmpKeyAlias), (uint8_t *)tmpKeyAlias};
    struct OH_Huks_ParamSet *genParamSet = nullptr;
    struct OH_Huks_ParamSet *encryptParamSet = nullptr;
    struct OH_Huks_ParamSet *decryptParamSet = nullptr;
    OH_Huks_Result ohResult;
    do {
        /* 1. 模拟生成密钥场景 */
        /*
         * 1.1. 获取生成密钥算法参数配置
         */
        ohResult = InitParamSet(&genParamSet, g_genEncDecParams, sizeof(g_genEncDecParams) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /*
         * 1.2. 调用generateKeyItem
         */
        ohResult = OH_Huks_GenerateKeyItem(&keyAlias, genParamSet, nullptr);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /* 2. 模拟加密场景 */
        /*
         * 2.1. 获取加密算法参数配置
         */
        ohResult = InitParamSet(&encryptParamSet, g_encryptParams, sizeof(g_encryptParams) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        char tmpInData[] = "AES_GCM_INDATA_1";
        struct OH_Huks_Blob inData = {(uint32_t)strlen(tmpInData), (uint8_t *)tmpInData};
        uint8_t cipher[AES_GCM_SIZE] = {0};
        struct OH_Huks_Blob cipherText = {AES_GCM_SIZE, cipher};
        /*
         * 2.2. 调用HksAesGcmTestEncrypt获取加密后的密文
         */
        ohResult = HksAesGcmTestEncrypt(&keyAlias, encryptParamSet, &inData, &cipherText);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /* 3. 模拟解密场景 */
        /*
         * 3.1. 获取解密算法参数配置
         */
        strncpy(AEAD, (char *)cipherText.data + strlen(tmpInData), AE_TAG_SIZE);
        cipherText.data[strlen(tmpInData)] = '\0';
        cipherText.size -= AE_TAG_SIZE;
        ohResult = InitParamSet(&decryptParamSet, g_decryptParams, sizeof(g_decryptParams) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /*
         * 3.2. 调用HksAesGcmTestDecrypt获取解密后的数据
         */
        uint8_t plainBuffer[AES_GCM_SIZE] = {0};
        struct OH_Huks_Blob plainText = {AES_GCM_SIZE, plainBuffer};
        ohResult = HksAesGcmTestDecrypt(&keyAlias, decryptParamSet, &cipherText, &plainText, &inData);
    } while (0);
    /* 4. 模拟删除密钥场景 */
    /*
     * 4.1. 调用deleteKeyItem删除密钥
     */
    (void)OH_Huks_DeleteKeyItem(&keyAlias, genParamSet);

    OH_Huks_FreeParamSet(&genParamSet);
    OH_Huks_FreeParamSet(&encryptParamSet);
    OH_Huks_FreeParamSet(&decryptParamSet);
    
    napi_value ret;
    napi_create_int32(env, ohResult.errorCode, &ret);
    return ret;
}
// [End encrypt_and_decrypt_AESGCMNoPadding_cpp]