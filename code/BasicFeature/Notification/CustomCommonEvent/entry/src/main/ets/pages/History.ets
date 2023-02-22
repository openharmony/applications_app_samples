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

import common from '@ohos.app.ability.common'
import historyFeature from '../feature/HistoryFeature'
import { Header } from '../component/Header'

@Entry
@Component
struct History {
  private feature: historyFeature = new historyFeature(getContext() as common.UIAbilityContext)
  @State arr: Array<Array<string>> = []

  async onPageShow() {
    this.feature.getData().then((data: Array<Array<string>>) => {
      this.arr = data
    })
  }

  build() {
    Column() {
      Header({src: 'historyTitle.png'})
      Column() {
        List({ space: 10, initialIndex: 0 }) {
          ForEach(this.arr, (item: Array<string>, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text($r('app.string.start_time')).size({ width: '30%', height: '100%' })
                    .fontSize(16)
                    .textAlign(TextAlign.Start)
                    .fontColor(0x000000)
                  Text(item[0]).size({ width: '70%', height: '100%' })
                    .fontSize(16)
                    .textAlign(TextAlign.Start)
                    .fontColor(0x000000)
                }.size({ width: '80%', height: '30%' })
                Row() {
                  Text($r('app.string.end_time')).size({ width: '20%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                  Text(item[1]).size({ width: '80%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                }.size({ width: '80%', height: '20%' })
                Row() {
                  Text($r('app.string.total_time')).size({ width: '20%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                  Text(item[2]).size({ width: '80%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                }.size({ width: '80%', height: '20%' })
                Row() {
                  Text($r('app.string.total_interrupt')).size({ width: '20%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                  Text(item[3]).size({ width: '80%', height: '100%' })
                    .fontSize(12)
                    .textAlign(TextAlign.Center)
                    .fontColor(0x000000)
                }.size({ width: '80%', height: '20%' })
              }
            }.size({ width: '100%', height: '18%' })
            .backgroundColor(0xFFFFFF)
            .borderRadius(10)
            .opacity(0.8)
          })
        }
        .listDirection(Axis.Vertical)
        .chainAnimation(false)
        .width('90%')
        .margin(10)
      }
      .size({ width: '90%', height: '85%' })
      .backgroundColor(0xfbfafb)
      .opacity(0.8)
      .position({ x: '5%', y: '10%' })
      .borderRadius(10)
    }.size({ width: '100%', height: '100%' })
    .backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
  }
}