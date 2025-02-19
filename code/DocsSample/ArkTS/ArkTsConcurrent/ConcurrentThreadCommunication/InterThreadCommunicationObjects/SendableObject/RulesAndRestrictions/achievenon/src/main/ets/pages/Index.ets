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

//非Sendable class只能实现非Sendable interface
//正例：
interface I {
  a: string;
};

class B implements I {
  a: string = 'hello world';
};

//反例：
// import { lang } from '@kit.ArkTS';
//
// type ISendable = lang.ISendable;
//
// interface I extends ISendable {};
//
// class B implements I {};

//Sendable装饰器修饰类型时仅支持修饰函数类型
//正例：
@Sendable
type SendableFuncType = () => void;

//反例：
// @Sendable
// type A = number; // 编译报错
//
// @Sendable
// class C {}
//
// @Sendable
// type D = C; // 编译报错

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
          const bInstance = new B();
          console.log('class B:', bInstance.a)
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}