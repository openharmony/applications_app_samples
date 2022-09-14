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

@CustomDialog
export struct mainDialog {
  private controller: CustomDialogController

  build() {
    Column() {
      Text($r('app.string.mainDialog_inputText'))
        .fontSize(16)
        .fontFamily('HarmonyHeiTi')
        .fontColor(Color.White)
      Row() {
        Button({ stateEffect: false }) {
          Text($r('app.string.mainDialog_know'))
            .fontColor('#5291FF')
            .fontSize(17)
        }
        .layoutWeight(7)
        .backgroundColor('#2F2F30')
        .margin(5)
        .onClick(() => {
          this.controller.close()
        })

      }
      .width('100%')
      .margin({ top: '2%' })
    }
    .width('26%')
    .padding({ top: '3%', left: '2%', right: '2%', bottom: '2%' })
    .borderRadius(24)
    .backgroundColor('#2F2F30')
  }
}