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

import { ORDER_DATA } from '../../mock/ProductsData'

@Component
export struct MyOrderComponent {
  @StorageProp('curBp') curBp: string = 'sm'

  build() {
    Column() {
      Row() {
        Text($r('app.string.orders'))
          .fontSize(16)
        Blank()
        Row() {
          Text($r('app.string.all_order'))
            .fontSize(14)
            .opacity(0.6)
          Image($r('app.media.arrows_right'))
            .width(12)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
      }
      .padding({ left: 12, right: 12 })
      .width('100%')

      Row() {
        ForEach(ORDER_DATA, item => {
          Column() {
            Image(item.img)
              .aspectRatio(1)
              .width(28)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })
            Text(item.title)
              .fontSize(12)
          }
          .layoutWeight(1)
        }, item => item.id.toString())
      }
      .width('100%')
      .margin({ top: 14 })
    }
    .padding({ left: 12, right: 12, top: 16, bottom: 16 })
    .border({ radius: 16 })
    .backgroundColor($r('app.color.white'))
    .margin({ top: 12 })
  }
}