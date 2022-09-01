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

import router from '@ohos.router'
import { RESOURCES } from '../mock/InfoData'
import { TitleBar, Title } from './common/Common'

@Entry
@Component
struct MobileData {
  private isLand: boolean = false

  build() {
    Column() {
      if (this.isLand) {
        TitleBar()
      }

      Title({ title: $r('app.string.mobile_network') })

      Column() {
        Row() {
          Text($r('app.string.airplane'))
            .height(48)
            .fontSize(16)
            .fontColor('#182431')

          Blank()

          Toggle({ type: ToggleType.Switch, isOn: false })
            .width(36)
            .height(20)
            .enabled(false)
            .selectedColor('#0D9FFB')
            .switchPointColor(0xe5ffffff)
        }
        .width('100%')
        .borderRadius(24)
        .padding({ left: 24, right: 24 })
        .backgroundColor(Color.White)

        ForEach(RESOURCES, (item) => {
          this.textShow(item)
        }, item => JSON.stringify(item))
      }
      .width('95%')
      .borderRadius(24)
      .margin({ bottom: 8 })
      .padding({ top: 4, bottom: 4 })
      .backgroundColor(Color.White)

      Row() {
        Text($r('app.string.traffic_management'))
          .fontSize(16)
          .fontColor('#182431')
          .layoutWeight(1)

        Blank()

        Image($r('app.media.right'))
          .width(16)
          .height(18)
          .objectFit(ImageFit.Contain)
      }
      .width('95%')
      .borderRadius(24)
      .height(56)
      .padding({ top: 4, bottom: 4, left: 24, right: 24 })
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff6f6f6')
  }

  @Builder textShow(text: string) {
    Row() {
      Text(text)
        .fontSize(16)
        .fontColor('#182431')

      Blank()

      Image($r('app.media.right'))
        .width(16)
        .height(18)
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height(48)
    .padding({ left: 24, right: 24 })
  }

  aboutToAppear() {
    try {
      this.isLand = router.getParams()['bool']
    } catch (err) {
      this.isLand = false
    }
  }
}