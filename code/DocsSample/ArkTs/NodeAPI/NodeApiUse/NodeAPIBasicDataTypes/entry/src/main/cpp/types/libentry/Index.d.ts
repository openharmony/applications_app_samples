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

export const getValueUint32: <T>(data: T) => number | void; // napi_get_value_uint32

export const getValueInt32: (value: number | string) => number | void; // napi_get_value_int32

export const getValueInt64: (value: number | string) => number | void; // napi_get_value_int64

export const getDouble: (value: number | string) => number | void; // napi_get_value_double

export const createInt32: () => number; // napi_create_int32

export const createUInt32: () => number; // napi_create_uint32

export const createInt64: () => number; // napi_create_int64

export const createDouble: () => number; // napi_create_double