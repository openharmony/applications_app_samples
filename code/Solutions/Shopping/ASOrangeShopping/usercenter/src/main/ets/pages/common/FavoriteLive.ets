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

import { FAVOR_LIVE_LIST_DATA } from '../../data/UserCenterData';

@Component
export struct FavoriteLive {
  @StorageProp('curBp') curBp: string = 'sm';

  build() {
    GridRow({ columns: { sm: 4, md: 8, lg: 12 }, gutter: { x: vp2px(8), y: vp2px(12) } }) {
      GridCol({ span: { sm: 4, md: 8, lg: 12 } }) {
        Row() {
          Text($r('app.string.often_see_live'))
            .fontSize(16)
            .fontWeight(500)
            .margin({ left: 12 })
          Blank()
          Row() {
            Text($r('app.string.see_more'))
              .fontSize(14)
              .opacity(0.6)
            Image($r('app.media.arrows_right'))
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .width(this.curBp === 'sm' ? 12 : this.curBp === 'md' ? 14 : 16)
          }
        }
        .width('100%')
        .padding({ top: 4 })
      }

      ForEach(FAVOR_LIVE_LIST_DATA, item => {
        GridCol({ span: { sm: 2, md: 4, lg: 4 } }) {
          Stack({ alignContent: Alignment.TopStart }) {
            Image(item.imgSrc)
              .objectFit(ImageFit.Cover)
            Row() {
              Text(item.title)
                .fontSize(10)
                .fontColor($r('app.color.white'))
                .borderRadius(10)
                .backgroundColor($r('app.color.pink'))
                .padding({ left: 6, right: 6, bottom: 2, top: 2 })

              Text(item.viewsInfo)
                .fontSize(10)
                .margin({ left: 6 })
                .fontColor($r('app.color.white'))
            }
            .borderRadius(10)
            .padding({ right: 6 })
            .margin({ left: 12, top: 12 })
            .backgroundColor($r('app.color.point'))
          }
          .width('100%')
        }
      })
    }
    .padding({ left: 12, right: 12, bottom: 12 })
  }
}