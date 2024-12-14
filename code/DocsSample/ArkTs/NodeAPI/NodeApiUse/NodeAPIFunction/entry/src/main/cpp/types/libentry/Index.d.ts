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

export const getCbArgs: <T>(arg: T) => T; // napi_get_cb_info

// getCbArgQuantity的入参由用户自定义，在此用例中，我们用两个入参，一个是string，一个是number
export const getCbArgQuantity: (str: string, num: number) => number;

export const getCbContext: () => Object;

export const callFunction: (func: Function) => number; // napi_call_function

export const objCallFunction: (obj: Object, func: Function) => number;

export const calculateArea: (width: number, height: number) => number; // napi_create_function

