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

// [Start pkcs1_seg_verify_rsa_keypair_sign]
#include "signing_signature_verification.h"

static constexpr int INT_64 = 64;
bool DoTestRsaSignatureSeg()
{
    OH_CryptoAsymKeyGenerator *keyCtx = nullptr;
    OH_CryptoKeyPair *keyPair = nullptr;
    OH_CryptoVerify *verify = nullptr;

    uint8_t plainText[] = {
        0x43, 0x31, 0x7d, 0xb5, 0x85, 0x2e, 0xd4, 0xef, 0x08, 0x7a, 0x17, 0x96, 0xbc, 0x7c, 0x8f, 0x80,
        0x8c, 0xa7, 0x63, 0x7f, 0x26, 0x89, 0x8f, 0xf0, 0xfa, 0xa7, 0x51, 0xbd, 0x9c, 0x69, 0x17, 0xf3,
        0xd1, 0xb5, 0xc7, 0x12, 0xbf, 0xcf, 0x91, 0x25, 0x82, 0x23, 0x6b, 0xd6, 0x64, 0x52, 0x77, 0x93,
        0x01, 0x9d, 0x70, 0xa3, 0xf4, 0x92, 0x16, 0xec, 0x3f, 0xa7, 0x3c, 0x83, 0x8d, 0x40, 0x41, 0xfc,
    };
    Crypto_DataBlob msgBlob = {.data = reinterpret_cast<uint8_t *>(plainText), .len = sizeof(plainText)};

    uint8_t pubKeyText[] = {
        0x2d, 0x2d, 0x2d, 0x2d, 0x2d, 0x42, 0x45, 0x47, 0x49, 0x4e, 0x20, 0x52, 0x53, 0x41, 0x20, 0x50, 0x55, 0x42,
        0x4c, 0x49, 0x43, 0x20, 0x4b, 0x45, 0x59, 0x2d, 0x2d, 0x2d, 0x2d, 0x2d, 0x0a, 0x4d, 0x49, 0x47, 0x4a, 0x41,
        0x6f, 0x47, 0x42, 0x41, 0x4d, 0x78, 0x63, 0x44, 0x4d, 0x6f, 0x61, 0x59, 0x52, 0x58, 0x6f, 0x78, 0x65, 0x69,
        0x33, 0x49, 0x6d, 0x33, 0x33, 0x78, 0x4a, 0x76, 0x61, 0x73, 0x63, 0x43, 0x62, 0x77, 0x31, 0x6f, 0x73, 0x63,
        0x32, 0x56, 0x56, 0x69, 0x47, 0x6a, 0x56, 0x47, 0x47, 0x4a, 0x37, 0x6c, 0x75, 0x4e, 0x41, 0x58, 0x6b, 0x6a,
        0x73, 0x56, 0x46, 0x64, 0x35, 0x0a, 0x58, 0x37, 0x4c, 0x4d, 0x6c, 0x46, 0x34, 0x63, 0x35, 0x5a, 0x75, 0x59,
        0x2f, 0x61, 0x69, 0x57, 0x77, 0x70, 0x54, 0x69, 0x63, 0x62, 0x67, 0x49, 0x33, 0x43, 0x66, 0x50, 0x6f, 0x32,
        0x6a, 0x6c, 0x52, 0x74, 0x67, 0x41, 0x46, 0x6b, 0x44, 0x71, 0x7a, 0x4b, 0x53, 0x46, 0x62, 0x46, 0x47, 0x51,
        0x6b, 0x43, 0x6e, 0x64, 0x63, 0x2b, 0x54, 0x59, 0x6b, 0x5a, 0x42, 0x32, 0x70, 0x45, 0x6f, 0x72, 0x0a, 0x7a,
        0x73, 0x61, 0x56, 0x58, 0x77, 0x5a, 0x47, 0x45, 0x34, 0x41, 0x43, 0x70, 0x59, 0x35, 0x79, 0x65, 0x66, 0x49,
        0x44, 0x6c, 0x45, 0x57, 0x49, 0x51, 0x4f, 0x6a, 0x59, 0x4b, 0x2f, 0x6c, 0x58, 0x71, 0x7a, 0x48, 0x47, 0x69,
        0x4f, 0x69, 0x32, 0x75, 0x4a, 0x45, 0x75, 0x44, 0x43, 0x50, 0x6a, 0x51, 0x64, 0x6a, 0x54, 0x41, 0x67, 0x4d,
        0x42, 0x41, 0x41, 0x45, 0x3d, 0x0a, 0x2d, 0x2d, 0x2d, 0x2d, 0x2d, 0x45, 0x4e, 0x44, 0x20, 0x52, 0x53, 0x41,
        0x20, 0x50, 0x55, 0x42, 0x4c, 0x49, 0x43, 0x20, 0x4b, 0x45, 0x59, 0x2d, 0x2d, 0x2d, 0x2d, 0x2d, 0x0a,
    };

    Crypto_DataBlob keyBlob = {.data = reinterpret_cast<uint8_t *>(pubKeyText), .len = sizeof(pubKeyText)};

    uint8_t signText[] = {
        0x68, 0x2f, 0x3b, 0xe6, 0xa6, 0x5c, 0xb8, 0x60, 0xd4, 0xe1, 0x64, 0xa7, 0xd8, 0x0c, 0x9c, 0x89,
        0x39, 0xb4, 0xf0, 0xb7, 0xad, 0xb5, 0x8a, 0x71, 0x04, 0xf1, 0xa5, 0x63, 0xdd, 0x32, 0x6a, 0x44,
        0xeb, 0xff, 0xb7, 0xe6, 0x85, 0xe5, 0xa5, 0x55, 0x5d, 0x5b, 0x28, 0x53, 0x63, 0xe4, 0xb3, 0xb9,
        0xa8, 0x70, 0xc8, 0x8f, 0xcd, 0x21, 0x8d, 0xe6, 0x1f, 0xe5, 0x78, 0x34, 0xd3, 0x45, 0x0c, 0x9c,
        0x7a, 0x22, 0x1b, 0x63, 0x55, 0xca, 0x14, 0xa5, 0x0c, 0x7a, 0x40, 0x8e, 0xa1, 0x14, 0x78, 0xa1,
        0xf1, 0x36, 0x78, 0xbd, 0xba, 0x37, 0x3b, 0x5b, 0xb0, 0x8e, 0xb3, 0x4a, 0x9b, 0x1b, 0x0c, 0xfa,
        0xfa, 0xc7, 0x9f, 0xb1, 0x35, 0x48, 0x82, 0x73, 0xf8, 0x6b, 0xd4, 0x76, 0x33, 0x5c, 0xed, 0x9c,
        0xd8, 0x4b, 0xc9, 0x92, 0xa0, 0x3f, 0x6e, 0xba, 0x78, 0x2e, 0x80, 0x78, 0x1e, 0x74, 0xa0, 0x47,
    };

    Crypto_DataBlob signBlob = {.data = reinterpret_cast<uint8_t *>(signText), .len = sizeof(signText)};

    // keypair
    OH_Crypto_ErrCode ret = CRYPTO_SUCCESS;
    ret = OH_CryptoAsymKeyGenerator_Create((const char *)"RSA2048", &keyCtx);
    if (ret != CRYPTO_SUCCESS) {
        return false;
    }
    ret = OH_CryptoAsymKeyGenerator_Convert(keyCtx, CRYPTO_PEM, &keyBlob, nullptr, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
        return false;
    }
    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyPair);
    // verify
    ret = OH_CryptoVerify_Create((const char *)"RSA1024|PKCS1|SHA256", &verify);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoVerify_Destroy(verify);
        OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
        return false;
    }
    int blockSize = 20;
    int cntS = INT_64 / blockSize;
    int remS = INT_64 % blockSize;
    ret = OH_CryptoVerify_Init(verify, pubKey);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoVerify_Destroy(verify);
        OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
        return false;
    }
    for (int i = 0; i < cntS; i++) {
        msgBlob.len = blockSize;
        ret = OH_CryptoVerify_Update(verify, (Crypto_DataBlob *)&msgBlob);
        if (ret != CRYPTO_SUCCESS) {
            OH_CryptoVerify_Destroy(verify);
            OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
            return false;
        }
        msgBlob.data += blockSize;
    }
    bool res = false;
    if (remS > 0) {
        msgBlob.len = remS;
        res = OH_CryptoVerify_Final(verify, (Crypto_DataBlob *)&msgBlob, (Crypto_DataBlob *)&signBlob);
        if (res != true) {
            OH_CryptoVerify_Destroy(verify);
            OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
            return false;
        }
    }

    msgBlob.data -= INT_64 - remS;
    msgBlob.len = INT_64;

    OH_CryptoVerify_Destroy(verify);
    OH_CryptoAsymKeyGenerator_Destroy(keyCtx);
    OH_CryptoKeyPair_Destroy(keyPair);
    return res;
}
// [End pkcs1_seg_verify_rsa_keypair_sign]