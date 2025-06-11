/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// Sendable class的内部不允许使用当前模块内上下文环境中定义的变量
// [Start counter_example]
// 正例：
import { lang } from '@kit.ArkTS';

type ISendable = lang.ISendable;

interface I extends ISendable {}

@Sendable
class B implements I {
  static o: number = 1;

  static bar(): B {
    return new B();
  }
}

@Sendable
class C {
  v: I = new B();
  u: number = B.o;

  foo() {
    return B.bar();
  }
}

// 反例：
// import { lang } from '@kit.ArkTS';
//
// type ISendable = lang.ISendable;
//
// interface I extends ISendable {}
//
// @Sendable
// class B implements I {}
//
// function bar(): B {
//   return new B();
// }
//
// let b = new B();
//
// {
//   @Sendable
//   class A implements I {}
//
//   @Sendable
//   class C {
//     u: I = bar(); // bar不是sendable class对象，编译报错
//     v: I = new A(); // A不是定义在top level中，编译报错
//
//     foo() {
//       return b; // b不是sendable class对象，而是sendable class的实例，编译报错
//     }
//   }
// }
// [End counter_example]

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          const cInstance = new C();
          cInstance.u = 1;
          console.log('class C:', cInstance.foo())
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}