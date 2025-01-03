/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct SwiperIndicatorStyle {
  build() {
    NavDestination() {
      Column({ space: 12 }) {

        ComponentCard({ title: $r('app.string.SwiperIndicatorStyle_titleDefault') }) {
          Swiper() {
            Text('0')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Gray)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('1')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Green)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('2')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Pink)
              .textAlign(TextAlign.Center)
              .fontSize(30)
          }
          .height(100)
        }

        ComponentCard({ title: $r('app.string.SwiperIndicatorStyle_titleCustom') }) {
          Swiper() {
            Text('0')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Gray)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('1')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Green)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('2')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Pink)
              .textAlign(TextAlign.Center)
              .fontSize(30)
          }
          .height(100)
          .indicator(
            Indicator.dot()
              .left(0)
              .itemWidth(15)
              .itemHeight(15)
              .selectedItemWidth(30)
              .selectedItemHeight(15)
              .color(Color.Red)
              .selectedColor(Color.Blue)
          )
        }

        ComponentCard({ title: $r('app.string.SwiperIndicatorStyle_titleDefaultArrows') }) {
          Swiper() {
            Text('0')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Gray)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('1')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Green)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('2')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Pink)
              .textAlign(TextAlign.Center)
              .fontSize(30)
          }
          .height(100)
          .displayArrow(true, false)
        }

        ComponentCard({ title: $r('app.string.SwiperIndicatorStyle_titleCustomArrows') }) {
          Swiper() {
            Text('0')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Gray)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('1')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Green)
              .textAlign(TextAlign.Center)
              .fontSize(30)

            Text('2')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Pink)
              .textAlign(TextAlign.Center)
              .fontSize(30)
          }
          .height(100)
          .displayArrow({
            showBackground: true,
            isSidebarMiddle: true,
            backgroundSize: 24,
            backgroundColor: Color.White,
            arrowSize: 18,
            arrowColor: Color.Blue
          }, false)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwiperIndicatorStyle_title'))
  }
}