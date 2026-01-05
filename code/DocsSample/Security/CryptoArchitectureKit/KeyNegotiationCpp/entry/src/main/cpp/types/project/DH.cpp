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

// [Start TestDh]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include "CryptoArchitectureKit/crypto_key_agreement.h"
#include "file.h"
#include <cstdio>
#include <cstring>

static OH_Crypto_ErrCode GenerateSecret(OH_CryptoKeyAgreement *dhKeyAgreement, OH_CryptoKeyPair *keyPairA,
    OH_CryptoKeyPair *keyPairB, Crypto_DataBlob *secret)
{
    OH_CryptoPrivKey *privKey = OH_CryptoKeyPair_GetPrivKey(keyPairA);
    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyPairB);
    return OH_CryptoKeyAgreement_GenerateSecret(dhKeyAgreement, privKey, pubKey, secret);
}

static OH_Crypto_ErrCode compareSecrets(const Crypto_DataBlob *secret1, const Crypto_DataBlob *secret2)
{
    if ((secret1->len == secret2->len) &&
        (memcmp(secret1->data, secret2->data, secret1->len) == 0)) {
        return CRYPTO_SUCCESS;
    }
    return CRYPTO_OPERTION_ERROR;
}

OH_Crypto_ErrCode doTestDHKeyAgreement()
{
    OH_CryptoAsymKeyGenerator *dhGen = nullptr;
    OH_CryptoKeyPair *keyPairA = nullptr;
    OH_CryptoKeyPair *keyPairB = nullptr;
    OH_CryptoKeyAgreement *dhKeyAgreement = nullptr;
    Crypto_DataBlob secret1 = { 0 };
    Crypto_DataBlob secret2 = { 0 };
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("DH_modp1536", &dhGen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    // 生成公私钥对A 和 B。
    ret = OH_CryptoAsymKeyGenerator_Generate(dhGen, &keyPairA);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    ret = OH_CryptoAsymKeyGenerator_Generate(dhGen, &keyPairB);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    ret = OH_CryptoKeyAgreement_Create("DH_modp1536", &dhKeyAgreement);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    // 使用A的公钥和B的私钥进行密钥协商。
    ret = GenerateSecret(dhKeyAgreement, keyPairB, keyPairA, &secret1);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    // 使用B的公钥和A的私钥进行密钥协商。
    ret = GenerateSecret(dhKeyAgreement, keyPairA, keyPairB, &secret2);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    // 比较两次协商的结果。
    ret = compareSecrets(&secret1, &secret2);
    if (ret != CRYPTO_SUCCESS) {
        printf("dh result is not equal\n");
        goto goto_cleanup;
    }

goto_cleanup:
    OH_Crypto_FreeDataBlob(&secret1);
    OH_Crypto_FreeDataBlob(&secret2);
    OH_CryptoKeyAgreement_Destroy(dhKeyAgreement);
    OH_CryptoKeyPair_Destroy(keyPairA);
    OH_CryptoKeyPair_Destroy(keyPairB);
    OH_CryptoAsymKeyGenerator_Destroy(dhGen);
    return ret;
}

// [End TestDh]