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

import ConfigData from '../viewmodel/ConfigData';

/**
 * about phone
 */
@Component
export struct AboutDevice {
  @Prop deviceInfoName: string | Resource;
  @Prop deviceInfoValue: string | Resource;

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.deviceInfoName)
          .fontSize($r('app.string.font_16'))
          .lineHeight($r('app.string.wh_value_22'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.default_text_color'))
          .padding({ top: $r('app.string.distance_12'), bottom: $r('app.string.distance_12') })
          .textAlign(TextAlign.Start);

        Text(this.deviceInfoValue)
          .fontSize($r('app.string.font_16'))
          .lineHeight($r('app.string.wh_value_22'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.default_text_color'))
          .padding({ top: $r('app.string.distance_12'), bottom: $r('app.string.distance_12') })
          .textAlign(TextAlign.End);
      }
      .width(ConfigData.WH_100_100);
    };
  }
}
