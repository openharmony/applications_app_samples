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

import commonEvent from '@ohos.commonEvent'
import context from '@ohos.application.context'
import settingFeature from '../feature/SettingFeature'
import surveillanceEventsManager from '../module/SurveillanceEventsManager'
import { Header } from '../component/Header'

@Entry
@Component
struct Setting {
  private feature:settingFeature = new settingFeature(getContext() as context.AbilityContext)
  private dataSource: Array<Array<any>> = [
    [commonEvent.Support.COMMON_EVENT_WIFI_POWER_STATE, $r('app.string.enable_wifi')],
    [commonEvent.Support.COMMON_EVENT_SCREEN_OFF, $r('app.string.enable_screen_off')],
    [commonEvent.Support.COMMON_EVENT_SCREEN_ON, $r('app.string.enable_screen_on')]
  ]
  aboutToAppear() {
    this.feature.init()
  }

  build() {
    Column({ space: 8 }) {
      Header({src: 'settingTitle.png'})
      Column() {
        ForEach(this.dataSource, (item: Array<any>) => {
          Column() {
            Text(item[1])
              .width('100%')
              .height('20%')
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .fontColor(0x000000)
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Column() {
                Text($r('app.string.always')).fontSize(14)
                Radio({ value: 'always', group: item[0] })
                  .checked(this.feature.checkStateForAlways(item[0]))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToAlways(item[0])
                    }
                  })
              }
              Divider().vertical(true).margin(20).height(20)
              Column() {
                Text($r('app.string.once')).fontSize(14)
                Radio({ value: 'once', group: item[0] })
                  .checked(this.feature.checkStateForOnce(item[0]))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToOnce(item[0])
                    }
                  })
              }
              Divider().vertical(true).margin(20).height(20)
              Column() {
                Text($r('app.string.never')).fontSize(14)
                Radio({ value: 'never', group: item[0] })
                  .checked(this.feature.checkStateForNever(item[0]))
                  .height(20)
                  .width(20)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.feature.changeStateToNever(item[0])
                    }
                  })
              }
            }.padding({ top: 10 })
            .backgroundColor(0xfbfafb)
            .borderRadius(10)
            .opacity(0.8)
          }
          .height('15%')
          .width('100%')
        })
      }.width('90%')
      .height('100%')
      .position({ x: '5%', y: '10%' })
    }.backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
    .width('100%')
    .height('100%')
  }
}