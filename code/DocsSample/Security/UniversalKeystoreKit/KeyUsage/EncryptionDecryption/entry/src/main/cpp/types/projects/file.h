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

#ifndef ENCRYPTIONDECRYPTIONGUIDANCEAES_FILE_H
#define ENCRYPTIONDECRYPTIONGUIDANCEAES_FILE_H
#include "napi/native_api.h"

napi_value TestAesCbc(napi_env env, napi_callback_info info);
napi_value TestAesGcm(napi_env env, napi_callback_info info);
napi_value TestRsaEcbPkcs(napi_env env, napi_callback_info info);
napi_value TestRsaEcbOaep(napi_env env, napi_callback_info info);
napi_value TestDesCbc(napi_env env, napi_callback_info info);
napi_value TestSm2(napi_env env, napi_callback_info info);

#endif //ENCRYPTIONDECRYPTIONGUIDANCEAES_FILE_H