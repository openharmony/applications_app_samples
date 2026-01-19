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

// [Start bigInt_object_method1]
// [Start bigInt_object_method2]
import { JSON } from '@kit.ArkTS';
// [StartExclude bigInt_object_method2]
// [StartExclude bigInt_object_method1]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testSerializingBigIntObjects1() {
  // [EndExclude bigInt_object_method1]
  let bigIntObject = BigInt(112233445566778899n)

  console.info(JSON.stringify(bigIntObject)); // 112233445566778899
  // [End bigInt_object_method1]
  if (globalLogUpdate) {
    globalLogUpdate(JSON.stringify(bigIntObject), false);
  }
}

function testSerializingBigIntObjects2() {
  // [EndExclude bigInt_object_method2]
  let bigIntObject = BigInt(112233445566778899n)

  // 错误序列化用法：自定义函数中直接返回BigInt对象
  // 错误案例：JSON.stringify(bigIntObject, (key: string, value: Object): Object =>{ return value; });

  // 正确序列化用法：自定义函数中将BigInt对象预处理为string对象
  let result: string = JSON.stringify(bigIntObject, (key: string, value: Object): Object => {
    if (typeof value === 'bigint') {
      return value.toString();
    }
    return value;
  });
  console.info('result:', result); // result: "112233445566778899"
  // [End bigInt_object_method2]
  let logMsg = 'result: ' + result;
  if (globalLogUpdate) {
    globalLogUpdate(logMsg, false);
  }
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.no_log_info');

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
          Text($r('app.string.status_info_title'))
            .fontSize(18)
            .fontWeight(600)
            .margin({ bottom: 12 })

          Column() {
            Text($r('app.string.current_status'))
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
          Text($r('app.string.test_serializing_bigint_method1')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testSerializingBigIntObjects1();
          this.currentState = $r('app.string.test_serializing_bigint_method1_complete');
        })

        Column() {
          Text($r('app.string.test_serializing_bigint_method2')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testSerializingBigIntObjects2();
          this.currentState = $r('app.string.test_serializing_bigint_method2_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}