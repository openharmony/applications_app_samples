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

// [Start rsa_pkcs1_encrypt_decrypt]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstring>

static OH_Crypto_ErrCode doRsaEncrypt(const Crypto_DataBlob *plainData, OH_CryptoKeyPair **keyPair,
    OH_CryptoAsymKeyGenerator **keyGen, Crypto_DataBlob *encryptedData)
{
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("RSA1024", keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = OH_CryptoAsymKeyGenerator_Generate(*keyGen, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(*keyGen);
        return ret;
    }

    OH_CryptoAsymCipher *cipher = nullptr;
    ret = OH_CryptoAsymCipher_Create("RSA1024|PKCS1", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoKeyPair_Destroy(*keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(*keyGen);
        return ret;
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_ENCRYPT_MODE, *keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        OH_CryptoKeyPair_Destroy(*keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(*keyGen);
        return ret;
    }

    ret = OH_CryptoAsymCipher_Final(cipher, plainData, encryptedData);
    OH_CryptoAsymCipher_Destroy(cipher);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoKeyPair_Destroy(*keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(*keyGen);
        return ret;
    }

    return ret;
}

static OH_Crypto_ErrCode doRsaDecrypt(const Crypto_DataBlob *encryptedData, OH_CryptoKeyPair *keyPair,
    const Crypto_DataBlob *expectedPlainData)
{
    OH_CryptoAsymCipher *cipher = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymCipher_Create("RSA1024|PKCS1", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_DECRYPT_MODE, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return ret;
    }

    Crypto_DataBlob decrypted = { 0 };
    ret = OH_CryptoAsymCipher_Final(cipher, encryptedData, &decrypted);
    OH_CryptoAsymCipher_Destroy(cipher);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    if ((decrypted.len != expectedPlainData->len) ||
        (memcmp(decrypted.data, expectedPlainData->data, decrypted.len) != 0)) {
        OH_Crypto_FreeDataBlob(&decrypted);
        return CRYPTO_OPERTION_ERROR;
    }

    OH_Crypto_FreeDataBlob(&decrypted);
    return ret;
}

OH_Crypto_ErrCode doTestRsaEncDec()
{
    const char *testData = "Hello, RSA!";
    Crypto_DataBlob plainData = {
        .data = (uint8_t *)testData,
        .len = strlen(testData)
    };

    OH_CryptoKeyPair *keyPair = nullptr;
    OH_CryptoAsymKeyGenerator *keyGen = nullptr;
    Crypto_DataBlob encryptedData = { 0 };

    OH_Crypto_ErrCode ret = doRsaEncrypt(&plainData, &keyPair, &keyGen, &encryptedData);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = doRsaDecrypt(&encryptedData, keyPair, &plainData);
    OH_Crypto_FreeDataBlob(&encryptedData);
    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeyGenerator_Destroy(keyGen);
    return ret;
}

// [Enc rsa_pkcs1_encrypt_decrypt]