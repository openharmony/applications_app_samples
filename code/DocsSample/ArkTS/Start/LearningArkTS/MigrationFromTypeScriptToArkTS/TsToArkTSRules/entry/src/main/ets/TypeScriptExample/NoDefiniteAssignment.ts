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
// [Start no_definiteAssignment_ts]
class C {
  name: string  // 只有在开启strictPropertyInitialization选项时会产生编译时错误
  age: number   // 只有在开启strictPropertyInitialization选项时会产生编译时错误
}

let c = new C();
// [End no_definiteAssignment_ts]

// [Start strict_typingRequired_ts]
// @ts-nocheck
// ...
// 关闭了类型检查后的代码
// ...

let s1: string = null; // 没有报错

// @ts-ignore
let s2: string = null; // 没有报错
// [End strict_typingRequired_ts]
