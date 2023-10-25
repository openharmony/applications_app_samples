/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Action } from '../models/Action'
import { ActionBarColorMode } from '../models/ActionBarMode'
import { screenManager, ColumnSize } from '../common/ScreenManager';
import { Constants } from '../constants/Constants';

export interface EventVisibility {
  isVisible: boolean;
}

@Component
export struct ActionBarButton {
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  private res: Resource | undefined = undefined;
  action: Action = Action.NONE;
  onMenuClicked: Function | null = null;
  isFirst = false;
  isAutoTint = true;
  colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  @State showPopup: boolean = false;
  @Consume moreMenuList: Action[];

  @Builder PopupBuilder() {
    Column() {
      ForEach(this.moreMenuList, (menu: Action): void => {
        Text(menu.textRes)
          .width('100%')
          .height($r('app.float.menu_height'))
          .fontColor(menu.fillColor)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .onClick((): void => {
            this.showPopup = false;
            if (this.onMenuClicked != null) this.onMenuClicked(menu);
          })
        if (this.moreMenuList.indexOf(menu) !== this.moreMenuList.length - 1) {
          Divider()
            .width('100%')
            .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
            .color($r('sys.color.ohos_id_color_list_separator'))
        }
      }, (menu: Action): string => { return JSON.stringify(menu.actionID) })
    }.width(screenManager.getColumnsWidth(ColumnSize.COLUMN_TWO))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .padding({
      top: $r('app.float.menu_padding_vertical'),
      bottom: $r('app.float.menu_padding_vertical'),
      left: $r('app.float.menu_padding_horizontal'),
      right: $r('app.float.menu_padding_horizontal')
    })
    .backgroundColor(Color.White)
  }

  @Builder ActionBarButtonBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      if (this.isAutoTint) {
        Image(this.res)
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .fillColor(this.colorMode === ActionBarColorMode.TRANSPARENT ?
          Action.ICON_DEFAULT_COLOR_CONTRARY : this.action.fillColor)
      } else {
        Image(this.res)
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
      }
    }
    .height($r('app.float.default_button_size'))
    .width($r('app.float.default_button_size'))
    .margin({ left: (this.action === Action.NAVIGATION) ? $r('app.float.max_padding_start') : 0 })
  }

  build() {
    if (this.action === Action.MORE) {
      Row() {
        this.ActionBarButtonBuilder()
      }
      .onClick((): void => {
        this.showPopup = !this.showPopup
      })
      .bindPopup(this.showPopup, {
        builder: this.PopupBuilder,
        placement: Placement.Top,
        maskColor: 0x33000000,
        popupColor: '#00FFFFFF',
        enableArrow: false,
        onStateChange: (e: EventVisibility): void => {
          if (!e.isVisible) {
            this.showPopup = false
          }
        }
      })
    } else {
      Row() {
        this.ActionBarButtonBuilder()
      }
      .onClick((): void => {
        if(this.onMenuClicked != null) this.onMenuClicked(this.action)
      })
    }
  }
}
