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
enum ArkUIButtonType {
  ARKUI_BUTTON_TYPE_NORMAL = 0,
  ARKUI_BUTTON_TYPE_CAPSULE = 1,
  ARKUI_BUTTON_TYPE_CIRCLE,
  ARKUI_BUTTON_ROUNDED_RECTANGLE = 8
}
@Entry
@Component
struct Index {
  @State nodeContent: NodeContent = new NodeContent();
  @State buttonType: number = ArkUIButtonType.ARKUI_BUTTON_TYPE_NORMAL;

  @Builder
  SubMenuModeType() {
    Menu() {
      MenuItem({ content: 'ARKUI_BUTTON_TYPE_NORMAL' }).width('50%').onChange(() => { this.buttonType = ArkUIButtonType.ARKUI_BUTTON_TYPE_NORMAL; this.nodeContent = new NodeContent(); Napi.createNativeButtonNode(this.nodeContent, this.buttonType); })
      MenuItem({ content: 'ARKUI_BUTTON_TYPE_CAPSULE' }).width('50%').onChange(() => { this.buttonType = ArkUIButtonType.ARKUI_BUTTON_TYPE_CAPSULE; this.nodeContent = new NodeContent(); Napi.createNativeButtonNode(this.nodeContent, this.buttonType); })
      MenuItem({ content: 'ARKUI_BUTTON_TYPE_CIRCLE' }).width('50%').onChange(() => { this.buttonType = ArkUIButtonType.ARKUI_BUTTON_TYPE_CIRCLE; this.nodeContent = new NodeContent(); Napi.createNativeButtonNode(this.nodeContent, this.buttonType); })
      MenuItem({ content: 'ARKUI_BUTTON_ROUNDED_RECTANGLE' }).width('50%').onChange(() => { this.buttonType = ArkUIButtonType.ARKUI_BUTTON_ROUNDED_RECTANGLE; this.nodeContent = new NodeContent(); Napi.createNativeButtonNode(this.nodeContent, this.buttonType); })
    }
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.set_button_type'))
          .height(50)
          .width('40%')
          .bindMenu(this.SubMenuModeType)
          .margin({ top: 40, bottom: 10 })
        Button($r('app.string.return_to_home_screen'))
          .height(50)
          .width('40%')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Column() {
          ContentSlot(this.nodeContent)
        }
        .margin({ top: 100, bottom: 10 })
        .width('100%')
      }
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }
}

