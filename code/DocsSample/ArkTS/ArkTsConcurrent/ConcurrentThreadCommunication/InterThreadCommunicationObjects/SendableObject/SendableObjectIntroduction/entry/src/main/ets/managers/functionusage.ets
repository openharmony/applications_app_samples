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

// [Start example_modify_function]
@Sendable
type SendableFuncType = () => void;

@Sendable
class TopLevelSendableClass {
  num: number = 1;

  PrintNum() {
    console.info('Top level sendable class');
  }
}

@Sendable
function topLevelSendableFunction() {
  console.info('Top level sendable function');
}

@Sendable
function sendableTestFunction() {
  const topClass = new TopLevelSendableClass(); // 顶层sendable class
  topClass.PrintNum();
  topLevelSendableFunction(); // 顶层sendable function
  console.info('Sendable test function');
}

@Sendable
class SendableTestClass {
  constructor(func: SendableFuncType) {
    this.callback = func;
  }

  callback: SendableFuncType; // 顶层sendable function

  CallSendableFunc() {
    sendableTestFunction(); // 顶层sendable function
  }
}
// [End example_modify_function]

@Entry
@Component
struct FunctionUsage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          let sendableClass = new SendableTestClass(sendableTestFunction);
          sendableClass.callback();
          sendableClass.CallSendableFunc();
          this.message = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}