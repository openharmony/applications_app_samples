/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start prop_sixteen_start]
// 定义复杂类型 Model
class Model {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

// 子组件：展示并操作两个数据
@Component
struct DisplayComponent {
  // [StartExclude prop_sixteen_start]
  // 简单类型（number）
  @Prop count: number;
  // 复杂类型（Model）
  @Prop title: Model;

  // [EndExclude prop_sixteen_start]
  build() {
    Column({ space: 20 }) {
      // 显示简单类型 count
      Text(`简单类型 count 的值：${this.count}`)
        .fontSize(18)
        .margin(5)

      // 显示复杂类型 title 的值
      Text(`复杂类型 title 的值：${this.title.value}`)
        .fontSize(18)
        .margin(5)

      // 按钮：触发数据赋值变化（验证@Prop的观察能力）
      Column({ space: 10 }) {
        Button('change count to 1')
          .onClick(() => {
            // [StartExclude prop_sixteen_start]
            this.count = 1; // 简单类型赋值变化，UI会更新
            // [EndExclude prop_sixteen_start]
          })

        Button('change title to "Hi"')
          .onClick(() => {
            // [StartExclude prop_sixteen_start]
            this.title = new Model('Hi'); // 复杂类型赋值新对象，UI会更新
            // [EndExclude prop_sixteen_start]
          })
      }
      .margin({ top: 20 })
    }
    .padding(30)
  }
}

// 入口组件
@Entry
@Component
struct TestPro {
  @State initCount: number = 0; // 初始值
  @State initTitle: Model = new Model('Hello'); // 初始值

  build() {
    Column() {
      // 引入子组件，传递初始数据
      DisplayComponent({
        count: this.initCount,
        title: this.initTitle
      });
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding(15)
  }
}

// [End prop_sixteen_start]

@Builder
export function MyTestProBuilder() {
  TestPro()
}