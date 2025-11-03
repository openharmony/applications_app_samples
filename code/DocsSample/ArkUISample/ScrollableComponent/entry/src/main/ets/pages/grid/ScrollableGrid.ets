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
import common from '@ohos.app.ability.common';
// [Start build_scrollable_horizontally_grid_layouts]
@Entry
@Component
export struct ScrollableGrid {
  @State services: Array<string> = [];
  // [StartExclude build_scrollable_horizontally_grid_layouts]
  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const streaming = context.resourceManager.getStringByNameSync('Live_Streaming')
    this.services.push(streaming)
    const imported = context.resourceManager.getStringByNameSync('Imported')
    this.services.push(imported)
    const categories = context.resourceManager.getStringByNameSync('Categories')
    this.services.push(categories)
    const recharge = context.resourceManager.getStringByNameSync('Recharge')
    this.services.push(recharge)
    const membership = context.resourceManager.getStringByNameSync('Membership')
    this.services.push(membership)
    const claim = context.resourceManager.getStringByNameSync('Claim_Coupon')
    this.services.push(claim)
    const lottery = context.resourceManager.getStringByNameSync('Lottery')
    this.services.push(lottery)
    const favorites = context.resourceManager.getStringByNameSync('Favorites')
    this.services.push(favorites)
    const points = context.resourceManager.getStringByNameSync('Points')
    this.services.push(points)
    const more = context.resourceManager.getStringByNameSync('More')
    this.services.push(more)
  }
  // [EndExclude build_scrollable_horizontally_grid_layouts]
  build() {
    // [StartExclude build_scrollable_horizontally_grid_layouts]
    NavDestination() {
      // [EndExclude build_scrollable_horizontally_grid_layouts]

      Column({ space: 5 }) {
        // [StartExclude build_scrollable_horizontally_grid_layouts]
        ComponentCard({ title: $r('app.string.ScrollableGrid_titleHorizontal') }) {
          // [EndExclude build_scrollable_horizontally_grid_layouts]

          Grid() {
            ForEach(this.services, (service: string, index) => {
              GridItem() {
              }
              .width('25%')
            }, (service: string): string => service)
          }
          .rowsTemplate('1fr 1fr') // 只设置rowsTemplate属性，当内容超出Grid区域时，可水平滚动。
          .rowsGap(15)

          // [StartExclude build_scrollable_horizontally_grid_layouts]
          .height(200)
          .columnsGap(10)
          // [EndExclude build_scrollable_horizontally_grid_layouts]
        }
      }
      // [StartExclude build_scrollable_horizontally_grid_layouts]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })

    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ScrollableGrid_title'))
  }
  // [EndExclude build_scrollable_horizontally_grid_layouts]
}
// [End build_scrollable_horizontally_grid_layouts]