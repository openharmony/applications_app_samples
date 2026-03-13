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
// [Start identifier_prop]
class X {
  public name: string = '';
}
let x: X = { name: 'x' };
console.info(x.name); // x

let y = ['a', 'b', 'c'];
console.info(y[2]); // c

// 在需要通过非标识符（即不同类型的key）获取数据的场景中，使用Map<Object, some_type>
let z = new Map<Object, string>();
z.set('name', '1');
z.set(2, '2');
console.info(z.get('name'));  // 1
console.info(z.get(2)); // 2

enum Test {
  A = 'aaa',
  B = 'bbb'
};

let obj: Record<string, number> = {
  [Test.A]: 1,   // 枚举中的字符串值
  [Test.B]: 2,   // 枚举中的字符串值
  ['value']: 3   // 字符串字面量
};
// [End identifier_prop]