/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { FavoriteLive } from './common/FavoriteLive';
import { MyOrder } from '../pages/common/MyOrder';
import { RewardSection } from '../pages/common/RrewardSection';
import { ServiceSection } from '../pages/common/ServiceSection';
import { UserInformation } from './common/UserInformation';

@Entry
@Component
struct Index {
  @StorageProp('curBp') curBp: string = 'sm';

  build() {
    Column() {
      Scroll() {
        GridRow({ columns: { sm: 4, md: 8, lg: 12 }, gutter: { x: vp2px(8), y: vp2px(12) } }) {
          GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
            UserInformation()
          }

          GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
            MyOrder()
          }

          GridCol({ span: { sm: 4, md: 4, lg: 12 } }) {
            RewardSection()
          }

          GridCol({ span: { sm: 4, md: 4, lg: 12 } }) {
            ServiceSection()
          }

          GridCol({ span: { sm: 4, md: 4, lg: 12 } }) {
            FavoriteLive()
          }
        }
        .padding({ left: 12, right: 12, bottom: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .constraintSize({ minHeight: '100%' })
      .backgroundImageSize({ width: '100%', height: '25%' })
      .backgroundImage($r('app.media.mask'), ImageRepeat.NoRepeat)

      Divider()
        .color(Color.Gray)
        .height(0.5)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.background'))
  }
}