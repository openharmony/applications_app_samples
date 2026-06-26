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

// [Start TestEcc]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <string>

#define SPLIT_SIZE 2

static OH_Crypto_ErrCode GetEccKeyParams(OH_CryptoKeyPair *keyCtx, Crypto_DataBlob *pubKeyXData,
    Crypto_DataBlob *pubKeyYData, Crypto_DataBlob *privKeyData)
{
    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyCtx);
    if (pubKey == nullptr) {
        return CRYPTO_OPERTION_ERROR;
    }
    OH_Crypto_ErrCode ret = OH_CryptoPubKey_GetParam(pubKey, CRYPTO_ECC_PK_X_DATABLOB, pubKeyXData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPubKey_GetParam(pubKey, CRYPTO_ECC_PK_Y_DATABLOB, pubKeyYData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    OH_CryptoPrivKey *privKey = OH_CryptoKeyPair_GetPrivKey(keyCtx);
    if (privKey == nullptr) {
        return CRYPTO_OPERTION_ERROR;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_SK_DATABLOB, privKeyData);
    return ret;
}

static void FreeEccKeyParams(Crypto_DataBlob *pubKeyXData, Crypto_DataBlob *pubKeyYData, Crypto_DataBlob *privKeyData)
{
    OH_Crypto_FreeDataBlob(pubKeyXData);
    OH_Crypto_FreeDataBlob(pubKeyYData);
    OH_Crypto_FreeDataBlob(privKeyData);
}

struct EccCommonParams {
    Crypto_DataBlob pData;
    Crypto_DataBlob aData;
    Crypto_DataBlob bData;
    Crypto_DataBlob gxData;
    Crypto_DataBlob gyData;
    Crypto_DataBlob nData;
    Crypto_DataBlob hData;
};

static OH_Crypto_ErrCode GetEccCommonParams(OH_CryptoKeyPair *keyCtx, EccCommonParams *params)
{
    OH_CryptoPrivKey *privKey = OH_CryptoKeyPair_GetPrivKey(keyCtx);
    if (privKey == nullptr) {
        return CRYPTO_OPERTION_ERROR;
    }
    OH_Crypto_ErrCode ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_FP_P_DATABLOB, &params->pData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_A_DATABLOB, &params->aData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_B_DATABLOB, &params->bData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_G_X_DATABLOB, &params->gxData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_G_Y_DATABLOB, &params->gyData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_N_DATABLOB, &params->nData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKey_GetParam(privKey, CRYPTO_ECC_H_INT, &params->hData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    return ret;
}

static void FreeEccCommonParams(EccCommonParams *params)
{
    OH_Crypto_FreeDataBlob(&params->pData);
    OH_Crypto_FreeDataBlob(&params->aData);
    OH_Crypto_FreeDataBlob(&params->bData);
    OH_Crypto_FreeDataBlob(&params->gxData);
    OH_Crypto_FreeDataBlob(&params->gyData);
    OH_Crypto_FreeDataBlob(&params->nData);
    OH_Crypto_FreeDataBlob(&params->hData);
}

size_t ConvertHex(uint8_t* dest, size_t count, const char* src)
{
    size_t i;
    int value;

    for (i = 0; i < count && sscanf(src + i * SPLIT_SIZE, "%2x", &value) == 1; i++) {
        dest[i] = value;
    }
    return i;
}

struct EccParams {
    Crypto_DataBlob pData;
    Crypto_DataBlob aData;
    Crypto_DataBlob bData;
    Crypto_DataBlob gxData;
    Crypto_DataBlob gyData;
    Crypto_DataBlob nData;
    Crypto_DataBlob hData;
    uint8_t p[256];
    uint8_t gx[256];
    uint8_t gy[256];
    uint8_t a[256];
    uint8_t b[256];
    uint8_t n[256];
    uint8_t h[4];
};

static void PrepareEccParams(EccParams *params)
{
    std::string pStr = "ffffffffffffffffffffffffffffffff000000000000000000000001";
    std::string gxStr = "b70e0cbd6bb4bf7f321390b94a03c1d356c21122343280d6115c1d21";
    std::string gyStr = "bd376388b5f723fb4c22dfe6cd4375a05a07476444d5819985007e34";
    std::string aStr = "fffffffffffffffffffffffffffffffefffffffffffffffffffffffe";
    std::string bStr = "b4050a850c04b3abf54132565044b0b7d7bfd8ba270b39432355ffb4";
    std::string nStr = "ffffffffffffffffffffffffffff16a2e0b8f03e13dd29455c5c2a3d";
    uint8_t h[] = {0x00, 0x00, 0x00, 0x01}; // 大端序

    size_t pLen = ConvertHex(params->p, pStr.size() / SPLIT_SIZE, pStr.c_str());
    size_t gxLen = ConvertHex(params->gx, gxStr.size() / SPLIT_SIZE, gxStr.c_str());
    size_t gyLen = ConvertHex(params->gy, gyStr.size() / SPLIT_SIZE, gyStr.c_str());
    size_t aLen = ConvertHex(params->a, aStr.size() / SPLIT_SIZE, aStr.c_str());
    size_t bLen = ConvertHex(params->b, bStr.size() / SPLIT_SIZE, bStr.c_str());
    size_t nLen = ConvertHex(params->n, nStr.size() / SPLIT_SIZE, nStr.c_str());

    params->pData = {.data = params->p, .len = pLen};
    params->aData = {.data = params->a, .len = aLen};
    params->bData = {.data = params->b, .len = bLen};
    params->gxData = {.data = params->gx, .len = gxLen};
    params->gyData = {.data = params->gy, .len = gyLen};
    params->nData = {.data = params->n, .len = nLen};
    params->hData = {.data = h, .len = sizeof(h)};
}

static OH_Crypto_ErrCode CreateEccKeySpec(EccParams *params, OH_CryptoAsymKeySpec **keySpec)
{
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeySpec_Create("ECC", CRYPTO_ASYM_KEY_COMMON_PARAMS_SPEC, keySpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_FP_P_DATABLOB, &params->pData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_A_DATABLOB, &params->aData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_B_DATABLOB, &params->bData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_G_X_DATABLOB, &params->gxData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_G_Y_DATABLOB, &params->gyData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_N_DATABLOB, &params->nData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_H_INT, &params->hData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode GenerateEccKeyPair(OH_CryptoAsymKeySpec *keySpec,
    OH_CryptoAsymKeyGeneratorWithSpec **generatorSpec, OH_CryptoKeyPair **keyPair)
{
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGeneratorWithSpec_Create(keySpec, generatorSpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = OH_CryptoAsymKeyGeneratorWithSpec_GenKeyPair(*generatorSpec, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGeneratorWithSpec_Destroy(*generatorSpec);
        return ret;
    }

    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode ValidateEccKeyPair(OH_CryptoKeyPair *keyPair)
{
    Crypto_DataBlob dataPkX = {.data = nullptr, .len = 0};
    Crypto_DataBlob dataPkY = {.data = nullptr, .len = 0};
    Crypto_DataBlob dataSk = {.data = nullptr, .len = 0};
    OH_Crypto_ErrCode ret = GetEccKeyParams(keyPair, &dataPkX, &dataPkY, &dataSk);
    if (ret != CRYPTO_SUCCESS) {
        FreeEccKeyParams(&dataPkX, &dataPkY, &dataSk);
        return ret;
    }
    FreeEccKeyParams(&dataPkX, &dataPkY, &dataSk);

    EccCommonParams commonParams = {};
    ret = GetEccCommonParams(keyPair, &commonParams);
    if (ret != CRYPTO_SUCCESS) {
        FreeEccCommonParams(&commonParams);
        return ret;
    }
    FreeEccCommonParams(&commonParams);

    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestEccGenKeyPairBySpec()
{
    EccParams params = {};
    PrepareEccParams(&params);

    OH_CryptoAsymKeySpec *keySpec = nullptr;
    OH_Crypto_ErrCode ret = CreateEccKeySpec(&params, &keySpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    OH_CryptoAsymKeyGeneratorWithSpec *generatorSpec = nullptr;
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = GenerateEccKeyPair(keySpec, &generatorSpec, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(keySpec);
        return ret;
    }

    ret = ValidateEccKeyPair(keyPair);

    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeySpec_Destroy(keySpec);
    OH_CryptoAsymKeyGeneratorWithSpec_Destroy(generatorSpec);
    return ret;
}

// [End TestEcc]