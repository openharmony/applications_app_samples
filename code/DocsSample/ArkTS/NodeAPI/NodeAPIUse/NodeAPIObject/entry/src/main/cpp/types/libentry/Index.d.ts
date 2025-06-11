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

export const getPrototype: (object: Object) => Object; // napi_get_prototype

export const createObject: () => { name: string }; // napi_create_object

export interface Obj {
  data: number
  message: string
}

export const objectFreeze: (objFreeze: Object) => Obj; // napi_object_freeze

export interface Obj1 {
  data: number
  message: string
  id: number
}

export const objectSeal: (objSeal: Object) => Obj1; // napi_object_seal

export const napiTypeof: <T>(value: T) => string | void; // napi_typeof

export const napiInstanceof: (date: Object, construct: Object) => boolean | void; // napi_instanceof

export const setTypeTagToObject: (obj: Object, index: number) => boolean | void; // napi_type_tag_object

export const checkObjectTypeTag: (obj: Object, index: number) => boolean; // napi_check_object_type_tag

export const createExternal: () => Object; // napi_create_external

export const getExternalType: (externalData: Object) => boolean; // napi_create_external

export const getValueExternal: () => number; // napi_get_value_external

export const createSymbol: () => symbol; // napi_create_symbol