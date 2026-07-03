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
import { HMRouterMgr } from '@hadss/hmrouter';
import { CommonConstants } from '../constants/CommonConstants';

@Component
export struct NavBar {
  @Prop title: string | Resource;
  rightIcon?: string | Resource;
  rightText?: string | Resource;
  paddingLeft?: Length;
  clickCallback?: () => void;
  backClick?: () => void;

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.24_vp'))
          .height($r('app.string.24_vp'))
          .onClick(() => {
            if (this.backClick) {
              this.backClick();
            } else {
              HMRouterMgr.pop();
            }
          });
        Text(this.title)
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'))
          .padding({ left: $r('app.string.8_vp') });
      };

      if (this.rightText != undefined) {
        Text(this.rightText)
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'))
          .padding({ left: $r('app.string.8_vp') })
          .onClick(() => {
            if (this.clickCallback != undefined) {
              this.clickCallback();
            }
          });
      }

      if (this.rightIcon != undefined) {
        Image(this.rightIcon)
          .width($r('app.string.22_vp'))
          .height($r('app.string.22_vp'))
          .focusable(false)
          .onClick(() => {
            if (this.clickCallback != undefined) {
              this.clickCallback();
            }
          });
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: this.paddingLeft ?? $r('app.string.20_vp'),
      right: this.paddingLeft ?? $r('app.string.20_vp')
    })
    .alignItems(VerticalAlign.Center)
    .height($r('app.string.page_toolbar_height'))
    .width(CommonConstants.FULL_WIDTH_PERCENT);
  }
}