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
import mediaQuery from '@ohos.mediaquery'
import { INFODATA } from '../mock/InfoData'

@Entry
@Component
struct Index {
  @State flag: number = -1
  @State info: string = ''
  @State isLand: boolean = false
  private listener: mediaQuery.MediaQueryListener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')

  build() {
    Row() {
      Column() {
        Row() {
          Text($r('app.string.entry_MainAbility'))
            .fontSize(30)
            .fontColor('#182431')
            .fontWeight(FontWeight.Medium)

          Blank()
        }
        .height(56)
        .width('90%')
        .padding({ top: 10, left: 8, bottom: 4 })
        .margin({ top: 56, left: 2, bottom: 4 })

        Column() {
          ForEach(INFODATA, (item, index) => {
            Column() {
              if (index !== 0) {
                Divider()
                  .height(0.8)
                  .width('100%')
                  .color('#33182431')
                  .padding({ left: 24, right: 28 })
              }
              Row() {
                Image(item.image)
                  .width(24)
                  .height(20)
                  .margin({ left: 8, right: 16 })
                  .objectFit(ImageFit.Contain)

                Text(item.name)
                  .fontSize(16)

                Blank()
                  .width('30%')

                Text(item.value)
                  .fontSize(14)
                  .fontColor('#182431')
                  .margin({ right: 4 })

                Image($r('app.media.right'))
                  .width(16)
                  .height(18)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .height(56)
              .borderRadius(24)
              .padding({ left: 24, right: 24 })
              .onClick(() => {
                this.info = item.info
                this.flag = item.index
                if (!this.isLand) {
                  router.push({
                    url: item.uri,
                    params: {
                      bool: true
                    }
                  })
                }
              })
            }
          }, item => JSON.stringify(item))
        }
        .width('90%')
        .borderRadius(24)
        .margin({ top: '2%' })
        .backgroundColor(Color.White)
        .padding({ top: 4, bottom: 4 })
      }
      .height('100%')
      .width(this.isLand ? '40%' : '100%')

      if (this.isLand) {
        Divider()
          .vertical(true)
          .strokeWidth(0.8)
          .color('#33182431')
      }

      if (this.isLand) {
        Column() {
          if (this.flag === 0) { // 选择Wlan页面
            this.Component(this.info)
          } else if (this.flag === 1) { // 选择蓝牙页面
            this.Component(this.info)
          } else if (this.flag === 2) { // 选择移动数据页面
            this.Component(this.info)
          }
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff6f6f6')
  }

  // 拉起WindowExtAbility
  @Builder Component(info: string) {
    AbilityComponent({
      want:{
        abilityName: info,
        bundleName: 'ohos.samples.windowextability'
      }
    })
      .width(767)
      .height(805)
  }

  onPortrait(mediaQueryResult) {
    this.isLand = mediaQueryResult.matches
  }

  aboutToAppear() {
    this.listener.on('change', this.onPortrait.bind(this))
  }
}