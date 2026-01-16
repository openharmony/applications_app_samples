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

// [Start poly1305_encrypt_decrypt_chacha20_symkey]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_sym_cipher.h"
#include <cstring>
#include "file.h"

// 参数赋值函数
static OH_Crypto_ErrCode doChaCha20Poly1305SetParams(Crypto_DataBlob *ivData, Crypto_DataBlob *aadData,
    Crypto_DataBlob *tagData, OH_CryptoSymCipherParams **params)
{
    OH_Crypto_ErrCode ret = OH_CryptoSymCipherParams_Create(params);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoSymCipherParams_SetParam(*params, CRYPTO_IV_DATABLOB, ivData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipherParams_SetParam(*params, CRYPTO_AAD_DATABLOB, aadData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipherParams_SetParam(*params, CRYPTO_TAG_DATABLOB, tagData);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    return ret;

end:
    OH_CryptoSymCipherParams_Destroy(*params);
    *params = nullptr;
    return ret;
}

// 加密函数
static OH_Crypto_ErrCode doChaCha20Poly1305Encrypt(OH_CryptoSymKey *keyCtx, OH_CryptoSymCipherParams *params,
    Crypto_DataBlob *msgBlob, Crypto_DataBlob *outUpdate, Crypto_DataBlob *tagOutPut)
{
    OH_CryptoSymCipher *encCtx = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSymCipher_Create("ChaCha20|Poly1305", &encCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(encCtx, CRYPTO_ENCRYPT_MODE, keyCtx, params);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Update(encCtx, msgBlob, outUpdate);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(encCtx, nullptr, tagOutPut);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

end:
    OH_CryptoSymCipher_Destroy(encCtx);
    return ret;
}

// 解密函数
static OH_Crypto_ErrCode doChaCha20Poly1305Decrypt(OH_CryptoSymKey *keyCtx, OH_CryptoSymCipherParams *params,
    Crypto_DataBlob *tagOutPut, Crypto_DataBlob *outUpdate, Crypto_DataBlob *decUpdate)
{
    OH_CryptoSymCipher *decCtx = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSymCipherParams_SetParam(params, CRYPTO_TAG_DATABLOB, tagOutPut);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoSymCipher_Create("ChaCha20|Poly1305", &decCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Init(decCtx, CRYPTO_DECRYPT_MODE, keyCtx, params);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymCipher_Final(decCtx, outUpdate, decUpdate);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

end:
    OH_CryptoSymCipher_Destroy(decCtx);
    return ret;
}

OH_Crypto_ErrCode doTestChaCha20Poly1305()
{
    OH_CryptoSymKeyGenerator *genCtx = nullptr;
    OH_CryptoSymKey *keyCtx = nullptr;
    OH_CryptoSymCipherParams *params = nullptr;

    Crypto_DataBlob outUpdate = {.data = nullptr, .len = 0};
    Crypto_DataBlob decUpdate = {.data = nullptr, .len = 0};

    uint8_t aad[8] = {1, 2, 3, 4, 5, 6, 7, 8};
    uint8_t tag[16] = {0};
    uint8_t iv[12] = {1, 2, 4, 12, 3, 4, 2, 3, 3, 2, 0, 4}; // iv使用安全随机数生成。
    Crypto_DataBlob ivData = {.data = iv, .len = sizeof(iv)};
    Crypto_DataBlob aadData = {.data = aad, .len = sizeof(aad)};
    Crypto_DataBlob tagData = {.data = tag, .len = sizeof(tag)};
    Crypto_DataBlob tagOutPut = {.data = nullptr, .len = 0};
    char *plainText = const_cast<char *>("this is test!");
    Crypto_DataBlob msgBlob = {.data = (uint8_t *)(plainText), .len = strlen(plainText)};
    OH_Crypto_ErrCode ret = OH_CryptoSymKeyGenerator_Create("ChaCha20", &genCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }
    ret = OH_CryptoSymKeyGenerator_Generate(genCtx, &keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 参数赋值。
    ret = doChaCha20Poly1305SetParams(&ivData, &aadData, &tagData, &params);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 加密。
    ret = doChaCha20Poly1305Encrypt(keyCtx, params, &msgBlob, &outUpdate, &tagOutPut);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 解密。
    ret = doChaCha20Poly1305Decrypt(keyCtx, params, &tagOutPut, &outUpdate, &decUpdate);
    if (ret != CRYPTO_SUCCESS) {
        goto end;
    }

    // 释放资源。
end:
    OH_CryptoSymCipherParams_Destroy(params);
    OH_CryptoSymKeyGenerator_Destroy(genCtx);
    OH_CryptoSymKey_Destroy(keyCtx);
    OH_Crypto_FreeDataBlob(&outUpdate);
    OH_Crypto_FreeDataBlob(&decUpdate);
    OH_Crypto_FreeDataBlob(&tagOutPut);
    return ret;
}
// [End poly1305_encrypt_decrypt_chacha20_symkey]