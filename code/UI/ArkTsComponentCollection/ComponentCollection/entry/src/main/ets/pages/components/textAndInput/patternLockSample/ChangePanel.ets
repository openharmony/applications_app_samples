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
export struct PatternLockControlPanel{
  @Link sideLength: number;
  @Link circleRadius: number;
  @Link pathStrokeWidth: number;
  @Link activeColor: Color;
  @Link selectedColor: Color;
  @Link pathColor: Color;
  @Link regularColor: Color;


  build(){
    Column(){
      CommonItemTwoRowSlider({
        changeValue:$sideLength,
        name:$r('app.string.patternlock_side_length'),
        max:200,
        min:100,
        testId:'patternLock_slider_001'
      })
      CommonItemTwoRowSlider({
        changeValue:$circleRadius,
        name:$r('app.string.patternlock_circle_radius'),
        max:12,
        min:3,
        testId:'patternLock_slider_002'
      })
      CommonItemTwoRowSlider({
        changeValue:$pathStrokeWidth,
        name:$r('app.string.patternlock_pathstroke_width'),
        max:20,
        min:10,
        testId:'patternLock_slider_003'
      })
      CommonItemColorSelect({
        name: $r('app.string.patternlock_regular_color'),
        isItemStyle: true,
        selectColor: $regularColor,
        testId:'patternLock_color_001'
      })
      CommonItemColorSelect({
        name: $r('app.string.patternlock_active_color'),
        isItemStyle: true,
        selectColor: $activeColor,
        testId:'patternLock_color_002'
      })
      CommonItemColorSelect({
        name: $r('app.string.patternlock_select_color'),
        isItemStyle: true,
        selectColor: $selectedColor,
        testId:'patternLock_color_003'
      })
      CommonItemColorSelect({
        name: $r('app.string.patternlock_path_color'),
        isItemStyle: true,
        selectColor: $pathColor,
        testId:'patternLock_color_004'
      })
    }
  }
}