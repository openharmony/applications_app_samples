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

// [Start encrypt_decrypt_chacha20_symkey]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_sym_cipher.h"
#include <cstring>
#include "file.h"

// 参数赋值函数
static OH_Crypto_ErrCode doChaCha20SetParams(Crypto_DataBlob *ivBlob, OH_CryptoSymCipherParams **params)
{
    OH_Crypto_ErrCode ret = OH_CryptoSymCipherParams_Create(params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoSymCipherParams_SetParam(*params, CRYPTO_IV_DATABLOB, ivBlob);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoSymCipherParams_Destroy(*params);
        *params = nullptr;
        return ret;
    }
    return ret;
}

// 加密函数
static OH_Crypto_ErrCode doChaCha20Encrypt(OH_CryptoSymKey *keyCtx, OH_CryptoSymCipherParams *params,
    Crypto_DataBlob *msgBlob, Crypto_DataBlob *encData)
{
    OH_CryptoSymCipher *encCtx = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSymCipher_Create("ChaCha20", &encCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(encCtx, CRYPTO_ENCRYPT_MODE, keyCtx, params);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(encCtx, msgBlob, encData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

end:
    OH_CryptoSymCipher_Destroy(encCtx);
    return ret;
}

// 解密函数
static OH_Crypto_ErrCode doChaCha20Decrypt(OH_CryptoSymKey *keyCtx, OH_CryptoSymCipherParams *params,
    Crypto_DataBlob *encData, Crypto_DataBlob *decData)
{
    OH_CryptoSymCipher *decCtx = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSymCipher_Create("ChaCha20", &decCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(decCtx, CRYPTO_DECRYPT_MODE, keyCtx, params); // 解密使用的params与加密时相同。
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(decCtx, encData, decData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

end:
    OH_CryptoSymCipher_Destroy(decCtx);
    return ret;
}

OH_Crypto_ErrCode doTestChaCha20()
{
    OH_CryptoSymKeyGenerator *genCtx = nullptr;
    OH_CryptoSymKey *keyCtx = nullptr;
    OH_CryptoSymCipherParams *params = nullptr;
    Crypto_DataBlob encData = {.data = nullptr, .len = 0};
    Crypto_DataBlob decData = {.data = nullptr, .len = 0};
    char *plainText = const_cast<char *>("this is test!");
    Crypto_DataBlob msgBlob = {.data = (uint8_t *)(plainText), .len = strlen(plainText)};
    uint8_t iv[16] = {1, 2, 4, 12, 3, 4, 2, 3, 3, 2, 0, 4, 3, 1, 0, 10}; // 示例代码iv值，开发者可使用安全随机数生成。
    Crypto_DataBlob ivBlob = {.data = iv, .len = sizeof(iv)};
    // 生成对称密钥。
    OH_Crypto_ErrCode ret = OH_CryptoSymKeyGenerator_Create("ChaCha20", &genCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymKeyGenerator_Generate(genCtx, &keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 参数赋值。
    ret = doChaCha20SetParams(&ivBlob, &params);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 加密。
    ret = doChaCha20Encrypt(keyCtx, params, &msgBlob, &encData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 解密。
    ret = doChaCha20Decrypt(keyCtx, params, &encData, &decData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

end:
    OH_CryptoSymCipherParams_Destroy(params);
    OH_CryptoSymKeyGenerator_Destroy(genCtx);
    OH_CryptoSymKey_Destroy(keyCtx);
    OH_Crypto_FreeDataBlob(&encData);
    OH_Crypto_FreeDataBlob(&decData);
    return ret;
}
// [End encrypt_decrypt_chacha20_symkey]