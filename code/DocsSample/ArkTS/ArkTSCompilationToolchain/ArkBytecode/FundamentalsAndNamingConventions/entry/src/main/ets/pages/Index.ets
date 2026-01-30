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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

const DOMAIN = 0x0000;

// [Start registers_accumulator]
function foo0(): number {
  return 1;
}
// [End registers_accumulator]

// [Start global_variables]
let a = 1;
let b = 1;
function foo1(): void {
  a += 2;
  b = 5;
}
// [End global_variables]

// [Start shared_Lexical]
@Sendable
class A { }

@Sendable
class B {
  u: A = new A()
}
// [End shared_Lexical]

// [Start patch_variables]
function bar(): void {} // 新增语句，编译补丁

function foo2(): void {
  bar(); // 新增语句，编译补丁
}
// [End patch_variables]

// [Start function_call_specifications]
function foo3(a: number, b: number): void {}
// [End function_call_specifications]

// [Start renaming_index]
namespace A {
  function bar() { } // bar的函数名为"#&A*#bar"
}

namespace A {
  function foo() { } // foo的函数名为"#&A^1*#foo"，其中"^1" 为重名序号
}
// [End renaming_index]

// [Start original_function_name]
function foo() {}; // 原函数名为"foo"
() => { }; // 原函数名为""
() => { }; // 原函数名为"^1"
// [End original_function_name]

{
  // [Start special_function_variable]
  let a = () => {} // 原函数名为"a"
  // [End special_function_variable]
}

// [Start avoid_use]
namespace A { // namespace在字节码中的函数名为"#&#A"
  class B { // 构造函数在字节码中的函数名为"#&A~B=#B"
    m() { // 函数m在字节码中的函数名为"#&A~B>#m"
      return () => {} // 匿名函数在字节码中的函数名为"#&A~B>m*#"
    }
    static s() {} // 静态函数s在字节码中的函数名为"#&A~B<#s"
  }
  enum E { // enum在字节码中的函数名为"#&A%#E"

  }
}
// [End avoid_use]

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = 'Welcome';
            hilog.info(DOMAIN, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
