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

// [Start convert_ecc_uncompressed_pub_keypair]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"

OH_Crypto_ErrCode doTestEccDataCovert()
{
    OH_CryptoAsymKeyGenerator *generator = nullptr;
    OH_CryptoKeyPair *keyPair = nullptr;
    Crypto_DataBlob returnBlob = { .data = nullptr, .len = 0 };
    OH_Crypto_ErrCode ret = CRYPTO_INVALID_PARAMS;

    ret = OH_CryptoAsymKeyGenerator_Create("ECC_BrainPoolP256r1", &generator);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    uint8_t pubKeyBlobData[] = {
        48, 90, 48, 20, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 9, 43, 36, 3, 3, 2,
        8, 1, 1, 7, 3, 66, 0, 4, 143, 39, 57, 249, 145, 50, 63, 222, 35, 70, 178,
        121, 202, 154, 21, 146, 129, 75, 76, 63, 8, 195, 157, 111, 40, 217, 215,
        148, 120, 224, 205, 82, 83, 92, 185, 21, 211, 184, 5, 19, 114, 33, 86, 85,
        228, 123, 242, 206, 200, 98, 178, 184, 130, 35, 232, 45, 5, 202, 189, 11,
        46, 163, 156, 152
    };
    Crypto_DataBlob pubKeyUncompressedBlob = {
        .data = pubKeyBlobData,
        .len = sizeof(pubKeyBlobData),
    };
    ret = OH_CryptoAsymKeyGenerator_Convert(generator, CRYPTO_DER, &pubKeyUncompressedBlob, nullptr, &keyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(generator);
        return ret;
    }

    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyPair);
    ret = OH_CryptoPubKey_Encode(pubKey, CRYPTO_DER, "X509|COMPRESSED", &returnBlob);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(generator);
        OH_CryptoKeyPair_Destroy(keyPair);
        return ret;
    }
    OH_CryptoAsymKeyGenerator_Destroy(generator);
    OH_CryptoKeyPair_Destroy(keyPair);
    return ret;
}
// [End convert_ecc_uncompressed_pub_keypair]
