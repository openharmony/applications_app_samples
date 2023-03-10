/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { INDEX_DATA } from '../../mocks/ProductsData'

@Component
export struct SwiperComponent {
  @StorageLink('theme') theme: number = -1 // 初始主题theme值
  @State swiperData: Array<SwiperModel> = indexData
  @StorageProp('curBp') curBp: string = 'md'

  build() {
    Swiper() {
      ForEach(INDEX_DATA, item => {
        Image(item.img)
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')
          .borderRadius(16)
      })
    }
    .padding({ left: 12, right: 12 })
    .height(170)
    .autoPlay(true)
    .itemSpace(20)
    .displayCount(this.curBp === 'sm' ? 1 : this.curBp === 'md' ? 2 : 3)
    .indicatorStyle({
      selectedColor: $r('app.color.red'),
      color: $r('app.color.white')
    })
  }
}