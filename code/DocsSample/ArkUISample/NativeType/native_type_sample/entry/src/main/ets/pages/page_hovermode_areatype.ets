/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import Napi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum ArkUIHoverModeAreaType {
  ARKUI_HOVER_MODE_AREA_TYPE_TOP = 0,
  ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM,
}

@Entry
@Component
struct Index {
  @State hoverModeAreaType: number = ArkUIHoverModeAreaType.ARKUI_HOVER_MODE_AREA_TYPE_TOP;
  @State currentNodeContent: NodeContent = new NodeContent();
  @Builder
  SubMenuModeType() {
    Menu() {
      MenuItem({ content: 'ARKUI_HOVER_MODE_AREA_TYPE_TOP' }).width('50%').onChange(() => {
        this.hoverModeAreaType = ArkUIHoverModeAreaType.ARKUI_HOVER_MODE_AREA_TYPE_TOP;
        this.currentNodeContent = new NodeContent();
        Napi.createHoverModeAreaTypePage(this.currentNodeContent, this.hoverModeAreaType)
      })
      MenuItem({ content: 'ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM' }).width('50%').onChange(() => {
        this.hoverModeAreaType = ArkUIHoverModeAreaType.ARKUI_HOVER_MODE_AREA_TYPE_BOTTOM;
        this.currentNodeContent = new NodeContent();
        Napi.createHoverModeAreaTypePage(this.currentNodeContent, this.hoverModeAreaType)
      })
    }
  }

  build() {
    Column() {
      Button($r('app.string.set_hover_mode_area_type'))
        .height(50)
        .width('50%')
        .bindMenu(this.SubMenuModeType)
        .margin({ top: 40, bottom: 10 })
        Button($r('app.string.return_to_home_screen'))
        .height(50)
        .width('50%')
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })
      ContentSlot(this.currentNodeContent)
    }
    .width('100%')
    .height('100%')
  }
}
