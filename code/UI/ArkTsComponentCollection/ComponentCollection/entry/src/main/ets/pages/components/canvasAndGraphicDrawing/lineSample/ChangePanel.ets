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

import { CommonItemSlider, CommonItemColorSelect, CommonItemTwoRowSlider} from '../../../../common/AttributeModificationTool';

@Component
export struct LineControlPanel {
  @Link startPointX: number
  @Link startPointY: number;
  @Link endPointX: number;
  @Link endPointY: number;
  @Link strokeWidth: number;
  @Link stroke: Color;
  @Link strokeDashArray: number;
  @Link strokeOpacity: number;

  build() {
    Column() {
      CommonItemColorSelect({
        name: $r('app.string.line_stroke_color'),
        isItemStyle: true,
        selectColor: $stroke,
        testId: 'line_color_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $startPointX,
        max: 200,
        min: 0,
        name: $r('app.string.line_start_point_x'),
        testId: 'line_slider_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $startPointY,
        max: 150,
        min: 0,
        name: $r('app.string.line_start_point_y'),
        testId: 'line_slider_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $endPointX,
        max: 200,
        min: 0,
        name: $r('app.string.line_end_point_x'),
        testId: 'line_slider_003'
      })
      CommonItemTwoRowSlider({
        changeValue: $endPointY,
        max: 150,
        min: 0,
        name: $r('app.string.line_end_point_y'),
        testId: 'line_slider_004'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeWidth,
        max: 10,
        min: 3,
        name: $r('app.string.line_stroke_width'),
        testId: 'line_slider_005'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeOpacity,
        max: 100,
        min: 0,
        vpTest:'%',
        name: $r('app.string.line_stroke_opacity'),
        testId: 'line_slider_006'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeDashArray,
        max: 40,
        min: 1,
        name: $r('app.string.line_stroke_dash'),
        testId: 'line_slider_007'
      })
    }
  }
}