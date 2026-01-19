/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start no_jsx_ts]
let a = +5;    // 5（number类型）。
let b = +'5';    // 5（number类型）。
let c = -5;    // -5（number类型）。
let d = -'5';    // -5（number类型）。
let e = ~5;    // -6（number类型）。
let f = ~'5';    // -6（number类型）。
let g = +'string'; // NaN（number类型）。

function returnTen(): string {
  return '-10';
}

function returnString(): string {
  return 'string';
}

let x = +returnTen();  // -10（number类型）。
let y = +returnString(); // NaN。
// [End no_jsx_ts]
