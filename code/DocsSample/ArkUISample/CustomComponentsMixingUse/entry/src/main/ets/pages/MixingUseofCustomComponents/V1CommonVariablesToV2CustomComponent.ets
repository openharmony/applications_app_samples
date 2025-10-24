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

// [Start v1_to_v2_common_variables]
class Info2 {
  public myId: number;
  public name: string;

  constructor(myId?: number, name?: string) {
    this.myId = myId || 0;
    this.name = name || 'aaa';
  }
}

@ComponentV2
struct Child2 {
  // V2对数据输入有严格的管理，从父组件接受数据时，必须@Param装饰器进行数据接收
  @Param @Once message: string = 'hello';                  // 可以观测到变化，同步回父组件依赖@Event，使用了@Once可以修改@Param装饰的变量
  @Param @Once undefinedVal: string | undefined = undefined;  // 使用了@Once可以修改@Param装饰的变量
  @Param info: Info2 = new Info2();                         // 观测不到类属性变化
  @Require @Param set: Set<number>;

  build() {
    Column() {
      Text(`child message:${this.message}`) // 显示 string
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'world';
        })

      Divider()
        .color(Color.Blue)
      Text(`undefinedVal:${this.undefinedVal}`) // 显示 undefinedVal
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.undefinedVal = 'change to define';
        })
      Divider()
        .color(Color.Blue)
      Text(`info id:${this.info.myId}`) // 显示 info:myId
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
@Component
struct Index2 {
  message: string = 'Hello World';       // 简单数据
  undefinedVal: undefined = undefined;    // 简单类型，undefined
  info: Info2 = new Info2();               // Class类型
  set: Set<number> = new Set([10, 20]);  // 内置 类型

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
      Child2({
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
// [End v1_to_v2_common_variables]