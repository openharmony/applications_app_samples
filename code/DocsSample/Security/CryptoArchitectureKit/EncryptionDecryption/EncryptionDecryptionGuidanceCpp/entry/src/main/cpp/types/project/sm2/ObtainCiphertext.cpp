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

// [Start obtain_cipher_text]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"

OH_Crypto_ErrCode doTestGetCipherTextSpec()
{
    // 准备标准ASN.1格式密文。
    uint8_t cipherTextArray[] = {
        48, 118, 2, 32, 45, 153, 88, 82, 104, 221, 226, 43, 174, 21, 122, 248, 5, 232, 105,
        41, 92, 95, 102, 224, 216, 149, 85, 236, 110, 6, 64, 188, 149, 70, 70, 183, 2, 32, 107,
        93, 198, 247, 119, 18, 40, 110, 90, 156, 193, 158, 205, 113, 170, 128, 146, 109, 75, 17,
        181, 109, 110, 91, 149, 5, 110, 233, 209, 78, 229, 96, 4, 32, 87, 167, 167, 247, 88, 146,
        203, 234, 83, 126, 117, 129, 52, 142, 82, 54, 152, 226, 201, 111, 143, 115, 169, 125, 128,
        42, 157, 31, 114, 198, 109, 244, 4, 14, 100, 227, 78, 195, 249, 179, 43, 70, 242, 69, 169,
        10, 65, 123
    };
    Crypto_DataBlob cipherText = {cipherTextArray, sizeof(cipherTextArray)};

    // 从ASN.1格式密文创建SM2密文规格对象。
    OH_CryptoSm2CiphertextSpec *sm2CipherSpec = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoSm2CiphertextSpec_Create(&cipherText, &sm2CipherSpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 获取各个参数。
    Crypto_DataBlob c1x = { 0 };
    Crypto_DataBlob c1y = { 0 };
    Crypto_DataBlob c2 = { 0 };
    Crypto_DataBlob c3 = { 0 };

    ret = OH_CryptoSm2CiphertextSpec_GetItem(sm2CipherSpec, CRYPTO_SM2_CIPHERTEXT_C1_X, &c1x);
    if (ret != CRYPTO_SUCCESS) {
        goto EXIT;
    }
    ret = OH_CryptoSm2CiphertextSpec_GetItem(sm2CipherSpec, CRYPTO_SM2_CIPHERTEXT_C1_Y, &c1y);
    if (ret != CRYPTO_SUCCESS) {
        goto EXIT;
    }
    ret = OH_CryptoSm2CiphertextSpec_GetItem(sm2CipherSpec, CRYPTO_SM2_CIPHERTEXT_C2, &c2);
    if (ret != CRYPTO_SUCCESS) {
        goto EXIT;
    }
    ret = OH_CryptoSm2CiphertextSpec_GetItem(sm2CipherSpec, CRYPTO_SM2_CIPHERTEXT_C3, &c3);
    if (ret != CRYPTO_SUCCESS) {
        goto EXIT;
    }

EXIT:
    OH_Crypto_FreeDataBlob(&c1x);
    OH_Crypto_FreeDataBlob(&c1y);
    OH_Crypto_FreeDataBlob(&c2);
    OH_Crypto_FreeDataBlob(&c3);
    OH_CryptoSm2CiphertextSpec_Destroy(sm2CipherSpec);
    return ret;
}

// [End obtain_cipher_text]