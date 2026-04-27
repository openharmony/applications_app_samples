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
 
import { sizeCalc } from '../utils/SizeCalc'

@Entry
@Component
struct ResolutionNotSupportedDialog {
  build() {
    Row() {
      Image($r('app.media.luping'))
        .width(`${sizeCalc(60)}px`)
        .margin({ right: `${sizeCalc(12)}px` })
      Row() {
        Text('暂不支持')
          .fontColor(Color.White)
          .fontSize(`${sizeCalc(36)}px`)
          .fontWeight(FontWeight.Medium)
        Divider()
          .vertical(true)
          .strokeWidth(`${sizeCalc(1)}px`)
          .height(`${sizeCalc(36)}px`)
          .color(Color.White)
          .margin({ left: `${sizeCalc(12)}px`, right: `${sizeCalc(12)}px` })
        Text('当前设备分辨率过高，请降低分辨率')
          .fontColor(Color.White)
          .fontSize(`${sizeCalc(36)}px`)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.MARQUEE })
      }
      .layoutWeight(1)
    }
    .padding({
      left: `${sizeCalc(43)}px`,
      right: `${sizeCalc(43)}px`,
      top: `${sizeCalc(20)}px`,
      bottom: `${sizeCalc(20)}px`
    })
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#B33A3F62')
    .borderRadius(`${sizeCalc(24)}px`)
  }
}
