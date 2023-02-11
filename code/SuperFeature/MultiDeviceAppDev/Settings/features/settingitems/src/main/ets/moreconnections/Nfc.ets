/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { SubItemToggle } from '../components/SubItemToggle'
import { ItemGroup } from '../components/ItemGroup'

@Component
export struct Nfc {
  build() {
    Scroll() {
      Column() {
        Image($r('app.media.ic_nfc'))
          .width(400)
          .height(400)
          .aspectRatio(1)
          .flexShrink(1)

        Text($r('app.string.nfcTips'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize(12)
          .lineHeight(19)
          .fontColor('#182431')
          .margin({top: 8, bottom: 24, left: 12, right: 12})
          .opacity(0.6)
          .textAlign(TextAlign.Center)

        ItemGroup() {
          SubItemToggle({
            title: $r('app.string.NFC')
          })
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
      .padding({left: 12, right: 12})
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
}