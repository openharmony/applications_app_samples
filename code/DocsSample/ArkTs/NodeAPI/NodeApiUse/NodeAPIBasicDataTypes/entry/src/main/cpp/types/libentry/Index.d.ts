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

// [Start napi_get_value_uint32_api]
export const getValueUint32: <T>(data: T) => number | void; // napi_get_value_uint32
// [End napi_get_value_uint32_api]

// [Start napi_get_value_int32_api]
export const getValueInt32: (value: number | string) => number | void; // napi_get_value_int32
// [End napi_get_value_int32_api]

// [Start napi_get_value_int64_api]
export const getValueInt64: (value: number | string) => number | void; // napi_get_value_int64
// [End napi_get_value_int64_api]

// [Start napi_get_value_double_api]
export const getDouble: (value: number | string) => number | void; // napi_get_value_double
// [End napi_get_value_double_api]

// [Start napi_create_int32_api]
export const createInt32: () => number; // napi_create_int32
// [End napi_create_int32_api]

// [Start napi_create_uint32_api]
export const createUInt32: () => number; // napi_create_uint32
// [End napi_create_uint32_api]

// [Start napi_create_int64_api]
export const createInt64: () => number; // napi_create_int64
// [End napi_create_int64_api]

// [Start napi_create_double_api]
export const createDouble: () => number; // napi_create_double
// [End napi_create_double_api]