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

export const createBuffer: () => string; // napi_create_buffer

export const createBufferCopy: () => string; // napi_create_buffer_copy

export const createExternalBuffer: () => string; // napi_create_external_buffer

export const getBufferInfo: () => string; // napi_get_buffer_info

export const isBuffer: () => boolean; // napi_is_buffer

export const createExternalArraybuffer: () => ArrayBuffer | void; // napi_create_external_arraybuffer