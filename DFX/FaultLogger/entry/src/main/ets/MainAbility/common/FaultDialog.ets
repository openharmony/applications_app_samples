/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import prompt from '@ohos.prompt'
import router from '@ohos.router'
import faultLogger from '@ohos.faultLogger'

@Preview
@CustomDialog
export struct FaultDialog {
  private controller: CustomDialogController
  private faultTypes: string[] = ['JS_CRASH', 'CPP_CRASH', 'FREEZE_CRASH']
  @State selectIndex: number = 0

  addFaultLog() {
    switch (this.selectIndex) {
      case 0:
        prompt.showToast({ message: '异常构造中...' })
        setTimeout(() => {
          let tempList = ['0', '1']
          console.info(tempList[3].toString())
        }, 100)
        break
      case 1:
        prompt.showToast({ message: '异常构造中,完成后应用会自动退出，请重新进入应用抓取异常信息' })
        setTimeout(() => {
          // 此处是为了构造cpp_crash，故意写的有问题的接口调用，因此添加了@ts-ignore
          let module = "ohos.samples.faultlogger";
          // @ts-ignore
          faultLogger.addFaultLog(0, faultLogger.FaultType.CPP_CRASH, module, "faultloggertestsummary02 ")
          router.back()
        }, 100)
        break
      case 2:
        prompt.showToast({ message: '异常构造中,会出现冻屏，请退出应用后重新进入应用抓取异常信息' })
        setTimeout(() => {
          let index = 0
          while (true) {
            index++
            this.selectIndex = index % 2
          }
        }, 100)
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