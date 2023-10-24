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

import { CommonItemSelect, CommonSwitcher } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { TABS_BAR_POSITION_SELECT, TABS_BAR_MODE_SELECT } from '../../ComponentData';

@Component
export struct ArgumentsControlPanel {
  @Link barPosition: BarPosition;
  private changeIndex !: (index: number) => void;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.tabs_arguments_bar_position'),
        selects: getStringArrayData(TABS_BAR_POSITION_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.barPosition = BarPosition.End;
              break;
            default:
              this.barPosition = BarPosition.Start;
              break;
          }
        },
        testId: `tab_001`
      })

      CommonItemSelect({
        name: $r('app.string.tabs_arguments_controller'),
        selects: ['0', '1', '2', '3'],
        callback: (index) => {
          this.changeIndex(index)
        },
        testId: `tab_002`
      })
    }
  }
}

@Component
export struct PropertiesControlPanel {
  @Link vertical: boolean;
  @Link barMode: BarMode;
  @Link isScrollable: boolean;
  @Link animationDuration: number;

  build() {
    Column() {
      CommonSwitcher({
        bool: $vertical,
        name: $r('app.string.tabs_properties_vertical'),
        testID: `tab_003`
      })

      CommonSwitcher({
        bool: $isScrollable,
        name: $r('app.string.tabs_properties_is_scrollable'),
        testID: `tab_004`
      })

      CommonItemSelect({
        name: $r('app.string.tabs_properties_bar_mode'),
        selects: getStringArrayData(TABS_BAR_MODE_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.barMode = BarMode.Scrollable;
              break;
            default:
              this.barMode = BarMode.Fixed;
              break;
          }
        },
        testId: `tab_005`
      })

      CommonItemSelect({
        name: $r('app.string.tabs_properties_animation_duration'),
        selects: ['400', '1000', '2000', '3000'],
        callback: (index, duration) => {
          this.animationDuration = Number.parseInt(duration);
        },
        testId: `tab_006`
      })
    }
  }
}