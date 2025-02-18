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
#include "CryptoArchitectureKit/crypto_sym_key.h"
#include "file.h"

OH_Crypto_ErrCode doTestDataCovertSymKey()
{
    const char *algName = "3DES192";
    OH_CryptoSymKeyGenerator *ctx = nullptr;
    OH_CryptoSymKey *convertKeyCtx = nullptr;
    Crypto_DataBlob out = {.data = nullptr, .len = 0};
    OH_Crypto_ErrCode ret;
    uint8_t arr[] = {0xba, 0x3d, 0xc2, 0x71, 0x21, 0x1e, 0x30, 0x56, 0xad, 0x47, 0xfc, 0x5a,
                     0x46, 0x39, 0xee, 0x7c, 0xba, 0x3b, 0xc2, 0x71, 0xab, 0xa0, 0x30, 0x72};
    Crypto_DataBlob convertBlob = {.data = arr, .len = sizeof(arr)};
    ret = OH_CryptoSymKeyGenerator_Create(algName, &ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    ret = OH_CryptoSymKeyGenerator_Convert(ctx, &convertBlob, &convertKeyCtx);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoSymKeyGenerator_Destroy(ctx);
        return ret;
    }
    ret = OH_CryptoSymKey_GetKeyData(convertKeyCtx, &out);
    OH_CryptoSymKeyGenerator_Destroy(ctx);
    OH_CryptoSymKey_Destroy(convertKeyCtx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    OH_Crypto_FreeDataBlob(&out);
    return ret;
}

