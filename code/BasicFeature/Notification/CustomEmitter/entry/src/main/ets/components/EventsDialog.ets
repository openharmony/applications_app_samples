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
export struct EventsDialog {
  private customDialogController?: CustomDialogController

  build() {
    Column() {
      Column() {
        Image($r('app.media.product004'))
          .objectFit(ImageFit.Contain)
          .height(300)
          .aspectRatio(1.4)

        Column() {
          Text($r('app.string.shopping'))
            .fontSize(24)
          Text($r('app.string.shopping_advertising'))
            .margin({ top: '100vp' })
            .fontSize(20)
            .opacity(0.6)
        }
        .margin({ top: '10vp' })
      }
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text($r('app.string.close_icon'))
          .fontSize('20vp')
          .textAlign(TextAlign.Center)
          .fontColor('#FFFFFF')
      }
      .position({ x: '85%', y: '3%' })
      .width('12%')
      .aspectRatio(2.4)
      .backgroundColor('rgba(0,0,0,0.3)')
      .borderRadius('18vp')
      .onClick(() => {
        this.customDialogController.close()
      })
    }
    .backgroundColor('#F1F3F5')
    .width('90%')
    .margin(60)
  }
}