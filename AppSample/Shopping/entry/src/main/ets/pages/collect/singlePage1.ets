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
export struct SinglePage1 {
  @Prop ratio: number
  @State collectData: CollectModel = collectData
  @State collected: boolean = false

  build() {
    Column() {
      Row() {
        Row() {
          Row() {
            Text($r('app.string.singText1'))
              .fontSize(13 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .alignItems(VerticalAlign.Center)

          Row() {
            Text($r('app.string.singText2'))
              .fontSize(13 * this.ratio)
            Image('/resources/icon/sort-down.png')
              .width(10)
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
          }
          .alignItems(VerticalAlign.Center)

          Row() {
            Text($r('app.string.singText3'))
              .fontSize(13 * this.ratio)
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

      Column() {
        Row() {
          Image(this.collectData.src)
            .width('40%')
            .height('100%')
            .objectFit(ImageFit.Contain)
            .border({ radius: 10 * this.ratio })
          Row() {
            Column() {
              Text(this.collectData.name)
                .fontSize(15 * this.ratio)
                .fontWeight(FontWeight.Bolder)
                .lineHeight(25 * this.ratio)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('55%')
              Text(this.collectData.collect)
                .fontSize(13 * this.ratio)
                .margin({ top: 10 })
              Text(this.collectData.price)
                .fontSize(15 * this.ratio)
                .fontWeight(FontWeight.Bolder)
                .fontColor(Color.Red)
                .margin({ top: 5 })
            }
            .margin({ left: 10 })
            .padding({ right: 2 })
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .height('100%')
        }
        .padding({ left: 10, right: 10 })
        .backgroundColor(Color.White)
        .border({ radius: 10 * this.ratio })
      }
      .margin({ top: 10 })
      .height('20%')
      .width('100%')
    }
  }
}