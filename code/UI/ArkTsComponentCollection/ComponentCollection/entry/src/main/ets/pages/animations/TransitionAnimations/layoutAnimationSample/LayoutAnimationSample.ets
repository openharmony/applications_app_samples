/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import { IntroductionTitle } from '../../../../common/IntroductionTitle'

@Extend(Column) function columnStyle() {
  .height(150)
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
  .margin({ bottom: 12 })
}

@Extend(Text) function textStyle() {
  .fontColor(Color.White)
  .size({ width: 100, height: 100 })
  .margin(5)
}

@Entry
@Component
struct LayoutAnimationSample {
  @State mPadding: number = 5;
  @State mMargin: number = 5;
  @State mSize: number = 100;
  @State mPositionX: number = 10;
  @State mPositionY: number = 0;
  @State mAlignment: Alignment = Alignment.Center;
  @State mDirection: Direction = Direction.Rtl;
  @State mColor: Color = Color.Pink;
  @State mHorizontalAlign: HorizontalAlign = HorizontalAlign.Start;
  intervalID: number | null = null;

  onPageShow() {
    this.intervalID = setInterval(() => {
      animateTo({ duration: 2000 }, () => {
        this.mColor = this.mColor == Color.Pink ? Color.Orange : Color.Pink
        this.mPadding = this.mPadding == 5 ? 20 : 5
        this.mMargin = this.mMargin == 5 ? 20 : 5
        this.mSize = this.mSize == 50 ? 100 : 50
        this.mPositionX = this.mPositionX == 10 ? 50 : 10
        this.mAlignment = this.mAlignment == Alignment.Center ? Alignment.TopStart : Alignment.Center
        this.mDirection = this.mDirection == Direction.Rtl ? Direction.Ltr : Direction.Rtl
        this.mHorizontalAlign = this.mHorizontalAlign == HorizontalAlign.Start ? HorizontalAlign.Center : HorizontalAlign.Start
      })

    }, 3000);
  }

  onPageHide() {
    clearInterval(this.intervalID)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.layout_animation_expansion') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_align') })
          Column() {
            Text($r('app.string.layout_animation_expansion_align'))
              .textStyle()
              .backgroundColor(this.mColor)
              .align(this.mAlignment)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_size') })
          Column() {
            Text()
              .textStyle()
              .size({ width: this.mSize, height: this.mSize })
              .backgroundColor(this.mColor)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_padding') })
          Column() {
            Column() {
              Text()
                .size({ width: '100%', height: '100%' })
                .backgroundColor($r('app.color.white'))
            }
            .size({ width: 100, height: 100 })
            .margin(5)
            .padding(this.mPadding)
            .backgroundColor(this.mColor)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_margin') })
          Column() {
            Row() {
              ForEach(['1', '2', '3'], (item: string) => {
                Text(item)
                  .textStyle()
                  .margin(this.mMargin)
                  .backgroundColor(this.mColor)
              })
            }
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_direction') })
          Column() {
            Row() {
              ForEach(['1', '2', '3'], (item: string) => {
                Text(item)
                  .textStyle()
                  .backgroundColor(this.mColor)
              })
            }
            .direction(this.mDirection)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_offset') })
          Column() {
            Text()
              .textStyle()
              .offset({
                x: this.mPositionX,
                y: this.mPositionY
              })
              .backgroundColor(this.mColor)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_position') })
          Column() {
            Text()
              .textStyle()
              .position({
                x: this.mPositionX,
                y: this.mPositionY
              })
              .backgroundColor(this.mColor)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_markAnchor') })
          Column() {
            Text()
              .textStyle()
              .markAnchor({
                x: this.mPositionX,
                y: this.mPositionY
              })
              .backgroundColor(this.mColor)
          }
          .columnStyle()

          IntroductionTitle({ introduction: $r('app.string.layout_animation_expansion_alignRules') })
          Column() {
            RelativeContainer() {
              Text()
                .size({ width: 100, height: 100 })
                .alignRules({
                  top: {
                    anchor: "__container__",
                    align: VerticalAlign.Top
                  },
                  left: {
                    anchor: "__container__",
                    align: this.mHorizontalAlign
                  }
                })
                .id('text1')
                .backgroundColor(this.mColor)
            }
            .margin({ top: 10 })
            .size({ width: 300, height: 100 })
            .border({ width: 2, color: $r('app.color.radio_response_region_color') })
          }
          .columnStyle()

          .margin({ bottom: 80 })
        }
        .padding({ left: 12, right: 12 })
        .constraintSize({ minHeight: '100%' })

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}