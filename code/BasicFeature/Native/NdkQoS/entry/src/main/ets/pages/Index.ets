/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'QoS Sample';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('High level QoS test', {type: ButtonType.Normal})
          .margin({top: 50})
          .height('6%')
          .width('50%')
          .borderRadius(8)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#aabbcc')
          .onClick(() => {
            let ret: string = testNapi.useHighQos().toString();
            AlertDialog.show({
              title: this.message,
              message: "High-level QoS calculation time: " + ret + " ms",
              alignment: DialogAlignment.Center,
              confirm: {
                value: "OK",
                action: () => {
                  console.log("High-QoS done")
                }
              }
            })
          })

        Button('Low level QoS test', {type: ButtonType.Normal})
          .margin({top: 50})
          .height('6%')
          .borderRadius(8)
          .width('50%')
          .backgroundColor('#aabbcc')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let ret: string = testNapi.useLowQos().toString();
            AlertDialog.show({
              title: this.message,
              message: "Low-level QoS calculation time: " + ret + " ms",
              alignment: DialogAlignment.Center,
              confirm: {
                value: "OK",
                action: () => {
                  console.log("Low-QoS done")
                }
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
