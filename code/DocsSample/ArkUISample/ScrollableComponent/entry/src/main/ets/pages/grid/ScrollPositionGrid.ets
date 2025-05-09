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
export struct ScrollPosition {
  @State services: Array<string> = ['Live Streaming', 'Imported', 'Categories', 'Recharge',
    'Membership', 'Claim Coupon', 'Lottery', 'Favorites', 'Points', 'More'];
  // [Start build_a_private_scrolling_object]
  private scroller: Scroller = new Scroller();
  // [End build_a_private_scrolling_object]


  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ScrollPosition_titleExample') }) {
          // [Start control_the_grid_scroll]
          Column({ space: 12 }) {
            Grid(this.scroller) {
              // [StartExclude control_the_grid_scroll]
              ForEach(this.services, (service: string) => {
                GridItem() {
                  Text(service)
                }.backgroundColor('#FFF1F3F5').width('25%')
              }, (service: string): string => service)
              // [EndExclude control_the_grid_scroll]
            }
            // [StartExclude control_the_grid_scroll]
            .height(100)
            .columnsGap(10)
            // [EndExclude control_the_grid_scroll]
            .rowsTemplate('1fr')

            Row({ space: 20 }) {
              Button('Previous')
                .onClick(() => {
                  this.scroller.scrollPage({ next: false });
                })

              Button('Next')
                .onClick(() => {
                  this.scroller.scrollPage({ next: true });
                })
            }
          }
          // [End control_the_grid_scroll]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ScrollPosition_title'))
  }
}