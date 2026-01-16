/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start specify_ecc_uncompressed_point_get_keypair]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"

OH_Crypto_ErrCode doTestEccPointCompressedToPoint()
{
    uint8_t pk[] = {
        2, 143, 39, 57, 249, 145, 50, 63, 222, 35, 70, 178, 121, 202, 154, 21, 146, 129, 75, 76, 63, 8, 195, 157, 111,
        40, 217, 215, 148, 120, 224, 205, 82
    };
    Crypto_DataBlob pkData = {pk, sizeof(pk)};
    OH_CryptoEcPoint *point = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoEcPoint_Create("NID_brainpoolP256r1", &pkData, &point);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    Crypto_DataBlob returnPointBlobData = {0};
    ret = OH_CryptoEcPoint_Encode(point, "UNCOMPRESSED", &returnPointBlobData);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoEcPoint_Destroy(point);
        return ret;
    }
    OH_Crypto_FreeDataBlob(&returnPointBlobData);
    OH_CryptoEcPoint_Destroy(point);
    return ret;
}
// [End specify_ecc_uncompressed_point_get_keypair]
