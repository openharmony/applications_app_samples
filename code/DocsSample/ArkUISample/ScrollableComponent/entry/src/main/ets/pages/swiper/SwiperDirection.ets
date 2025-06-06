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
export struct SwiperDirection {
  private swiperHorizontalController: SwiperController = new SwiperController();
  private swiperVerticalController: SwiperController = new SwiperController();

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwiperPageSwitchMethod_titleHorizontal') }) {
          Column({ space: 8 }) {
            // [Start rotate_horizontally]
            Swiper(this.swiperHorizontalController) {
              // [StartExclude rotate_horizontally]
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
              // [EndExclude rotate_horizontally]
            }
            // [StartExclude rotate_horizontally]
            .height(200)
            // [EndExclude rotate_horizontally]
            .indicator(true)
            .vertical(false)
            // [End rotate_horizontally]

            Row({ space: 12 }) {
              Button('showNext')
                .onClick(() => {
                  this.swiperHorizontalController.showNext(); // 通过controller切换到后一页
                })
              Button('showPrevious')
                .onClick(() => {
                  this.swiperHorizontalController.showPrevious(); // 通过controller切换到前一页
                })
            }.margin(5)
          }
        }

        ComponentCard({ title: $r('app.string.SwiperPageSwitchMethod_titleVertical') }) {
          Column({ space: 8 }) {
            // [Start rotate_vertically]
            Swiper(this.swiperVerticalController) {
              // [StartExclude rotate_vertically]
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
              // [EndExclude rotate_vertically]
            }
            // [StartExclude rotate_vertically]
            .height(200)
            // [EndExclude rotate_vertically]
            .indicator(true)
            .vertical(true)
            // [End rotate_vertically]

            Row({ space: 12 }) {
              Button('showNext')
                .onClick(() => {
                  this.swiperVerticalController.showNext(); // 通过controller切换到后一页
                })
              Button('showPrevious')
                .onClick(() => {
                  this.swiperVerticalController.showPrevious(); // 通过controller切换到前一页
                })
            }.margin(5)
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwiperDirection_title'))
  }
}