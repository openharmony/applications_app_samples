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

@Component
export default struct SceneCardComponent {
  private icon: string | Resource = '';
  private name: string | Resource = '';
  private content: string | Resource = '';
  private deviceNum: number = 0;
  private isFlag: boolean = false;
  @State isEnabled: boolean = true;
  enableCallback: (value: boolean) => void = (value: boolean) => {
  };
  onClickEvent?: () => void;

  build() {
    Column() {
      Row() {
        Image(this.icon)
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_height'));
        if (this.isFlag) {
          Toggle({ type: ToggleType.Switch, isOn: this.isEnabled })
            .onChange((value: boolean) => {
              this.enableCallback(value);
            });
        }
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

      Blank();
      Text(this.name)
        .fontColor($r('app.color.text_color_white'))
        .fontSize($r('app.string.font_14'))
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .lineHeight($r('app.string.line_20'));
      if (this.content != '') {
        Text(this.content)
          .fontSize($r('app.string.font_14'))
          .fontColor($r('app.color.text_color_white'))
          .width(CommonConstants.FULL_WIDTH_PERCENT)
          .lineHeight($r('app.string.line_20'));
      }
      Row() {
        Text($r('app.string.combination', `${this.deviceNum}`))
          .fontSize($r('app.string.font_12'))
          .fontColor($r('app.color.default_text_color'))
          .lineHeight($r('app.string.line_24'));
        Image($r('app.media.ic_public_arrow_right'))
          .height($r('app.string.ic_arrow_left_icon_width'));
      }
      .height($r('app.string.line_24'))
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width(CommonConstants.FULL_WIDTH_PERCENT);

    }
    .onClick(() => {
      this.onClickEvent?.();
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height($r('app.string.card_height'))
    .borderRadius($r('app.string.card_border_radius'))
    .padding($r('app.string.card_border_radius'))
    .backgroundColor($r('app.color.scene_component_bg'));
  }
}