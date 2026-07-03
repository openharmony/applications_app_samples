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
import { CommonConstants } from '@ohos/common';
import router from '@ohos.router';

@Component
export default struct HeadTitleComponent {
  @Prop title: string | Resource;
  isLeftIcon?: string | Resource;
  paddingLeft?: Length;
  clickCallback: () => void = () => {
  };
  backClick?: () => void;

  back() {
    router.back();
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_width'))
          .onClick(() => {
            if (this.backClick) {
              this.backClick();
            } else {
              this.back();
            }
          });
        Text(this.title)
          .fontSize($r('app.string.font_20'))
          .fontColor('rgba(0,0,0,0.9)')
          .padding({ left: $r('app.string.padding_tab_title_left') });
      };

      if (this.isLeftIcon != '') {
        Image(this.isLeftIcon)
          .width($r('app.string.tip_icon_size'))
          .height($r('app.string.tip_icon_size'))
          .onClick(() => {
            this.clickCallback();
          });
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: this.paddingLeft ?? $r('app.string.padding_tab_left'),
      right: this.paddingLeft ?? $r('app.string.padding_tab_left')
    })
    .alignItems(VerticalAlign.Center)
    .height($r('app.string.scene_tab_height'))
    .width(CommonConstants.FULL_WIDTH_PERCENT);
  }
}