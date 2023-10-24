/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { CommonItemSelect } from '../../../../common/AttributeModificationTool'
import { getStringArrayData } from '../../../../data/ResourceDataHandle'

@Component
export struct ChangePanel {
  @Link mSideBarContainerType: SideBarContainerType
  private selectData: Resource[] = [$r('app.string.side_bar_type_embed'), $r('app.string.side_bar_type_overlay'), $r('app.string.side_bar_type_auto')]

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.set_side_bar_type'),
        selects: getStringArrayData(this.selectData),
        callback: (index) => {
          switch (index) {
            case 0:
              this.mSideBarContainerType = SideBarContainerType.Embed
              break
            case 1:
              this.mSideBarContainerType = SideBarContainerType.Overlay
              break
            default:
              this.mSideBarContainerType = SideBarContainerType.AUTO
          }
        }
      })
    }
  }
}