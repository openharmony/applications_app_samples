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

// [Start TestRsa]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <string>
#define SPLIT_SIZE 2

static OH_Crypto_ErrCode GetRsaKeyParams(OH_CryptoKeyPair *keyCtx, Crypto_DataBlob *pubKeyData, Crypto_DataBlob *dataN)
{
    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyCtx);
    if (pubKey == nullptr) {
        return CRYPTO_OPERTION_ERROR;
    }
    OH_Crypto_ErrCode ret = OH_CryptoPubKey_GetParam(pubKey, CRYPTO_RSA_E_DATABLOB, pubKeyData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    return OH_CryptoPubKey_GetParam(pubKey, CRYPTO_RSA_N_DATABLOB, dataN);
}

static void FreeRsaKeyParams(Crypto_DataBlob *pubKeyData, Crypto_DataBlob *dataN)
{
    OH_Crypto_FreeDataBlob(pubKeyData);
    OH_Crypto_FreeDataBlob(dataN);
}

size_t RsaConvertHex(uint8_t* dest, size_t count, const char* src)
{
    size_t i;
    int value;

    for (i = 0; i < count && sscanf(src + i * SPLIT_SIZE, "%2x", &value) == 1; i++) {
        dest[i] = value;
    }
    return i;
}

struct RsaParams {
    Crypto_DataBlob nData;
    Crypto_DataBlob eData;
    uint8_t n[1024];
    uint8_t e[20];
};

static void PrepareRsaParams(RsaParams *params)
{
    std::string nStr = "9260d0750ae117eee55c3f3deaba74917521a262ee76007cdf8a56755ad73a1598a1408410a01434c3f"
    "5bc54a88b57fa19fc4328daea0750a4c44e88cff3b2382621b80f670464433e4336e6d003e8cd65bff211da144b88291c2259a"
    "00a72b711c116ef7686e8fee34e4d933c868187bdc26f7be071493c86f7a5941c3510806ad67b0f94d88f5cf5c02a092821d86"
    "26e8932b65c5bd8c92049c210932b7afa7ac59c0e886ae5c1edb00d8ce2c57633db26bd6639bff73cee82be9275c402b4cf2a4"
    "388da8cf8c64eefe1c5a0f5ab8057c39fa5c0589c3e253f0960332300f94bea44877b588e1edbde97cf2360727a09b775262d"
    "7ee552b3319b9266f05a25";
    std::string eStr = "010001";
    
    size_t nLen = RsaConvertHex(params->n, nStr.size() / SPLIT_SIZE, nStr.c_str());
    size_t eLen = RsaConvertHex(params->e, eStr.size() / SPLIT_SIZE, eStr.c_str());
    
    params->nData = {.data = params->n, .len = nLen};
    params->eData = {.data = params->e, .len = eLen};
}

static OH_Crypto_ErrCode CreateRsaKeySpec(RsaParams *params, OH_CryptoAsymKeySpec **keySpec)
{
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeySpec_Create("RSA", CRYPTO_ASYM_KEY_PUBLIC_KEY_SPEC, keySpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_RSA_E_DATABLOB, &params->eData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    ret = OH_CryptoAsymKeySpec_SetParam(*keySpec, CRYPTO_RSA_N_DATABLOB, &params->nData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(*keySpec);
        return ret;
    }
    
    return CRYPTO_SUCCESS;
}

static OH_Crypto_ErrCode GenerateRsaKeyPair(OH_CryptoAsymKeySpec *keySpec,
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

static OH_Crypto_ErrCode ValidateRsaKeyPair(OH_CryptoKeyPair *keyPair)
{
    Crypto_DataBlob dataE = {.data = nullptr, .len = 0};
    Crypto_DataBlob dataN = {.data = nullptr, .len = 0};
    OH_Crypto_ErrCode ret = GetRsaKeyParams(keyPair, &dataE, &dataN);
    if (ret != CRYPTO_SUCCESS) {
        FreeRsaKeyParams(&dataE, &dataN);
        return ret;
    }
    FreeRsaKeyParams(&dataE, &dataN);
    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestRsaGenKeyPairBySpec()
{
    RsaParams params = {};
    PrepareRsaParams(&params);
    
    OH_CryptoAsymKeySpec *keySpec = nullptr;
    OH_Crypto_ErrCode ret = CreateRsaKeySpec(&params, &keySpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    
    OH_CryptoAsymKeyGeneratorWithSpec *generatorSpec = nullptr;
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = GenerateRsaKeyPair(keySpec, &generatorSpec, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeySpec_Destroy(keySpec);
        return ret;
    }
    
    ret = ValidateRsaKeyPair(keyPair);
    
    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeySpec_Destroy(keySpec);
    OH_CryptoAsymKeyGeneratorWithSpec_Destroy(generatorSpec);
    return ret;
}

// [End TestRsa]