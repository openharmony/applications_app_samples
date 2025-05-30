#ifndef FILE_H
#define FILE_H
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

OH_Crypto_ErrCode doTestDataCovertAsymKey();
OH_Crypto_ErrCode doAsymEccCovert();
OH_Crypto_ErrCode doAsymSm2Covert();

#endif // FILE_H