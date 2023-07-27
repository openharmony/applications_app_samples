/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { getStringData } from '../../../../data/ResourceDataHandle';

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Entry
@Component
struct FlexSample {
  build() {
    Column() {
      TitleBar({ title: $r('app.string.flex') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.flex_flexBasis') })
          Row() {
            Flex() {
              Text($r('app.string.flex_basis_100'))
                .flexBasis(100) // 这里表示宽度为100vp
                .height(100)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_basis_auto'))
                .flexBasis(getStringData($r('app.string.flex_auto'))) // 这里表示宽度保持原本设置的60%的宽度
                .width('60%')
                .height(100)
                .backgroundColor(0xD2B48C)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor(0xAFEEEE)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.flex_flexGrow') })
          Row() {
            Flex() {
              Text($r('app.string.flex_grow_2'))
                .flexGrow(2) // 父容器分配给该Text的宽度为剩余宽度的2/3
                .height(100)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_grow_1'))
                .flexGrow(1) // 父容器分配给该Text的宽度为剩余宽度的1/3
                .height(100)
                .backgroundColor(0xD2B48C)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor(0xAFEEEE)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.flex_flexShrink') })
          Row() {
            Flex({ direction: FlexDirection.Row }) {
              Text($r('app.string.flex_shrink_0'))
                .flexShrink(0)
                .width('50%')
                .height(100)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_shrink_default')) // 默认值为1
                .width('40%')
                .height(100)
                .backgroundColor(0xD2B48C)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_shrink_1'))
                .flexShrink(1)
                .width('40%')
                .height(100)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor(0xAFEEEE)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.flex_alignSelf') })
          Row() {
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Text($r('app.string.flex_no_alignSelf_70'))
                .width('33%')
                .height(70)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_end_alignSelf'))
                .alignSelf(ItemAlign.End)
                .width('33%')
                .height(70)
                .backgroundColor(0xD2B48C)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_end_alignSelf_100'))
                .width('34%')
                .height('100%')
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor(0xAFEEEE)
          }
          .rowStyle()

          IntroductionTitle({ introduction: $r('app.string.flex_layoutWeight') })
          Row() {
            Flex({ direction: FlexDirection.Row }) {
              Text($r('app.string.size_size_description_one'))
                .width(100)
                .height(100)
                .backgroundColor(0xF5DEB3)
                .textAlign(TextAlign.Center)
              Text($r('app.string.flex_layoutWeight')) // 默认值为1
                .layoutWeight(1)
                .height(100)
                .backgroundColor(0xD2B48C)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
            .height(120)
            .padding(10)
            .backgroundColor(0xAFEEEE)
          }
          .rowStyle()
        }
        .constraintSize({ minHeight: '100%' })
      }
      .margin({ bottom: 60 })
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}