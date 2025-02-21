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

export const add: (a: number, b: number) => number; // 模块加载

export const createObjectWithProperties: (data: string) => Object; // ArkTS Object相关 napi_create_object_with_properties

export const createObjectWithNameProperties: (data: string) => string | { name: string }; // ArkTS Object相关 napi_create_object_with_named_properties

export const runScriptPath: () => boolean; // 运行指定abc文件 napi_run_script_path

// 给ArkTS对象绑定回调和回调所需的参数 napi_coerce_to_native_binding_object
export const getAddress: () => number;

export const getSetSize: () => number;

export const store: (a: number) => void;

export const erase: (a: number) => void;

export const clear: () => void;

export const aboutSerialize: (obj: Object) => number; // 序列化和反序列化

export const isSendable: <T>(a: T) => boolean; // Sendable相关 napi_is_sendable

@Sendable
export class SendableClass {
  static staticStr: string;
  static staticFunc(): string;
  str: string;
  func(): string;
} // Sendable相关 napi_define_sendable_class

export const getSendableObject: () => { x: true }; // Sendable相关 napi_create_sendable_object_with_properties

export const getSendableArray: () => []; // Sendable相关 napi_create_sendable_array

export const getSendableArrayWithLength: () => []; // Sendable相关 napi_create_sendable_array_with_length

export const getSendableArrayBuffer: () => void; // Sendable相关 napi_create_sendable_arraybuffer

export const getSendableTypedArray: () => void; // Sendable相关 napi_create_sendable_typedarray

export const wrapSendable: () => void; // Sendable相关 napi_wrap_sendable

export const wrapSendableWithSize: () => void; // Sendable相关 napi_wrap_sendable_with_size

export const unwrapSendable: () => void; // Sendable相关 napi_unwrap_sendable

export const removeWrapSendable: () => void; // Sendable相关 napi_remove_wrap_sendable

