#ifndef MYAPPLICATION_AA_H
#define MYAPPLICATION_AA_H
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
#include "CryptoArchitectureKit/crypto_signature.h"
#include "CryptoArchitectureKit/crypto_asym_key.h"

bool DoTestRsaSignature();
bool DoTestRsaSignatureSeg();
OH_Crypto_ErrCode DoTestRsaSignatureRecover();
bool DoTestRsaPssSignatureSeg();
bool DoTestEcdsaSignature();
bool DoTestSm2Signature();

#endif // MYAPPLICATION_AA_H