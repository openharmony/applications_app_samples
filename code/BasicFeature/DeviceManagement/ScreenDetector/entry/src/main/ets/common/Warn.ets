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
export struct Warn {
  private errMsg?: Resource
  private limit?: string
  private dialogController?: CustomDialogController

  @Builder infoText(msg: Resource, limit: string) {
    Row() {
      Text(msg)
        .margin({ left: 5 })
        .fontSize(18)
      Text(limit)
        .fontSize(18)
    }
    .margin(5)
  }

  build() {
    Column() {
      Text($r('app.string.warning'))
        .margin(10)
        .fontSize(20)

      Column() {
        this.infoText(this.errMsg, this.limit)
      }
      .padding(5)
      .width('100%')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Start)
    }
    .padding(5)
    .width('100%')
    .borderRadius(10)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.dialogController.close()
    })
  }
}