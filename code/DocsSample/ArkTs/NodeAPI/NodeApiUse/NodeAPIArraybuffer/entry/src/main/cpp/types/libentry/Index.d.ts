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

// [Start napi_is_arraybuffer_api]
export const isArrayBuffer: <T>(arrayBuffer: T) => boolean | void; // napi_is_arraybuffer
// [End napi_is_arraybuffer_api]

// [Start napi_get_arraybuffer_info_api]
export class ArrayBufferInfo {
  byteLength: number;
  buffer: Object;
}

export const getArraybufferInfo: (data: ArrayBuffer) => ArrayBufferInfo | void; // napi_get_arraybuffer_info
// [End napi_get_arraybuffer_info_api]

// [Start napi_detach_arraybuffer_api]
export const detachedArraybuffer: (buffer: ArrayBuffer) => ArrayBuffer; // napi_detach_arraybuffer

export const isDetachedArraybuffer: (arrarBeffer: ArrayBuffer) => boolean; //napi_is_detached_arraybuffer
// [End napi_detach_arraybuffer_api]

// [Start napi_create_arraybuffer_api]
export const createArraybuffer: (size: number) => ArrayBuffer; // napi_create_arraybuffer
// [End napi_create_arraybuffer_api]