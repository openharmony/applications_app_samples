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
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants } from '../constants/CommonConstants';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

@CustomDialog
export struct DefaultDialog {
  @State currentIndex: number = 1;
  @State content: ResourceStr = '';
  leftText: ResourceStr = '';
  rightText: ResourceStr = '';
  controller: CustomDialogController;
  cancel: Function = () => {
  };
  confirm: Function = () => {
  };

  build() {
    Column() {
      Row() {
        Text(this.content)
          .fontSize($r('app.string.font_16'))
          .fontColor($r('app.color.dialog_font_color'))
          .lineHeight(20);
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT);

      Row() {
        Button(this.leftText)
          .fontColor(this.currentIndex == 0 ? $r('app.color.text_color_black') : $r('app.color.text_color_white'))
          .borderRadius($r('app.string.12_vp'))
          .width(CommonConstants.LAUNCHER_BTN_MARGIN_TOP)
          .backgroundColor(this.currentIndex == 0 ? $r('app.color.dialog_button_bg2') :
          $r('app.color.dialog_button_bg'))
          .onFocus(() => {
            this.currentIndex = 0;
          })
          .focusBox({
            margin: LengthMetrics.px(10),
            strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            this.cancel();
          });


        Button(this.rightText)
          .fontColor(this.currentIndex == 1 ? $r('app.color.text_color_black') : $r('app.color.text_color_white'))
          .borderRadius($r('app.string.12_vp'))
          .width(CommonConstants.LAUNCHER_BTN_MARGIN_TOP)
          .backgroundColor(this.currentIndex == 1 ? $r('app.color.dialog_button_bg2') :
          $r('app.color.dialog_button_bg'))
          .defaultFocus(true)
          .onFocus(() => {
            this.currentIndex = 1;
          })
          .focusBox({
            margin: LengthMetrics.px(10),
            strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            this.confirm();
          });

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: $r('app.string.20_vp'), right: $r('app.string.20_vp') });
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: $r('app.string.20_vp'),
      right: $r('app.string.20_vp'),
      top: $r('app.string.24_vp'),
      bottom: $r('app.string.24_vp')
    })
    .backgroundColor($r('app.color.dialog_bg'))
    .borderRadius($r('app.string.font_16'))
    .width('35%')
    .height('30%');
  }
}