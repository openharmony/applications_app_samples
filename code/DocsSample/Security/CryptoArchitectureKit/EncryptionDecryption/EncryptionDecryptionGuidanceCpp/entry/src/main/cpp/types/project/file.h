#ifndef ENCRYPTIONDECRYPTIONGUIDANCESM2_FILE_H
#define ENCRYPTIONDECRYPTIONGUIDANCESM2_FILE_H
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

OH_Crypto_ErrCode doTestGenCipherTextBySpec();
OH_Crypto_ErrCode doTestGetCipherTextSpec();
OH_Crypto_ErrCode doTestSm2EncMessage();

OH_Crypto_ErrCode doTestRsaEncDec();
OH_Crypto_ErrCode doTestRsaEncLongMessage();

#endif //ENCRYPTIONDECRYPTIONGUIDANCESM2_FILE_H