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
// [Start builder_function_combined_with_the_v2_decorator_and_local]
class LocalInfo {
  public name: string = 'Tom';
  public age: number = 25;
}

@Builder
function overBuilderLocal(param: LocalInfo) {
  Column() {
    Text(`Global@Builder name: ${param.name}`)
    Text(`Global@Builder age: ${param.age}`)
  }
  .width(230)
  .height(40)
  .margin(10)
  .padding({ left: 20 })
  .backgroundColor('#0d000000')
  .borderRadius(20)
}

@ComponentV2
struct ChildLocalPage {
  @Require @Param childLocalInfo: LocalInfo;

  build() {
    Column() {
      // 此处为引用传递方式
      overBuilderLocal({ name: this.childLocalInfo.name, age: this.childLocalInfo.age })
    }
  }
}

@Entry
@ComponentV2
struct ParentLocalPage {
  LocalInfo1: LocalInfo = { name: 'Tom', age: 25 };
  @Local LocalInfo2: LocalInfo = { name: 'Tom', age: 25 };

  @Builder
  privateBuilder() {
    Column() {
      Text(`Private@Builder name: ${this.LocalInfo1.name}`)
      Text(`Private@Builder age: ${this.LocalInfo1.age}`)
    }
    .width(230)
    .height(40)
    .margin(10)
    .backgroundColor('#0d000000')
    .borderRadius(20)
  }

  build() {
    Column() {
      Flex() {
        Column() {
          Text(`LocalInfo1: ${this.LocalInfo1.name}  ${this.LocalInfo1.age}`) // Text1
          Text(`LocalInfo2: ${this.LocalInfo2.name}  ${this.LocalInfo2.age}`) // Text2
        }
      }
      .width(230)
      .height(40)
      .margin(10)
      .padding({ left: 60 })
      .backgroundColor('#0d000000')
      .borderRadius(20)

      // 调用局部@Builder
      this.privateBuilder()
      // 调用全局@Builder, 此处为引用传递方式
      overBuilderLocal({ name: this.LocalInfo2.name, age: this.LocalInfo2.age })
      ChildLocalPage({ childLocalInfo: this.LocalInfo1 }) // 调用自定义组件
      ChildLocalPage({ childLocalInfo: this.LocalInfo2 }) // 调用自定义组件
      Button('change LocalInfo1&LocalInfo2')
        .onClick(() => {
          this.LocalInfo1 = { name: 'Cat', age: 18 }; // Text1不会刷新，原因是没有装饰器修饰监听不到值的改变
          this.LocalInfo2 = { name: 'Cat', age: 18 }; // Text2会刷新，原因是有装饰器修饰，可以监听到值的改变
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End builder_function_combined_with_the_v2_decorator_and_local]