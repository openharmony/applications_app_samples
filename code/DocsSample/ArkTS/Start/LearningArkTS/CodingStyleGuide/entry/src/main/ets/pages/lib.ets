/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start noESObject_lib_incorrectExample]
// [Start noESObject_lib_correctExample]
// lib.ets
export interface I {
  sum: number
}

// [StartExclude noESObject_lib_correctExample]
export function getObject1(value: number): I {
  let obj: I = { sum: value };
  return obj
}
// [End noESObject_lib_incorrectExample]

// [EndExclude noESObject_lib_correctExample]
export function getObject2(value: number): I {
  let obj: I = { sum: value };
  return obj
}
// [End noESObject_lib_correctExample]
