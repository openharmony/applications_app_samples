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
import router from '@ohos.router';
import { CommonConstants, Logger } from '@ohos/common';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

let TAG = 'EmptyPage';

@Component
export default struct EmptyPage {
  addClick: () => void = () => {
  };

  build() {
    Column() {

      Row() {
        Text($r('app.string.no_device'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'));
        Text($r('app.string.to'))
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'));
        Text($r('app.string.add_device'))
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.scene_empty_color'))
          .focusBox({
            margin: LengthMetrics.px(2),
            strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            this.addClick();
          })
          .id(`add_ip_device`)
          .onHover(() => {
            this.getUIContext().getFocusController().requestFocus(`add_ip_device`);
          });
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.string.line_20'))
      .margin({ top: $r('app.string.vp_20') });

      Image($r('app.media.empty'))
        .width($r('app.string.empty_width'))
        .height($r('app.string.empty_height'))
        .margin({ top: $r('app.string.vp_20') });
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Center);
  }
}