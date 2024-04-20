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

import { ChangePanel } from './ChangePanel'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Column)
function columnStyle() {
  .width('90%')
  .padding(16)
  .margin(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct SafeAreaSample {
  @State mSafeAreaType: SafeAreaType[] = [SafeAreaType.CUTOUT]
  @State mSafeAreaEdge: SafeAreaEdge[] = [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]

  build() {
    Column() {
      Stack() {
        Row() {
        }
        .height('100%')
        .width('100%')
        .backgroundImage($r('app.media.img_test_1'))
        .backgroundImageSize(ImageSize.Cover)
        .alignItems(VerticalAlign.Top)
        .expandSafeArea(this.mSafeAreaType, this.mSafeAreaEdge)

        Column() {
          TitleBar({ title: $r('app.string.safe_area') })
            .backgroundColor($r('app.color.background_shallow_grey'))
          Column() {
            IntroductionTitle({ introduction: $r('app.string.safe_area_type_and_safe_area_edge') })
            ChangePanel({
              mSafeAreaType: $mSafeAreaType,
              mSafeAreaEdge: $mSafeAreaEdge
            })
          }
          .columnStyle()
          .alignItems(HorizontalAlign.Center)

          TextInput({ placeholder: $r('app.string.save_area_input_text') })
            .width(320)
            .height(40)
            .fontSize(14)
            .fontColor(Color.Black)
            .backgroundColor(Color.White)
            .enableKeyboardOnFocus(false)
            .margin({ top: 200 })
            .placeholderFont({ size: 14, weight: 400 })
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }
}