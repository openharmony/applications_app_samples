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

export const coerceToBool: <T>(data: T) => boolean; // napi_coerce_to_bool

export const coerceToNumber: <T>(data: T) => number; // napi_coerce_to_number

export const coerceToObject: <T>(data: T) => Object; // napi_coerce_to_object

export const coerceToString: <T>(data: T) => string; // napi_coerce_to_string

export const getBoolean: <T>(data: T, value: String) => boolean; // napi_get_boolean

export const getValueBool: (value: boolean | string) => boolean | void; // napi_get_value_bool

export const getGlobal: () => Object; // napi_get_global

export const getNull: () => null; // napi_get_null

export const getUndefined: (value: undefined) => boolean; // napi_get_undefined
