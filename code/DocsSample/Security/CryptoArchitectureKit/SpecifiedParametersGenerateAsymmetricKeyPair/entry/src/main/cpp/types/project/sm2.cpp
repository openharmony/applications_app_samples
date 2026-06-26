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

// [Start TestSm2]

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

size_t Sm2ConvertHex(uint8_t* dest, size_t count, const char* src)
{
    size_t i;
    int value;

    for (i = 0; i < count && sscanf(src + i * SPLIT_SIZE, "%2x", &value) == 1; i++) {
        dest[i] = value;
    }
    return i;
}

struct Sm2Params {
    Crypto_DataBlob pkXData;
    Crypto_DataBlob pkYData;
    Crypto_DataBlob skData;
    uint8_t pkX[256];
    uint8_t pkY[256];
    uint8_t sk[256];
};

static void PrepareSm2Params(Sm2Params *params)
{
    std::string pkXStr = "67F3B850BDC0BA5D3A29D8A0883C4B17612AB84F87F18E28F77D824A115C02C4";
    std::string pkYStr = "D48966CE754BBBEDD6501A1385E1B205C186E926ADED44287145E8897D4B2071";
    std::string skStr = "6330B599ECD23ABDC74B9A5B7B5E00E553005F72743101C5FAB83AEB579B7074";
    
    size_t pkXLen = Sm2ConvertHex(params->pkX, pkXStr.size() / SPLIT_SIZE, pkXStr.c_str());
    size_t pkYLen = Sm2ConvertHex(params->pkY, pkYStr.size() / SPLIT_SIZE, pkYStr.c_str());
    size_t skLen = Sm2ConvertHex(params->sk, skStr.size() / SPLIT_SIZE, skStr.c_str());
    
    params->pkXData = {.data = params->pkX, .len = pkXLen};
    params->pkYData = {.data = params->pkY, .len = pkYLen};
    params->skData = {.data = params->sk, .len = skLen};
}

static OH_Crypto_ErrCode CreateSm2KeySpec(Sm2Params *params, OH_CryptoAsymKeySpec **keySpec,
    OH_CryptoAsymKeySpec **sm2CommonSpec)
{
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeySpec_Create("SM2", CRYPTO_ASYM_KEY_KEY_PAIR_SPEC, keySpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_GenEcCommonParamsSpec("NID_sm2", sm2CommonSpec);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetCommonParamsSpec(*keySpec, *sm2CommonSpec);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*sm2CommonSpec);
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_PK_X_DATABLOB, &params->pkXData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*sm2CommonSpec);
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_PK_Y_DATABLOB, &params->pkYData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*sm2CommonSpec);
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_ECC_SK_DATABLOB, &params->skData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*sm2CommonSpec);
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode GenerateSm2KeyPair(OH_CryptoAsymKeySpec *keySpec,
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

static OH_Crypto_ErrCode ValidateSm2KeyPair(OH_CryptoKeyPair *keyPair)
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
    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestSm2GenKeyPairBySpec()
{
    Sm2Params params = {};
    PrepareSm2Params(&params);
    
    OH_CryptoAsymKeySpec *keySpec = nullptr;
    OH_CryptoAsymKeySpec *sm2CommonSpec = nullptr;
    OH_Crypto_ErrCode ret = CreateSm2KeySpec(&params, &keySpec, &sm2CommonSpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    
    OH_CryptoAsymKeyGeneratorWithSpec *generatorSpec = nullptr;
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = GenerateSm2KeyPair(keySpec, &generatorSpec, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(sm2CommonSpec);
        OH_CryptoAsymKeySpec_Destroy(keySpec);
        return ret;
    }
    
    ret = ValidateSm2KeyPair(keyPair);
    
    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeyGeneratorWithSpec_Destroy(generatorSpec);
    OH_CryptoAsymKeySpec_Destroy(sm2CommonSpec);
    OH_CryptoAsymKeySpec_Destroy(keySpec);
    return ret;
}

// [End TestSm2]