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

import { CommonItemTwoRowSlider, CommonItemSelect, CommonSwitcher } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { SBC_POSITION_DATA, SBC_TYPE_DATA } from '../../ComponentData';

@Extend(Text) function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({ left: 12, top: 12 })
}

@Component
export struct ArgumentsControlPanel {
  @Link type: SideBarContainerType;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.sidebarcontainer_argument_type'),
        selects: getStringArrayData(SBC_TYPE_DATA),
        callback: (index) => {
          switch (index) {
            case 1:
              this.type = SideBarContainerType.Overlay;
              break;
            default:
              this.type = SideBarContainerType.Embed;
          }
        },
        testId : `sidebarContainer_001`
      })
    }
    .width('100%')
  }
}

@Component
export struct PropertyControlPanel {
  @Link isShowSidebar: boolean;
  @Link leftMargin: number;
  @Link topMargin: number;
  @Link isShowButton: boolean;
  @Link sidebarPosition: SideBarPosition;
  @Link minWidth: number;
  @Link maxWidth: number;
  @Link isAutoHidden: boolean;

  build() {
    Column({space:5}) {
      CommonSwitcher({
        name: $r('app.string.sidebarcontainer_show_switch'),
        bool: $isShowSidebar,
        testID: `sidebarContainer_002`
      })

      CommonItemTwoRowSlider({
        changeValue: $leftMargin,
        min: 0,
        max: 100,
        name: $r('app.string.sidebarcontainer_left_margin'),
        testId: `sidebarContainer_003`
      })

      CommonItemTwoRowSlider({
        changeValue: $topMargin,
        min: 0,
        max: 100,
        name: $r('app.string.sidebarcontainer_top_margin'),
        testId: `sidebarContainer_004`
      })

      CommonSwitcher({
        name: $r('app.string.sidebarcontainer_show_button_switch'),
        bool: $isShowButton,
        testID: `sidebarContainer_005`
      })

      CommonItemSelect({
        name: $r('app.string.sidebarcontainer_position_title'),
        selects: getStringArrayData(SBC_POSITION_DATA),
        callback: (index) => {
          switch (index) {
            case 1:
              this.sidebarPosition = SideBarPosition.End;
              break;
            default:
              this.sidebarPosition = SideBarPosition.Start;
          }
        },
        testId: `sidebarContainer_006`
      })

      CommonItemTwoRowSlider({
        changeValue: $minWidth,
        min: 10,
        max: 190,
        name: $r('app.string.sidebarcontainer_min_width'),
        testId: `sidebarContainer_007`
      })

      CommonItemTwoRowSlider({
        changeValue: $maxWidth,
        min: 210,
        max: 300,
        name: $r('app.string.sidebarcontainer_max_width'),
        testId: `sidebarContainer_008`
      })

      CommonSwitcher({
        name: $r('app.string.sidebarcontainer_auto_hide'),
        bool: $isAutoHidden,
        testID: `sidebarContainer_009`
      })
    }
  }
}