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
import { Header } from '../component/Header'

@Entry
@Component
struct Detail {
  private arr: Array<string> = router.getParams()['recEvents']
  private filteredArr: Array<string> = router.getParams()['onceEvents']

  build() {
    Column() {
      Header({src: 'detailTitle.png'})
      Column() {
        List({ space: 10, initialIndex: 0 }) {
          ForEach(this.arr, (item) => {
            ListItem() {
              Text(item).size({ width: '100%', height: '100%' })
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .fontColor(0x000000)
            }
            .backgroundColor(0xFFFFFF)
            .borderRadius(10)
            .opacity(0.8)
            .size({ width: '100%', height: '8%' })
          })
        }
        .listDirection(Axis.Vertical)
        .edgeEffect(EdgeEffect.None)
        .chainAnimation(false)
        .width('90%')
        .margin(10)
      }.size({ width: '90%', height: '70%' })
      .backgroundColor(0xfbfafb)
      .opacity(0.8)
      .position({ x: '5%', y: '10%' })
      .borderRadius(10)
      Column() {
        Text($r('app.string.once_tips')).size({ width: '100%', height: '30%' })
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .fontColor(0x000000)
        ForEach(this.filteredArr, (item) => {
          Text(item).size({ width: '100%', height: '20%' })
            .fontSize(14)
            .textAlign(TextAlign.Center)
            .fontColor(0x000000)
        })
      }.size({ width: '90%', height: '15%' })
      .backgroundColor(0xfbfafb)
      .opacity(0.8)
      .position({ x: '5%', y: '82%' })
      .borderRadius(10)
    }.size({ width: '100%', height: '100%' })
    .backgroundImage($rawfile('vbg720.png'))
    .backgroundImageSize(ImageSize.Contain)
  }
}