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

// [Start specify_pem_string_convert_rsa_keypair]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"
#include "file.h"

OH_Crypto_ErrCode doTestPemDataCovertAsymKey()
{
    OH_CryptoAsymKeyGenerator *ctx = nullptr;
    OH_Crypto_ErrCode ret;

    ret = OH_CryptoAsymKeyGenerator_Create("RSA1024", &ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    uint8_t sm2PubKeyBlobData[] = {
        48,  129, 159, 48,  13,  6,   9,   42,  134, 72,  134, 247, 13,  1,   1,   1,   5,   0,   3,   129, 141,
        0,   48,  129, 137, 2,   129, 129, 0,   235, 184, 151, 247, 130, 216, 140, 187, 64,  124, 219, 137, 140,
        184, 53,  137, 216, 105, 156, 141, 137, 165, 30,  80,  232, 55,  96,  46,  23,  237, 197, 123, 121, 27,
        240, 190, 14,  111, 237, 172, 67,  42,  47,  164, 226, 248, 211, 157, 213, 194, 131, 109, 181, 41,  173,
        217, 127, 252, 121, 126, 26,  130, 55,  4,   134, 104, 73,  5,   132, 91,  214, 146, 232, 64,  99,  87,
        33,  222, 155, 159, 9,   59,  212, 144, 46,  183, 83,  89,  220, 189, 148, 13,  176, 5,   139, 156, 230,
        143, 16,  152, 79,  36,  8,   112, 40,  174, 35,  83,  82,  57,  137, 87,  123, 215, 99,  199, 66,  131,
        150, 31,  143, 56,  252, 2,   73,  41,  70,  159, 2,   3,   1,   0,   1};

    OH_CryptoKeyPair *dupKeyPair = nullptr;
    Crypto_DataBlob pubBlob = {.data = sm2PubKeyBlobData, .len = sizeof(sm2PubKeyBlobData)};
    ret = OH_CryptoAsymKeyGenerator_Convert(ctx, CRYPTO_DER, &pubBlob, nullptr, &dupKeyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(ctx);
        return ret;
    }

    OH_CryptoPubKey *pubKey1 = OH_CryptoKeyPair_GetPubKey(dupKeyPair);
    Crypto_DataBlob retBlob = {.data = nullptr, .len = 0};
    ret = OH_CryptoPubKey_Encode(pubKey1, CRYPTO_PEM, "PKCS1", &retBlob);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(ctx);
        OH_CryptoKeyPair_Destroy(dupKeyPair);
        return ret;
    }
    OH_Crypto_FreeDataBlob(&retBlob);
    OH_CryptoAsymKeyGenerator_Destroy(ctx);
    OH_CryptoKeyPair_Destroy(dupKeyPair);
    return ret;
}
// [End specify_pem_string_convert_rsa_keypair]
