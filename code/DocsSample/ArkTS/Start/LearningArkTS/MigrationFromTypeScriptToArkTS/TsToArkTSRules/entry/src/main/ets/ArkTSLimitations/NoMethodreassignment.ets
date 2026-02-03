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
// [Start no_reassignMethod]
class C {
  foo() {
    console.info('foo');
  }
}

class Derived extends C {
  foo() {
    console.info('Extra');
    super.foo();
  }
}

function bar() {
  console.info('bar');
}

let c1 = new C();
let c2 = new C();
c1.foo(); // foo
c2.foo(); // foo

let c3 = new Derived();
c3.foo(); // Extra foo
// [End no_reassignMethod]
