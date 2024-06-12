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

import { router } from '@kit.ArkUI';

@Entry
@Component
struct ReturnMainPage {
  @State inputTxt: string = '';

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image($r('app.media.arrow'))
          .height(44)
          .width(44)
          .onClick(() => {
            router.back();
          })
        Text($r('app.string.scenarioization'))
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(22)
          .margin({ left: '2.4%' })
      }.margin({ top: '2.8%', left: '4.9%' })

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image($r('app.media.style'))
          .height('48%')
          .width('56%')
      }.margin({ top: '19.8%' })

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column() {
          Row() {
            Button($r('app.string.returnMainPage'))
              .type(ButtonType.Normal)
              .borderRadius(25)
              .fontColor($r('app.color.cancelBtnColor'))
              .backgroundColor($r('app.color.mainInterface'))
              .fontSize(18)
              .height('7.8%')
              .width('38.2%')
              .onClick(() => {
                router.back();
              })
          }
        }
      }.margin({ top: '44.6%' })
    }
    .backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}