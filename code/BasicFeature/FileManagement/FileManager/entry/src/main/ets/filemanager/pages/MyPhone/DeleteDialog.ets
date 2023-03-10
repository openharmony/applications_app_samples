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

// 用户输入名字的弹窗
@CustomDialog
export struct DeleteDialog {
  controller: CustomDialogController
  confirm: () => void

  build() {
    Column() {
      Text($r('app.string.label_is_delete'))
        .fontSize(20)
        .margin({ bottom: 20 })

      Row() {
        Text($r('app.string.label_delete'))
          .fontSize(20)
          .fontColor(Color.Red)
          .flexGrow(1)
          .padding({ top: 8, bottom: 8 })
          .onClick(() => {
            this.confirm()
          })

        Text($r('app.string.label_cancel'))
          .fontSize(20)
          .fontColor(Color.Gray)
          .padding({ top: 8, bottom: 8 })
          .onClick(() => {
            this.controller.close()
          })
      }
      .width(200)
    }
    .width('100%')
    .padding(20)
    .borderRadius(20)
    .backgroundColor(Color.White)
  }
}