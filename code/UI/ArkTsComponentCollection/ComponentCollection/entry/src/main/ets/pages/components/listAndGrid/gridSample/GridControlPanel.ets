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


import { CommonItemTwoRowSlider, CommonItemSelect } from '../../../../common/AttributeModificationTool';

@Component
export struct ArgumentsControlPanel {
  @Link columnTemplate: string;
  @Link rowsTemplate: string;
  @Link columnsGap: number;
  @Link rowGap: number;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.grid_properties_columns_template'),
        selects: ['1', '2', '3'],
        callback: (index) => {
          switch (index) {
            case 1:
              this.columnTemplate = '1fr 1fr 2fr 1fr';
              break;
            case 2:
              this.columnTemplate = '1fr 1fr 3fr 1fr';
              break;
            default:
              this.columnTemplate = '1fr 1fr 1fr 1fr';
              break;
          }
        },
        testId : `grid_001`
      })

      CommonItemSelect({
        name: $r('app.string.grid_properties_rows_template'),
        selects: ['1', '2', '3'],
        callback: (index) => {
          switch (index) {
            case 1:
              this.rowsTemplate= '1fr 1fr 2fr 1fr';
              break;
            case 2:
              this.rowsTemplate= '1fr 1fr 3fr 1fr';
              break;
            default:
              this.rowsTemplate= '1fr 1fr 1fr 1fr';
              break;
          }
        },
        testId : `grid_002`
      })

      CommonItemTwoRowSlider({
        name: $r('app.string.grid_properties_columns_gap'),
        min: 0,
        max: 15,
        changeValue: $columnsGap,
        testId : `grid_003`
      })

      CommonItemTwoRowSlider({
        name: $r('app.string.grid_properties_columns_gap'),
        min: 0,
        max: 15,
        changeValue: $rowGap,
        testId : `grid_004`
      })
    }
  }
}