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

// [Start parent_require_tart]
@ObservedV2
class Info {
  @Trace public name: string = '';
  @Trace public age: number = 0;
}

@ComponentV2
struct ChildPage {
  @Require @Param childInfo: Info = new Info();
  @Require @Param stateValue: string = 'Hello';

  build() {
    Column() {
      Text(`ChildPage childInfo name :${this.childInfo.name}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Text(`ChildPage childInfo age :${this.childInfo.age}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Text(`ChildPage stateValue age :${this.stateValue}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Entry
@ComponentV2
struct ParentPage {
  info1: Info = { name: 'Tom', age: 25 };
  label1: string = 'Hello World';
  @Local info2: Info = { name: 'Tom', age: 25 };
  @Local label2: string = 'Hello World';

  build() {
    Column() {
      Text(`info1: ${this.info1.name}  ${this.info1.age}`) // Text1
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      // 父组件ParentPage构造子组件ChildPage时进行了构造赋值。
      // 为ChildPage中被@Require @Param装饰的childInfo和stateValue属性传入了值。
      ChildPage({ childInfo: this.info1, stateValue: this.label1 }) // 创建自定义组件。
      Line()
        .width('100%')
        .height(5)
        .backgroundColor('#000000').margin(10)
      Text(`info2: ${this.info2.name}  ${this.info2.age}`) // Text2。
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      // 同上，在父组件创建子组件的过程中进行构造赋值。
      ChildPage({ childInfo: this.info2, stateValue: this.label2 }) // 创建自定义组件。
      Line()
        .width('100%')
        .height(5)
        .backgroundColor('#000000').margin(10)
      Button('change info1&info2')
        .onClick(() => {
          this.info1 = { name: 'Cat', age: 18 }; // Text1不会刷新，原因是info1没有装饰器装饰，监听不到值的改变。
          this.info2 = { name: 'Cat', age: 18 }; // Text2会刷新，原因是info2有装饰器装饰，能够监听到值的改变。
          this.label1 = 'Luck'; // 不会刷新，原因是label1没有装饰器装饰，监听不到值的改变。
          this.label2 = 'Luck'; // 会刷新，原因是label2有装饰器装饰，可以监听到值的改变。
        })
    }
  }
}
// [End parent_require_tart]