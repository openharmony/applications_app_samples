/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import faultLogger from '@ohos.faultLogger'
import Logger from '../model/Logger'

const INDEX: number = 0 // 初始索引值
const DURATION: number = 100 // 定时器时间

@Preview
@CustomDialog
export struct FaultDialog {
  private controller: CustomDialogController
  private faultTypes: string[] = ['JS_CRASH', 'CPP_CRASH', 'FREEZE_CRASH']
  @State selectIndex: number = INDEX

  addFaultLog() {
    switch (this.selectIndex) {
      case 0:
        promptAction.showToast({ message: $r('app.string.js_crash_building') })
        setTimeout(() => {
          let tempList = ['0', '1']
          Logger.info(tempList[3].toString())
        }, DURATION)
        break
      case 1:
        promptAction.showToast({ message: $r('app.string.cpp_crash_building') })
        setTimeout(() => {
          // 此处是为了构造cpp_crash，故意写的有问题的接口调用，因此添加了@ts-ignore
          let module = 'ohos.samples.faultlogger'
          //@ts-ignore
          faultLogger.addFaultLog(0, faultLogger.FaultType.CPP_CRASH, module, 'faultloggertestsummary02')
          router.back()
        }, DURATION)
        break
      case 2:
        promptAction.showToast({ message: $r('app.string.app_freeze_building') })
        setTimeout(() => {
          let index = 0 // 循环初始值
          while (true) {
            index++
            this.selectIndex = index % 2
          }
        }, DURATION)
        break
      default:
        break
    }
  }

  build() {
    Column() {
      Text($r('app.string.select_fault_type'))
        .textAlign(TextAlign.Start)
        .width('100%')
        .fontSize(22)

      Column() {
        ForEach(this.faultTypes, (item, index) => {
          Row() {
            Image(this.selectIndex === index ? $r('app.media.checked') : $r('app.media.uncheck'))
              .height(30).width(30)
              .objectFit(ImageFit.Contain)

            Text(item)
              .padding(10)
              .fontSize(20)
              .fontColor(Color.Black)
          }
          .key(item)
          .width('100%')
          .onClick(() => {
            this.selectIndex = index
          })
        }, item => item)

        Row() {
          Button() {
            Text($r('app.string.sure'))
              .fontColor(Color.Red)
              .width('90%')
              .textAlign(TextAlign.Center)
              .fontSize(20)
          }
          .key('OK')
          .type(ButtonType.Capsule)
          .backgroundColor(Color.White)
          .layoutWeight(1)
          .onClick(() => {
            this.controller.close()
            this.addFaultLog()
          })

          Divider().size({ width: 1, height: 40 }).backgroundColor(Color.Gray)

          Button() {
            Text($r('app.string.cancel'))
              .fontColor('#0D9FFB')
              .width('90%')
              .textAlign(TextAlign.Center)
              .fontSize(20)
          }
          .type(ButtonType.Capsule)
          .backgroundColor(Color.White)
          .layoutWeight(1)
          .onClick(() => {
            this.controller.close()
          })
        }
        .width('100%')
      }
    }
    .padding(16)
  }
}