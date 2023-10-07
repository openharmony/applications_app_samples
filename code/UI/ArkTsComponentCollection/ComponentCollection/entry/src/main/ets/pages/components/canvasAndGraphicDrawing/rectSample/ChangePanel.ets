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

import { CommonItemTwoRowSlider, CommonItemColorSelect } from '../../../../common/AttributeModificationTool';

@Component
export struct RectControlPanel {
  @Link rectHeight: number;
  @Link rectWidth: number;
  @Link radiusWidth: number;
  @Link radiusHeight: number;
  @Link fillOpacity: number;
  @Link strokeWidth: number;
  @Link stroke: Color;
  @Link strokeDashArray: number;
  @Link fill: Color;
  @Link strokeOpacity: number;

  build() {

    Column() {
      CommonItemColorSelect({
        name: $r('app.string.rect_fill'),
        isItemStyle: true,
        selectColor: $fill,
        testId: 'rect_color_001'
      })
      CommonItemColorSelect({
        name: $r('app.string.rect_stroke'),
        isItemStyle: true,
        selectColor: $stroke,
        testId: 'rect_color_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $rectHeight,
        max: 200,
        min: 50,
        name: $r('app.string.rect_height'),
        testId: 'rect_slider_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $rectWidth,
        max: 200,
        min: 50,
        name: $r('app.string.rect_width'),
        testId: 'rect_slider_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $radiusWidth,
        max: 50,
        min: 0,
        name: $r('app.string.rect_radius_width'),
        testId: 'rect_slider_003'
      })
      CommonItemTwoRowSlider({
        changeValue: $radiusHeight,
        max: 50,
        min: 0,
        name: $r('app.string.rect_radius_height'),
        testId: 'rect_slider_004'
      })

      CommonItemTwoRowSlider({
        changeValue: $fillOpacity,
        max: 100,
        min: 0,
        name: $r('app.string.rect_fill_opacity'),
        vpTest: '%',
        testId: 'rect_slider_005'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeOpacity,
        max: 100,
        min: 0,
        name: $r('app.string.rect_stroke_opacity'),
        vpTest: '%',
        testId: 'rect_slider_006'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeWidth,
        max: 10,
        min: 3,
        name: $r('app.string.rect_stroke_width'),
        testId: 'rect_slider_007'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeDashArray,
        max: 40,
        min: 1,
        name: $r('app.string.rect_stroke_dash'),
        testId: 'rect_slider_008'
      })
    }
  }
}