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

// [Start prop_seventeen_start]
// 定义嵌套类
class Info {
  public value: string;
  constructor(value: string) {
    this.value = value;
  }
}

class Model {
  public value: string;
  public info: Info;
  constructor(value: string, info: Info) {
    this.value = value;
    this.info = info;
  }
}
// [End prop_seventeen_start]

// 子组件：展示 Model 中的两个值
@Component
struct NestedDisplay {
  // 接收复杂类型 Model（带嵌套 Info）
  @Prop title: Model;

  build() {
    Column({ space: 20 }) {
      // 显示第一层属性：title.value

      Text(`title.value [the first layer]：${this.title.value}`)
        .fontSize(18)
        .padding(10)
        .backgroundColor('#F5F5F5')
        .borderRadius(6);

      // 显示第二层属性：title.info.value
      Text(`title.info.value [the second layer]：${this.title.info.value}`)
        .fontSize(18)
        .padding(10)
        .backgroundColor('#E8F4F8')
        .borderRadius(6);

      // 按钮区域：修改不同层级的属性
      Column({ space: 10 }) {
        // 按钮1：修改第一层属性（@Prop 可观察到）
        Button('change title.value to "Hi"')
          .onClick(() => {
            // [Start prop_seventeen_start]
            this.title.value = 'Hi'; // 第一层属性变化，UI 会更新
            // [End prop_seventeen_start]
          });

        // 按钮2：修改第二层属性（@Prop 观察不到，UI 不更新）
        Button('change title.info.value to "ArkUI"')
          .onClick(() => {
            // [Start prop_seventeen_start]
            this.title.info.value = 'ArkUI'; // 第二层属性变化，@Prop 无反应
            // [End prop_seventeen_start]
          });

        // 按钮3：重新赋值整个 Model（强制更新所有属性）
        Button('Reassign Model')
          .onClick(() => {
            // 重新创建 Model 对象（改变引用），@Prop 会观察到并更新所有属性
            this.title = new Model(
              this.title.value,
              new Info(this.title.info.value)
            );
          });
      }
      .margin({ top: 20 });
    }
    .padding(30);
  }
}

// 入口组件：提供初始数据
@Entry
@Component
struct Test {
  // 初始化嵌套对象
  @State initTitle: Model = new Model(
    'Hello', // title.value 初始值
    new Info('Initial Info') // title.info.value 初始值
  );

  build() {
      Column() {
        // 引入子组件，传递 Model 数据
        NestedDisplay({ title: this.initTitle });
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .padding(15);
  }
}

// [End prop_seventeen_start]

@Builder
export function MyTestBuilder(){
  Test()
}