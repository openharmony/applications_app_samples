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
import { TitleBar, Title, Taggle, Show } from './common/Common'

@Entry
@Component
struct Bluetooth {
  private isLand: boolean = false

  build() {
    Column() {
      if (this.isLand) {
        TitleBar()
      }

      Title({ title: $r('app.string.bluetooth') })
      Taggle({ info: $r('app.string.bluetooth') })

      Row() {
        Text($r('app.string.device_found'))
          .fontSize(14)
          .fontColor('#182431')

        Blank()
          .width('87%')
      }
      .opacity(0.6)
      .height(48)
      .margin({ bottom: 8, left: 24 })

      Row() {
        Text($r('app.string.device_name'))
          .fontSize(16)
          .fontColor('#182431')
          .layoutWeight(1)

        Blank()

        Text($r('app.string.phone'))
          .fontSize(16)
          .fontColor('#182431')
          .margin({ right: 4 })

        Image($r('app.media.right'))
          .width(16)
          .height(18)
          .objectFit(ImageFit.Contain)
      }
      .width('95%')
      .height(56)
      .borderRadius(24)
      .padding({ top: 4, bottom: 4, left: 24, right: 24 })
      .backgroundColor(Color.White)

      Show({ info: $r('app.string.connect_device') })
        .margin({ left: 24 })

      Column() {
        this.deviceShow($r('app.media.phone'), $r('app.string.my_pc'), $r('app.media.setting'))
        this.deviceShow($r('app.media.phone'), $r('app.string.standby_machine'), $r('app.media.setting'))
      }
      .width('95%')
      .borderRadius(24)
      .padding({ top: 4, bottom: 4, left: 24, right: 24 })
      .backgroundColor(Color.White)

      Show({ info: $r('app.string.use_device') })
        .margin({ left: 24 })

      Column() {
        this.deviceShow($r('app.media.watch'), $r('app.string.smart_watch'), null)
        this.deviceShow($r('app.media.computer'), $r('app.string.my_pc'), null)
        this.deviceShow($r('app.media.earphone'), $r('app.string.my_earphones'), null)
      }
      .width('95%')
      .borderRadius(24)
      .padding({ top: 4, bottom: 4, left: 24, right: 24 })
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff6f6f6')
  }

  @Builder deviceShow(device: Resource, info: Resource, img: Resource) {
    Row() {
      Row() {
        Image(device)
          .width(24)
          .height(20)
          .margin({ right: 18 })
          .objectFit(ImageFit.Contain)

        Text(info)
          .fontSize(16)
      }
      .layoutWeight(1)

      Blank()

      Image(img)
        .width(24)
        .height(20)
        .objectFit(ImageFit.Contain)
    }
    .height(48)
    .width('100%')
  }

  aboutToAppear() {
    try {
      this.isLand = router.getParams()['bool']
    } catch (err) {
      this.isLand = false
    }
  }
}