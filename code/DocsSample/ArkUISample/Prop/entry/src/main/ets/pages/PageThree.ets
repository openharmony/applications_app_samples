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

// [Start prop_three_start]
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

@Component
struct PropDemo {
  // 初始化Model数据（第一层value为"Hello"，第二层info.value为"World"）
  @Prop title: Model = new Model("Hello", new Info("World"));

  build() {
    // [StartExclude prop_three_start]
    Column() {
      // 展示第一层数据
      Text(`第一层数据: ${this.title.value}`)
        .fontSize(20)
        .margin(10)

      // 展示第二层数据
      Text(`第二层数据: ${this.title.info.value}`)
        .fontSize(20)
        .margin(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    // [EndExclude prop_three_start]
  }
}
// [End prop_three_start]
// 入口组件
@Entry
@Component
struct PropDemoIndex {
  build() {
    NavDestination() {
      Column() {
        PropDemo()
      }
    }
  }
}

@Builder
export function MyPropDemoIndexBuilder(){
  PropDemoIndex()
}