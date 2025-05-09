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
export struct SwiperMultiPage {
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.SwiperMultiPage_titleExample') }) {
          // [Start each_page_displays_multiple_subpages]
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
            Text('3')
              .width('90%')
              .height('100%')
              .backgroundColor(Color.Yellow)
              .textAlign(TextAlign.Center)
              .fontSize(30)
          }
          // [StartExclude each_page_displays_multiple_subpages]
          .height(200)
          // [EndExclude each_page_displays_multiple_subpages]
          .indicator(true)
          .displayCount(2)
        }
        // [End each_page_displays_multiple_subpages]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.SwiperMultiPage_title'))
  }
}