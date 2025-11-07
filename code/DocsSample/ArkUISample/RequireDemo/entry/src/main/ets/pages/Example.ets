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

// [Start example_require_start]
@Entry
@Component
struct Example {
  @State message: string = 'Hello World!';

  @Builder
  buildTest() {
    Row() {
      Text('Hello, world!!')
        .fontSize(30)
    }
  }

  build() {
    Row() {
      // 构造ChildV1、ChildV2组件时传递相应参数，编译通过。
      ChildV1({
        regularValue: 'Hello',
        stateValue: 'Hello',
        provideValue: 'Hello',
        initBuildTest: this.buildTest,
        initMessage: 'Hello'
      })
      ChildV2({ message: this.message })
    }
  }
}

@Component
struct ChildV1 {
  // 使用@Require必须构造时传参。
  @Require regularValue: string;
  @Require @State stateValue: string;
  @Require @Provide provideValue: string;
  @Require @BuilderParam initBuildTest: () => void;
  @Require @Prop initMessage: string;

  build() {
    Column() {
      Text(this.initMessage)
        .fontSize(30)
      this.initBuildTest();
    }
  }
}

@ComponentV2
struct ChildV2 {
  // 使用@Require必须构造时传参。
  @Require @Param message: string;

  build() {
    Column() {
      Text(this.message)
    }
  }
}
// [End example_require_start]