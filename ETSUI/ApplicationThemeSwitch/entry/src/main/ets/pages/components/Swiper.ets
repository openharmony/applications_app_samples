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

import { SwiperModel } from '../../models/HomeModel'
import { indexData } from '../../mocks/HomeData'
import { getTheme } from '../../utils/ThemeGet'

@Component
export struct SwiperComponent {
  @Prop ratio: number
  @Prop isLand: boolean
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State swiperData: Array<SwiperModel> = indexData

  build() {
    Column() {
      Swiper() {
        ForEach(this.swiperData, item => {
          Column() {
            Flex({ justifyContent: FlexAlign.Center }) {
              Image(item.img)
                .objectFit(ImageFit.Fill)
                .border({ radius: 20 * this.ratio })
            }
          }
          .clip(true)
          .border({ radius: 20 * this.ratio })
          .margin({ right: this.isLand ? 5 : 0, left: this.isLand ? 5 : 0 })
          .width(this.isLand ? '50%' : '100%')
        }, item => item.toString())
      }
      .margin(2)
      .loop(!this.isLand)
      .autoPlay(!this.isLand)
      .indicator(!this.isLand)
      .disableSwipe(this.isLand)
      .borderRadius(10)
      .padding({ left: 2, right: 2 })
      .margin({ right: this.isLand ? 8 : 16, left: this.isLand ? 20 : 16 })
      .indicatorStyle({ selectedColor: 'red', color: Color.White })
      .displayMode(this.isLand ? SwiperDisplayMode.AutoLinear : SwiperDisplayMode.Stretch)
      .backgroundColor(getTheme(this.theme).MAIN_BACKGROUND_COLOR)
    }
  }
}