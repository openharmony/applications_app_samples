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

import { CommonItemTwoRowSlider, CommonItemSelect, CommonItemColorSelect
} from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { PATH_SELECT_COMMANDS } from '../../ComponentData';

@Component
export struct PathControlPanel {
  @Link commands: string;
  @Link fillOpacity: number;
  @Link strokeWidth: number;
  @Link stroke: Color;
  @Link strokeDashArray: number;
  @Link fill: Color;
  @Link strokeOpacity: number;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.path_commands_select'),
        selects: getStringArrayData(PATH_SELECT_COMMANDS),
        callback: (index) => {
          switch (index) {
            case 1:
              this.commands = 'M100 0 L200 240 L0 240 Z';
              break;
            case 2:
              this.commands = 'M0 0 H200 V200 H0 Z';
              break;
            case 3:
              this.commands = 'M100 0 L0 100 L50 200 L150 200 L200 100 Z';
              break;
            case 4:
              this.commands = 'M0 300 S100 0 240 300 Z';
              break;
            case 5:
              this.commands = 'M0 150 C0 100 140 0 200 150 L100 300 Z';
              break;
            case 6:
              this.commands = 'M0 100 A30 20 20 0 0 200 100 Z';
              break;
            default:
              this.commands = 'M0 0 L600 0';
          }
        }, testId: 'path_select_001'
      })
      CommonItemColorSelect({
        name: $r('app.string.path_fill'),
        isItemStyle: true,
        selectColor: $fill,
        testId: 'path_color_001'
      })
      CommonItemColorSelect({
        name: $r('app.string.path_stroke_color'),
        isItemStyle: true,
        selectColor: $stroke,
        testId: 'path_color_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $fillOpacity,
        max: 100,
        min: 0,
        name: $r('app.string.path_fill_opacity'),
        vpTest:'%',
        testId: 'path_slider_001'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeOpacity,
        max: 100,
        min: 0,
        name: $r('app.string.path_stroke_opacity'),
        vpTest:'%',
        testId: 'path_slider_002'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeWidth,
        max: 10,
        min: 3,
        name: $r('app.string.path_stroke_width'),
        testId: 'path_slider_003'
      })
      CommonItemTwoRowSlider({
        changeValue: $strokeDashArray,
        max: 40,
        min: 1,
        name: $r('app.string.path_stroke_dash'),
        testId: 'path_slider_004'
      })
    }
  }
}