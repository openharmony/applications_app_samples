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

// [Start v2_to_v1_state_variables]
class InfoSeven {
  public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@Component
struct ChildSeven {
  // V1从V2接收的状态变量，仅可使用@State、@Prop、@Provide接收
  @State  message: string = 'hello';            // 可以观测到变化
  @State info: InfoSeven = new InfoSeven();                // 可以观测一层类属性变化
  @Prop undefinedVal: undefined | string = undefined;
  @Provide set: Set<number> = new Set();
  build() {
    Column() {
      Text(`child message:${this.message}`)     // 显示 string
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'world';
        })
      Divider()
        .color(Color.Blue)
      Text(`undefinedVal:${this.undefinedVal}`)     // 显示 undefinedVal
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.undefinedVal = 'change to define';
        })
      Divider()
        .color(Color.Blue)
      Text(`info id:${this.info.myId}`)     // 显示 info:myId
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.info.myId++;
        })

      Divider()
        .color(Color.Blue)
      ForEach(Array.from(this.set.values()), (item: number) => {  // 显示 Set
        Text(`${item}`)
          .fontSize(30)
      })
    }
    .margin(5)
  }
}

@Entry
@ComponentV2
struct Index7 {
  @Local message: string = 'Hello World';           // 简单数据类型，支持传递
  @Provider() undefinedVal: undefined = undefined;   // 简单数据类型，undefined，支持传递
  @Consumer() info: InfoSeven = new InfoSeven();              // Class类型，支持传递
  @Param set: Set<number> = new Set([10, 20]);      // 内置类型，不支持传递；消除编译错误请去掉@Param

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
      ChildSeven({
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
// [End v2_to_v1_state_variables]