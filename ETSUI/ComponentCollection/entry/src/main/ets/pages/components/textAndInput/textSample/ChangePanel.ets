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

import { CommonItemSlider, CommonItemSelect, CommonItemColorSelect } from '../../../../common/AttributeModificationTool'

@Component
export struct ChangeTextCase {
  @Link textCase: TextCase

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.text_text_case'),
        selects: [
          $r('app.string.text_text_case_normal'),
          $r('app.string.text_text_case_uppercase'),
          $r('app.string.text_text_case_lowercase')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.textCase = TextCase.UpperCase
              break
            case 2:
              this.textCase = TextCase.LowerCase
              break
            default:
              this.textCase = TextCase.Normal
          }
        }
      })
        .margin({ top: 12 })
    }
  }
}

@Component
export struct ChangeTextAttribute {
  @Link letterSpacing: number
  @Link textOverFlow: TextOverflow
  @Link textMaxLines: number
  @Link lineHeight: number
  @Link fontColor: string
  @Link styleForDecorative: TextDecorationType
  @Link textAlign: TextAlign

  build() {
    Column() {
      CommonItemSlider({
        changeValue: $letterSpacing,
        min: 0,
        max: 10,
        name: $r('app.string.text_letter_spacing')
      })

      CommonItemSlider({
        changeValue: $lineHeight,
        min: 20,
        max: 32,
        name: $r('app.string.text_line_height')
      })

      CommonItemSelect({
        name: $r('app.string.text_text_align_type'),
        selects: [
          $r('app.string.text_text_align_start'),
          $r('app.string.text_text_align_center'),
          $r('app.string.text_text_align_end')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.textAlign = TextAlign.Center
              break
            case 2:
              this.textAlign = TextAlign.End
              break
            default:
              this.textAlign = TextAlign.Start
          }
        }
      })

      CommonItemSelect({
        name: $r('app.string.text_overflow'),
        selects: [
          $r('app.string.text_none'),
          $r('app.string.text_text_over_flow_clip'),
          $r('app.string.text_text_over_flow_ellipsis')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.textMaxLines = 3
            // Clip is default type
              this.textOverFlow = TextOverflow.Clip
              break
            case 2:
              this.textMaxLines = 3
              this.textOverFlow = TextOverflow.Ellipsis
              break
            default:
              this.textMaxLines = -1
              this.textOverFlow = TextOverflow.None
          }
        }
      })

      CommonItemSelect({
        name: $r('app.string.text_decoration_type'),
        selects: [
          $r('app.string.text_none'),
          $r('app.string.text_decoration_type_line_through'),
          $r('app.string.text_decoration_type_over_line'),
          $r('app.string.text_decoration_type_under_line')],
        callback: (index) => {
          switch (index) {
            case 1:
              this.styleForDecorative = TextDecorationType.LineThrough
              break
            case 2:
              this.styleForDecorative = TextDecorationType.Overline
              break
            case 3:
              this.styleForDecorative = TextDecorationType.Underline
              break
            default:
              this.styleForDecorative = TextDecorationType.None
          }
        }
      })

      // CommonItemColorInput will parse color 'FF000000' -> '#FF000000'
      CommonItemColorSelect({
        name: $r('app.string.text_font_color'),
        selectColor: $fontColor
      })
    }
  }
}