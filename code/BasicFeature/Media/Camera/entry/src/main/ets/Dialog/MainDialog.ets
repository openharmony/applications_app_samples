/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@CustomDialog
export struct mainDialog {
  controller: CustomDialogController;

  async aboutToAppear() {
    console.info(`Camera aboutToAppear entry`);
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.ALLOW_WLAN'))
          .fontSize(16)
          .fontFamily('HarmonyHeiTi')
          .fontColor('#182431')
          .width('100%')
          .fontWeight(500)
          .textAlign(TextAlign.Start)
        Text($r('app.string.CLOSE_WLAN'))
          .fontSize(10)
          .opacity(0.6)
          .textAlign(TextAlign.Start)
          .width('100%')
          .fontFamily('HarmonyHeiTi')
          .fontColor('#182431')
          .fontWeight(400)
          .margin({ top: 2 })
      }

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Auto }) {
        Button() {
          Text($r('app.string.WLAN_AND_CELLULAR'))
            .fontColor($r('app.color.theme_color'))
            .fontSize(14)
            .width('100%')
            .fontWeight(500)
            .height('30%')
            .textAlign(TextAlign.Center)
        }
        .backgroundColor('#FFF')
        .onClick(() => {
          this.controller.close();
        })

        Button() {
          Text($r('app.string.ONLY_WLAN'))
            .fontColor($r('app.color.theme_color'))
            .fontSize(14)
            .fontWeight(500)
            .width('100%')
            .height('30%')
            .textAlign(TextAlign.Center)
        }
        .backgroundColor('#FFF')
        .onClick(() => {
          this.controller.close();
        })

        Button() {
          Text($r('app.string.NOT_ALLOW'))
            .fontColor($r('app.color.theme_color'))
            .fontSize(14)
            .fontWeight(500)
            .width('100%')
            .height('30%')
            .textAlign(TextAlign.Center)
        }
        .backgroundColor('#FFF')
        .onClick(() => {
          this.controller.close();
        })
      }
      .margin({ top: 10 })
      .height('80%')
      .backgroundColor('#FFF')
    }
    .width('750px')
    .height('700px')
    .padding({
      top: '3%',
      left: '2%',
      right: '2%',
      bottom: '2%'
    })
    .borderRadius(24)
    .backgroundColor('#FFF')
  }
}
