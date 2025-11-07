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

// [Start v1_to_v2_state_variables]
class Info4 {
  public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@ComponentV2
struct Child4 {
  // V2对数据输入有严格的管理，从父组件接受数据时，必须@Param装饰器进行数据接收
  @Param @Once message: string = 'hello';
  @Param @Once undefinedVal: string | undefined = undefined;  // 使用了@Once可以修改@Param装饰的变量
  @Param info: Info4 = new Info4();
  @Require @Param set: Set<number>;
  build() {
    Column() {
      Text(`child message:${this.message}`) // 显示string
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'world';
        })
      Divider()
        .color(Color.Blue)
      Text(`undefinedVal:${this.undefinedVal}`) // 显示undefinedVal
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.undefinedVal = 'change to define';
        })
      Divider()
        .color(Color.Blue)
      Text(`info id:${this.info.myId}`) // 显示info:myId
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.info.myId++;
        })
      Divider()
        .color(Color.Blue)
      ForEach(Array.from(this.set.values()), (item: number) => {  // 显示Set
        Text(`${item}`)
          .fontSize(30)
      })
    }
    .margin(5)
  }
}

@Entry
@Component
struct Index4 {
  @State message: string = 'Hello World';       // 简单类型数据，支持
  @State undefinedVal: undefined = undefined;    // 简单类型数据，undefined，支持
  @State info: Info4 = new Info4();               // Class类型，不支持传递，编译器报错；消除编译错误请去掉@State
  @State set: Set<number> = new Set([10, 20]);  // 内置类型，不支持传递，编译器报错；消除编译错误请去掉@State

  build() {
    Column() {
      Text(`message:${this.message}`)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'world hello';
        })
      Divider()
        .color(Color.Blue)
      Child4({
        message: this.message,
        undefinedVal: this.undefinedVal,
        info: this.info,
        set: this.set
      })
    }
    .height('100%')
    .width('100%')
  }
}
// [End v1_to_v2_state_variables]