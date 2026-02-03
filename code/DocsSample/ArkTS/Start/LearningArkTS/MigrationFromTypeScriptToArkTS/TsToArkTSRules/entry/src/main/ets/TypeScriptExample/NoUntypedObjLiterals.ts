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
// [Start no_untypedCaseOne_ts]
let o1 = { n: 42, s: 'foo' };
let o2: Object = { n: 42, s: 'foo' };
let o3: object = { n: 42, s: 'foo' };

let oo: Object[] = [{ n: 1, s: '1' }, { n: 2, s: '2' }];
// [End no_untypedCaseOne_ts]

// [Start no_untypedCaseTwo_ts]
class C2 {
  s: string;
  constructor(s: string) {
    this.s = 's =' + s;
  }
}
let o4: C2 = { s: 'foo' };
// [End no_untypedCaseTwo_ts]

// [Start no_untypedCaseThree_ts]
class C3 {
  readonly n: number = 0;
  readonly s: string = '';
}
let o5: C3 = { n: 42, s: 'foo' };
// [End no_untypedCaseThree_ts]

// [Start no_untypedCaseFour_ts]
abstract class A { }
let o6: A = {};
// [End no_untypedCaseFour_ts]

// [Start no_untypedCaseFive_ts]
class C4 {
  n: number = 0;
  s: string = '';
  f() {
    console.info('Hello');
  }
}
let o7: C4 = { n: 42, s: 'foo', f: () => { } };
// [End no_untypedCaseFive_ts]

// [Start no_untypedCaseSix_ts]
class Point {
  x: number = 0;
  y: number = 0;
}

function getPoint(o: Point): Point {
  return o;
}

// TS支持structural typing，可以推断p的类型为Point
let p = { x: 5, y: 10 };
getPoint(p);

// 可通过上下文推断出对象字面量的类型为Point
getPoint({ x: 5, y: 10 });
// [End no_untypedCaseSix_ts]