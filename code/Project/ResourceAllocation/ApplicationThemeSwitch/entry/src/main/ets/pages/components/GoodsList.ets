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

import { getTheme } from '../../utils/ThemeGet'
import { PRODUCT_DATA } from '../../mocks/ProductsData'

@Component
export struct GoodsList {
  @StorageLink('theme') theme: number = -1 // 初始主题theme值

  build() {
    GridRow({ gutter: { x: vp2px(8), y: vp2px(8) }, }) {
      ForEach(PRODUCT_DATA, item => {
        GridCol({ span: { sm: 6, md: 6, lg: 4 } }) {
          Column() {
            // 此处的商品图片需要根据父组件的宽度而变化，这里使用65%
            Image(item.uri)
              .width('70%')
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .margin({ bottom: 12 })

            Column() {
              Text(item.title)
                .width('100%')
                .fontSize(14)
                .fontColor(getTheme(this.theme).DEFAULT_COLOR)
              Text(item.info)
                .width('100%')
                .fontSize(14)
                .margin({ top: 6 })
                .fontColor(getTheme(this.theme).DEFAULT_COLOR)
              Text(item.price)
                .fontSize(16)
                .margin({ top: 6 })
                .offset({ x: -3 }) // 因为￥是中文字符，上面的xx是中文字符，占的宽度不一样，所以需要对齐，添加offset
                .fontColor(getTheme(this.theme).DEFAULT_COLOR)
              Column() {
                Text(item.labels)
                  .fontSize(10)
                  .fontColor(getTheme(this.theme).DEFAULT_COLOR)
              }
              .borderRadius(6)
              .padding({ left: 6, right: 6, top: 4, bottom: 4 })
              .backgroundColor($r('app.color.pink'))
              .margin({ top: 6 })
            }
            .alignItems(HorizontalAlign.Start)
          }
          .borderRadius(10)
          .padding(12)
          .backgroundColor(getTheme(this.theme).BACKGROUND_COLOR)
        }
      }, item => item.id.toString())
    }
    .padding({ left: 12, right: 12 })
    .onAreaChange((oldArea: Area, newArea: Area) => {
      AppStorage.SetOrCreate('listHeight', newArea.height as number)
    })
  }
}