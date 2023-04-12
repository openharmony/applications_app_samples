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

import router from '@ohos.router'
import { FIND_SEARCH_TEXT_DATA } from '../../mock/ProductsData'

@Component
export struct TitleBarComponent {

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap }) {
        Row() {
          Image($r('app.media.logo'))
            .width(24)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
          Image($r('app.media.scan_code'))
            .width(24)
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.push({
                url: 'pages/ScanPage'
              })
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Image($r('app.media.search'))
            .objectFit(ImageFit.Contain)
            .width(20)
            .aspectRatio(1)
          Swiper() {
            ForEach(FIND_SEARCH_TEXT_DATA, item => {
              Column() {
                Text(item.searchText)
                  .opacity(0.6)
                  .fontColor($r('app.color.blank'))
                  .fontSize(14)
                  .fontFamily('HarmonyHeiTi')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }, item => item.searchText.toString())
          }
          .loop(true)
          .autoPlay(true)
          .vertical(true)
          .indicator(false)
          .interval(2000)
          .padding(12)
        }
        .zIndex(2)
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .margin({ top: 8, bottom: 12 })
        .padding({left: 12, right: 12})
        .backgroundColor($r('app.color.white'))
        .border({ width: 2, color: $r('app.color.white'), radius: 40 })
      }
      .margin({ top: 12 })
      .padding({ left: 12, right: 12 })
    }
    .width('100%')
  }
}