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

// [Start prikey_encoding]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include "file.h"

static OH_Crypto_ErrCode SetParams(OH_CryptoPrivKeyEncodingParams *params)
{
    Crypto_DataBlob password = {(uint8_t *)"1234567890", 10};
    Crypto_DataBlob cipher = {(uint8_t *)"AES-128-CBC", 11};
    OH_Crypto_ErrCode ret = OH_CryptoPrivKeyEncodingParams_SetParam(params,
        CRYPTO_PRIVATE_KEY_ENCODING_PASSWORD_STR, &password);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoPrivKeyEncodingParams_SetParam(params, CRYPTO_PRIVATE_KEY_ENCODING_SYMMETRIC_CIPHER_STR, &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    return CRYPTO_SUCCESS;
}

OH_Crypto_ErrCode doTestPriKeyPkcs1Encoded()
{
    OH_CryptoAsymKeyGenerator *keyGen = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("RSA2048", &keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = OH_CryptoAsymKeyGenerator_Generate(keyGen, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }

    OH_CryptoPrivKey *privKey = OH_CryptoKeyPair_GetPrivKey(keyPair);
    if (privKey == nullptr) {
        OH_CryptoKeyPair_Destroy(keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return CRYPTO_OPERTION_ERROR;
    }
    OH_CryptoPrivKeyEncodingParams *params = nullptr;
    ret = OH_CryptoPrivKeyEncodingParams_Create(&params);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoKeyPair_Destroy(keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }
    ret = SetParams(params);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoPrivKeyEncodingParams_Destroy(params);
        OH_CryptoKeyPair_Destroy(keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }

    Crypto_DataBlob pemData = {0};
    ret = OH_CryptoPrivKey_Encode(privKey, CRYPTO_PEM, "PKCS1", params, &pemData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoPrivKeyEncodingParams_Destroy(params);
        OH_CryptoKeyPair_Destroy(keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }
    OH_Crypto_FreeDataBlob(&pemData);
    OH_CryptoPrivKeyEncodingParams_Destroy(params);
    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeyGenerator_Destroy(keyGen);
    return ret;
}
// [End prikey_encoding]
