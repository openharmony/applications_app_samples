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
export struct SinglePage3 {
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

          Row() {
            Text($r('app.string.singText3'))
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
        .width('75%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)
      .border({ radius: 5 })
      .padding(10)

      Row() {
        Image(this.collectData.src)
          .width('32%')
          .height('16%')
          .objectFit(ImageFit.Contain)
          .border({ radius: 10 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 10 })
    }
  }
}