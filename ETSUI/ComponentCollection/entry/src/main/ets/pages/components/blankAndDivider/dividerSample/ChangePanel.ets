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


import { CommonItemSlider, CommonItemSelect } from '../../../../common/AttributeModificationTool'

@Component
export struct ChangePanel {
  @Link lineColor: ResourceColor
  @Link strokeWidth: number
  @Link lineCapStyle: LineCapStyle

  build() {
    Column() {
      // Slid to change stroke width
      CommonItemSlider({ changeValue: $strokeWidth, min: 1, max: 25, name: $r('app.string.divider_stroke_width') })

      // Select line color
      CommonItemSelect({
        name: $r('app.string.divider_line_color'),
        selects: ['Blue', 'Green', 'Orange', 'Pink'],
        callback: (index) => {
          switch (index) {
            case 1:
              this.lineColor = $r('app.color.background_green')
              break
            case 2:
              this.lineColor = $r('app.color.background_orange')
              break
            case 3:
              this.lineColor = $r('app.color.background_pink')
              break
            default:
              this.lineColor = $r('app.color.background_blue')
          }
        }
      })

      // Select lineCapStyle
      CommonItemSelect({
        name: $r('app.string.divider_line_cap'),
        selects: ['Butt', 'Round', 'Square'],
        callback: (index) => {
          switch (index) {
            case 1:
              this.lineCapStyle = LineCapStyle.Round
              break
            case 2:
              this.lineCapStyle = LineCapStyle.Square
              break
            default:
              this.lineCapStyle = LineCapStyle.Butt
          }
        }
      })
    }
  }
}