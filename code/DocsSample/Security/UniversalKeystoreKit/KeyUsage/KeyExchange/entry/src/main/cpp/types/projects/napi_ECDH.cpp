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
// [Start key_agreement_ECDH_cpp]
#include "huks/native_huks_api.h"
#include "huks/native_huks_param.h"
#include "napi/native_api.h"
#include <cstring>
#include "file.h"

/* 初始化参数 */
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
static const uint32_t IV_SIZE = 16;
static uint8_t IV[IV_SIZE] = {0}; // this is a test value, for real use the iv should be different every time
static struct OH_Huks_Blob g_keyAliasFinal1001 = {(uint32_t)strlen("HksECDHAgreeKeyAliasTest001_1_final"),
                                                  (uint8_t *)"HksECDHAgreeKeyAliasTest001_1_final"};
/* 集成密钥参数集 */
static struct OH_Huks_Param g_genAgreeParams[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_ECC},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_AGREE},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_ECC_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_DIGEST, .uint32Param = OH_HUKS_DIGEST_NONE}};
static struct OH_Huks_Param g_agreeParamsInit01[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_ECDH},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_AGREE},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_ECC_KEY_SIZE_256}};
static struct OH_Huks_Param g_agreeParamsFinish01[] = {
    {.tag = OH_HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG, .uint32Param = OH_HUKS_STORAGE_ONLY_USED_IN_HUKS},
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_AES},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_AES_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_AGREE},
    {.tag = OH_HUKS_TAG_KEY_ALIAS, .blob = g_keyAliasFinal1001},
    {.tag = OH_HUKS_TAG_PADDING, .uint32Param = OH_HUKS_PADDING_NONE},
    {.tag = OH_HUKS_TAG_BLOCK_MODE, .uint32Param = OH_HUKS_MODE_CBC}};
static struct OH_Huks_Blob g_keyAliasFinal2001 = {(uint32_t)strlen("HksECDHAgreeKeyAliasTest001_2_final"),
                                                  (uint8_t *)"HksECDHAgreeKeyAliasTest001_2_final"};
static struct OH_Huks_Param g_agreeParamsInit02[] = {
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_ECDH},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_AGREE},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_ECC_KEY_SIZE_256}};
static struct OH_Huks_Param g_agreeParamsFinish02[] = {
    {.tag = OH_HUKS_TAG_DERIVED_AGREED_KEY_STORAGE_FLAG, .uint32Param = OH_HUKS_STORAGE_ONLY_USED_IN_HUKS},
    {.tag = OH_HUKS_TAG_ALGORITHM, .uint32Param = OH_HUKS_ALG_AES},
    {.tag = OH_HUKS_TAG_KEY_SIZE, .uint32Param = OH_HUKS_AES_KEY_SIZE_256},
    {.tag = OH_HUKS_TAG_PURPOSE, .uint32Param = OH_HUKS_KEY_PURPOSE_AGREE},
    {.tag = OH_HUKS_TAG_KEY_ALIAS, .blob = g_keyAliasFinal2001},
    {.tag = OH_HUKS_TAG_PADDING, .uint32Param = OH_HUKS_PADDING_NONE},
    {.tag = OH_HUKS_TAG_BLOCK_MODE, .uint32Param = OH_HUKS_MODE_CBC}};
static const uint32_t ECDH_COMMON_SIZE = 1024;
static struct OH_Huks_Blob g_keyAlias01001 = {(uint32_t)strlen("HksECDHAgreeKeyAliasTest001_1"),
                                              (uint8_t *)"HksECDHAgreeKeyAliasTest001_1"};
static struct OH_Huks_Blob g_keyAlias02001 = {(uint32_t)strlen("HksECDHAgreeKeyAliasTest001_2"),
                                              (uint8_t *)"HksECDHAgreeKeyAliasTest001_2"};

