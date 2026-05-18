'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import {
  Component,
  StorageLink,
  Stack,
  Resource,
  Text,
  Consume,
  $r,
  StateStyles,
  ShadowOptions
} from '@kit.ArkUI';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { MenuKey, MenuType } from '../InputMethodExtensionAbility/pages/KeyboardKeyData';

// 无大小写的灰色组件
@Component
export struct KeyItemGray {
  keyValue: string | undefined = undefined;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  @Consume menuType: number;

  build(): void {
    Stack() {
      if (this.keyValue) {
        Text(this.keyValue).fontSize(this.inputStyle.switchNumberFontSize).fontColor('black')
      }
    }
    .backgroundColor($r('app.color.key_item_gray'))
    .borderRadius(4)
    .onClick(() => {
      if (this.keyValue === String(MenuKey.NUMBER_KEY)) {
        this.menuType = MenuType.NUMBER;
      } else if (this.keyValue === String(MenuKey.SPECIAL_KEY)) {
        this.menuType = MenuType.SPECIAL;
      } else if (this.keyValue === String(MenuKey.NORMAL_KEY)) {
        this.menuType = MenuType.NORMAL;
      }
    })
    .height('100%')
    .width(this.inputStyle.switchButtonWidth)
    .shadow({ radius: 1, color: $r('app.color.shadow'), offsetY: 3 } as ShadowOptions)
    .stateStyles({
      normal: () => {
        this.backgroundColor($r('app.color.key_item_gray'))
      },
      pressed: () => {
        this.backgroundColor($r('app.color.key_item_gray_pressed'))
      }
    } as StateStyles)
  }
}