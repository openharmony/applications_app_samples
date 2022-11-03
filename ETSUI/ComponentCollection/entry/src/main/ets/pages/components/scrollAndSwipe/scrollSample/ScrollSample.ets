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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Extend(Column)
function cardStyle() {
  .backgroundColor(Color.White)
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Circle)
function colorPicker(color: Color | string, callback: ()=>void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles
function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Entry
@Component
struct ScrollSample {
  @State scroll_direction: ScrollDirection = ScrollDirection.Vertical

  build() {
    Column() {
      TitleBar({title: $r('app.string.scroll_name')})
      Text($r('app.string.scroll_horizontal'))
        .leftTitleStyle()
      Column() {
        Scroll() {
          Image($r('app.media.banner'))
            .width('150%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        }
        .scrollable(this.scroll_direction)
        .width('100%')
        .height(200)
      }.cardStyle()
      Text($r('app.string.scroll_vertical'))
        .leftTitleStyle()
      Column() {
        Scroll() {
          Image($r('app.media.banner'))
            .width('100%')
            .height('150%')
            .objectFit(ImageFit.Contain)
        }
        .scrollable(ScrollDirection.Vertical)
        .width('100%')
        .height(200)
      }.cardStyle()
    }.backgroundColor($r('app.color.background_light_gray'))
    .width('100%')
    .height('100%')
    .padding({left: 20, right: 20})
  }
}