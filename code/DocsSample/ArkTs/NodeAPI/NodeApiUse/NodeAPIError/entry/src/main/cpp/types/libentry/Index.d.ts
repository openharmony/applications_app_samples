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

// [Start napi_get_last_error_info_api]
export const getLastErrorInfo: (str: string) => string; // napi_get_last_error_info
// [End napi_get_last_error_info_api]

// [Start napi_create_type_error_api]
export const creatTypeError: () => Error; // napi_create_type_error
// [End napi_create_type_error_api]

// [Start napi_create_range_error_api]
export const creatRangeError: () => Error; // napi_create_range_error
// [End napi_create_range_error_api]

// [Start napi_create_error_api]
export const napiThrow: () => void; // napi_create_error and napi_throw
// [End napi_create_error_api]

// [Start napi_throw_error_api]
export const napiThrowErrorMessage: () => void; // napi_throw_error

export const napiThrowError: (dividend: number, divisor: number) => void; // napi_throw_error
// [End napi_throw_error_api]

// [Start napi_throw_type_error_api]
export const throwTypeErrorMessage: () => void; // napi_throw_type_error

export const throwTypeError: (message: string) => void; // napi_throw_type_error
// [End napi_throw_type_error_api]

// [Start napi_throw_range_error_api]
export const throwRangeErrorMessage: () => void; // napi_throw_range_error

export const throwRangeError: (num: number) => number | void; // napi_throw_range_error
// [End napi_throw_range_error_api]

// [Start napi_is_error_api]
export const napiIsError: <T>(obj: T) => boolean; // napi_is_error
// [End napi_is_error_api]

// [Start napi_get_and_clear_last_exception_api]
export const getAndClearLastException: () => Error | void; // napi_get_and_clear_last_exception
// [End napi_get_and_clear_last_exception_api]

// [Start ark_napi_is_exception_pending_interface]
export interface MyObject {
  code: string;
  message: string;
}
// [End ark_napi_is_exception_pending_interface]

// [Start napi_is_exception_pending_api]
export const isExceptionPending: () => Object | void; // napi_is_exception_pending
// [End napi_is_exception_pending_api]

// [Start napi_fatal_error_api]
export const fatalError: () => void; // napi_fatal_error
// [End napi_fatal_error_api]

// [Start napi_fatal_exception_api]
export const fatalException: (err: Error) => void; // napi_fatal_exception
// [End napi_fatal_exception_api]