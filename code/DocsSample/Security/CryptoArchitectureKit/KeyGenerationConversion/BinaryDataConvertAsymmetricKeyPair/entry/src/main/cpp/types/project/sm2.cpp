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

#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"
#include "file.h"

OH_Crypto_ErrCode doAsymSm2Covert()
{
    OH_CryptoAsymKeyGenerator *ctx = nullptr;
    OH_CryptoKeyPair *dupKeyPair = nullptr;
    OH_Crypto_ErrCode ret;

    ret = OH_CryptoAsymKeyGenerator_Create("SM2_256", &ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    uint8_t sm2PubKeyBlobData[] = {48,  89,  48,  19,  6,   7,   42,  134, 72,  206, 61,  2,   1,   6,   8,   42,
                                   134, 72,  206, 61,  3,   1,   7,   3,   66,  0,   4,   157, 58,  248, 205, 95,
                                   171, 229, 33,  116, 44,  192, 12,  115, 119, 84,  156, 128, 56,  180, 246, 84,
                                   43,  33,  244, 224, 221, 181, 154, 155, 222, 157, 124, 131, 217, 214, 134, 199,
                                   155, 61,  196, 203, 107, 13,  227, 121, 57,  199, 109, 220, 103, 55,  78,  148,
                                   185, 226, 212, 162, 31,  66,  201, 50,  129, 1,   156};

    uint8_t sm2PriKeyBlobData[] = {48,  49,  2,   1,   1,   4,   32, 255, 121, 33, 196, 188, 159, 112, 149, 146, 107,
                                   243, 78,  152, 214, 12,  119, 87, 199, 207, 57, 116, 64,  150, 240, 121, 22,  88,
                                   138, 196, 71,  70,  222, 160, 10, 6,   8,   42, 134, 72,  206, 61,  3,   1,   7};
    Crypto_DataBlob pubBlob = {.data = sm2PubKeyBlobData, .len = sizeof(sm2PubKeyBlobData)};
    Crypto_DataBlob priBlob = {.data = sm2PriKeyBlobData, .len = sizeof(sm2PriKeyBlobData)};
    ret = OH_CryptoAsymKeyGenerator_Convert(ctx, CRYPTO_DER, &pubBlob, &priBlob, &dupKeyPair);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoAsymKeyGenerator_Destroy(ctx);
        return ret;
    }

    OH_CryptoAsymKeyGenerator_Destroy(ctx);
    OH_CryptoKeyPair_Destroy(dupKeyPair);
    return ret;
}