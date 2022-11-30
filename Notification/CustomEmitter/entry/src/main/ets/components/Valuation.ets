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

import { COMMENT_DATA } from '../mock/DetailData'

@Component
export struct Valuation {
  build() {
    Column() {
      Row() {
        Text($r('app.string.evaluate'))
          .fontSize(16)
          .fontWeight(500)
        Row() {
          Text($r('app.string.ninety_nine_percent'))
            .fontSize(14)
            .fontWeight(400)
            .fontColor($r('app.color.red'))
          Text($r('app.string.praise'))
            .fontSize(14)
            .fontWeight(400)
            .fontColor($r('app.color.blank'))
            .padding({ right: 10 })
          Image($r('app.media.right'))
            .width(6)
            .height(12)
        }
      }
      .width('100%')
      .margin({ bottom: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        ForEach(COMMENT_DATA, item => {
          Row() {
            Image(item.url)
              .objectFit(ImageFit.Contain)
              .width(40)
              .height(40)
            Column({ space: 6 }) {
              Text(item.user)
                .fontSize(14)
                .fontWeight(500)
                .fontColor($r('app.color.blank'))
              Image(item.img)
                .height(12)
                .width(60)
            }
            .padding({ left: 12 })
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .margin({ bottom: 10 })

          Row() {
            Text(item.text)
              .fontSize(14)
              .fontWeight(400)
              .opacity(0.8)
              .fontColor($r('app.color.blank'))
          }
          .width('100%')
          .margin({ bottom: 12, top: 6 })
        })
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .padding({ top: 12, bottom: 12, right: 16, left: 16 })
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
  }
}