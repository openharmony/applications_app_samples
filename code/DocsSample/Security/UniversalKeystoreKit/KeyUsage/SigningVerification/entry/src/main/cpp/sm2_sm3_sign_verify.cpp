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

// [Start key_algorithm_sm2_sm3_sign_verify_cpp]
#include "huks/native_huks_api.h"
#include "huks/native_huks_param.h"
#include "napi/native_api.h"
#include <cstring>

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

static struct OH_Huks_Param g_genSignVerifyParamsSM2[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_SM2},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_SM2_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_SIGN | OH_HUKS_KEY_PURPOSE_VERIFY},
    {.tag = OH_HUKS_TAG_DIGEST, .uint32Param = OH_HUKS_DIGEST_SM3},
};

static struct OH_Huks_Param g_signParamsSM2[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_SM2},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_SM2_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_SIGN},
    {.tag = OH_HUKS_TAG_DIGEST, .uint32Param = OH_HUKS_DIGEST_SM3}
};

static struct OH_Huks_Param g_verifyParamsSM2[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_SM2},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_SM2_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_VERIFY},
    {.tag = OH_HUKS_TAG_DIGEST, .uint32Param = OH_HUKS_DIGEST_SM3}
};

static const uint32_t SM2_COMMON_SIZE = 256;
static const char *DATA_TO_SIGN_SM2 = "Hks_SM2_Sign_Verify_Test_0000000000000000000000000000000000000000000000000000000"
                                      "00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                                      "0000000000000000000000000000000000000000000000000"
                                      "000000000000000000000000_string";

/* 1. 生成密钥 */
static OH_Huks_Result GenerateKeySM2(const struct OH_Huks_Blob *keyAlias,
                                     const struct OH_Huks_ParamSet *genParamSet)
{
    return OH_Huks_GenerateKeyItem(keyAlias, genParamSet, nullptr);
}

/* 2. 签名 */
static OH_Huks_Result SignDataSM2(const struct OH_Huks_Blob *keyAlias,
                                  const struct OH_Huks_ParamSet *signParamSet,
                                  const struct OH_Huks_Blob *inData,
                                  struct OH_Huks_Blob *outDataSign)
{
    uint8_t handleS[sizeof(uint64_t)] = {0};
    struct OH_Huks_Blob handleSign = {(uint32_t)sizeof(uint64_t), handleS};
    
    OH_Huks_Result ohResult = OH_Huks_InitSession(keyAlias, signParamSet, &handleSign, nullptr);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }

    ohResult = OH_Huks_UpdateSession(&handleSign, signParamSet, inData, outDataSign);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }

    struct OH_Huks_Blob finishInData = {0, NULL};
    ohResult = OH_Huks_FinishSession(&handleSign, signParamSet, &finishInData, outDataSign);
    
    return ohResult;
}

/* 3. 验签 */
static OH_Huks_Result VerifySignatureSM2(const struct OH_Huks_Blob *keyAlias,
                                         const struct OH_Huks_ParamSet *verifyParamSet,
                                         const struct OH_Huks_Blob *inData,
                                         const struct OH_Huks_Blob *signature)
{
    uint8_t handleV[sizeof(uint64_t)] = {0};
    struct OH_Huks_Blob handleVerify = {(uint32_t)sizeof(uint64_t), handleV};
    
    OH_Huks_Result ohResult = OH_Huks_InitSession(keyAlias, verifyParamSet, &handleVerify, nullptr);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }

    uint8_t temp[] = "out";
    struct OH_Huks_Blob verifyOut = {(uint32_t)sizeof(temp), temp};
    ohResult = OH_Huks_UpdateSession(&handleVerify, verifyParamSet, inData, &verifyOut);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    
    ohResult = OH_Huks_FinishSession(&handleVerify, verifyParamSet, signature, &verifyOut);
    
    return ohResult;
}

napi_value SignVerifyKeySM2SM3(napi_env env, napi_callback_info info)
{
    struct OH_Huks_Blob g_keyAlias = {(uint32_t)strlen("test_signVerify_SM2_SM3"),
        (uint8_t *)"test_signVerify_SM2_SM3"};
    struct OH_Huks_Blob inData = {(uint32_t)strlen(DATA_TO_SIGN_SM2), (uint8_t *)DATA_TO_SIGN_SM2};
    struct OH_Huks_ParamSet *genParamSet = nullptr;
    struct OH_Huks_ParamSet *signParamSet = nullptr;
    struct OH_Huks_ParamSet *verifyParamSet = nullptr;
    OH_Huks_Result ohResult;
    
    do {
        ohResult = InitParamSet(&genParamSet, g_genSignVerifyParamsSM2,
                                sizeof(g_genSignVerifyParamsSM2) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        
        ohResult = InitParamSet(&signParamSet, g_signParamsSM2,
                                sizeof(g_signParamsSM2) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        
        ohResult = InitParamSet(&verifyParamSet, g_verifyParamsSM2,
                                sizeof(g_verifyParamsSM2) / sizeof(OH_Huks_Param));
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }

        /* 1. 生成密钥 */
        ohResult = GenerateKeySM2(&g_keyAlias, genParamSet);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }

        /* 2. 签名 */
        uint8_t outDataS[SM2_COMMON_SIZE] = {0};
        struct OH_Huks_Blob outDataSign = {SM2_COMMON_SIZE, outDataS};
        ohResult = SignDataSM2(&g_keyAlias, signParamSet, &inData, &outDataSign);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }

        /* 3. 验签 */
        ohResult = VerifySignatureSM2(&g_keyAlias, verifyParamSet, &inData, &outDataSign);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
    } while (0);
    
    (void)OH_Huks_DeleteKeyItem(&g_keyAlias, genParamSet);
    OH_Huks_FreeParamSet(&genParamSet);
    OH_Huks_FreeParamSet(&signParamSet);
    OH_Huks_FreeParamSet(&verifyParamSet);

    napi_value ret;
    napi_create_int32(env, ohResult.errorCode, &ret);
    return ret;
}

// [End key_algorithm_sm2_sm3_sign_verify_cpp]