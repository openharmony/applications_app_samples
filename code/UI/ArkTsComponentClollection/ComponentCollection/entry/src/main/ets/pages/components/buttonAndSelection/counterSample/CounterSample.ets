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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Entry
@Component
struct CounterSample {
  @State count: number = 0
  @State imageCount: number = 0
  private images: Resource[] = [$r('app.media.ic_button_circle_add'), $r('app.media.ic_blank_and_divider'),
  $r('app.media.ic_select_option_gesture'), $r('app.media.ic_prop_size'),
  $r('app.media.ic_custom_dialog_voice')]

  build() {
    Column() {
      TitleBar({ title: $r('app.string.counter_name') })
      Text('Number Content')
        .leftTitleStyle()
      Column() {
        Counter() {
          Text(this.count.toString())
        }.onInc(() => {
          this.count++
        })
        .onDec(() => {
          this.count--
        })
      }.cardStyle()

      Text('Image Content')
        .leftTitleStyle()
      Column() {
        Counter() {
          Image(this.images[this.imageCount])
            .width(20)
            .height(20)
        }.onInc(() => {
          if (this.imageCount < this.images.length - 1)
            this.imageCount++
        })
        .onDec(() => {
          if (this.imageCount > 0)
            this.imageCount--
        })
      }.cardStyle()
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
    .padding({ left: 20, right: 20 })

  }
}