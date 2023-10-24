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

import { CommonItemTwoRowSlider, CommonItemColorSelect} from '../../../../common/AttributeModificationTool';

@Component
export struct PolylineControlPanel {
  @Link polylineFirstX: number;
  @Link polylineFirstY: number;
  @Link polylineSecondX: number;
  @Link polylineSecondY: number;
  @Link polylineThirdX: number;
  @Link polylineThirdY: number;
  @Link strokeWidth: number;
  @Link stroke: Color;
  @Link strokeDashArray: number;
  @Link strokeOpacity: number;

  build() {
    Column() {
      CommonItemColorSelect({
        name: $r('app.string.polyline_stroke_color'),
        isItemStyle: true,
        selectColor: $stroke,
        testId: 'polyline_color_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineFirstX,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_first_x'),
        testId: 'polyline_slider_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineFirstY,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_first_y'),
        testId: 'polyline_slider_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineSecondX,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_second_x'),
        testId: 'polyline_slider_003'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineSecondY,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_second_y'),
        testId: 'polyline_slider_004'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineThirdX,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_third_x'),
        testId: 'polyline_slider_005'
      })
      CommonItemTwoRowSlider({
        changeValue: $polylineThirdY,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_third_y'),
        testId: 'polyline_slider_006'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeOpacity,
        max: 100,
        min: 0,
        name: $r('app.string.polyline_stroke_opacity'),
        vpTest: '%',
        testId: 'polyline_slider_007'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeWidth,
        max: 10,
        min: 3,
        name: $r('app.string.polyline_stroke_width'),
        testId: 'polyline_slider_008'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeDashArray,
        max: 40,
        min: 1,
        name: $r('app.string.polyline_stroke_dash'),
        testId: 'polyline_slider_009'
      })
    }
  }
}