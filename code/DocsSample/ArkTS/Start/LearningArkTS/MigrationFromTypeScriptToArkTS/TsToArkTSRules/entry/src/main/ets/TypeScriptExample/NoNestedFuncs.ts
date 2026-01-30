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
// [Start no_nestedFuncs_ts]
function addNum(a: number, b: number): void {

  // 函数内声明函数
  function logToConsole(message: string): void {
    console.info(message);
  }

  let result = a + b;

  // 调用函数
  logToConsole('result is ' + result);
}
// [End no_nestedFuncs_ts]
