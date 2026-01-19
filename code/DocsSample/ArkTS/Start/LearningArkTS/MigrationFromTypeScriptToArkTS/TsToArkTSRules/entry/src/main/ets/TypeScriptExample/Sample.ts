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
// [Start sample_ts]
function addTen(x: number): number {
  var ten = 10;
  return x + ten;
}
// [End sample_ts]

// [Start struct_typing_caseOne]
class T {
  public name: string = ''

  public greet(): void {
    console.info('Hello, ' + this.name);
  }
}

class U {
  public name: string = ''

  public greet(): void {
    console.info('Greetings, ' + this.name);
  }
}
// [End struct_typing_caseOne]

// [Start struct_typing_caseTwo]
let u: U = new T(); // 是否允许？
//[End struct_typing_caseTwo]

// [Start struct_typing_caseThree]
function greeter(u: U) {
  console.info('To ' + u.name);
  u.greet();
}

let t: T = new T();
greeter(t); // 是否允许？
// [End struct_typing_caseThree]
