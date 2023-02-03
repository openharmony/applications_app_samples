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

import { BoutiqueModel } from '../../model/homeModel'
import { boutiqueData } from '../../data/homeData'

@Component
export struct Boutique {
  @State boutiqueData: Array<BoutiqueModel> = boutiqueData
  @Prop ratio: number

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.boutiqueData[0].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[0].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[0].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[0].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(this.boutiqueData[1].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[1].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[1].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[1].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Row() {
        Column() {
          Text(this.boutiqueData[2].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[2].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[2].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[2].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(this.boutiqueData[3].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[3].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[3].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[3].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Row() {
        Column() {
          Text(this.boutiqueData[4].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[4].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[4].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[4].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text(this.boutiqueData[5].text1)
            .fontSize(15 * this.ratio)
            .fontWeight(FontWeight.Bold)
          Text(this.boutiqueData[5].text2)
            .fontSize(15 * this.ratio)
            .margin(5)
          Row() {
            Image(this.boutiqueData[5].img1)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
            Image(this.boutiqueData[5].img2)
              .width('45%')
              .aspectRatio(0.8)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
        }
        .width('50%')
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
    }
    .width('92%')
  }
}