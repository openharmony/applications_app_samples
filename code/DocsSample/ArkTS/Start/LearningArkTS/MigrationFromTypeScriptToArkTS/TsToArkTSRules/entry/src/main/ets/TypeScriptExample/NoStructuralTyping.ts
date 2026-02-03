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
// [Start no_structuralTyping_ts]
interface I1 {
  f(): string
}

interface I2 { // I2等价于I1
  f(): string
}

class X {
  n: number = 0
  s: string = ''
}

class Y { // Y等价于X
  n: number = 0
  s: string = ''
}

let x = new X();
let y = new Y();

// 将X对象赋值给Y对象
y = x;

// 将Y对象赋值给X对象
x = y;

function foo(x: X) {
  console.info(x.n + x.s);
}

// 由于X和Y的API是等价的，所以X和Y是等价的
foo(new X());
foo(new Y());
// [End no_structuralTyping_ts]