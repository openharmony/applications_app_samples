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

import { CommonItemSlider, CommonItemColorSelect } from '../../../../common/AttributeModificationTool'

@Component
export struct ChangePanel {
  @Link blockColor: Color
  @Link selectColor: Color
  @Link trackColor: Color
  @Link trackThickness: number

  build() {
    Column() {
      CommonItemSlider({
        name: $r('app.string.slider_track_thickness'),
        changeValue: $trackThickness,
        min: 4,
        max: 9
      })

      // CommonItemColorInput will parse color 'FFFFFFFF' -> '#FFFFFFFF'
      CommonItemColorSelect({
        name: $r('app.string.slider_block_color'),
        selectColor: $blockColor
      })

      CommonItemColorSelect({
        name: $r('app.string.slider_select_color'),
        selectColor: $selectColor
      })

      CommonItemColorSelect({
        name: $r('app.string.slider_track_color'),
        selectColor: $trackColor
      })
    }
  }
}