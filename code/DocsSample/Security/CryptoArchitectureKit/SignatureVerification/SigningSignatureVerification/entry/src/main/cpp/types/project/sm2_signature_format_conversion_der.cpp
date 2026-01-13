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
// [Start sm2_signature_format_conversion_der]
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"
#include "CryptoArchitectureKit/crypto_signature.h"

OH_Crypto_ErrCode DoTestSm2RStoDER()
{
    static unsigned char rCoordinate[] = {
        107, 93,  198, 247, 119, 18,  40,  110, 90,  156, 193,
        158, 205, 113, 170, 128, 146, 109, 75,  17,  181, 109,
        110, 91,  149, 5,   110, 233, 209, 78,  229, 96};

    static unsigned char sCoordinate[] = {
        45,  153, 88,  82,  104, 221, 226, 43,  174, 21,  122,
        248, 5,   232, 105, 41,  92,  95,  102, 224, 216, 149,
        85,  236, 110, 6,   64,  188, 149, 70,  70,  183};

    // 由R和S生成DER格式的签名数据。
    OH_CryptoEccSignatureSpec *spec = NULL;
    Crypto_DataBlob r = {0};
    Crypto_DataBlob s = {0};
    r.data = rCoordinate;
    r.len = sizeof(rCoordinate);
    s.data = sCoordinate;
    s.len = sizeof(sCoordinate);
    OH_Crypto_ErrCode ret = OH_CryptoEccSignatureSpec_Create(NULL, &spec);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoEccSignatureSpec_Destroy(spec);
        return ret;
    }
    ret = OH_CryptoEccSignatureSpec_SetRAndS(spec, &r, &s);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoEccSignatureSpec_Destroy(spec);
        return ret;
    }
    Crypto_DataBlob sig = {0};
    ret = OH_CryptoEccSignatureSpec_Encode(spec, &sig);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoEccSignatureSpec_Destroy(spec);
        return ret;
    }
    OH_Crypto_FreeDataBlob(&sig);
    OH_CryptoEccSignatureSpec_Destroy(spec);
    spec = NULL;
    return CRYPTO_SUCCESS;
}

// [End sm2_signature_format_conversion_der]