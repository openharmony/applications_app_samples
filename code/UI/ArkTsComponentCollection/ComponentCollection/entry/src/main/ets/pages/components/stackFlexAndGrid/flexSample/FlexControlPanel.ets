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

import { CommonItemSelect } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import {
  FLEX_DIRECTION_SELECT_DATA,
  FLEX_WRAP_SELECT_DATA,
  FLEX_JUSTIFY_CONTENT_SELECT_DATA,
  FLEX_ALIGN_ITEMS_SELECT_DATA
} from '../../ComponentData';

@Component
export struct DirectionControlPanel {
  @Link flexDirection: FlexDirection;

  build() {
    CommonItemSelect({
      name: $r('app.string.flex_introduction_direction'),
      selects: getStringArrayData(FLEX_DIRECTION_SELECT_DATA),
      callback: (index) => {
        switch (index) {
          case 1:
            this.flexDirection = FlexDirection.RowReverse;
            break;
          case 2:
            this.flexDirection = FlexDirection.Column;
            break;
          case 3:
            this.flexDirection = FlexDirection.ColumnReverse;
            break;
          default:
            this.flexDirection = FlexDirection.Row;
            break;
        }
      },
      testId: `flex_001`
    })
  }
}

@Component
export struct WrapControlPanel {
  @Link wrap: FlexWrap

  build() {
    Column() {
      CommonItemSelect(
        {
          name: $r('app.string.flex_argument_wrap'),
          selects: getStringArrayData(FLEX_WRAP_SELECT_DATA),
          callback: (index) => {
            switch (index) {
              case 1:
                this.wrap = FlexWrap.Wrap;
                break;
              case 2:
                this.wrap = FlexWrap.WrapReverse;
                break;
              default:
                this.wrap = FlexWrap.NoWrap;
                break;
            }
          },
          testId: `flex_002`
        }
      )
    }
  }
}

@Component
export struct JustifyContentControlPanel {
  @Link JustifyContent: FlexAlign

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.flex_argument_justifycontent'),
        selects: getStringArrayData(FLEX_JUSTIFY_CONTENT_SELECT_DATA),
        callback: (index) => {
          switch (index) {
            case 1:
              this.JustifyContent = FlexAlign.Center;
              break;
            case 2:
              this.JustifyContent = FlexAlign.End;
              break;
            case 3:
              this.JustifyContent = FlexAlign.SpaceBetween;
              break;
            case 4:
              this.JustifyContent = FlexAlign.SpaceAround;
              break;
            case 5:
              this.JustifyContent = FlexAlign.SpaceEvenly;
              break;
            default:
              this.JustifyContent = FlexAlign.Start;
              break;
          }
        },
        testId: `flex_003`
      })
    }
  }
}

@Component
export struct AlignItemsControlPanel {
  @Link alignItems: ItemAlign

  build() {
    CommonItemSelect({
      name: $r('app.string.flex_argument_alignItems'),
      selects: getStringArrayData(FLEX_ALIGN_ITEMS_SELECT_DATA),
      callback: (index) => {
        switch (index) {
          case 1:
            this.alignItems = ItemAlign.Start;
            break;
          case 2:
            this.alignItems = ItemAlign.Center;
            break;
          case 3:
            this.alignItems = ItemAlign.End;
            break;
          case 4:
            this.alignItems = ItemAlign.Stretch;
            break;
          case 5:
            this.alignItems = ItemAlign.Baseline;
            break;
          default:
            this.alignItems = ItemAlign.Auto;
            break;
        }
      },
      testId: `flex_004`
    })
  }
}

@Component
export struct AlignContentControlPanel {
  @Link alignContent: FlexAlign

  build() {
    CommonItemSelect({
      name: $r('app.string.flex_argument_alignContent'),
      selects: getStringArrayData(FLEX_JUSTIFY_CONTENT_SELECT_DATA),
      callback: (index) => {
        switch (index) {
          case 1:
            this.alignContent = FlexAlign.Center;
            break;
          case 2:
            this.alignContent = FlexAlign.End;
            break;
          case 3:
            this.alignContent = FlexAlign.SpaceBetween;
            break;
          case 4:
            this.alignContent = FlexAlign.SpaceAround;
            break;
          case 5:
            this.alignContent = FlexAlign.SpaceEvenly;
            break;
          default:
            this.alignContent = FlexAlign.Start;
            break;
        }
      },
      testId:`flex_005`
    })
  }
}