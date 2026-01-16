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

// [Start TestX25519]

#include "CryptoArchitectureKit/crypto_architecture_kit.h"
#include "CryptoArchitectureKit/crypto_key_agreement.h"
#include "file.h"
#include <cstdio>
#include <cstring>


static OH_Crypto_ErrCode GenerateSecret(OH_CryptoKeyAgreement *x25519KeyAgreement, OH_CryptoKeyPair *keyPairA,
    OH_CryptoKeyPair *keyPairB, Crypto_DataBlob *secret)
{
    OH_CryptoPrivKey *privKey = OH_CryptoKeyPair_GetPrivKey(keyPairA);
    OH_CryptoPubKey *pubKey = OH_CryptoKeyPair_GetPubKey(keyPairB);
    return OH_CryptoKeyAgreement_GenerateSecret(x25519KeyAgreement, privKey, pubKey, secret);
}

static OH_Crypto_ErrCode CompareSecrets(Crypto_DataBlob secret1, Crypto_DataBlob secret2)
{
    if ((secret1.len == secret2.len) &&
        (memcmp(secret1.data, secret2.data, secret1.len) == 0)) {
        return CRYPTO_SUCCESS;
    }
    return CRYPTO_OPERTION_ERROR;
}

static OH_Crypto_ErrCode CovertKeyPairByBlob(OH_CryptoAsymKeyGenerator *x25519Gen, OH_CryptoKeyPair **keyPair)
{
    uint8_t pubKeyArray[] = {48, 42, 48, 5, 6, 3, 43, 101, 110, 3, 33, 0, 36, 98, 216, 106, 74, 99, 179, 203, 81, 145,
                             147, 101, 139, 57, 74, 225, 119, 196, 207, 0, 50, 232, 93, 147, 188, 21, 225, 228, 54, 251,
                             230, 52};
    uint8_t priKeyArray[] = {48, 46, 2, 1, 0, 48, 5, 6, 3, 43, 101, 110, 4, 34, 4, 32, 112, 65, 156, 73, 65, 89, 183,
                             39, 119, 229, 110, 12, 192, 237, 186, 153, 21, 122, 28, 176, 248, 108, 22, 242, 239, 179,
                             106, 175, 85, 65, 214, 90};
    Crypto_DataBlob pubKeyBlob = {pubKeyArray, sizeof(pubKeyArray)};
    Crypto_DataBlob priKeyBlob = {priKeyArray, sizeof(priKeyArray)};
    return OH_CryptoAsymKeyGenerator_Convert(x25519Gen, CRYPTO_DER, &pubKeyBlob, &priKeyBlob, keyPair);
}

OH_Crypto_ErrCode doTestX25519KeyAgreement()
{
    OH_CryptoAsymKeyGenerator *x25519Gen = nullptr;
    OH_CryptoKeyPair *keyPairA = nullptr;
    OH_CryptoKeyPair *keyPairB = nullptr;
    OH_CryptoKeyAgreement *x25519KeyAgreement = nullptr;
    Crypto_DataBlob secret1 = {0};
    Crypto_DataBlob secret2 = {0};
    OH_Crypto_ErrCode ret = OH_CryptoAsymKeyGenerator_Create("X25519", &x25519Gen);
    if (ret != CRYPTO_SUCCESS) {
        return ret;
    }

    ret = CovertKeyPairByBlob(x25519Gen, &keyPairA);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    ret = OH_CryptoAsymKeyGenerator_Generate(x25519Gen, &keyPairB);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    ret = OH_CryptoKeyAgreement_Create("X25519", &x25519KeyAgreement);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    // 使用A的公钥和B的私钥进行密钥协商。
    ret = GenerateSecret(x25519KeyAgreement, keyPairB, keyPairA, &secret1);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    // 使用A的私钥和B的公钥进行密钥协商。
    ret = GenerateSecret(x25519KeyAgreement, keyPairA, keyPairB, &secret2);
    if (ret != CRYPTO_SUCCESS) {
        goto goto_cleanup;
    }

    ret = CompareSecrets(secret1, secret2);
    if (ret != CRYPTO_SUCCESS) {
        printf("x25519 result is not equal\n");
        goto goto_cleanup;
    }

goto_cleanup:
    OH_Crypto_FreeDataBlob(&secret1);
    OH_Crypto_FreeDataBlob(&secret2);
    OH_CryptoKeyAgreement_Destroy(x25519KeyAgreement);
    OH_CryptoKeyPair_Destroy(keyPairA);
    OH_CryptoKeyPair_Destroy(keyPairB);
    OH_CryptoAsymKeyGenerator_Destroy(x25519Gen);
    return CRYPTO_SUCCESS;
}

// [End TestX25519]