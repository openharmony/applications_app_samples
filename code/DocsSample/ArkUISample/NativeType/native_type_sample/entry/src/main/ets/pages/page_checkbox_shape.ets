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

enum ArkUICheckboxShape {
  ArkUI_CHECKBOX_SHAPE_CIRCLE = 0,
  ArkUI_CHECKBOX_SHAPE_ROUNDED_SQUARE
}

@Entry
@Component
struct Index {
  @State checkboxType: number = ArkUICheckboxShape.ArkUI_CHECKBOX_SHAPE_CIRCLE;
  @State currentNodeContent: NodeContent = new NodeContent();
  @Builder
  SubMenuModeType() {
    Menu() {
      MenuItem({ content: 'ArkUI_CHECKBOX_SHAPE_CIRCLE' }).width('50%').onChange(() => { this.checkboxType = ArkUICheckboxShape.ArkUI_CHECKBOX_SHAPE_CIRCLE; this.currentNodeContent = new NodeContent(); Napi.createNativeCheckboxShapePage(this.currentNodeContent, this.checkboxType) })
      MenuItem({ content: 'ArkUI_CHECKBOX_SHAPE_ROUNDED_SQUARE' }).width('50%').onChange(() => { this.checkboxType = ArkUICheckboxShape.ArkUI_CHECKBOX_SHAPE_ROUNDED_SQUARE; this.currentNodeContent = new NodeContent(); Napi.createNativeCheckboxShapePage(this.currentNodeContent, this.checkboxType) })
    }
  }

  build() {
    Column() {
      Button('CheckboxShape')
        .height(50)
        .width('50%')
        .bindMenu(this.SubMenuModeType)
        .margin({ top: 40, bottom: 10 })
      Blank()
        .height(200)
      ContentSlot(this.currentNodeContent)
    }
    .width('100%')
    .height('100%')
  }
}
