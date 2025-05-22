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

// [Start message_digest_calculation_digest_algorithm_one_time_incoming]

#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_digest.h"
#include <cstring>
#include "file.h"

OH_Crypto_ErrCode doTestMd()
{
    OH_Crypto_ErrCode ret;
    OH_CryptoDigest *ctx = nullptr;
    char *testData = const_cast<char *>("0123456789");
    Crypto_DataBlob in = {.data = (uint8_t *)(testData), .len = strlen(testData)};
    Crypto_DataBlob out = {.data = nullptr, .len = 0};
    int mdLen = 0;
    ret = OH_CryptoDigest_Create("SHA256", &ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    do {
        ret = OH_CryptoDigest_Update(ctx, &in);
        if (ret != CRYPTO_SUCCESS) {
            break;
        }
        ret = OH_CryptoDigest_Final(ctx, &out);
        if (ret != CRYPTO_SUCCESS) {
            break;
        }
        mdLen = OH_CryptoDigest_GetLength(ctx);
    } while (0);
    OH_Crypto_FreeDataBlob(&out);
    OH_DigestCrypto_Destroy(ctx);
    return ret;
}

// [End message_digest_calculation_digest_algorithm_one_time_incoming]