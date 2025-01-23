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
export struct ScrollableGrid {
  @State services: Array<string> = ['Live Streaming', 'Imported', 'Categories', 'Recharge',
    'Membership', 'Claim Coupon', 'Lottery', 'Favorites', 'Points', 'More'];

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ScrollableGrid_titleHorizontal') }) {
          Grid() {
            ForEach(this.services, (service: string) => {
              GridItem() {
                Text(service)
              }.backgroundColor('#FFF1F3F5').width('25%')
            }, (service: string): string => service)
          }
          .height(200)
          .columnsGap(10)
          .rowsGap(15)
          .rowsTemplate('1fr 1fr') // 只设置rowsTemplate属性，当内容超出Grid区域时，可水平滚动。
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ScrollableGrid_title'))
  }
}