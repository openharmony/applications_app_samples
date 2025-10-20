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
// [Start prop_eighteen_start]
// 嵌套类定义（保留原始结构）
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

// 子组件：展示数组 title 及嵌套对象数据
@Component
struct DataDisplay {
  // @Prop 装饰的数组（支持赋值、修改项、增删操作的观察）
  @Prop title: string[];
  // 嵌套对象数据（用于展示，不涉及深层修改）
  @Prop modelData: Model;

  build() {
      Column({ space: 25 }) {
        // 2. 展示数组 title 数据
        Column({ space: 10 }) {
          // 用 Scroll 包裹数组项，避免数据过多溢出
          Scroll() {
            Column({ space: 8 }) {
              // 遍历数组展示每一项
              ForEach(this.title, (item: string, index: number) => {
                Text(`第 ${index + 1} 项: ${item}`)
                  .fontSize(14)
                  .padding(5)
                  .backgroundColor('#E8F4F8')
                  .borderRadius(4);
              }, (item: string, index: number) => `${index}-${item}`); // 唯一键
            }
            .padding(5);
          }
          .height(150)
          .width('100%')
          .borderWidth(1)
          .borderColor('#EEEEEE')
          .borderRadius(6);
        }
        // 3. 数组操作按钮区
        Column({ space: 10 }) {
          // 按钮容器 Row：用链式方法设置换行
          Row({ space: 5 }) {
            // 按钮1：赋值为 ["1"]
            Button('赋值为 ["1"]')
              .fontSize(8)
              .onClick(() => this.title = ['1']);

            // 按钮2：第一项改为 "2"
            Button('第一项改为 "2"')
              .fontSize(8)
              .onClick(() => this.title.length > 0 && (this.title[0] = '2'));
            // 按钮4：新增 "3"
            Button('新增 "3"')
              .fontSize(8)
              .onClick(() => this.title.push('3'));
            // 按钮3：删除最后一项
            Button('删除最后一项')
              .fontSize(8)
              .onClick(() => this.title.pop());

          }

        }
      }
      .padding(20);
  }
}

// 入口组件：提供初始数据
@Entry
@Component
struct Test {
  // 初始化数组（@State 管理，传递给子组件 @Prop）
  @State arrTitle: string[] = [];
  // 初始化嵌套对象
  @State initModel: Model = new Model(
    '初始 Model 值',
    new Info('初始 Info 值')
  );

  build() {
    Column() {
      // 引入子组件，传递数据
      DataDisplay({
        title: this.arrTitle,
        modelData: this.initModel
      });
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding(15);
  }
}

// [End prop_eighteen_start]

@Builder
export function MyTestBuilder(){
  Test()
}