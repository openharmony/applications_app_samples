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
// [Start no_untypedCaseOne]
class C1 {
  public n: number = 0;
  public s: string = '';
}

let o1: C1 = {n: 42, s: 'foo'};
let o2: C1 = {n: 42, s: 'foo'};
let o3: C1 = {n: 42, s: 'foo'};

let oo: C1[] = [{n: 1, s: '1'}, {n: 2, s: '2'}];
// [End no_untypedCaseOne]

// [Start no_untypedCaseTwo]
class C2 {
  public s: string;
  constructor(s: string) {
    this.s = 's =' + s;
  }
}
let o4 = new C2('foo');
// [End no_untypedCaseTwo]

// [Start no_untypedCaseThree]
class C3 {
  public n: number = 0;
  public s: string = '';
}
let o5: C3 = {n: 42, s: 'foo'};
// [End no_untypedCaseThree]

// [Start no_untypedCaseFour]
abstract class A {}
class C extends A {}
let o6: C = {}; // 或 let o6: C = new C()。
// [End no_untypedCaseFour]

// [Start no_untypedCaseFive]
class C4 {
  public n: number = 0;
  public s: string = '';
  f() {
    console.info('Hello');
  }
}
let o7 = new C4();
o7.n = 42;
o7.s = 'foo';
// [End no_untypedCaseFive]

// [Start no_untypedCaseSix]
class Point {
  public x: number = 0;
  public y: number = 0;

  // 在字面量初始化之前，使用constructor()创建一个有效对象。
  // 由于没有为Point定义构造函数，编译器将自动添加一个默认构造函数。
}

function getPoint(o: Point): Point {
  return o;
}

// 字面量初始化需要显式定义类型。
let p: Point = {x: 5, y: 10};
getPoint(p);

// getPoint接受Point类型，字面量初始化生成一个Point的新实例。
getPoint({x: 5, y: 10});
// [End no_untypedCaseSix]