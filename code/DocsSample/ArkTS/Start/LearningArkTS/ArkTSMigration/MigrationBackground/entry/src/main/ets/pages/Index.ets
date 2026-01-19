/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

// [Start def_person]
class Person {
  name: string = ''; // undefined

  setName(n: string): void {
    this.name = n;
  }

  // 类型为"string"，不可能为"null"或者"undefined"。
  getName(): string {
    return this.name;
  }
}
// [StartExclude def_person]

// [Start def_personFix]
class Person1 {
  name?: string; // 可能为undefined。

  setName(n: string): void {
    this.name = n;
  }

  getName(): string | undefined { // 返回类型匹配name的类型。
    return this.name;
  }
}
// [StartExclude def_personFix]

function testClassPersonWithName() {
  // [EndExclude def_person]
  let buddy = new Person()
  // 假设代码中没有对name的赋值，例如没有调用"buddy.setName('John')"。
  let len = buddy.getName().length; // 0, 没有运行时异常。
  // [End def_person]

  console.info(`len: ${len}`);
  let logMsg = `len: ${len}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

function testClassPersonWithName1() {
  // [EndExclude def_personFix]
  let buddy = new Person1()
  // 假设代码中没有对name的赋值，例如没有调用"buddy.setName('John')"。

  let len = buddy.getName()?.length; // 编译成功，没有运行时错误。
  // [End def_personFix]

  console.info(`len: ${len}`);
  let logMsg = `len: ${len}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

// [Start def_func]
function notify(who: string, what: string) {
  console.info(`Dear ${who}, a message for you: ${what}`);
}

// [StartExclude def_func]
function testNotify() {
  // [EndExclude def_func]
  notify('Jack', 'You look great today');
  // [End def_func]
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.state_not_initialized');
  @State logMessages: string | ResourceStr = $r('app.string.log_no_info');

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text($r('app.string.real_time_status'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_state'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Text(this.currentState)
              .fontSize(14)
              .fontColor('#007DFF')
              .width('100%')
              .padding(10)
              .backgroundColor('#F0F0F0')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.log_info'))
              .fontSize(14)
              .fontWeight(600)
              .margin({ bottom: 8 })
            Scroll() {
              Text(this.logMessages)
                .fontSize(12)
                .fontColor('#52C41A')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ bottom: 16 })

        Column() {
          Text($r('app.string.test_class_property')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClassPersonWithName();
          this.currentState = $r('app.string.test_class_property_complete');
        })

        Column() {
          Text($r('app.string.test_class_property_uncertain_type')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testClassPersonWithName1();
          this.currentState = $r('app.string.test_class_property_uncertain_type_complete');
        })

        Column() {
          Text($r('app.string.test_performance')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testNotify();
          this.currentState = $r('app.string.test_performance_complete');
        })

      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}