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
  @Link title: string | Resource;
  @Link isLeftIcon: string | Resource;
  @State isEdit: boolean = false;
  @State isClose: boolean = false; // 是否使用返回callback事件
  clickCallback: () => void = () => {
  };
  deleteConfirm: () => void = () => {
  };
  closeCallback: () => void = () => {
  };

  back() {
    if (this.isClose) {
      this.closeCallback();
    } else {
      router.back();
    }
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_height'))
          .onClick(() => {
            this.back();
          });
        Text(this.title)
          .fontSize($r('app.string.font_20'))
          .fontColor('rgba(0,0,0,0.9)')
          .padding({ left: $r('app.string.padding_tab_title_left') });
      };

      if (this.isLeftIcon != '') {
        if (this.isEdit) {
          Image(this.isLeftIcon)
            .width($r('app.string.tip_icon_width'))
            .height($r('app.string.tip_icon_height'))
            .bindMenu([
              {
                value: $r('app.string.delete'),
                action: () => {
                  console.info('handle Menu1 select');
                  this.deleteConfirm();
                }
              }
            ])
            .onClick(() => {
              this.clickCallback();
            });
        } else {
          Image(this.isLeftIcon)
            .width($r('app.string.tip_icon_width'))
            .height($r('app.string.tip_icon_height'))
            .onClick(() => {
              this.clickCallback();
            });
        }
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: $r('app.string.padding_tab_left'), right: $r('app.string.padding_tab_left') })
    .alignItems(VerticalAlign.Center)
    .height($r('app.string.scene_tab_height'))
    .width(CommonConstants.FULL_WIDTH_PERCENT);
  }
}