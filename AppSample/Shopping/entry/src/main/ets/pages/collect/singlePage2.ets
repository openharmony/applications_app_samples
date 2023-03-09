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

import { collectData } from '../../data/collectData'
import { CollectModel } from '../../model/collectModel'

@Component
export struct SinglePage2 {
  @Prop ratio: number
  @State collectData: CollectModel = collectData

  build() {
    Column() {
      Row() {
        Row() {
          Row() {
            Text($r('app.string.singText1'))
              .fontSize(12 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .alignItems(VerticalAlign.Center)

          Row() {
            Text($r('app.string.singText2'))
              .fontSize(12 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .alignItems(VerticalAlign.Center)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .width('45%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)
      .border({ radius: 5 })
      .padding(10)

      Row() {
        Column() {
          Text($r('app.string.singText4'))
            .fontSize(15 * this.ratio)
            .margin({ top: 10, bottom: 10 })
          Text($r('app.string.singText3'))
            .fontSize(15 * this.ratio)
            .margin({ top: 10, bottom: 10 })
        }
        .width('25%')
        .height('100%')
        .backgroundColor('#dfe5e3')
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 10 })

        Column() {
          Row() {
            Column() {
              Image(this.collectData.src)
                .width('20%')
                .height('8%')
                .objectFit(ImageFit.Contain)
                .border({ radius: 5 * this.ratio })
                .margin({ bottom: 5 })
              Text(this.collectData.price)
                .fontSize(12 * this.ratio)
                .fontColor(Color.Red)
                .width('20%')
                .textAlign(TextAlign.Center)
            }
            .alignItems(HorizontalAlign.Start)
            .padding(10)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .width('75%')
        .height('100%')
        .backgroundColor(Color.White)
      }
    }
  }
}