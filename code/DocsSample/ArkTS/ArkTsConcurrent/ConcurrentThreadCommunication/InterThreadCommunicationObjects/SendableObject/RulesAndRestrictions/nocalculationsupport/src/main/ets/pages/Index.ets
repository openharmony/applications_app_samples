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

//Sendable class/interface的成员变量不支持使用计算属性名
//正例：
@Sendable
class A {
  num1: number = 1;
  num2: number = 2;

  add(): number {
    return this.num1 + this.num2;
  }
}

//反例：
// enum B {
//   b1 = 'bbb';
// }
// @Sendable
// class A {
//   ['aaa']: number = 1; // ['aaa'] is allowed in other classes in ets files
//   [B.b1]: number = 2; // [B.b1] is allowed in other classes in ets files
// }

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
          const aInstance = new A();
          aInstance.num1 = 1;
          aInstance.num2 = 2;
          console.log('class A:', aInstance.add())
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}