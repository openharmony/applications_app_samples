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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { SubMenuType } from '../model/KeyboardKeyData';

@Preview
@Component
export struct Submenu {
  @StorageLink('submenuType') submenuType: number = SubMenuType.NORMAL;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();

  build() {
    Grid() {
      GridItem() {
        Column() {
          Image($r('app.media.ic_edit'))
            .size({ width: this.inputStyle.editPicSize, height: this.inputStyle.editPicSize })
            .objectFit(ImageFit.Cover)
          Text($r('app.string.edit'))
            .fontColor($r('app.color.text_normal'))
            .fontSize(this.inputStyle.editFontSize)
            .opacity(0.6)
            .margin({ top: 8 })
        }
        .width('100%')
        .height('50%')
        .justifyContent(FlexAlign.Center)
        .id('btnEdit')
        .onClick(() => {
          this.submenuType = SubMenuType.EDIT;
        })
      }
    }
    .width('100%')
    .height('100%')
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .backgroundColor('#F1F3F5')
  }
}