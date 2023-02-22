/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http:// www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ChangeTextCase, ChangeTextAttribute } from './ChangePanel'
import { TitleBar } from '../../../../common/TitleBar'

@Extend(Column) function backgroundStyle() {
  .size({ width: '100%' })
  .margin({ top: 12 })
  .padding(12)
  .borderRadius(24)
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct TextSample {
  @State lineHeight: number = 23
  @State textMaxLines: number = -1
  @State letterSpacing: number = 2
  @State fontColor: string = '#FF000000'
  @State textCase: TextCase = TextCase.Normal
  @State textAlign: TextAlign = TextAlign.Start
  @State textOverFlow: TextOverflow = TextOverflow.None
  @State styleForDecorative: TextDecorationType = TextDecorationType.None
  @State textContent: Resource = $r('app.string.text_content')

  build() {
    Column() {
      TitleBar({ title: $r('app.string.text_title') })
      Scroll() {
        Column({ space: 12 }) {
          Column() {
            Text(this.textContent)
              .height(160)
              .minFontSize(16)
              .maxFontSize(20)
              .baselineOffset(0)
              .fontColor(this.fontColor)
              .textAlign(this.textAlign)
              .lineHeight(this.lineHeight)
              .maxLines(this.textMaxLines)
              .letterSpacing(this.letterSpacing)
              .textOverflow({ overflow: this.textOverFlow })
              .decoration({ type: this.styleForDecorative })

            ChangeTextAttribute({
              fontColor: $fontColor,
              textAlign: $textAlign,
              lineHeight: $lineHeight,
              textMaxLines: $textMaxLines,
              letterSpacing: $letterSpacing,
              textOverFlow: $textOverFlow,
              styleForDecorative: $styleForDecorative,
            })
          }
          .backgroundStyle()

          // Lowercase or uppercase
          Column() {
            Text($r('app.string.text_content_en'))
              .textCase(this.textCase)
              .maxLines(5)

            ChangeTextCase({
              textCase: $textCase
            })
          }
          .backgroundStyle()
          .margin({ bottom: 60 })
        }
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen
      }
      .size({ width: '100%', height: '100%' })
      .padding({ left: 12, right: 12 })
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}