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
// [Start sm2_der_convert_r_s]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"
#include "CryptoArchitectureKit/crypto_signature.h"

OH_Crypto_ErrCode DoTestSm2DerConvertRS()
{
    uint8_t signText[] = {
        0x30, 0x45, 0x02, 0x21, 0x00, 0xab, 0xf8, 0xe2, 0x96, 0x7d, 0x5b, 0x28, 0xfb, 0x9a, 0xbd, 0x05, 0xa6,
        0x81, 0xd6, 0xb1, 0x55, 0x69, 0x22, 0x25, 0xd2, 0xa3, 0x5d, 0xa8, 0xc0, 0x96, 0xe0, 0x1d, 0x38, 0x74,
        0xa0, 0xc9, 0x4f, 0x02, 0x20, 0x20, 0x27, 0x04, 0x7a, 0x31, 0x94, 0xe7, 0x32, 0x61, 0xc3, 0x55, 0xa6,
        0x5e, 0x1e, 0xdd, 0x3d, 0x04, 0x1c, 0x1e, 0x2d, 0x8d, 0x8d, 0x45, 0xca, 0xd9, 0x40, 0xe8, 0x97, 0xcd,
        0x01, 0x18, 0xc5,
    };
    Crypto_DataBlob signBlob = {
        .data = reinterpret_cast<uint8_t *>(signText),
        .len = sizeof(signText)};

    OH_CryptoEccSignatureSpec *eccSignSpec = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoEccSignatureSpec_Create(&signBlob, &eccSignSpec);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    Crypto_DataBlob r = {.data = nullptr, .len = 0};
    Crypto_DataBlob s = {.data = nullptr, .len = 0};
    ret = OH_CryptoEccSignatureSpec_GetRAndS(eccSignSpec, &r, &s);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoEccSignatureSpec_Destroy(eccSignSpec);
        return ret;
    }
    OH_Crypto_FreeDataBlob(&r);
    OH_Crypto_FreeDataBlob(&s);
    OH_CryptoEccSignatureSpec_Destroy(eccSignSpec);
    return CRYPTO_SUCCESS;
}

// [End sm2_der_convert_r_s]