static OH_Huks_Result MallocAndCheckBlobData(struct OH_Huks_Blob *blob, const uint32_t blobSize)
{
    struct OH_Huks_Result ret;
    ret.errorCode = OH_HUKS_SUCCESS;
    if (blobSize == 0 || blobSize > ECDH_COMMON_SIZE) {
        ret.errorCode = OH_HUKS_ERR_CODE_INTERNAL_ERROR;
        return ret;
    }
    blob->data = (uint8_t *)malloc(blobSize);
    if (blob->data == NULL) {
        ret.errorCode = OH_HUKS_ERR_CODE_INTERNAL_ERROR;
    }
    return ret;
}
/* 导出密钥 */
OH_Huks_Result HksEcdhAgreeExport(const struct OH_Huks_Blob *keyAlias1, const struct OH_Huks_Blob *keyAlias2,
                                  struct OH_Huks_Blob *publicKey1, struct OH_Huks_Blob *publicKey2,
                                  const struct OH_Huks_ParamSet *genParamSet)
{
    OH_Huks_Result ret = OH_Huks_ExportPublicKeyItem(keyAlias1, genParamSet, publicKey1);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    ret = OH_Huks_ExportPublicKeyItem(keyAlias2, genParamSet, publicKey2);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    return ret;
}
static const char *IN_DATA = "Hks_ECDH_Agree_Test_000000000000000000000000000000000000000000000000000000000000"
                              "00000000000000000000000000000000000000000000000000000000000000000000000000000000"
                              "0000000000000000000000000000000000000000000000000000000000000000000000000_string";
/* 协商密钥操作 */
OH_Huks_Result HksEcdhAgreeFinish(const struct OH_Huks_Blob *keyAlias, const struct OH_Huks_Blob *publicKey,
                                  const struct OH_Huks_ParamSet *initParamSet,
                                  const struct OH_Huks_ParamSet *finishParamSet, struct OH_Huks_Blob *outData)
{
    struct OH_Huks_Blob inData = {(uint32_t)strlen(IN_DATA), (uint8_t *)IN_DATA};
    uint8_t handleU[sizeof(uint64_t)] = {0};
    struct OH_Huks_Blob handle = {sizeof(uint64_t), handleU};
    OH_Huks_Result ret = OH_Huks_InitSession(keyAlias, initParamSet, &handle, nullptr);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    uint8_t outDataU[ECDH_COMMON_SIZE] = {0};
    struct OH_Huks_Blob outDataUpdate = {ECDH_COMMON_SIZE, outDataU};
    ret = OH_Huks_UpdateSession(&handle, initParamSet, publicKey, &outDataUpdate);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    ret = OH_Huks_FinishSession(&handle, finishParamSet, &inData, outData);
    if (ret.errorCode != OH_HUKS_SUCCESS) {
        return ret;
    }
    return ret;
}


static OH_Huks_Result InitializeAgreeParamSets(struct OH_Huks_ParamSet **genParamSet,
    struct OH_Huks_ParamSet **initParamSet01,
    struct OH_Huks_ParamSet **finishParamSet01,
    struct OH_Huks_ParamSet **initParamSet02,
    struct OH_Huks_ParamSet **finishParamSet02)
{
    OH_Huks_Result ohResult;
    
    ohResult = InitParamSet(genParamSet, g_genAgreeParams,
                            sizeof(g_genAgreeParams) / sizeof(OH_Huks_Param));
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    ohResult = InitParamSet(initParamSet01, g_agreeParamsInit01,
                            sizeof(g_agreeParamsInit01) / sizeof(OH_Huks_Param));
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    ohResult = InitParamSet(finishParamSet01, g_agreeParamsFinish01,
                            sizeof(g_agreeParamsFinish01) / sizeof(OH_Huks_Param));
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    ohResult = InitParamSet(initParamSet02, g_agreeParamsInit02,
                            sizeof(g_agreeParamsInit02) / sizeof(OH_Huks_Param));
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    ohResult = InitParamSet(finishParamSet02, g_agreeParamsFinish02,
                            sizeof(g_agreeParamsFinish02) / sizeof(OH_Huks_Param));
    return ohResult;
}

static OH_Huks_Result GenerateKeyPair(struct OH_Huks_ParamSet *genParamSet)
{
    OH_Huks_Result ohResult;
    
    /* 设备A生成密钥 */
    ohResult = OH_Huks_GenerateKeyItem(&g_keyAlias01001, genParamSet, nullptr);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    
    /* 设备B生成密钥 */
    ohResult = OH_Huks_GenerateKeyItem(&g_keyAlias02001, genParamSet, nullptr);
    return ohResult;
}

