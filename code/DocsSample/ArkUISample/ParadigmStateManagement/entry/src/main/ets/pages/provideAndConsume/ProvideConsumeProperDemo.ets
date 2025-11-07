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
// [Start provide_consume_proper_demo]
@Component
struct Child {
  @Consume num: number;
  // 从API version 20开始，@Consume装饰的变量支持设置默认值
  @Consume num1: number = 17;

  build() {
    Column() {
      Text(`Value of num: ${this.num}`)
      Text(`Value of num1: ${this.num1}`)
    }
  }
}

@Entry
@Component
struct Parent {
  @Provide num: number = 10;

  build() {
    Column() {
      Text(`Value of num: ${this.num}`)
      Child()
    }
  }
}
// [End provide_consume_proper_demo]

@Component
export struct ProvideConsumeProperDemoDecorator {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.provide_consume_proper_demo'))
  }
}