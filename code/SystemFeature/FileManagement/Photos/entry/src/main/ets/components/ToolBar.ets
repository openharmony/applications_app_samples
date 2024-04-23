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

import { screenManager, ColumnSize } from '../common/ScreenManager';
import { ToolBarButton } from './ToolBarButton';
import { EventVisibility } from './ActionBarButton';
import { Constants } from '../constants/Constants';
import { ActionBarProp } from '../common/ActionBarProp';
import { Action } from '../models/Action';
import { ActionBarMode } from '../models/ActionBarMode';

export class MenuItem {
  value: string = '';
  action: () => void = () => {};
}

@Component
export struct ToolBar {
  @StorageLink('isSplitMode') isSplitMode: boolean = screenManager.isSplitMode();
  @StorageLink('leftBlank') leftBlank: number[] = [0, 0, 0, 0];
  @Link toolMenuList: Action[];
  @Consume moreMenuList: Action[];
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @State showPopup: boolean = false;
  private isFromPhotoBrowser = false;
  onMenuClicked: Function | null = null;
  @State actionBarProp: ActionBarProp = new ActionBarProp();

  private createActionBar(): ActionBarProp {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
      .setMode(ActionBarMode.DETAIL_MODE);
    return actionBarProp;
  }

  aboutToAppear(): void {
    this.actionBarProp = this.createActionBar();
  }

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
            if(this.onMenuClicked != null) this.onMenuClicked(menu);
          })
        if (this.moreMenuList.indexOf(menu) !== this.moreMenuList.length - 1) {
          Divider()
            .width('100%')
            .strokeWidth(Constants.MENU_DIVIDER_STROKE_WIDTH)
            .color($r('sys.color.ohos_id_color_list_separator'))
        }
      }, (menu: Action): string => { return (menu.actionType != null ? menu.actionType.id.toString() : menu.actionID.toString())})
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

  build() {
    if (!this.isHorizontal) {
      Row() {
        Row() {
          ForEach(this.toolMenuList, (menu: Action): void => {
            if (menu === Action.MORE) {
              Column() {
                Row() {
                  ToolBarButton({
                    res: menu.iconRes,
                    action: menu,
                    isLeft: true,
                    isAutoTint: menu.isAutoTint,
                    colorMode: this.actionBarProp.getColorMode()
                  })
                }.margin({ top: $r('app.float.id_icon_margin_vertical') })

                Row() {
                  Text(menu.textRes)
                    .fontSize($r('sys.float.ohos_id_text_size_caption'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor(menu.fillColor)
                }.margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
              }
              .width(Constants.PERCENT_HUNDRED / this.toolMenuList.length + '%')
              .height('100%')
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
              Column() {
                Row() {
                  ToolBarButton({
                    res: menu.iconRes,
                    action: menu,
                    isLeft: true,
                    isAutoTint: menu.isAutoTint,
                    colorMode: this.actionBarProp.getColorMode()
                  })
                }.margin({ top: $r('app.float.id_icon_margin_vertical') })

                Row() {
                  Text(menu.textRes)
                    .fontSize($r('sys.float.ohos_id_text_size_caption'))
                    .fontFamily($r('app.string.id_text_font_family_regular'))
                    .fontColor(menu.fillColor)
                }
                .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
              }
              .onClick((): void => {
                if(this.onMenuClicked != null) this.onMenuClicked(menu)
              })
              .width(Constants.PERCENT_HUNDRED / this.toolMenuList.length + '%')
              .height('100%')
            }
          }, (menu: Action): string => { return (menu.actionType != null ? menu.actionType.id.toString() : menu.actionID.toString()) })
        }
        .width('100%')
        .height(Constants.ActionBarHeight)
        .padding(this.toolMenuList.length > 4 ? {} : { left: $r('app.float.actionbar_margin_horizontal'),
                                 right: $r('app.float.actionbar_margin_horizontal') })
      }
      .padding({
        bottom: this.isFromPhotoBrowser ? px2vp(this.leftBlank[3]) : 0
      })
      .width('100%')
      .backgroundColor(this.actionBarProp.getBackgroundColor())
      .opacity(this.actionBarProp.getAlpha())
      .markAnchor({ x: '0%', y: '100%' })
      .position({ x: '0%', y: '100%' })
    }
  }
}
