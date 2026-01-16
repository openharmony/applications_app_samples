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

// [Start des_crypt_decrypt]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_sym_cipher.h"
#include <cstring>
#include "file.h"

OH_Crypto_ErrCode doTestDesEcb()
{
    OH_CryptoSymKeyGenerator *genCtx = nullptr;
    OH_CryptoSymCipher *encCtx = nullptr;
    OH_CryptoSymCipher *decCtx = nullptr;
    OH_CryptoSymKey *keyCtx = nullptr;
    char *plainText = const_cast<char *>("this is test!");
    Crypto_DataBlob input = {.data = (uint8_t *)(plainText), .len = strlen(plainText)};
    Crypto_DataBlob encData = {.data = nullptr, .len = 0};
    Crypto_DataBlob decData = {.data = nullptr, .len = 0};

    // 随机生成对称密钥。
    OH_Crypto_ErrCode ret = OH_CryptoSymKeyGenerator_Create("DES64", &genCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymKeyGenerator_Generate(genCtx, &keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 加密操作。
    ret = OH_CryptoSymCipher_Create("DES64|ECB|PKCS7", &encCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(encCtx, CRYPTO_ENCRYPT_MODE, keyCtx, nullptr);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(encCtx, &input, &encData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 解密操作。
    ret = OH_CryptoSymCipher_Create("DES64|ECB|PKCS7", &decCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(decCtx, CRYPTO_DECRYPT_MODE, keyCtx, nullptr);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(decCtx, &encData, &decData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
end:
    OH_CryptoSymCipher_Destroy(encCtx);
    OH_CryptoSymCipher_Destroy(decCtx);
    OH_CryptoSymKeyGenerator_Destroy(genCtx);
    OH_CryptoSymKey_Destroy(keyCtx);
    OH_Crypto_FreeDataBlob(&encData);
    OH_Crypto_FreeDataBlob(&decData);
    return ret;
}
// [End des_crypt_decrypt]