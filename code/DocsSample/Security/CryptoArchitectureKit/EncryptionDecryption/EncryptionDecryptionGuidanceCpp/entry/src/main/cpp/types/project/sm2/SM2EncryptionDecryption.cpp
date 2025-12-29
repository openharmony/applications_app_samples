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

// [Start encrypt_decrypt_sm2_asymkey]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <algorithm>
#include <vector>
#include <string>

static std::vector<uint8_t> doTestSm2Enc(OH_CryptoKeyPair *keyPair, std::vector<uint8_t> &plainText)
{
    std::vector<uint8_t> cipherText;
    OH_CryptoAsymCipher *cipher = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymCipher_Create("SM2_256|SM3", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return std::vector<uint8_t>{};
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_ENCRYPT_MODE, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }

    Crypto_DataBlob in = {};
    in.data = plainText.data();
    in.len = plainText.size();
    Crypto_DataBlob out = {};
    ret = OH_CryptoAsymCipher_Final(cipher, &in, &out);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }
    cipherText.insert(cipherText.end(), out.data, out.data + out.len);
    OH_Crypto_FreeDataBlob(&out);

    OH_CryptoAsymCipher_Destroy(cipher);
    return cipherText;
}

static std::vector<uint8_t> doTestSm2Dec(OH_CryptoKeyPair *keyPair, std::vector<uint8_t> &encryptText)
{
    std::vector<uint8_t> decryptText;
    OH_CryptoAsymCipher *cipher = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymCipher_Create("SM2_256|SM3", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return std::vector<uint8_t>{};
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_DECRYPT_MODE, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }

    Crypto_DataBlob in = {};
    in.data = encryptText.data();
    in.len = encryptText.size();
    Crypto_DataBlob out = {};
    ret = OH_CryptoAsymCipher_Final(cipher, &in, &out);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }
    decryptText.insert(decryptText.end(), out.data, out.data + out.len);
    OH_Crypto_FreeDataBlob(&out);

    OH_CryptoAsymCipher_Destroy(cipher);
    return decryptText;
}

OH_Crypto_ErrCode doTestSm2EncMessage()
{
    OH_CryptoAsymKeyGenerator *keyGen = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("SM2_256", &keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = OH_CryptoAsymKeyGenerator_Generate(keyGen, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }

    std::string message = "This is a test";
    std::vector<uint8_t> plainText(message.begin(), message.end());
    std::vector<uint8_t> cipherText = doTestSm2Enc(keyPair, plainText);
    std::vector<uint8_t> decryptText = doTestSm2Dec(keyPair, cipherText);

    if ((plainText.size() != decryptText.size()) ||
        (!std::equal(plainText.begin(), plainText.end(), decryptText.begin()))) {
        OH_CryptoKeyPair_Destroy(keyPair);
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return CRYPTO_OPERTION_ERROR;
    }

    OH_CryptoKeyPair_Destroy(keyPair);
    OH_CryptoAsymKeyGenerator_Destroy(keyGen);
    return CRYPTO_SUCCESS;
}

// [End encrypt_decrypt_sm2_asymkey]