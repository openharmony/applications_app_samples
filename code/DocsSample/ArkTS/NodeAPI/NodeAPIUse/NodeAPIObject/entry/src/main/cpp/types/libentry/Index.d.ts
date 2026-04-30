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

// [Start napi_get_prototype_api]
export const getPrototype: (object: Object) => Object; // napi_get_prototype
// [End napi_get_prototype_api]

// [Start napi_create_object_api]
export const createObject: () => { name: string }; // napi_create_object
// [End napi_create_object_api]

// [Start napi_object_freeze_api]
export interface Obj {
  data: number
  message: string
}

export const objectFreeze: (objFreeze: Object) => Obj; // napi_object_freeze
// [End napi_object_freeze_api]

// [Start napi_object_seal_api]
export interface Obj1 {
  data: number
  message: string
  id: number
}

export const objectSeal: (objSeal: Object) => Obj1; // napi_object_seal
// [End napi_object_seal_api]

// [Start napi_typeof_api]
export const napiTypeOf: <T>(value: T) => string | undefined; // napi_typeof
// [End napi_typeof_api]

// [Start napi_instanceof_api]
export const napiInstanceOf: (date: Object, construct: Object) => boolean | undefined; // napi_instanceof
// [End napi_instanceof_api]

// [Start napi_type_tag_object_api]
export const setTypeTagToObject: (obj: Object, index: number) => boolean | undefined; // napi_type_tag_object

export const checkObjectTypeTag: (obj: Object, index: number) => boolean; // napi_check_object_type_tag
// [End napi_type_tag_object_api]

// [Start napi_create_external_api]
export const createExternal: () => Object; // napi_create_external

export const getExternalType: (externalData: Object) => boolean; // napi_create_external
// [End napi_create_external_api]

// [Start napi_get_value_external_api]
export const getValueExternal: () => number; // napi_get_value_external
// [End napi_get_value_external_api]

// [Start napi_create_symbol_api]
export const createSymbol: () => symbol; // napi_create_symbol
// [End napi_create_symbol_api]