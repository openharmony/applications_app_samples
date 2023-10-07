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
import {  GRIDCONTAIER_SIZE_TYPE_SELECT_DATA  } from '../../ComponentData';

@Component
export struct ArgumentsControlPanel {
  @Link sizeType : SizeType;
  @Link gutter : number;
  @Link gridMargin: number;
  build() {
    Column() {
      CommonItemSelect({
        name : $r('app.string.gridcontainer_sizetype'),
        selects : getStringArrayData(GRIDCONTAIER_SIZE_TYPE_SELECT_DATA),
        callback : (index) => {
          switch (index) {
            case 1:
              this.sizeType = SizeType.SM;
              break;
            case 2:
              this.sizeType = SizeType.MD;
              break;
            case 3:
              this.sizeType = SizeType.LG;
              break;
            case 4:
              this.sizeType = SizeType.Auto;
              break;
            default:
              this.sizeType = SizeType.XS;
              break;
          }
        },
        testId: `gridcontainer_001`
      })

      CommonItemTwoRowSlider({
        changeValue: $gutter,
        min:0,
        max:20,
        name: $r('app.string.gridcontainer_gutter'),
        testId: `gridcontainer_002`
      })

      CommonItemTwoRowSlider({
        changeValue: $gridMargin,
        min:0,
        max:12,
        name: $r('app.string.gridcontainer_margin'),
        testId: `gridcontainer_003`
      })
    }
  }
}

