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

import Constant from '../../common/Constant'

@Component
export struct SelectTime {
  @Link hour: number
  @Link minute: number
  @Link second: number

  build() {
    Column({ space: 15 }) {
      Row() {
        TextPicker({ range: this.pickerArrayGen(24) })
          .width(60)
          .onChange((value: string, index: number) => {
            this.hour = index
          })
        Text(':')
          .fontSize(24)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(Constant.FONT_WEIGHT)
          .margin({ left: 15, right: 15 })
        TextPicker({ range: this.pickerArrayGen(60) })
          .width(60)
          .onChange((value: string, index: number) => {
            this.minute = index
          })
        Text(':')
          .fontSize(24)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(Constant.FONT_WEIGHT)
          .margin({ left: 15, right: 15 })
        TextPicker({ range: this.pickerArrayGen(60) })
          .width(60)
          .onChange((value: string, index: number) => {
            this.second = index
          })
      }

      Row() {
        Text($r('app.string.countdown_hour'))
          .fontSize(14)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('app.color.font_dark'))
        Text($r('app.string.countdown_minute'))
          .fontSize(14)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi')
          .margin({ left: 82, right: 82 })
          .fontColor($r('app.color.font_dark'))
        Text($r('app.string.countdown_second'))
          .fontSize(14)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('app.color.font_dark'))
      }
    }
  }

  pickerArrayGen(num) {
    return Array.from({ length: num }, (_, i) => (i < 10) ? ('0' + i) : ('' + i))
  }
}