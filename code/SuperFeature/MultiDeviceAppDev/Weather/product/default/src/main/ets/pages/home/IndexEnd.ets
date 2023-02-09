/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Style } from '@ohos/common'

@Preview
@Component
export default struct IndexEnd {
  build() {
    Column() {
      Row() {
        Image($r('app.media.icon_china_weather'))
          .width(16)
          .height(16)
          .objectFit(ImageFit.Contain)
          .opacity(0.6)
        Text($r('app.string.china_weather'))
          .fontColor('#99FFFFFF')
          .fontSize(12)
      }

      Text($r('app.string.weather_version'))
        .fontColor('#99FFFFFF')
        .fontSize(12)
        .margin({ top: 8 })
      Text($r('app.string.weather_statement'))
        .fontColor('#FFFFFF')
        .fontSize(12)
        .margin({ top: 4 })
      Text($r('app.string.weather_copyright'))
        .fontColor('#99FFFFFF')
        .fontSize(12)
        .margin({ top: 4 })
    }
    .width('100%')
    .padding({ top: 40, bottom: 50 })
  }
}