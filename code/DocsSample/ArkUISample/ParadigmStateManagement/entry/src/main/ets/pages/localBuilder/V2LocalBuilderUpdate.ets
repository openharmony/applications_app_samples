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

@Component
export struct LocalBuilderV2LocalBuilderUpdate {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      ParentPage()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.v2_local_builder_update'))
  }
}

// [Start LocalBuilder_in_V2_use]
@ObservedV2
class Info {
  @Trace name: string = '';
  @Trace age: number = 0;
}

@ComponentV2
struct ChildPage {
  @Require @Param childInfo: Info;

  build() {
    Column() {
      // $r('app.string.v2_local_builder_update_text_01_name') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_01_name', this.childInfo.name))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      // $r('app.string.v2_local_builder_update_text_01_age') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_01_age', this.childInfo.age))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }
}

@Entry
@ComponentV2
struct ParentPage {
  info1: Info = { name: 'Tom', age: 25 };
  @Local info2: Info = { name: 'Tom', age: 25 };

  @LocalBuilder
  privateBuilder() {
    Column() {
      // $r('app.string.v2_local_builder_update_text_02_name') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_02_name', this.info1.name))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      // $r('app.string.v2_local_builder_update_text_02_age') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_02_age', this.info1.age))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }

  @LocalBuilder
  privateBuilderSecond() {
    Column() {
      // $r('app.string.v2_local_builder_update_text_02_name') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_02_name', this.info2.name))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      // $r('app.string.v2_local_builder_update_text_02_age') 需要更换为开发者所需的字符串资源文件
      Text($r('app.string.v2_local_builder_update_text_02_age', this.info2.age))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
  }

  build() {
    Column() {
      Text(`info1: ${this.info1.name}  ${this.info1.age}`) // Text1
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      this.privateBuilder() // 调用局部@Builder
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Text(`info2: ${this.info2.name}  ${this.info2.age}`) // Text2
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      this.privateBuilderSecond() // 调用局部@Builder
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Text(`info1: ${this.info1.name}  ${this.info1.age}`) // Text1
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      ChildPage({ childInfo: this.info1 }) // 调用自定义组件
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Text(`info2: ${this.info2.name}  ${this.info2.age}`) // Text2
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      ChildPage({ childInfo: this.info2 }) // 调用自定义组件
      Line()
        .width('100%')
        .height(10)
        .backgroundColor('#000000').margin(10)
      Button('change info1&info2')
        .onClick(() => {
          this.info1 = { name: 'Cat', age: 18 }; // Text1不会刷新，原因是info1没被装饰器装饰，无法监听到值的改变。
          this.info2 = { name: 'Cat', age: 18 }; // Text2会刷新，原因是info2有装饰器装饰，可以监听到值的改变。
        })
    }
  }
}
// [End LocalBuilder_in_V2_use]