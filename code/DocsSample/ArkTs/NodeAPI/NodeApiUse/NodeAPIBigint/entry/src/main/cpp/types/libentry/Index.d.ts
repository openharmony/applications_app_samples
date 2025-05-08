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

// [Start napi_create_bigint_int64_api]
export const createBigintInt64t: () => bigint; // napi_create_bigint_int64
// [End napi_create_bigint_int64_api]

// [Start napi_create_bigint_uint64_api]
export const createBigintUint64t: () => bigint; // napi_create_bigint_uint64
// [End napi_create_bigint_uint64_api]

// [Start napi_create_bigint_words_api]
export const createBigintWords: () => bigint | void; // napi_create_bigint_words
// [End napi_create_bigint_words_api]

// [Start napi_get_value_bigint_int64_api]
export const getValueBigintInt64t: (bigInt64: bigint) => boolean | void; // napi_get_value_bigint_int64
// [End napi_get_value_bigint_int64_api]

// [Start napi_get_value_bigint_uint64_api]
export const getValueBigintUint64t: (bigUint64: bigint) => boolean | void; // napi_get_value_bigint_uint64
// [End napi_get_value_bigint_uint64_api]

// [Start napi_get_value_bigint_words_api]
export const getValueBigintWords: (bigIntWords: bigint) => bigint | void; // napi_get_value_bigint_words
// [End napi_get_value_bigint_words_api]