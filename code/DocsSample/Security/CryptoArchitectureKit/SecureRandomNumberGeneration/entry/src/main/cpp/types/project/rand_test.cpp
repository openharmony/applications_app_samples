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

// [Start rand_test_cpp]
#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include <cstdio>
#include "file.h"

OH_Crypto_ErrCode doTestRandomNumber()
{
    // 创建随机数生成器。
    OH_CryptoRand *rand = nullptr;
    OH_Crypto_ErrCode ret = OH_CryptoRand_Create(&rand);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 设置随机种子（可选）。
    uint8_t seedData[12] = {0x25, 0x65, 0x58, 0x89, 0x85, 0x55, 0x66, 0x77, 0x88, 0x99, 0x11, 0x22};
    Crypto_DataBlob seed = {
        .data = seedData,
        .len = sizeof(seedData)
    };
    ret = OH_CryptoRand_SetSeed(rand, &seed);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoRand_Destroy(rand);
        return ret;
    }

    // 生成指定长度的随机数。
    Crypto_DataBlob out = {0};
    uint32_t randomLength = 24; // 生成24字节的随机数。
    ret = OH_CryptoRand_GenerateRandom(rand, randomLength, &out);
    if (ret != CRYPTO_SUCCESS) {
        OH_CryptoRand_Destroy(rand);
        return ret;
    }

    // 获取并打印随机数生成器的算法名称。
    const char *algoName = OH_CryptoRand_GetAlgoName(rand);
    if (algoName != nullptr) {
        printf("Random number generator algorithm: %s\n", algoName);
    }

    printf("Generated random number length: %u\n", out.len);

    // 清理资源。
    OH_Crypto_FreeDataBlob(&out);
    OH_CryptoRand_Destroy(rand);
    return CRYPTO_SUCCESS;
}
// [End rand_test_cpp]