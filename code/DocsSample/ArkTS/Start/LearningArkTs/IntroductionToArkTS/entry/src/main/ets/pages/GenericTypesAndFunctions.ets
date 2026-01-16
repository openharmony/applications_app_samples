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

export {};

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;
// [Start generic_define]
class CustomStack<Element> {
  public push(e: Element):void {
    // ...
  }
}
// [End generic_define]
// [Start generic_define_example]
let s = new CustomStack<string>();
s.push('hello');
// [End generic_define_example]
// [Start generic_constraint]
interface Hashable {
  hash(): number;
}
class MyHashMap<Key extends Hashable, Value> {
  public set(k: Key, v: Value) {
    let h = k.hash();
    // ...其他代码...
  }
}
// [End generic_constraint]
// [Start generic_function]
function last(x: number[]): number {
  return x[x.length - 1];
}
// [StartExclude generic_function]
function testGenericTypes() {
  // [EndExclude generic_function]
  last([1, 2, 3]); // 3
  // [End generic_function]
  console.info(`last([1, 2, 3]): , ${last([1, 2, 3])}`);
  let logMsg = `last([1, 2, 3]): ${last([1, 2, 3])}`;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}
// [Start generic_array]
function last1<T>(x: T[]): T {
  return x[x.length - 1];
}
// [End generic_array]
// [Start generic_defaultValue]
class SomeType {}
interface Interface <T1 = SomeType> { }
class Base <T2 = SomeType> { }
class Derived1 extends Base implements Interface { }
// Derived1在语义上等价于Derived2
class Derived2 extends Base<SomeType> implements Interface<SomeType> { }

function foo<T = number>(): void {
  // ...
}
foo();
// 此函数在语义上等价于下面的调用
foo<number>();
// [Start generic_defaultValue]

@Entry
@Component
struct GenericDemoPage {
  @State currentState: string | ResourceStr = $r('app.string.Uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.No_log_information_available');

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
          Text($r('app.string.Realtime_status_information'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.Current_status'))
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
            Text($r('app.string.Log_information'))
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
          Text($r('app.string.Test_GenericTypes')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testGenericTypes();
          this.currentState = $r('app.string.Test_GenericTypes_finish');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}