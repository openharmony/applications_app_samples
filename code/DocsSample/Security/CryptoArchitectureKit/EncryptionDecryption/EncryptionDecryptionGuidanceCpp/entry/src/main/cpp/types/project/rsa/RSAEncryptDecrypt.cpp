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

// [Start rsa_encrypt_decrypt]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <algorithm>
#include <vector>
#include <string>

static std::vector<uint8_t> doTestRsaEnc(OH_CryptoKeyPair *keyPair, std::vector<uint8_t> &plainText)
{
    std::vector<uint8_t> cipherText;
    OH_CryptoAsymCipher *cipher = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymCipher_Create("RSA1024|PKCS1", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return std::vector<uint8_t>{};
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_ENCRYPT_MODE, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }

    size_t plainTextSplitLen = 64;
    for (size_t i = 0; i < plainText.size(); i += plainTextSplitLen) {
        Crypto_DataBlob in = {};
        in.data = plainText.data() + i;
        if (i + plainTextSplitLen > plainText.size()) {
            in.len = plainText.size() - i;
        } else {
            in.len = plainTextSplitLen;
        }
        Crypto_DataBlob out = {};
        ret = OH_CryptoAsymCipher_Final(cipher, &in, &out);
        if (ret != CRYPTO_SUCCESS) {
            OH_CryptoAsymCipher_Destroy(cipher);
            return std::vector<uint8_t>{};
        }
        cipherText.insert(cipherText.end(), out.data, out.data + out.len);
        OH_Crypto_FreeDataBlob(&out);
    }

    OH_CryptoAsymCipher_Destroy(cipher);
    return cipherText;
}

static std::vector<uint8_t> doTestRsaDec(OH_CryptoKeyPair *keyPair, std::vector<uint8_t> &encryptText)
{
    std::vector<uint8_t> decryptText;
    OH_CryptoAsymCipher *cipher = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymCipher_Create("RSA1024|PKCS1", &cipher);
    if (ret != CRYPTO_SUCCESS) {
        return std::vector<uint8_t>{};
    }

    ret = OH_CryptoAsymCipher_Init(cipher, CRYPTO_DECRYPT_MODE, keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymCipher_Destroy(cipher);
        return std::vector<uint8_t>{};
    }

    size_t cipherTextSplitLen = 128; // RSA密钥每次加密生成的密文字节长度计算方式：密钥位数/8。
    for (size_t i = 0; i < encryptText.size(); i += cipherTextSplitLen) {
        Crypto_DataBlob in = {};
        in.data = encryptText.data() + i;
        if (i + cipherTextSplitLen > encryptText.size()) {
            in.len = encryptText.size() - i;
        } else {
            in.len = cipherTextSplitLen;
        }
        Crypto_DataBlob out = {};
        ret = OH_CryptoAsymCipher_Final(cipher, &in, &out);
        if (ret != CRYPTO_SUCCESS) {
            OH_CryptoAsymCipher_Destroy(cipher);
            return std::vector<uint8_t>{};
        }
        decryptText.insert(decryptText.end(), out.data, out.data + out.len);
        OH_Crypto_FreeDataBlob(&out);
    }

    OH_CryptoAsymCipher_Destroy(cipher);
    return decryptText;
}

OH_Crypto_ErrCode doTestRsaEncLongMessage()
{
    OH_CryptoAsymKeyGenerator *keyGen = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("RSA1024", &keyGen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    OH_CryptoKeyPair *keyPair = nullptr;
    ret = OH_CryptoAsymKeyGenerator_Generate(keyGen, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(keyGen);
        return ret;
    }

    std::string message =
        "This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!"
        "This is a long plainTest! This is a long plainTest! This is a long plainTest! This is a long plainTest!";

    std::vector<uint8_t> plainText(message.begin(), message.end());
    std::vector<uint8_t> cipherText = doTestRsaEnc(keyPair, plainText);
    std::vector<uint8_t> decryptText = doTestRsaDec(keyPair, cipherText);

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

// [End rsa_encrypt_decrypt]