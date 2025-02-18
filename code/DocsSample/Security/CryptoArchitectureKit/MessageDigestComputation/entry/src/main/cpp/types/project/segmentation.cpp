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

#include <cstdlib>
#include "CryptoArchitectureKit/crypto_common.h"
#include "CryptoArchitectureKit/crypto_digest.h"
#include "file.h"
#define OH_CRYPTO_DIGEST_DATA_MAX (1024 * 1024 * 100)

static constexpr int INT_640 = 640;

OH_Crypto_ErrCode doLoopMd()
{
    OH_Crypto_ErrCode ret;
    OH_CryptoDigest *ctx = nullptr;
    uint8_t *testData = (uint8_t *)malloc(OH_CRYPTO_DIGEST_DATA_MAX);
    if (testData == nullptr) {
        return CRYPTO_MEMORY_ERROR;
    }
    Crypto_DataBlob out = {.data = nullptr, .len = 0};
    int mdLen = 0;
    int isBlockSize = 20;
    int offset = 0;

    ret = OH_CryptoDigest_Create("SHA256", &ctx);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }
    do {
        for (int i = 0; i < INT_640 / isBlockSize; i++) {
            Crypto_DataBlob in = {.data = reinterpret_cast<uint8_t *>(testData + offset),
                                  .len = static_cast<size_t>(isBlockSize)};
            ret = OH_CryptoDigest_Update(ctx, &in);
            if (ret != CRYPTO_SUCCESS) {
                break;
            }
            offset += isBlockSize;
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