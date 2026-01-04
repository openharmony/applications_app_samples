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

// [Start float_number]
import { JSON } from '@kit.ArkTS';
// [StartExclude float_number]
let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testSerializingFloatingPointNumbers() {
  // [EndExclude float_number]
  // 序列化小数部分不为零的浮点数，可以正常序列化。
  let floatNumber1 = 10.12345;
  console.info(JSON.stringify(floatNumber1)); // 10.12345

  // 序列化小数部分为零的浮点数，为保持数值的简洁表示，会丢失小数部分的精度。
  let floatNumber2 = 10.00;
  console.info(JSON.stringify(floatNumber2)); // 10

  // 以下是防止浮点数精度丢失的方法：
  let result = JSON.stringify(floatNumber2, (key: string, value: Object): Object => {
    if (typeof value === 'number') {
      // 按照业务场景需要，定制所需的固定精度。
      return value.toFixed(2);
    }
    return value;
  });
  console.info(result); // "10.00"
  // [End float_number]
  let logMsg = 'JSON.stringify(floatNumber1): ' + JSON.stringify(floatNumber1) + '\n' +
    'JSON.stringify(floatNumber2): ' + JSON.stringify(floatNumber2) + '\n' + 'result: ' + result;
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
          Text($r('app.string.test_serializing_floating_point')).fontColor(Color.Black).fontSize(14);
        }
        .backgroundColor(Color.White)
        .borderRadius(20)
        .width('90%')
        .height(32)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 12 })
        .onClick(() => {
          testSerializingFloatingPointNumbers();
          this.currentState = $r('app.string.test_serializing_floating_point_complete');
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
      .padding(16);
    }
  }
}