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
import { WLANDATA } from '../mock/InfoData'
import { TitleBar, Title, Taggle, Show } from './common/Common'

@Entry
@Component
struct Wlan {
  private isLand: boolean = false

  build() {
    Column() {
      if (this.isLand) {
        TitleBar()
      }

      Title({ title: $r('app.string.wlan') })
      Taggle({ info: $r('app.string.wlan') })

      Show({ info: $r('app.string.connect_wlan') })
        .margin({ left: 24 })

      Row() {
        this.ShowInfo($r('app.string.wlan_index'), $r('app.string.connect'), $r('app.media.wlanLock'))
      }
      .width('95%')
      .height(64)
      .borderRadius(24)
      .padding({ left: 24, right: 24, top: 4, bottom: 4 })
      .backgroundColor(Color.White)

      Show({ info: $r('app.string.available_wlan') })
        .margin({ left: 24 })

      Column() {
        ForEach(WLANDATA, (item) => {
          Row() {
            this.ShowInfo(item.text, item.info, item.img)
          }
          .height(64)
        }, item => JSON.stringify(item))
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

  @Builder ShowInfo(text: Resource, info: Resource, img: Resource) {
    Row() {
      Column() {
        Row() {
          Text(text)
            .fontSize(16)
            .layoutWeight(1)

          Blank()
        }

        Row() {
          Text(info)
            .fontSize(14)
            .layoutWeight(1)

          Blank()
        }
        .margin({ top: 2 })
      }
      .layoutWeight(1)

      Blank()

      Image(img)
        .width(24)
        .height(18)
        .objectFit(ImageFit.Contain)
    }
  }

  aboutToAppear() {
    try {
      this.isLand = router.getParams()['bool']
    } catch (err) {
      this.isLand = false
    }
  }
}