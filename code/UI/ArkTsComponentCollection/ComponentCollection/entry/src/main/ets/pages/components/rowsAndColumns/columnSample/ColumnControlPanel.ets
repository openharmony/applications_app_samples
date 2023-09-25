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
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { COLUMN_ALIGNITEMS_DATA, COLUMN_JUSTIFYCONTENT_DATA } from '../../ComponentData';

@Component
export struct ArgumentsControlPanel {
  @Link elementSpacing: number;

  build() {
    Column() {
      CommonItemTwoRowSlider(
        {
          changeValue: $elementSpacing,
          min: 0,
          max: 110,
          name: $r('app.string.column_element_spacing'),
          testId: `column_001`
        }
      )
    }
  }
}

@Component
export struct PropertyControlPanel {
  @Link alignItems: HorizontalAlign;
  @Link justifyContent: FlexAlign;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.column_alignitems_description'),
        selects: getStringArrayData(COLUMN_ALIGNITEMS_DATA),
        callback: (index) => {
          switch (index) {
            case 1:
              this.alignItems = HorizontalAlign.Center;
              break;
            case 2:
              this.alignItems = HorizontalAlign.End;
              break;
            default:
              this.alignItems = HorizontalAlign.Start;
          }
        },
        testId: `column_002`
      })

      CommonItemSelect({
        name: $r('app.string.column_justifycontent_description'),
        selects: getStringArrayData(COLUMN_JUSTIFYCONTENT_DATA),
        callback: (index) => {
          switch (index) {
            case 1:
              this.justifyContent = FlexAlign.Center;
              break;
            case 2:
              this.justifyContent = FlexAlign.End;
              break;
            case 3:
              this.justifyContent = FlexAlign.SpaceBetween;
              break;
            case 4:
              this.justifyContent = FlexAlign.SpaceAround;
              break;
            case 5:
              this.justifyContent = FlexAlign.SpaceEvenly;
              break;
            default:
              this.justifyContent = FlexAlign.Start;
          }
        },
        testId: `column_003`
      })
    }
  }
}