static OH_Huks_Result KeyAgreement(struct OH_Huks_Blob *g_keyAlias,
    struct OH_Huks_Blob *publicKey,
    struct OH_Huks_Blob *outData,
    struct OH_Huks_ParamSet *initParamSet,
    struct OH_Huks_ParamSet *finishParamSet)
{
    OH_Huks_Result ohResult;
    
    ohResult = MallocAndCheckBlobData(outData, outData->size);
    if (ohResult.errorCode != OH_HUKS_SUCCESS) {
        return ohResult;
    }
    /* 协商密钥 */
    ohResult = HksEcdhAgreeFinish(g_keyAlias, publicKey, initParamSet, finishParamSet, outData);
    return ohResult;
}

static void CleanKey(struct OH_Huks_Blob *genKeyAlias,
    struct OH_Huks_Blob *genKeyAliasFinal,
    struct OH_Huks_ParamSet *genParamSet,
    struct OH_Huks_ParamSet **initParamSet,
    struct OH_Huks_ParamSet **finishParamSet)
{
    OH_Huks_DeleteKeyItem(genKeyAlias, genParamSet);
    OH_Huks_DeleteKeyItem(genKeyAliasFinal, NULL);
    OH_Huks_FreeParamSet(initParamSet);
    OH_Huks_FreeParamSet(finishParamSet);
}

/* 协商密钥整体流程 */
napi_value EcdhAgreeKey(napi_env env, napi_callback_info info)
{
    struct OH_Huks_ParamSet *genParamSet = nullptr;
    struct OH_Huks_ParamSet *initParamSet01 = nullptr;
    struct OH_Huks_ParamSet *finishParamSet01 = nullptr;
    struct OH_Huks_ParamSet *initParamSet02 = nullptr;
    struct OH_Huks_ParamSet *finishParamSet02 = nullptr;
    struct OH_Huks_Blob publicKey01 = {.size = OH_HUKS_ECC_KEY_SIZE_256, .data = nullptr};
    struct OH_Huks_Blob publicKey02 = {.size = OH_HUKS_ECC_KEY_SIZE_256, .data = nullptr};
    struct OH_Huks_Blob outData01 = {.size = ECDH_COMMON_SIZE, .data = nullptr};
    struct OH_Huks_Blob outData02 = {.size = ECDH_COMMON_SIZE, .data = nullptr};
    OH_Huks_Result ohResult;
    do {
        /* 1.确定密钥别名集成密钥参数集 */
        ohResult = InitializeAgreeParamSets(&genParamSet, &initParamSet01, &finishParamSet01,
                                            &initParamSet02, &finishParamSet02);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /* 2.设备A和设备B生成密钥 */
        ohResult = GenerateKeyPair(genParamSet);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        ohResult = MallocAndCheckBlobData(&publicKey01, publicKey01.size);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        ohResult = MallocAndCheckBlobData(&publicKey02, publicKey02.size);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /* 3.设备A、B导出公钥 */
        ohResult = HksEcdhAgreeExport(&g_keyAlias01001, &g_keyAlias02001, &publicKey01, &publicKey02, genParamSet);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        /* 4.设备A、B执行密钥协商 */
        ohResult = KeyAgreement(&g_keyAlias01001, &publicKey02, &outData01, initParamSet01, finishParamSet01);
        if (ohResult.errorCode != OH_HUKS_SUCCESS) {
            break;
        }
        ohResult = KeyAgreement(&g_keyAlias02001, &publicKey01, &outData02, initParamSet02, finishParamSet02);
    } while (0);
    free(publicKey01.data);
    free(publicKey02.data);
    free(outData01.data);
    free(outData02.data);
    /* 5.设备A、B删除密钥 */
    CleanKey(&g_keyAlias01001, &g_keyAliasFinal1001, genParamSet, &initParamSet01, &finishParamSet01);
    CleanKey(&g_keyAlias02001, &g_keyAliasFinal2001, genParamSet, &initParamSet02, &finishParamSet02);
    OH_Huks_FreeParamSet(&genParamSet);

    napi_value ret;
    napi_create_int32(env, ohResult.errorCode, &ret);
    return ret;
}
// [End key_agreement_ECDH_cpp]