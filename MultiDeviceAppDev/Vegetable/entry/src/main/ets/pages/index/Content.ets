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
import { CardGenerator } from '../../common/Card'
import { CardDataFormat } from '../../common/Card'
import { getCardsData } from '../../common/Card'

@Preview
@Component
export struct Content {
  // show 7 cards' infos
  cards: CardDataFormat[] = getCardsData(7)

  build() {
    Column() {
      Text('Vegetables').fontSize(20).fontWeight(FontWeight.Bold).textAlign(TextAlign.Start).width('100%')
      Text('Vegetables are one of the essential foods in people\'s daily diet, which can provide a variety of vitamins, minerals and other nutrients necessary for human body. \nAccording to the statistics of FAO in 1990, 90% of vitamin C and 60% of vitamin for human body come from vegetables.In addition, there are a variety of phytochemicals in vegetables.')
        .textAlign(TextAlign.Start)
        .width('100%')
      GridRow({
        gutter: 10,
        breakpoints: {
          value: ["300vp", "500vp", "700vp", "900vp", "1300vp"],
          reference: BreakpointsReference.WindowSize
        }
      }) {
        ForEach(this.cards, (item: CardDataFormat) => {
          GridCol({
            span: {
              xs: 12,
              sm: 6,
              md: 6,
              lg: 4,
              xl: 4,
              xxl: 4
            }
          }) {
            CardGenerator({ data: item })
          }
        }, item => item.title)
        GridCol({
          span: {
            xs: 12,
            sm: 6,
            md: 6,
            lg: 4,
            xl: 4,
            xxl: 4
          }
        }) {
          Column() {
            Text('More.....')
              .fontWeight(FontWeight.Bold)
              .fontSize(20)
              .textAlign(TextAlign.Start)
              .width('100%')
              .fontColor(Color.Blue)
              .onClick(() => {
                router.push({ url: 'pages/More' })
              })
          }.height(100).justifyContent(FlexAlign.Center).borderWidth(1)
        }
      }
    }.backgroundColor('#1111')
  }
}