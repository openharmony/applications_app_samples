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
import { InputHandler } from '../model/KeyboardController';
import { SubMenuType } from '../model/KeyboardKeyData';

@Preview
@Component
export struct TopMenu {
  @StorageLink('submenuType') submenuType: number = SubMenuType.NORMAL;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();

  build() {
    Column() {
      Divider()
        .color($r('app.color.light_gray'))
        .width('100%')
        .margin({ bottom: 11 })
      Row() {
        Stack() {
          Image($r('app.media.ic_keyboard'))
            .width(this.inputStyle.downMenuPicWidth)
            .height(this.inputStyle.downMenuHeight)
            .objectFit(ImageFit.Contain)
            .id('keyboardMenu')
        }
        .margin({ left: 8 })
        .width(this.inputStyle.downMenuWidth)
        .borderRadius(4)
        .height('100%')
        .onClick(() => {
          if (this.submenuType > SubMenuType.NORMAL) {
            this.submenuType = SubMenuType.NORMAL;
          } else {
            this.submenuType = SubMenuType.MENU;
          }
        })

        Divider()
          .vertical(true)
          .color($r('app.color.light_gray'))
          .margin({ left: 8 })
        Blank()
        Divider()
          .vertical(true)
          .color($r('app.color.light_gray'))
          .margin({ right: 8 })
        Stack() {
          Image($rawfile('down.svg'))
            .width(this.inputStyle.downMenuPicWidth)
            .height(this.inputStyle.downMenuPicHeight)
            .objectFit(ImageFit.Contain)
            .id('kikaInputDown')
        }
        .width(this.inputStyle.downMenuWidth)
        .borderRadius(4)
        .height('100%')
        .onClick(() => {
          this.submenuType = SubMenuType.NORMAL;
          InputHandler.getInstance().hideKeyboardSelf();
        })
      }
      .width('100%')
      .layoutWeight(1)

      Row() {
        Divider()
          .color($r('app.color.light_gray'))
          .width(this.inputStyle.editDriverLeft)
        if (this.submenuType > SubMenuType.NORMAL) {
          Image($r('app.media.ic_submenu_arrow'))
            .size({ width: this.inputStyle.subMenuWidth, height: this.inputStyle.subMenuWidth })
            .objectFit(ImageFit.Contain)
            .alignSelf(ItemAlign.End)
        }
        Divider()
          .color($r('app.color.light_gray'))
          .layoutWeight(1)
      }
      .height(12)
      .alignItems(VerticalAlign.Bottom)
    }
    .width('100%')
    .height(this.inputStyle.downMenuHeight)
  }
}