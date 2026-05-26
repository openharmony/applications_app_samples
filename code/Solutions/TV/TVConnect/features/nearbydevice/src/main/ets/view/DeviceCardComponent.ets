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
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

@Component
export default struct DeviceCardComponent {
  icon: string | Resource = '';
  name: string | Resource = '';
  @State isEnabled: boolean = true;
  enableCallback: (value: boolean) => void = (value: boolean) => {
  };

  build() {
    Column() {
      Row() {
        Image(this.icon)
          .width($r('app.string.wh_value_60'))
          .height($r('app.string.wh_value_60'));
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

      Blank();
      Text(this.name)
        .fontColor('rgba(0, 0, 0, 0.9)')
        .fontSize($r('app.string.vp_14'))
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .lineHeight($r('app.string.vp_20'));
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height($r('app.string.wh_value_120'))
    .borderRadius($r('app.string.radius_16'))
    .padding($r('app.string.radius_16'))
    .backgroundColor(Color.White);
  }
}