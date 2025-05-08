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

// [Start napi_create_array_api]
export const createArray: () => number[]; // 使用Node-API接口进行array相关开发 napi_create_array
// [End napi_create_array_api]

// [Start napi_create_array_with_length_api]
export const createArrayWithLength: (length: number) => void[]; // 使用Node-API接口进行array相关开发 napi_create_array_with_length
// [End napi_create_array_with_length_api]

// [Start napi_get_array_length_api]
export const getArrayLength: (arr: Array<any>) => number | void; // 使用Node-API接口进行array相关开发 napi_get_array_length
// [End napi_get_array_length_api]

// [Start napi_is_array_api]
export const isArray: <T>(data: Array<T> | T) => boolean | void; // 使用Node-API接口进行array相关开发 napi_is_array
// [End napi_is_array_api]

// [Start napi_set_element_api]
export const napiSetElement: <T>(arr: Array<T>, index: number,
  value: T) => void; // 使用Node-API接口进行array相关开发 napi_set_element
// [End napi_set_element_api]

// [Start napi_get_element_api]
export const napiGetElement: <T>(arr: Array<T>,
  index: number) => number | string | Object | boolean | undefined; // 使用Node-API接口进行array相关开发 napi_get_element
// [End napi_get_element_api]

// [Start napi_has_element_api]
export const napiHasElement: <T>(arr: Array<T>, index: number) => boolean; // 使用Node-API接口进行array相关开发 napi_has_element
// [End napi_has_element_api]

// [Start napi_delete_element_api]
export const napiDeleteElement: <T>(arr: Array<T>,
  index: number) => boolean; // 使用Node-API接口进行array相关开发 napi_delete_element
// [End napi_delete_element_api]

// [Start napi_create_typed_array_api]
export const enum TypedArrayTypes {
  INT8_ARRAY = 0,
  UINT8_ARRAY,
  UINT8_CLAMPED_ARRAY,
  INT16_ARRAY,
  UINT16_ARRAY,
  INT32_ARRAY,
  UINT32_ARRAY,
  FLOAT32_ARRAY,
  FLOAT64_ARRAY,
  BIGINT64_ARRAY,
  BIGuINT64_ARRAY,
}

export const createTypedArray: <T>(type: TypedArrayTypes) => T; // 使用Node-API接口进行array相关开发 napi_create_typedarray
// [End napi_create_typed_array_api]

// [Start napi_is_typed_array_api]
export const isTypedarray: (data: Object) => boolean | void; // 使用Node-API接口进行array相关开发 napi_is_typedarray
// [End napi_is_typed_array_api]

// [Start napi_get_typed_array_info_api]
export const getTypedarrayInfo: <T>(typeArray: T,
  infoType: number) => ArrayBuffer | number | boolean; // 使用Node-API接口进行array相关开发 napi_get_typedarray_info
// [End napi_get_typed_array_info_api]

// [Start napi_create_data_view_api]
export const createDataView: (arraybuffer: ArrayBuffer) => DataView | void; // 使用Node-API接口进行array相关开发 napi_create_dataview
// [End napi_create_data_view_api]

// [Start napi_is_data_view_api]
export const isDataView: (date: DataView | string) => boolean | void; // 使用Node-API接口进行array相关开发 napi_is_dataview
// [End napi_is_data_view_api]

// [Start napi_get_data_view_info_api]
export const getDataViewInfo: (dataView: DataView,
  infoType: number) => ArrayBuffer | number; // 使用Node-API接口进行array相关开发 napi_get_dataview_info
// [End napi_get_data_view_info_api]