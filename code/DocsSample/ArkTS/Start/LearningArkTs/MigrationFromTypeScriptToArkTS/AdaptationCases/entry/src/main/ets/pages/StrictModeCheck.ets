/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

{
  // [Start strictProperty_initialization]
  interface I {
    name:string
  }

  class A {}

  class Test {
    public a: number;
    public b: string;
    public c: boolean;
    public d: I = { name:'abc' };
    public e: A | null = null;
    constructor(a:number, b:string, c:boolean) {
      this.a = a;
      this.b = b;
      this.c = c;
    }
  }
  // [End strictProperty_initialization]
}
// [Start null_is_not_assignable_to_type]
class A {
  bar() {}
}
function foo(n: number) {
  if (n === 0) {
    return null;
  }
  return new A();
}
function getNumber() {
  return 5;
}

let a: A | null = foo(getNumber());
a?.bar();
// [End null_is_not_assignable_to_type]
// [Start strict_function_type_check]
function foo1(fn: (value?: string) => void, value: string): void {}

foo1((value?: string) => {}, '');
// [End strict_function_type_check]
{
  // [Start strict_null_check]
  class Test {
    private value?: string;

    public printValue () {
      if (this.value) {
        console.info(this.value.toLowerCase());
      }
    }
  }

  let t = new Test();
  t.printValue();
  // [End strict_null_check]
}

{
  // [Start function_return_type_mismatch]
  class Test {
    public handleClick: ((action: string, externInfo?: string) => void) | null = null;
  }
  // [End function_return_type_mismatch]
}
// [Start null_is_not_assignable_to_type1]
class A1 {
  value: number
  constructor(value: number) {
    this.value = value;
  }
}

function foo(v: number): A1 | null {
  if (v > 0) {
    return new A1(v);
  }
  return null;
}

let a: A1 | null = foo(123);

if (a != null) {
  // 非空分支
} else {
  // 处理null
}
// [End null_is_not_assignable_to_type1]
// [Start null_is_not_assignable_to_type2]
class A2 {
  value: number
  constructor(value: number) {
    this.value = value;
  }
}

function foo(v: number): A2 | null {
  if (v > 0) {
    return new A2(v);
  }
  return null;
}

let a: A2 = foo(123)!;
// [End null_is_not_assignable_to_type2]
{
  // [Start cannot_invoke_an_object_one]
  interface A {
    foo: () => void
  }
  let a: A = { foo: () => {} };
  a.foo();
  // [End cannot_invoke_an_object_one]
}

{
  // [Start cannot_invoke_an_object_two]
  interface A {
    foo?: () => void
  }

  let a: A = { foo: () => {} };
  if (a.foo) {
    a.foo();
  }
  // [End cannot_invoke_an_object_two]
}

{
  // [Start is_used_before_being_assigned]
  class Test {
    public value: number = 0
  }

  let a: Test | null = null;
  try {
    a = { value:1 };
  } catch (e) {
    if (a) {
      a.value;
    }
  }

  if (a) {
    a.value;
  }
  // [End is_used_before_being_assigned]
}
// [Start function_lacks_ending]
function foo4(a: number): number | undefined {
  if (a > 0) {
    return a;
  }
  return
}
// [End function_lacks_ending]