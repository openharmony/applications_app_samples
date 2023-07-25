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

import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Row) function rowStyle() {
  .margin(10)
  .width('100%')
  .borderRadius(14)
  .padding({ left: 12, right: 12 })
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Badge) function badgeStyle() {
  .layoutWeight(1)
  .borderRadius(20)
  .margin({ left: 12, right: 12 })
  .backgroundColor($r('app.color.tab_bar_divider'))
}

@Entry
@Component
struct BadgeSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.auxiliary_badge') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.badge_type') })
          Row() {
            Badge({
              count: 1,
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_number'))
            }
            .badgeStyle()

            Badge({
              value: 'new',
              style: {
                color: 0xFFFFFF,
                fontSize: 14,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_string'))
            }
            .badgeStyle()
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.badge_max') })
          Row() {
            Badge({
              count: 10, // 设置提醒消息数100
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_number_normal'))
            }
            .badgeStyle()

            Badge({
              count: 100, // 设置提醒消息数100
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_number_max'))
            }
            .badgeStyle()
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.badge_location') })
          Row() {
            Badge({
              count: 1, // 设置提醒消息数
              position: BadgePosition.Left,
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_left'))
            }
            .badgeStyle()

            Badge({
              count: 1, // 设置提醒消息数
              position: BadgePosition.RightTop,
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_top'))
            }
            .badgeStyle()

            Badge({
              count: 1, // 设置提醒消息数
              position: BadgePosition.Right,
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 20,
                badgeColor: Color.Red }
            }) {
              this.RowContainer($r('app.string.badge_right'))
            }
            .badgeStyle()
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.badge_style') })
          Row() {
            Badge({
              value: ' ',
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 24,
                badgeColor: Color.Blue }
            }) {
              this.RowContainer($r('app.string.badge_blue'))
            }
            .badgeStyle()

            Badge({
              value: ' ',
              style: {
                color: 0xFFFFFF,
                fontSize: 16,
                badgeSize: 14,
                badgeColor: Color.Green }
            }) {
              this.RowContainer($r('app.string.badge_green'))
            }
            .badgeStyle()
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder RowContainer(description: Resource) {
    Row() {
      Text(description)
        .maxLines(2)
        .fontSize(16)
        .fontColor($r('app.color.font_color_shallow'))
        .textAlign(TextAlign.Center)
    }
    .padding(8)
    .alignSelf(ItemAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}