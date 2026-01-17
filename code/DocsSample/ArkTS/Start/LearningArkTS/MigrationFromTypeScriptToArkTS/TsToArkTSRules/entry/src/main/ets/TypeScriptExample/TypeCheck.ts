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
// [Start type_check_ts]
// 只有在开启noImplicitReturns选项时会产生编译时错误。
function foo(s: string): string {
  if (s != '') {
    console.info(s);
    return s;
  } else {
    console.info(s);
  }
}

let n: number = null; // 只有在开启strictNullChecks选项时会产生编译时错误。
// [End type_check_ts]
